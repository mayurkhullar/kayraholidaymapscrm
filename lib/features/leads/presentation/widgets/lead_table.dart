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
    _LeadTableColumn(label: 'Lead Code', width: leadTableLeadCodeWidth),
    _LeadTableColumn(label: 'Client', width: leadTableClientWidth),
    _LeadTableColumn(label: 'Destination', width: leadTableDestinationWidth),
    _LeadTableColumn(label: 'Travel Type', width: leadTableTravelTypeWidth),
    _LeadTableColumn(label: 'Budget', width: leadTableBudgetWidth),
    _LeadTableColumn(label: 'Stage', width: leadTableStageWidth),
    _LeadTableColumn(label: 'Owner', width: leadTableOwnerWidth),
    _LeadTableColumn(label: 'Updated', width: leadTableUpdatedWidth),
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

  @override
  Widget build(BuildContext context) {
    final theme = Theme.of(context);
    final colorScheme = theme.colorScheme;

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
                          for (var index = 0; index < widget.leads.length; index++) ...[
                            LeadTableRowItem(
                              lead: widget.leads[index],
                              onTap: widget.onLeadTap == null
                                  ? null
                                  : () => widget.onLeadTap!(widget.leads[index]),
                            ),
                            if (index < widget.leads.length - 1)
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
  });

  final String label;
  final double width;
  final bool isLast;

  @override
  Widget build(BuildContext context) {
    final theme = Theme.of(context);
    final colorScheme = theme.colorScheme;

    return Padding(
      padding: EdgeInsets.only(right: isLast ? 0 : AppSpacing.md),
      child: SizedBox(
        width: width,
        child: Text(
          label,
          style: theme.textTheme.labelLarge?.copyWith(
            color: colorScheme.onSurfaceVariant,
            fontWeight: FontWeight.w700,
          ),
        ),
      ),
    );
  }
}

class _LeadTableColumn {
  const _LeadTableColumn({required this.label, required this.width});

  final String label;
  final double width;
}
