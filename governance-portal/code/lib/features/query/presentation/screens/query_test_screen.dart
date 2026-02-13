import 'package:flutter/material.dart';
import 'package:hooks_riverpod/hooks_riverpod.dart';
import 'package:flutter_hooks/flutter_hooks.dart';
import '../../../../core/hooks/af_value_notifier.dart';
import '../../domain/entities/query_input.dart';
import '../../domain/entities/query_result.dart';
import '../../domain/usecases/execute_query_usecase.dart';
import '../providers/query_providers.dart';
import '../widgets/query_form.dart';
import '../widgets/query_result_card.dart';
import '../widgets/query_history_list.dart';

class QueryTestScreen extends HookConsumerWidget {
  const QueryTestScreen({super.key});

  @override
  Widget build(BuildContext context, WidgetRef ref) {
    final queryResultNotifier = useAfValueNotifier<QueryResult?>(null);
    final isLoadingNotifier = useAfValueNotifier<bool>(false);
    final queryErrorNotifier = useAfValueNotifier<String?>(null);
    final queryHistoryNotifier = useAfValueNotifier<List<QueryInput>>([]);

    // Get repository and create use case
    final repositoryAsync = ref.watch(queryRecordsRepositoryProvider);

    // Return loading state if repository is not ready
    return repositoryAsync.when(
      data: (repository) {
        final executeQueryUseCase = useMemoized(
          () => ExecuteQueryUseCase(repository),
          [repository],
        );

        Future<void> handleSubmit(QueryInput input) async {
          if (queryErrorNotifier.isDisposed) return;
          queryErrorNotifier.value = null;

          if (isLoadingNotifier.isDisposed) return;
          isLoadingNotifier.value = true;

          try {
            final result = await executeQueryUseCase(input);

            if (!queryResultNotifier.isDisposed) {
              queryResultNotifier.value = result;
            }

            // Add to history
            if (!queryHistoryNotifier.isDisposed) {
              final history = queryHistoryNotifier.value;
              queryHistoryNotifier.value = [input, ...history.take(9).toList()];
            }
          } catch (e) {
            if (!queryErrorNotifier.isDisposed) {
              queryErrorNotifier.value = e.toString();
            }
          } finally {
            if (!isLoadingNotifier.isDisposed) {
              isLoadingNotifier.value = false;
            }
          }
        }

        void handleClear() {
          if (!queryResultNotifier.isDisposed) {
            queryResultNotifier.value = null;
          }
          if (!queryErrorNotifier.isDisposed) {
            queryErrorNotifier.value = null;
          }
        }

        void handleClearHistory() {
          if (!queryHistoryNotifier.isDisposed) {
            queryHistoryNotifier.value = [];
          }
        }

        return Scaffold(
          appBar: AppBar(
            title: const Text('Query Test (TRQP)'),
            actions: [
              IconButton(
                icon: const Icon(Icons.help_outline),
                onPressed: () {
                  _showHelpDialog(context);
                },
                tooltip: 'Help',
              ),
            ],
          ),
          body: Row(
            children: [
              // Left panel - Query form
              Expanded(
                flex: 3,
                child: SingleChildScrollView(
                  padding: const EdgeInsets.all(16),
                  child: Column(
                    crossAxisAlignment: CrossAxisAlignment.start,
                    children: [
                      Text(
                        'Trust Registry Query Protocol',
                        style:
                            Theme.of(context).textTheme.headlineSmall?.copyWith(
                                  fontWeight: FontWeight.bold,
                                ),
                      ),
                      const SizedBox(height: 8),
                      Text(
                        'Test recognition and authorization queries against the Trust Registry',
                        style: Theme.of(context).textTheme.bodyMedium?.copyWith(
                              color: Colors.grey[600],
                            ),
                      ),
                      const SizedBox(height: 24),
                      QueryForm(
                        onSubmit: handleSubmit,
                        onClear: handleClear,
                      ),
                      ValueListenableBuilder<bool>(
                        valueListenable: isLoadingNotifier,
                        builder: (context, isLoading, _) {
                          if (isLoading) {
                            return const Padding(
                              padding: EdgeInsets.only(top: 24),
                              child: Center(child: CircularProgressIndicator()),
                            );
                          }
                          return const SizedBox.shrink();
                        },
                      ),
                      ValueListenableBuilder<String?>(
                        valueListenable: queryErrorNotifier,
                        builder: (context, queryError, _) {
                          if (queryError != null) {
                            return Padding(
                              padding: const EdgeInsets.only(top: 24),
                              child: Card(
                                color: Colors.red[50],
                                child: Padding(
                                  padding: const EdgeInsets.all(16),
                                  child: Row(
                                    children: [
                                      Icon(Icons.error_outline,
                                          color: Colors.red[700]),
                                      const SizedBox(width: 12),
                                      Expanded(
                                        child: Column(
                                          crossAxisAlignment:
                                              CrossAxisAlignment.start,
                                          children: [
                                            Text(
                                              'Query Failed',
                                              style: TextStyle(
                                                fontWeight: FontWeight.bold,
                                                color: Colors.red[900],
                                              ),
                                            ),
                                            const SizedBox(height: 4),
                                            Text(
                                              queryError,
                                              style: TextStyle(
                                                  color: Colors.red[800]),
                                            ),
                                          ],
                                        ),
                                      ),
                                    ],
                                  ),
                                ),
                              ),
                            );
                          }
                          return const SizedBox.shrink();
                        },
                      ),
                      ValueListenableBuilder<QueryResult?>(
                        valueListenable: queryResultNotifier,
                        builder: (context, queryResult, _) {
                          if (queryResult != null) {
                            return Padding(
                              padding: const EdgeInsets.only(top: 24),
                              child: QueryResultCard(result: queryResult),
                            );
                          }
                          return const SizedBox.shrink();
                        },
                      ),
                    ],
                  ),
                ),
              ),

              // Right panel - Query history
              Container(
                width: 300,
                decoration: BoxDecoration(
                  border: Border(
                    left: BorderSide(color: Colors.grey[300]!),
                  ),
                ),
                child: ValueListenableBuilder<List<QueryInput>>(
                  valueListenable: queryHistoryNotifier,
                  builder: (context, history, _) {
                    return QueryHistoryList(
                      history: history,
                      onClearHistory: handleClearHistory,
                      onQuerySelected: handleSubmit,
                    );
                  },
                ),
              ),
            ],
          ),
        );
      },
      loading: () => Scaffold(
        appBar: AppBar(title: const Text('Query Test (TRQP)')),
        body: const Center(child: CircularProgressIndicator()),
      ),
      error: (error, stack) => Scaffold(
        appBar: AppBar(title: const Text('Query Test (TRQP)')),
        body: Center(child: Text('Error: $error')),
      ),
    );
  }

  void _showHelpDialog(BuildContext context) {
    showDialog(
      context: context,
      builder: (context) => AlertDialog(
        title: const Text('Trust Registry Query Protocol'),
        content: const SingleChildScrollView(
          child: Column(
            crossAxisAlignment: CrossAxisAlignment.start,
            mainAxisSize: MainAxisSize.min,
            children: [
              Text(
                'TRQP allows you to query whether an entity is:',
                style: TextStyle(fontWeight: FontWeight.bold),
              ),
              SizedBox(height: 8),
              Text('• Recognized by an authority'),
              Text('• Authorized to perform an action on a resource'),
              SizedBox(height: 16),
              Text(
                'Fields:',
                style: TextStyle(fontWeight: FontWeight.bold),
              ),
              SizedBox(height: 8),
              Text('• Entity ID: The DID of the entity being queried'),
              Text('• Authority ID: The DID of the authority'),
              Text('• Action: The action being requested (e.g., "issue")'),
              Text('• Resource: The resource type (e.g., "credential-type")'),
            ],
          ),
        ),
        actions: [
          TextButton(
            onPressed: () => Navigator.pop(context),
            child: Text('Close'),
          ),
        ],
      ),
    );
  }
}
