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
    _LeadTableColumn(label: 'Lead Code', flex: 2),
    _LeadTableColumn(label: 'Client', flex: 2),
    _LeadTableColumn(label: 'Destination', flex: 2),
    _LeadTableColumn(label: 'Travel Type', flex: 2),
    _LeadTableColumn(label: 'Stage', flex: 2),
    _LeadTableColumn(label: 'Owner', flex: 2),
    _LeadTableColumn(label: 'Updated', flex: 2),
  ];

  @override
  Widget build(BuildContext context) {
    final theme = Theme.of(context);
    final colorScheme = theme.colorScheme;

    return Card(
      child: SingleChildScrollView(
        scrollDirection: Axis.horizontal,
        child: ConstrainedBox(
          constraints: const BoxConstraints(minWidth: 980),
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
                    children: _columns
                        .map(
                          (column) => Expanded(
                            flex: column.flex,
                            child: Text(
                              column.label,
                              style: theme.textTheme.labelLarge?.copyWith(
                                color: colorScheme.onSurfaceVariant,
                                fontWeight: FontWeight.w700,
                              ),
                            ),
                          ),
                        )
                        .toList(growable: false),
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

class _LeadTableColumn {
  const _LeadTableColumn({required this.label, required this.flex});

  final String label;
  final int flex;
}
