import 'package:flutter/material.dart';

import '../../../../core/theme/app_spacing.dart';
import '../../domain/models/lead_model.dart';
import 'lead_table_row_item.dart';

class LeadTable extends StatelessWidget {
  const LeadTable({
    required this.leads,
    super.key,
  });

  final List<LeadModel> leads;

  static const List<_LeadTableColumn> _columns = [
    _LeadTableColumn(label: 'Lead Code', width: leadTableLeadCodeWidth),
    _LeadTableColumn(label: 'Client', width: leadTableClientWidth),
    _LeadTableColumn(label: 'Destination', width: leadTableDestinationWidth),
    _LeadTableColumn(label: 'Travel Type', width: leadTableTravelTypeWidth),
    _LeadTableColumn(label: 'Stage', width: leadTableStageWidth),
    _LeadTableColumn(label: 'Owner', width: leadTableOwnerWidth),
    _LeadTableColumn(label: 'Updated', width: leadTableUpdatedWidth),
  ];

  static const double _tableContentWidth =
      leadTableLeadCodeWidth +
      leadTableClientWidth +
      leadTableDestinationWidth +
      leadTableTravelTypeWidth +
      leadTableStageWidth +
      leadTableOwnerWidth +
      leadTableUpdatedWidth +
      (AppSpacing.md * (_columns.length - 1));

  @override
  Widget build(BuildContext context) {
    final theme = Theme.of(context);
    final colorScheme = theme.colorScheme;

    return Card(
      child: SingleChildScrollView(
        scrollDirection: Axis.horizontal,
        child: ConstrainedBox(
          constraints: const BoxConstraints(minWidth: _tableContentWidth),
          child: Container(
            decoration: BoxDecoration(
              borderRadius: BorderRadius.circular(18),
              border: Border.all(color: colorScheme.outlineVariant),
            ),
            child: Column(
              children: [
                Padding(
                  padding: const EdgeInsets.symmetric(
                    horizontal: AppSpacing.xl,
                    vertical: AppSpacing.lg,
                  ),
                  child: Row(
                    children: [
                      for (var index = 0; index < _columns.length; index++)
                        _LeadTableHeaderCell(
                          label: _columns[index].label,
                          width: _columns[index].width,
                          isLast: index == _columns.length - 1,
                        ),
                    ],
                  ),
                ),
                Divider(
                  height: 1,
                  thickness: 1,
                  color: colorScheme.outlineVariant,
                ),
                ListView.separated(
                  shrinkWrap: true,
                  physics: const NeverScrollableScrollPhysics(),
                  itemCount: leads.length,
                  separatorBuilder: (context, index) => Divider(
                    height: 1,
                    thickness: 1,
                    color: colorScheme.outlineVariant.withValues(alpha: 0.7),
                  ),
                  itemBuilder: (context, index) {
                    return LeadTableRowItem(lead: leads[index]);
                  },
                ),
              ],
            ),
          ),
        ),
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
