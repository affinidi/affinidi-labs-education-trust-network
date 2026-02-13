part of 'records_list_screen.dart';

class _RecordsTable extends HookWidget {
  final List<TrustRecord> records;
  final List<Entity> entities;
  final List<Authority> authorities;
  final DeleteRecordUseCase deleteRecordUseCase;
  final VoidCallback onRefresh;
  final RecordsRepository repository;

  const _RecordsTable({
    required this.records,
    required this.entities,
    required this.authorities,
    required this.deleteRecordUseCase,
    required this.onRefresh,
    required this.repository,
  });

  @override
  Widget build(BuildContext context) {
    final theme = Theme.of(context);
    final isProcessingNotifier = useAfValueNotifier<bool>(false);

    // Create lookup maps for quick access
    final entityMap = useMemoized(
      () => {for (var entity in entities) entity.did: entity},
      [entities],
    );
    final authorityMap = useMemoized(
      () => {for (var authority in authorities) authority.did: authority},
      [authorities],
    );

    return Padding(
      padding: const EdgeInsets.all(16),
      child: Container(
        decoration: BoxDecoration(
          color: AppColors.neutral0,
          borderRadius: BorderRadius.circular(AppSpacing.radiusLg),
          border: Border.all(color: AppColors.neutral200),
          boxShadow: [
            BoxShadow(
              color: Colors.black.withAlpha(15),
              blurRadius: 18,
              offset: const Offset(0, 6),
            ),
          ],
        ),
        child: ClipRRect(
          borderRadius: BorderRadius.circular(AppSpacing.radiusLg),
          child: Column(
            children: [
              Expanded(
                child: Scrollbar(
                  child: LayoutBuilder(
                    builder: (context, constraints) {
                      return SingleChildScrollView(
                        child: SingleChildScrollView(
                          scrollDirection: Axis.horizontal,
                          child: ConstrainedBox(
                            constraints:
                                BoxConstraints(minWidth: constraints.maxWidth),
                            child: ValueListenableBuilder<bool>(
                              valueListenable: isProcessingNotifier,
                              builder: (context, isProcessing, _) {
                                return DataTable(
                                  showCheckboxColumn: false,
                                  headingRowHeight: 44,
                                  dataRowMinHeight: 52,
                                  dataRowMaxHeight: 60,
                                  columnSpacing: 16,
                                  horizontalMargin: 16,
                                  dividerThickness: 0.8,
                                  headingTextStyle:
                                      theme.textTheme.bodySmall?.copyWith(
                                    color: AppColors.neutral400,
                                    fontWeight: FontWeight.w700,
                                    letterSpacing: 0.2,
                                  ),
                                  dataTextStyle:
                                      theme.textTheme.bodyMedium?.copyWith(
                                    color: AppColors.neutral500,
                                  ),
                                  headingRowColor: const WidgetStatePropertyAll(
                                    AppColors.neutral50,
                                  ),
                                  columns: const [
                                    DataColumn(label: Text('#')),
                                    DataColumn(label: Text('Authority')),
                                    DataColumn(label: Text('Status')),
                                    DataColumn(label: Text('Entity')),
                                    DataColumn(label: Text('Action')),
                                    DataColumn(label: Text('Resource')),
                                    DataColumn(label: Text('More')),
                                  ],
                                  rows: List<DataRow>.generate(
                                    records.length,
                                    (index) {
                                      final record = records[index];

                                      // Lookup authority and entity names
                                      final authority =
                                          authorityMap[record.authorityId];
                                      final entity = entityMap[record.entityId];

                                      return DataRow(
                                        color: WidgetStateProperty.resolveWith(
                                          (states) {
                                            if (states.contains(
                                                WidgetState.selected)) {
                                              return AppColors.neutral100;
                                            }
                                            return index.isEven
                                                ? AppColors.neutral0
                                                : AppColors.neutral50;
                                          },
                                        ),
                                        onSelectChanged: isProcessing
                                            ? null
                                            : (_) {
                                                showAppModal(
                                                  context: context,
                                                  title: 'Modify Record',
                                                  body: RecordFormScreen(
                                                    record: record,
                                                    isModal: true,
                                                    repository: repository,
                                                  ),
                                                ).then((_) => onRefresh());
                                              },
                                        cells: [
                                          DataCell(
                                            SizedBox(
                                              width: 28,
                                              child: Text(
                                                '${index + 1}',
                                                textAlign: TextAlign.right,
                                              ),
                                            ),
                                          ),
                                          DataCell(
                                            authority != null
                                                ? _NameWithDidCell(
                                                    name: authority.name,
                                                    did: record.authorityId,
                                                    maxWidth: 320,
                                                  )
                                                : _EllipsizedCell(
                                                    text: record.authorityId,
                                                    maxWidth: 320,
                                                  ),
                                          ),
                                          DataCell(
                                            _AuthorizationRecognitionStatus(
                                              authorized: record.authorized,
                                              recognized: record.recognized,
                                            ),
                                          ),
                                          DataCell(
                                            entity != null
                                                ? _NameWithDidCell(
                                                    name: entity.name,
                                                    did: record.entityId,
                                                    maxWidth: 320,
                                                  )
                                                : _EllipsizedCell(
                                                    text: record.entityId,
                                                    maxWidth: 320,
                                                  ),
                                          ),
                                          DataCell(
                                            _EllipsizedCell(
                                              text: record.action,
                                              maxWidth: 110,
                                            ),
                                          ),
                                          DataCell(
                                            _ResourceCell(
                                                text: record.resource),
                                          ),
                                          DataCell(
                                            Align(
                                              alignment: Alignment.centerLeft,
                                              child: PopupMenuButton<String>(
                                                tooltip: 'More',
                                                icon: const Icon(
                                                  Icons.more_horiz,
                                                  color: AppColors.neutral400,
                                                ),
                                                onSelected: (value) async {
                                                  if (value == 'modify') {
                                                    await showAppModal(
                                                      context: context,
                                                      title: 'Modify Record',
                                                      body: RecordFormScreen(
                                                        record: record,
                                                        isModal: true,
                                                        repository: repository,
                                                      ),
                                                    );
                                                    onRefresh();
                                                    return;
                                                  }

                                                  if (value == 'revoke') {
                                                    final confirmed =
                                                        await showDialog<bool>(
                                                      context: context,
                                                      builder: (context) =>
                                                          AlertDialog(
                                                        title: const Text(
                                                            'Revoke Record'),
                                                        content: const Text(
                                                          'Are you sure you want to revoke this record? This action cannot be undone.',
                                                        ),
                                                        actions: [
                                                          TextButton(
                                                            onPressed: () =>
                                                                Navigator.pop(
                                                                    context,
                                                                    false),
                                                            child: const Text(
                                                                'Cancel'),
                                                          ),
                                                          DestructiveButton(
                                                            label: 'Revoke',
                                                            onPressed: () =>
                                                                Navigator.pop(
                                                                    context,
                                                                    true),
                                                          ),
                                                        ],
                                                      ),
                                                    );

                                                    if (confirmed != true) {
                                                      return;
                                                    }

                                                    if (isProcessingNotifier
                                                        .isDisposed) return;
                                                    isProcessingNotifier.value =
                                                        true;

                                                    try {
                                                      await deleteRecordUseCase(
                                                        entityId:
                                                            record.entityId,
                                                        authorityId:
                                                            record.authorityId,
                                                        action: record.action,
                                                        resource:
                                                            record.resource,
                                                      );

                                                      onRefresh();

                                                      if (context.mounted) {
                                                        ScaffoldMessenger.of(
                                                                context)
                                                            .showSnackBar(
                                                          const SnackBar(
                                                            content: Text(
                                                              'Record revoked successfully',
                                                            ),
                                                            backgroundColor:
                                                                AppColors
                                                                    .semanticSuccess,
                                                          ),
                                                        );
                                                      }
                                                    } catch (e) {
                                                      if (context.mounted) {
                                                        ScaffoldMessenger.of(
                                                                context)
                                                            .showSnackBar(
                                                          SnackBar(
                                                            content: Text(
                                                              'Error revoking record: ${e.toString()}',
                                                            ),
                                                            backgroundColor:
                                                                AppColors
                                                                    .semanticError,
                                                          ),
                                                        );
                                                      }
                                                    } finally {
                                                      if (!isProcessingNotifier
                                                          .isDisposed) {
                                                        isProcessingNotifier
                                                            .value = false;
                                                      }
                                                    }
                                                  }
                                                },
                                                itemBuilder: (context) =>
                                                    const [
                                                  PopupMenuItem(
                                                    value: 'modify',
                                                    child: Row(
                                                      children: [
                                                        Icon(
                                                            Icons.edit_outlined,
                                                            size: 18),
                                                        SizedBox(width: 10),
                                                        Text('Modify'),
                                                      ],
                                                    ),
                                                  ),
                                                  PopupMenuItem(
                                                    value: 'revoke',
                                                    child: Row(
                                                      children: [
                                                        Icon(
                                                          Icons.block,
                                                          size: 18,
                                                          color: AppColors
                                                              .semanticError,
                                                        ),
                                                        SizedBox(width: 10),
                                                        Text('Revoke'),
                                                      ],
                                                    ),
                                                  ),
                                                ],
                                              ),
                                            ),
                                          ),
                                        ],
                                      );
                                    },
                                  ),
                                );
                              },
                            ),
                          ),
                        ),
                      );
                    },
                  ),
                ),
              ),
            ],
          ),
        ),
      ),
    );
  }
}
