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
        fillColor: colorScheme.surface,
        contentPadding: const EdgeInsets.symmetric(
          horizontal: AppSpacing.md,
          vertical: 10,
        ),
        border: OutlineInputBorder(
          borderRadius: BorderRadius.circular(12),
          borderSide: BorderSide(color: colorScheme.outlineVariant),
        ),
        enabledBorder: OutlineInputBorder(
          borderRadius: BorderRadius.circular(12),
          borderSide: BorderSide(color: colorScheme.outlineVariant),
        ),
        focusedBorder: OutlineInputBorder(
          borderRadius: BorderRadius.circular(12),
          borderSide: BorderSide(color: colorScheme.primary, width: 1.2),
        ),
        labelStyle: theme.textTheme.bodySmall?.copyWith(
          color: colorScheme.onSurfaceVariant,
        ),
        hintStyle: theme.textTheme.bodyMedium?.copyWith(
          color: colorScheme.onSurfaceVariant,
        ),
      ),
    );

    return LayoutBuilder(
      builder: (context, constraints) {
        final isCompact = constraints.maxWidth < 760;
        final compactFieldWidth = constraints.maxWidth - (AppSpacing.md * 2);
        final searchMaxWidth = isCompact ? compactFieldWidth : 320.0;
        final dropdownWidth = isCompact ? compactFieldWidth : 180.0;

        return Container(
          width: double.infinity,
          decoration: BoxDecoration(
            color: colorScheme.surfaceContainerHighest,
            borderRadius: BorderRadius.circular(16),
            border: Border.all(color: colorScheme.outlineVariant),
          ),
          padding: const EdgeInsets.symmetric(
            horizontal: AppSpacing.md,
            vertical: 8,
          ),
          child: Theme(
            data: controlTheme,
            child: Wrap(
              spacing: AppSpacing.sm,
              runSpacing: AppSpacing.sm,
              crossAxisAlignment: WrapCrossAlignment.center,
              children: [
                SizedBox(
                  width: searchMaxWidth.clamp(0.0, 320.0).toDouble(),
                  child: TextField(
                    controller: searchController,
                    decoration: InputDecoration(
                      hintText: 'Search client, destination, or lead code',
                      prefixIcon: Icon(
                        Icons.search_rounded,
                        size: 18,
                        color: colorScheme.onSurfaceVariant,
                      ),
                      isDense: true,
                    ),
                  ),
                ),
                SizedBox(
                  width: dropdownWidth.clamp(0.0, 180.0).toDouble(),
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
                  width: dropdownWidth.clamp(0.0, 180.0).toDouble(),
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
                SizedBox(
                  width: isCompact ? compactFieldWidth : null,
                  child: OutlinedButton.icon(
                    onPressed: onClearFilters,
                    icon: const Icon(Icons.restart_alt_rounded, size: 16),
                    label: const Text('Clear Filters'),
                    style: OutlinedButton.styleFrom(
                      visualDensity: VisualDensity.compact,
                      minimumSize: Size(isCompact ? compactFieldWidth : 0, 40),
                      backgroundColor: colorScheme.surface,
                      padding: const EdgeInsets.symmetric(
                        horizontal: AppSpacing.md,
                        vertical: 10,
                      ),
                      shape: RoundedRectangleBorder(
                        borderRadius: BorderRadius.circular(12),
                      ),
                    ),
                  ),
                ),
              ],
            ),
          ),
        );
      },
    );
  }
}

class _FilterOption {
  const _FilterOption({required this.value, required this.label});

  final String? value;
  final String label;
}
