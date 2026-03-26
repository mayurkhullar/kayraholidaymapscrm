import 'dart:math' as math;

import 'package:flutter/material.dart';

import '../../../../core/theme/app_spacing.dart';
import '../../../../core/widgets/two_axis_table_viewport.dart';
import '../../domain/models/lead_model.dart';
import 'lead_table_row_item.dart';

class LeadTable extends StatefulWidget {
  const LeadTable({
    required this.leads,
    super.key,
    this.onLeadTap,
  });

  final List<LeadModel> leads;
  final ValueChanged<LeadModel>? onLeadTap;

  static const List<_LeadTableColumn> _columns = [
    _LeadTableColumn(
      label: 'Lead Code',
      width: leadTableLeadCodeWidth,
      sortKey: _LeadSortColumn.leadCode,
    ),
    _LeadTableColumn(
      label: 'Client',
      width: leadTableClientWidth,
      sortKey: _LeadSortColumn.client,
    ),
    _LeadTableColumn(
      label: 'Destination',
      width: leadTableDestinationWidth,
      sortKey: _LeadSortColumn.destination,
    ),
    _LeadTableColumn(label: 'Travel Type', width: leadTableTravelTypeWidth),
    _LeadTableColumn(label: 'Budget', width: leadTableBudgetWidth),
    _LeadTableColumn(label: 'Stage', width: leadTableStageWidth),
    _LeadTableColumn(label: 'Owner', width: leadTableOwnerWidth),
    _LeadTableColumn(
      label: 'Updated',
      width: leadTableUpdatedWidth,
      sortKey: _LeadSortColumn.updated,
    ),
  ];

  static const double _minTableWidth = 1100;

  static final double _tableContentWidth = math.max(
    _minTableWidth,
    leadTableLeadCodeWidth +
        leadTableClientWidth +
        leadTableDestinationWidth +
        leadTableTravelTypeWidth +
        leadTableBudgetWidth +
        leadTableStageWidth +
        leadTableOwnerWidth +
        leadTableUpdatedWidth +
        (AppSpacing.md * (_columns.length - 1)) +
        (16 * 2),
  );

  @override
  State<LeadTable> createState() => _LeadTableState();
}

class _LeadTableState extends State<LeadTable> {
  _LeadSortColumn? _sortColumn;
  bool _isAscending = true;

  void _handleSort(_LeadSortColumn sortColumn) {
    setState(() {
      if (_sortColumn == sortColumn) {
        _isAscending = !_isAscending;
      } else {
        _sortColumn = sortColumn;
        _isAscending = true;
      }
    });
  }

  List<LeadModel> _sortedLeads(List<LeadModel> leads) {
    final sortedLeads = List<LeadModel>.of(leads);
    final sortColumn = _sortColumn;

    if (sortColumn == null) {
      return sortedLeads;
    }

    int compareStrings(String? left, String? right) {
      final normalizedLeft = (left ?? '').trim().toLowerCase();
      final normalizedRight = (right ?? '').trim().toLowerCase();
      return normalizedLeft.compareTo(normalizedRight);
    }

    int compareDates(DateTime? left, DateTime? right) {
      if (left == null && right == null) {
        return 0;
      }
      if (left == null) {
        return -1;
      }
      if (right == null) {
        return 1;
      }
      return left.compareTo(right);
    }

    sortedLeads.sort((left, right) {
      final comparison = switch (sortColumn) {
        _LeadSortColumn.leadCode => compareStrings(left.leadCode, right.leadCode),
        _LeadSortColumn.client => compareStrings(
          left.clientNameSnapshot,
          right.clientNameSnapshot,
        ),
        _LeadSortColumn.destination => compareStrings(
          left.destination,
          right.destination,
        ),
        _LeadSortColumn.updated => compareDates(left.updatedAt, right.updatedAt),
      };

      return _isAscending ? comparison : -comparison;
    });

    return sortedLeads;
  }

