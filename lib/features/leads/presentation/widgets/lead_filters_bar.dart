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

    return Container(
      decoration: BoxDecoration(
        color: colorScheme.surfaceContainerHighest.withValues(alpha: 0.14),
        borderRadius: BorderRadius.circular(16),
        border: Border.all(
          color: colorScheme.outlineVariant.withValues(alpha: 0.45),
        ),
      ),
      padding: const EdgeInsets.symmetric(
        horizontal: AppSpacing.md,
        vertical: 10,
      ),
      child: Theme(
        data: theme,
        child: Wrap(
          spacing: AppSpacing.sm,
          runSpacing: AppSpacing.sm,
          crossAxisAlignment: WrapCrossAlignment.center,
          children: [
            ConstrainedBox(
              constraints: const BoxConstraints(minWidth: 240, maxWidth: 336),
              child: TextField(
                controller: searchController,
                decoration: const InputDecoration(
                  hintText: 'Search by client or destination',
                  prefixIcon: Icon(Icons.search_rounded),
                  isDense: true,
                ),
              ),
            ),
            SizedBox(
              width: 206,
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
              width: 206,
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
                foregroundColor: colorScheme.onSurfaceVariant,
                visualDensity: VisualDensity.compact,
                minimumSize: const Size(0, 44),
                side: BorderSide(
                  color: colorScheme.outlineVariant.withValues(alpha: 0.68),
                ),
                padding: const EdgeInsets.symmetric(
                  horizontal: AppSpacing.lg,
                  vertical: 13,
                ),
                shape: RoundedRectangleBorder(
                  borderRadius: BorderRadius.circular(14),
                ),
              ),
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
