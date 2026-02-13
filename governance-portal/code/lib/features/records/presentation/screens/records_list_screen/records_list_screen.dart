import 'package:flutter/material.dart';
import 'package:flutter_riverpod/flutter_riverpod.dart';
import 'package:governance_portal/features/records/domain/repositories/records_repository.dart';
import 'package:hooks_riverpod/hooks_riverpod.dart';
import 'package:flutter_hooks/flutter_hooks.dart';
import 'package:governance_portal/core/design_system/app_colors.dart';
import 'package:governance_portal/core/design_system/app_spacing.dart';
import 'package:governance_portal/core/widgets/destructive_button.dart';
import 'package:governance_portal/features/records/domain/entities/trust_record.dart';
import '../../../../../core/widgets/app_header.dart';
import '../../../../../core/widgets/app_modal.dart';
import '../../../../../core/hooks/af_value_notifier.dart';
import '../../../domain/usecases/list_records_usecase.dart';
import '../../../domain/usecases/delete_record_usecase.dart';
import '../record_form_screen.dart';
import '../../../../entities/data/entities_storage.dart';
import '../../../../entities/domain/entities/entity.dart';
import '../../../../authorities/data/authorities_storage.dart';
import '../../../../authorities/domain/entities/authority.dart';

part '_empty_view.dart';
part '_error_view.dart';
part '_records_table.dart';
part '_ellipsized_cell.dart';
part '_resource_cell.dart';
part '_authorization_recognition_status.dart';
part '_status_tag.dart';
part '_name_with_did_cell.dart';

class RecordsListScreen extends HookConsumerWidget {
  final RecordsRepository repository;
  const RecordsListScreen({super.key, required this.repository});

  @override
  Widget build(BuildContext context, WidgetRef ref) {
    // State management using hooks
    final refreshKeyNotifier = useAfValueNotifier<int>(0);
    final refreshKey = useValueListenable(refreshKeyNotifier);
    final recordsNotifier = useAfValueNotifier<List<TrustRecord>?>(null);
    final isLoadingNotifier = useAfValueNotifier<bool>(true);
    final errorNotifier = useAfValueNotifier<String?>(null);
    final entitiesNotifier = useAfValueNotifier<List<Entity>>([]);
    final authoritiesNotifier = useAfValueNotifier<List<Authority>>([]);

    // Load entities and authorities from storage
    useEffect(() {
      void loadLookupData() async {
        try {
          final entitiesStorage = await EntitiesStorage.init();
          final authoritiesStorage = await AuthoritiesStorage.init();

          if (!entitiesNotifier.isDisposed) {
            entitiesNotifier.value = entitiesStorage.getEntities();
          }
          if (!authoritiesNotifier.isDisposed) {
            authoritiesNotifier.value = authoritiesStorage.getAuthorities();
          }
        } catch (e) {
          print('Error loading lookup data: $e');
        }
      }

      loadLookupData();
      return null;
    }, []);

    final listRecordsUseCase = useMemoized(
      () => ListRecordsUseCase(repository),
      [repository],
    );
    final deleteRecordUseCase = useMemoized(
      () => DeleteRecordUseCase(repository),
      [repository],
    );

    // Load records when refreshKey changes
    useEffect(() {
      void loadRecords() async {
        if (isLoadingNotifier.isDisposed) return;
        isLoadingNotifier.value = true;
        errorNotifier.value = null;

        try {
          final records = await listRecordsUseCase();
          if (!recordsNotifier.isDisposed) {
            recordsNotifier.value = records;
          }
        } catch (e) {
          if (!errorNotifier.isDisposed) {
            errorNotifier.value = e.toString();
          }
        } finally {
          if (!isLoadingNotifier.isDisposed) {
            isLoadingNotifier.value = false;
          }
        }
      }

      loadRecords();
      return null;
    }, [refreshKey]);

    // Refresh callback
    void refreshRecords() {
      refreshKeyNotifier.value = refreshKeyNotifier.value + 1;
    }

    // Create use cases

    return Scaffold(
      body: Column(
        children: [
          // Top header (no search bar)
          AppHeader(
            title: 'Trust Records',
            showSearchBar: false,
            onCreatePressed: () async {
              await showAppModal(
                context: context,
                title: 'Create Record',
                body: RecordFormScreen(
                  isModal: true,
                  repository: repository,
                ),
              );

              // Refresh the list after modal closes
              refreshRecords();
            },
          ),

          // Records List
          Expanded(
            child: ValueListenableBuilder<bool>(
              valueListenable: isLoadingNotifier,
              builder: (context, isLoading, _) {
                return ValueListenableBuilder<String?>(
                  valueListenable: errorNotifier,
                  builder: (context, error, _) {
                    return ValueListenableBuilder<List<TrustRecord>?>(
                      valueListenable: recordsNotifier,
                      builder: (context, records, _) {
                        // Loading state
                        if (isLoading && records == null) {
                          return const Center(
                            child: CircularProgressIndicator(),
                          );
                        }

                        // Error state
                        if (error != null && records == null) {
                          return _ErrorView(
                            error: error,
                            onRetry: refreshRecords,
                          );
                        }

                        // Empty state
                        if (records == null || records.isEmpty) {
                          return _EmptyView();
                        }

                        // Success state
                        return Stack(
                          children: [
                            ValueListenableBuilder<List<Entity>>(
                              valueListenable: entitiesNotifier,
                              builder: (context, entities, _) {
                                return ValueListenableBuilder<List<Authority>>(
                                  valueListenable: authoritiesNotifier,
                                  builder: (context, authorities, _) {
                                    return _RecordsTable(
                                      records: records,
                                      entities: entities,
                                      authorities: authorities,
                                      deleteRecordUseCase: deleteRecordUseCase,
                                      onRefresh: refreshRecords,
                                      repository: repository,
                                    );
                                  },
                                );
                              },
                            ),
                            if (isLoading)
                              Container(
                                color: Colors.black26,
                                child: const Center(
                                  child: CircularProgressIndicator(),
                                ),
                              ),
                          ],
                        );
                      },
                    );
                  },
                );
              },
            ),
          ),
        ],
      ),
    );
  }
}
