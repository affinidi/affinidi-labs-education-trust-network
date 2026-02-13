import 'package:flutter/material.dart';
import 'package:flutter_hooks/flutter_hooks.dart';
import 'package:governance_portal/core/design_system/app_colors.dart';
import 'package:governance_portal/core/design_system/app_spacing.dart';
import 'package:governance_portal/core/design_system/app_typography.dart';
import 'package:governance_portal/core/widgets/app_modal.dart';
import 'package:governance_portal/features/entities/presentation/screens/entity_form_screen.dart';
import '../../domain/entities/entity.dart';

class EntitiesTable extends HookWidget {
  final List<Entity> entities;
  final Function(String id, Map<String, dynamic> data)? onEdit;

  const EntitiesTable({
    super.key,
    required this.entities,
    this.onEdit,
  });

  @override
  Widget build(BuildContext context) {
    final theme = Theme.of(context);
    final searchController = useTextEditingController();
    final searchQuery = useState('');
    final sortOption = useState('name-asc');
    final expandedRows = useState<Set<String>>({});

    // Filter and sort entities
    var filteredEntities = entities.where((entity) {
      if (searchQuery.value.isEmpty) return true;
      final query = searchQuery.value.toLowerCase();
      return entity.name.toLowerCase().contains(query) ||
          entity.did.toLowerCase().contains(query) ||
          (entity.description?.toLowerCase().contains(query) ?? false);
    }).toList();

    // Sort entities
    filteredEntities.sort((a, b) {
      switch (sortOption.value) {
        case 'name-asc':
          return a.name.compareTo(b.name);
        case 'name-desc':
          return b.name.compareTo(a.name);
        case 'did-asc':
          return a.did.compareTo(b.did);
        case 'did-desc':
          return b.did.compareTo(a.did);
        default:
          return 0;
      }
    });

    return Column(
      children: [
        // Search, Sort, Export controls
        Container(
          padding: EdgeInsets.all(AppSpacing.spacing2),
          decoration: const BoxDecoration(
            color: Colors.transparent,
          ),
          child: Row(
            children: [
              // Search bar
              Expanded(
                child: SizedBox(
                  height: 48,
                  child: TextField(
                    controller: searchController,
                    onChanged: (value) => searchQuery.value = value,
                    decoration: InputDecoration(
                      hintText: 'Search entities...',
                      hintStyle: AppTypography.bodyMedium.copyWith(
                        color: AppColors.neutral400,
                      ),
                      filled: true,
                      fillColor: Colors.white,
                      prefixIcon: Icon(
                        Icons.search,
                        color: AppColors.neutral400,
                        size: AppSpacing.iconMd,
                      ),
                      border: OutlineInputBorder(
                        borderRadius:
                            BorderRadius.circular(AppSpacing.radiusMd),
                        borderSide: BorderSide(color: AppColors.neutral200),
                      ),
                      enabledBorder: OutlineInputBorder(
                        borderRadius:
                            BorderRadius.circular(AppSpacing.radiusMd),
                        borderSide: BorderSide(color: AppColors.neutral200),
                      ),
                      focusedBorder: OutlineInputBorder(
                        borderRadius:
                            BorderRadius.circular(AppSpacing.radiusMd),
                        borderSide: BorderSide(color: AppColors.neutral400),
                      ),
                      contentPadding: EdgeInsets.symmetric(
                        horizontal: AppSpacing.spacing2,
                      ),
                      isDense: true,
                    ),
                    style: AppTypography.bodyMedium,
                  ),
                ),
              ),
              SizedBox(width: AppSpacing.spacing2),
              // Sort dropdown
              Container(
                height: 48,
                padding: EdgeInsets.symmetric(
                  horizontal: AppSpacing.spacing1_5,
                ),
                decoration: BoxDecoration(
                  color: AppColors.neutral100,
                  borderRadius: BorderRadius.circular(AppSpacing.radiusMd),
                ),
                child: DropdownButton<String>(
                  value: sortOption.value,
                  underline: const SizedBox(),
                  icon: Icon(
                    Icons.keyboard_arrow_down,
                    color: AppColors.neutral400,
                    size: AppSpacing.iconMd,
                  ),
                  style: AppTypography.bodyMedium.copyWith(
                    color: AppColors.neutral500,
                  ),
                  onChanged: (value) {
                    if (value != null) sortOption.value = value;
                  },
                  items: [
                    DropdownMenuItem(
                      value: 'name-asc',
                      child:
                          Text('Name (A-Z)', style: AppTypography.bodyMedium),
                    ),
                    DropdownMenuItem(
                      value: 'name-desc',
                      child:
                          Text('Name (Z-A)', style: AppTypography.bodyMedium),
                    ),
                    DropdownMenuItem(
                      value: 'did-asc',
                      child: Text('Entity ID (A-Z)',
                          style: AppTypography.bodyMedium),
                    ),
                    DropdownMenuItem(
                      value: 'did-desc',
                      child: Text('Entity ID (Z-A)',
                          style: AppTypography.bodyMedium),
                    ),
                  ],
                ),
              ),
              SizedBox(width: AppSpacing.spacing2),
              // Export button
              Container(
                height: 48,
                decoration: BoxDecoration(
                  borderRadius: BorderRadius.circular(AppSpacing.radiusMd),
                ),
                child: TextButton.icon(
                  onPressed: () {
                    // TODO: Implement export
                  },
                  style: TextButton.styleFrom(
                    padding: EdgeInsets.symmetric(
                      horizontal: AppSpacing.spacing1_5,
                    ),
                    shape: RoundedRectangleBorder(
                      borderRadius: BorderRadius.circular(AppSpacing.radiusMd),
                    ),
                  ),
                  icon: Icon(
                    Icons.file_download_outlined,
                    color: AppColors.neutral400,
                    size: AppSpacing.iconMd,
                  ),
                  label: Text(
                    'Export',
                    style: AppTypography.bodyMedium.copyWith(
                      color: AppColors.neutral400,
                    ),
                  ),
                ),
              ),
            ],
          ),
        ),
        // Table
        Expanded(
          child: Padding(
            padding: EdgeInsets.all(AppSpacing.spacing2),
            child: Scrollbar(
              child: LayoutBuilder(
                builder: (context, constraints) {
                  return SingleChildScrollView(
                    child: SingleChildScrollView(
                      scrollDirection: Axis.horizontal,
                      child: ConstrainedBox(
                        constraints:
                            BoxConstraints(minWidth: constraints.maxWidth),
                        child: DataTable(
                          showCheckboxColumn: false,
                          headingRowHeight: 44,
                          dataRowMinHeight: 52,
                          dataRowMaxHeight: double.infinity,
                          columnSpacing: 16,
                          horizontalMargin: 16,
                          dividerThickness: 0.3,
                          headingTextStyle: theme.textTheme.bodySmall?.copyWith(
                            color: const Color(0xFF475569),
                            fontWeight: FontWeight.w700,
                            letterSpacing: 0.2,
                          ),
                          dataTextStyle: theme.textTheme.bodyMedium?.copyWith(
                            color: AppColors.neutral500,
                          ),
                          headingRowColor: const WidgetStatePropertyAll(
                            Colors.transparent,
                          ),
                          columns: const [
                            DataColumn(label: Text('#')),
                            DataColumn(label: Text('Entity ID')),
                            DataColumn(label: Text('Name')),
                            DataColumn(label: Text('Edit')),
                            DataColumn(label: Text('Details')),
                          ],
                          rows: List<DataRow>.generate(
                            filteredEntities.length,
                            (index) {
                              final entity = filteredEntities[index];
                              final recordKey = entity.id;
                              final isExpanded =
                                  expandedRows.value.contains(recordKey);

                              return DataRow(
                                color: const WidgetStatePropertyAll(
                                  Colors.transparent,
                                ),
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
                                    _EllipsizedCell(
                                      text: entity.did,
                                      maxWidth: 320,
                                    ),
                                  ),
                                  DataCell(
                                    _EllipsizedCell(
                                      text: entity.name,
                                      maxWidth: 200,
                                    ),
                                  ),
                                  DataCell(
                                    IconButton(
                                      tooltip: 'Edit',
                                      icon: Icon(
                                        Icons.edit_outlined,
                                        color: AppColors.neutral400,
                                        size: AppSpacing.iconMd,
                                      ),
                                      onPressed: () async {
                                        final result = await showAppModal<
                                            Map<String, dynamic>>(
                                          context: context,
                                          title: 'Edit Entity',
                                          body: EntityFormScreen(
                                            isModal: true,
                                            initialEntity: entity,
                                          ),
                                        );
                                        if (result != null &&
                                            result.containsKey('id') &&
                                            onEdit != null) {
                                          onEdit!(
                                              result['id'] as String, result);
                                        }
                                      },
                                    ),
                                  ),
                                  DataCell(
                                    Row(
                                      mainAxisSize: MainAxisSize.min,
                                      children: [
                                        if (entity.description != null ||
                                            entity.context != null)
                                          IconButton(
                                            tooltip: isExpanded
                                                ? 'Collapse'
                                                : 'Expand',
                                            icon: Icon(
                                              isExpanded
                                                  ? Icons.expand_less
                                                  : Icons.expand_more,
                                              color: AppColors.neutral400,
                                            ),
                                            onPressed: () {
                                              final newSet = Set<String>.from(
                                                  expandedRows.value);
                                              if (isExpanded) {
                                                newSet.remove(recordKey);
                                              } else {
                                                newSet.add(recordKey);
                                              }
                                              expandedRows.value = newSet;
                                            },
                                          ),
                                      ],
                                    ),
                                  ),
                                ],
                              );
                            },
                          ).expand((row) {
                            // Find entity for this row
                            final entityDid =
                                (row.cells[1].child as _EllipsizedCell).text;
                            final entity =
                                entities.firstWhere((e) => e.did == entityDid);
                            final recordKey = entity.id;
                            final isExpanded =
                                expandedRows.value.contains(recordKey);

                            if (!isExpanded) return [row];

                            // Create expanded detail row
                            return [
                              row,
                              DataRow(
                                cells: [
                                  const DataCell(SizedBox.shrink()),
                                  DataCell(
                                    Container(
                                      padding: EdgeInsets.only(
                                        top: AppSpacing.spacing2,
                                        bottom: AppSpacing.spacing2,
                                      ),
                                      decoration: const BoxDecoration(
                                        color: Colors.transparent,
                                      ),
                                      child: Column(
                                        crossAxisAlignment:
                                            CrossAxisAlignment.start,
                                        children: [
                                          if (entity.description != null) ...[
                                            Text(
                                              'Description',
                                              style: AppTypography.labelMedium
                                                  .copyWith(
                                                color: AppColors.neutral400,
                                                fontWeight: AppTypography
                                                    .fontWeightBold,
                                              ),
                                            ),
                                            SizedBox(
                                                height: AppSpacing.spacing0_5),
                                            Text(
                                              entity.description!,
                                              style: AppTypography.bodyMedium
                                                  .copyWith(
                                                color: AppColors.neutral500,
                                              ),
                                            ),
                                            if (entity.context != null)
                                              SizedBox(
                                                  height: AppSpacing.spacing2),
                                          ],
                                          if (entity.context != null) ...[
                                            Text(
                                              'Context',
                                              style: AppTypography.labelMedium
                                                  .copyWith(
                                                color: AppColors.neutral400,
                                                fontWeight: AppTypography
                                                    .fontWeightBold,
                                              ),
                                            ),
                                            SizedBox(
                                                height: AppSpacing.spacing0_5),
                                            Text(
                                              _formatContext(entity.context!),
                                              style: AppTypography.bodyMedium
                                                  .copyWith(
                                                color: AppColors.neutral500,
                                              ),
                                            ),
                                          ],
                                        ],
                                      ),
                                    ),
                                  ),
                                  const DataCell(SizedBox.shrink()),
                                  const DataCell(SizedBox.shrink()),
                                  const DataCell(SizedBox.shrink()),
                                ],
                              ),
                            ];
                          }).toList(),
                        ),
                      ),
                    ),
                  );
                },
              ),
            ),
          ),
        ),
      ],
    );
  }

  String _formatContext(Map<String, dynamic> context) {
    return context.entries.map((e) => '${e.key}: ${e.value}').join('\n');
  }
}

class _EllipsizedCell extends StatelessWidget {
  final String text;
  final double maxWidth;

  const _EllipsizedCell({
    required this.text,
    required this.maxWidth,
  });

  @override
  Widget build(BuildContext context) {
    return ConstrainedBox(
      constraints: BoxConstraints(maxWidth: maxWidth),
      child: Tooltip(
        message: text,
        waitDuration: const Duration(milliseconds: 500),
        child: Text(
          text,
          maxLines: 2,
          overflow: TextOverflow.ellipsis,
        ),
      ),
    );
  }
}