  @override
  Widget build(BuildContext context) {
    final theme = Theme.of(context);
    final colorScheme = theme.colorScheme;
    final sortedLeads = _sortedLeads(widget.leads);

    return LayoutBuilder(
      builder: (context, _) {
        return Container(
          width: double.infinity,
          decoration: BoxDecoration(
            color: colorScheme.surface,
            borderRadius: BorderRadius.circular(20),
            border: Border.all(
              color: colorScheme.outlineVariant.withValues(alpha: 0.68),
            ),
            boxShadow: const [
              BoxShadow(
                color: Color(0x050F172A),
                blurRadius: 10,
                offset: Offset(0, 2),
              ),
            ],
          ),
          clipBehavior: Clip.antiAlias,
          child: TwoAxisTableViewport(
            minContentWidth: LeadTable._tableContentWidth,
            header: Container(
              decoration: BoxDecoration(
                color: colorScheme.surfaceContainerHighest.withValues(
                  alpha: 0.82,
                ),
                border: Border(
                  bottom: BorderSide(
                    color: colorScheme.outlineVariant.withValues(
                      alpha: 0.7,
                    ),
                  ),
                ),
              ),
              padding: const EdgeInsets.symmetric(
                horizontal: 16,
                vertical: 10,
              ),
              child: Row(
                children: [
                  for (var index = 0; index < LeadTable._columns.length; index++)
                    _LeadTableHeaderCell(
                      label: LeadTable._columns[index].label,
                      width: LeadTable._columns[index].width,
                      isLast: index == LeadTable._columns.length - 1,
                      isActive: LeadTable._columns[index].sortKey == _sortColumn,
                      isAscending: _isAscending,
                      onTap: LeadTable._columns[index].sortKey == null
                          ? null
                          : () => _handleSort(
                                LeadTable._columns[index].sortKey!,
                              ),
                    ),
                ],
              ),
            ),
            bodyBuilder: (context, verticalController) {
              if (sortedLeads.isEmpty) {
                return ListView(
                  controller: verticalController,
                  padding: const EdgeInsets.all(AppSpacing.lg),
                  children: [
                    Text(
                      'No leads available.',
                      style: theme.textTheme.bodyMedium?.copyWith(
                        color: colorScheme.onSurfaceVariant,
                      ),
                    ),
                  ],
                );
              }

              return ListView.separated(
                controller: verticalController,
                padding: EdgeInsets.zero,
                itemCount: sortedLeads.length,
                separatorBuilder: (context, index) => Divider(
                  height: 1,
                  thickness: 1,
                  color: colorScheme.outlineVariant.withValues(
                    alpha: 0.35,
                  ),
                ),
                itemBuilder: (context, index) => LeadTableRowItem(
                  lead: sortedLeads[index],
                  index: index,
                  onTap: widget.onLeadTap == null
                      ? null
                      : () => widget.onLeadTap!(sortedLeads[index]),
                ),
              );
            },
          ),
        );
      },
    );
  }
}

class _LeadTableHeaderCell extends StatelessWidget {
  const _LeadTableHeaderCell({
    required this.label,
    required this.width,
    required this.isLast,
    required this.isActive,
    required this.isAscending,
    this.onTap,
  });

  final String label;
  final double width;
  final bool isLast;
  final bool isActive;
  final bool isAscending;
  final VoidCallback? onTap;

  @override
  Widget build(BuildContext context) {
    final theme = Theme.of(context);
    final colorScheme = theme.colorScheme;
    final textStyle = theme.textTheme.labelLarge?.copyWith(
      color: isActive
          ? colorScheme.onSurface
          : colorScheme.onSurface.withValues(alpha: 0.9),
      fontWeight: FontWeight.w600,
      letterSpacing: 0.05,
    );

    return Padding(
      padding: EdgeInsets.only(right: isLast ? 0 : AppSpacing.md),
      child: SizedBox(
        width: width,
        child: onTap == null
            ? Text(label, style: textStyle)
            : Material(
                color: Colors.transparent,
                child: InkWell(
                  onTap: onTap,
                  borderRadius: BorderRadius.circular(10),
                  child: Padding(
                    padding: const EdgeInsets.symmetric(vertical: 2),
                    child: Row(
                      children: [
                        Flexible(child: Text(label, style: textStyle)),
                        const SizedBox(width: AppSpacing.xs),
                        Icon(
                          isActive
                              ? (isAscending
                                  ? Icons.arrow_upward_rounded
                                  : Icons.arrow_downward_rounded)
                              : Icons.unfold_more_rounded,
                          size: 16,
                          color: isActive
                              ? colorScheme.primary
                              : colorScheme.onSurfaceVariant,
                        ),
                      ],
                    ),
                  ),
                ),
              ),
      ),
    );
  }
}

enum _LeadSortColumn {
  leadCode,
  client,
  destination,
  updated,
}

class _LeadTableColumn {
  const _LeadTableColumn({
    required this.label,
    required this.width,
    this.sortKey,
  });

  final String label;
  final double width;
  final _LeadSortColumn? sortKey;
}
