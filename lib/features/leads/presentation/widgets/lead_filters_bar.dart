import 'package:flutter/material.dart';

import '../../../../core/theme/app_spacing.dart';

class LeadFiltersBar extends StatelessWidget {
  const LeadFiltersBar({
    required this.searchController,
    required this.selectedStage,
    required this.selectedTravelType,
    required this.onStageChanged,
    required this.onTravelTypeChanged,
    required this.onClearFilters,
    super.key,
  });

  final TextEditingController searchController;
  final String? selectedStage;
  final String? selectedTravelType;
  final ValueChanged<String?> onStageChanged;
  final ValueChanged<String?> onTravelTypeChanged;
  final VoidCallback onClearFilters;

  static const List<_FilterOption> _stageOptions = [
    _FilterOption(value: null, label: 'All Stages'),
    _FilterOption(value: 'NEW_LEAD', label: 'New Lead'),
    _FilterOption(value: 'CONTACTED', label: 'Contacted'),
    _FilterOption(value: 'QUOTATION_SENT', label: 'Quotation Sent'),
    _FilterOption(value: 'NEGOTIATION', label: 'Negotiation'),
    _FilterOption(value: 'ON_HOLD', label: 'On Hold'),
    _FilterOption(value: 'CONFIRMED', label: 'Confirmed'),
    _FilterOption(value: 'LOST', label: 'Lost'),
  ];

  static const List<_FilterOption> _travelTypeOptions = [
    _FilterOption(value: null, label: 'All Types'),
    _FilterOption(value: 'FIT', label: 'FIT'),
    _FilterOption(value: 'CORPORATE', label: 'Corporate'),
    _FilterOption(value: 'GROUP', label: 'Group'),
    _FilterOption(value: 'MICE', label: 'MICE'),
  ];

  @override
  Widget build(BuildContext context) {
    final theme = Theme.of(context);
    final colorScheme = theme.colorScheme;
    final inputDecorationTheme = theme.inputDecorationTheme;

    final controlTheme = theme.copyWith(
      inputDecorationTheme: inputDecorationTheme.copyWith(
        filled: true,
        fillColor: const Color(0xFF0F1723),
        contentPadding: const EdgeInsets.symmetric(
          horizontal: AppSpacing.md,
          vertical: AppSpacing.md,
        ),
        border: OutlineInputBorder(
          borderRadius: BorderRadius.circular(14),
          borderSide: BorderSide(
            color: colorScheme.outlineVariant.withValues(alpha: 0.22),
          ),
        ),
        enabledBorder: OutlineInputBorder(
          borderRadius: BorderRadius.circular(14),
          borderSide: BorderSide(
            color: colorScheme.outlineVariant.withValues(alpha: 0.22),
          ),
        ),
        focusedBorder: OutlineInputBorder(
          borderRadius: BorderRadius.circular(14),
          borderSide: BorderSide(
            color: colorScheme.primary.withValues(alpha: 0.48),
          ),
        ),
        labelStyle: theme.textTheme.bodySmall?.copyWith(
          color: colorScheme.onSurfaceVariant.withValues(alpha: 0.76),
        ),
        hintStyle: theme.textTheme.bodyMedium?.copyWith(
          color: colorScheme.onSurfaceVariant.withValues(alpha: 0.68),
        ),
      ),
    );

    return Container(
      decoration: BoxDecoration(
        color: const Color(0xFF111A27),
        borderRadius: BorderRadius.circular(20),
        border: Border.all(
          color: colorScheme.outlineVariant.withValues(alpha: 0.16),
        ),
      ),
      padding: const EdgeInsets.all(AppSpacing.lg),
      child: Theme(
        data: controlTheme,
        child: Column(
          crossAxisAlignment: CrossAxisAlignment.start,
          children: [
            Text(
              'Refine lead view',
              style: theme.textTheme.titleSmall?.copyWith(
                fontWeight: FontWeight.w700,
                letterSpacing: -0.1,
              ),
            ),
            const SizedBox(height: 4),
            Text(
              'Search and narrow the pipeline without changing the current workflow.',
              style: theme.textTheme.bodySmall?.copyWith(
                color: colorScheme.onSurfaceVariant.withValues(alpha: 0.76),
              ),
            ),
            const SizedBox(height: AppSpacing.lg),
            Wrap(
              spacing: AppSpacing.md,
              runSpacing: AppSpacing.md,
              crossAxisAlignment: WrapCrossAlignment.center,
              children: [
                ConstrainedBox(
                  constraints: const BoxConstraints(
                    minWidth: 260,
                    maxWidth: 380,
                  ),
                  child: TextField(
                    controller: searchController,
                    decoration: InputDecoration(
                      hintText: 'Search by client, destination, or lead code',
                      prefixIcon: Icon(
                        Icons.search_rounded,
                        color: colorScheme.onSurfaceVariant.withValues(
                          alpha: 0.76,
                        ),
                      ),
                      isDense: true,
                    ),
                  ),
                ),
                SizedBox(
                  width: 210,
                  child: DropdownButtonFormField<String?>(
                    value: selectedStage,
                    decoration: const InputDecoration(
                      labelText: 'Stage',
                      isDense: true,
                    ),
                    items: _stageOptions
                        .map(
                          (option) => DropdownMenuItem<String?>(
                            value: option.value,
                            child: Text(option.label),
                          ),
                        )
                        .toList(growable: false),
                    onChanged: onStageChanged,
                  ),
                ),
                SizedBox(
                  width: 210,
                  child: DropdownButtonFormField<String?>(
                    value: selectedTravelType,
                    decoration: const InputDecoration(
                      labelText: 'Travel Type',
                      isDense: true,
                    ),
                    items: _travelTypeOptions
                        .map(
                          (option) => DropdownMenuItem<String?>(
                            value: option.value,
                            child: Text(option.label),
                          ),
                        )
                        .toList(growable: false),
                    onChanged: onTravelTypeChanged,
                  ),
                ),
                OutlinedButton.icon(
                  onPressed: onClearFilters,
                  icon: const Icon(Icons.restart_alt_rounded, size: 18),
                  label: const Text('Clear Filters'),
                  style: OutlinedButton.styleFrom(
                    foregroundColor: colorScheme.onSurface,
                    visualDensity: VisualDensity.compact,
                    minimumSize: const Size(0, 48),
                    side: BorderSide(
                      color: colorScheme.outlineVariant.withValues(alpha: 0.28),
                    ),
                    backgroundColor: colorScheme.surface.withValues(alpha: 0.16),
                    padding: const EdgeInsets.symmetric(
                      horizontal: AppSpacing.lg,
                      vertical: AppSpacing.md,
                    ),
                    shape: RoundedRectangleBorder(
                      borderRadius: BorderRadius.circular(14),
                    ),
                  ),
                ),
              ],
            ),
          ],
        ),
      ),
    );
  }
}

class _FilterOption {
  const _FilterOption({required this.value, required this.label});

  final String? value;
  final String label;
}
