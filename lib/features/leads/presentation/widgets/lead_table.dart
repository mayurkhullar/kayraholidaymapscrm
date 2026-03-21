import 'dart:math' as math;

import 'package:flutter/material.dart';

import '../../../../core/theme/app_spacing.dart';
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

  static final double _tableContentWidth =
      leadTableLeadCodeWidth +
      leadTableClientWidth +
      leadTableDestinationWidth +
      leadTableTravelTypeWidth +
      leadTableBudgetWidth +
      leadTableStageWidth +
      leadTableOwnerWidth +
      leadTableUpdatedWidth +
      (AppSpacing.md * (_columns.length - 1)) +
      (AppSpacing.xl * 2);

  @override
  State<LeadTable> createState() => _LeadTableState();
}

class _LeadTableState extends State<LeadTable> {
  late final ScrollController _horizontalScrollController;
  _LeadSortColumn? _sortColumn;
  bool _isAscending = true;

  @override
  void initState() {
    super.initState();
    _horizontalScrollController = ScrollController();
  }

  @override
  void dispose() {
    _horizontalScrollController.dispose();
    super.dispose();
  }

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

    return Card(
      child: LayoutBuilder(
        builder: (context, constraints) {
          final viewportWidth = constraints.maxWidth.isFinite
              ? constraints.maxWidth
              : LeadTable._tableContentWidth;
          final tableWidth = math.max(viewportWidth, LeadTable._tableContentWidth);

          return Scrollbar(
            controller: _horizontalScrollController,
            thumbVisibility: tableWidth > viewportWidth,
            child: SingleChildScrollView(
              controller: _horizontalScrollController,
              scrollDirection: Axis.horizontal,
              child: ConstrainedBox(
                constraints: BoxConstraints(minWidth: tableWidth),
                child: Container(
                  decoration: BoxDecoration(
                    borderRadius: BorderRadius.circular(18),
                    border: Border.all(color: colorScheme.outlineVariant),
                  ),
                  child: Column(
                    crossAxisAlignment: CrossAxisAlignment.start,
                    children: [
                      Padding(
                        padding: const EdgeInsets.symmetric(
                          horizontal: AppSpacing.xl,
                          vertical: AppSpacing.lg,
                        ),
                        child: Row(
                          children: [
                            for (
                              var index = 0;
                              index < LeadTable._columns.length;
                              index++
                            )
                              _LeadTableHeaderCell(
                                label: LeadTable._columns[index].label,
                                width: LeadTable._columns[index].width,
                                isLast: index == LeadTable._columns.length - 1,
                                isActive:
                                    LeadTable._columns[index].sortKey == _sortColumn,
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
                      Divider(
                        height: 1,
                        thickness: 1,
                        color: colorScheme.outlineVariant,
                      ),
                      Column(
                        children: [
                          for (var index = 0; index < sortedLeads.length; index++) ...[
                            LeadTableRowItem(
                              lead: sortedLeads[index],
                              onTap: widget.onLeadTap == null
                                  ? null
                                  : () => widget.onLeadTap!(sortedLeads[index]),
                            ),
                            if (index < sortedLeads.length - 1)
                              Divider(
                                height: 1,
                                thickness: 1,
                                color: colorScheme.outlineVariant.withValues(
                                  alpha: 0.7,
                                ),
                              ),
                          ],
                        ],
                      ),
                    ],
                  ),
                ),
              ),
            ),
          );
        },
      ),
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
      color: isActive ? colorScheme.onSurface : colorScheme.onSurfaceVariant,
      fontWeight: FontWeight.w700,
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
                  hoverColor: colorScheme.primary.withValues(alpha: 0.04),
                  splashColor: colorScheme.primary.withValues(alpha: 0.06),
                  child: Padding(
                    padding: const EdgeInsets.symmetric(
                      horizontal: AppSpacing.sm,
                      vertical: AppSpacing.xs,
                    ),
                    child: Row(
                      mainAxisSize: MainAxisSize.min,
                      children: [
                        Flexible(
                          child: Text(
                            label,
                            style: textStyle,
                            overflow: TextOverflow.ellipsis,
                          ),
                        ),
                        if (isActive) ...[
                          const SizedBox(width: AppSpacing.xs),
                          Text(
                            isAscending ? '↑' : '↓',
                            style: theme.textTheme.labelMedium?.copyWith(
                              color: colorScheme.primary,
                              fontWeight: FontWeight.w700,
                            ),
                          ),
                        ],
                      ],
                    ),
                  ),
                ),
              ),
      ),
    );
  }
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

enum _LeadSortColumn {
  leadCode,
  client,
  destination,
  updated,
}
