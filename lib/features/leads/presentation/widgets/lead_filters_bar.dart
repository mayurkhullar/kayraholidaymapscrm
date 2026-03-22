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
          vertical: 12,
        ),
        border: OutlineInputBorder(
          borderRadius: BorderRadius.circular(12),
          borderSide: BorderSide(
            color: colorScheme.outlineVariant.withValues(alpha: 0.22),
          ),
        ),
        enabledBorder: OutlineInputBorder(
          borderRadius: BorderRadius.circular(12),
          borderSide: BorderSide(
            color: colorScheme.outlineVariant.withValues(alpha: 0.22),
          ),
        ),
        focusedBorder: OutlineInputBorder(
          borderRadius: BorderRadius.circular(12),
          borderSide: BorderSide(
            color: colorScheme.primary.withValues(alpha: 0.52),
          ),
        ),
        labelStyle: theme.textTheme.bodySmall?.copyWith(
          color: colorScheme.onSurfaceVariant.withValues(alpha: 0.76),
        ),
        hintStyle: theme.textTheme.bodyMedium?.copyWith(
          color: colorScheme.onSurfaceVariant.withValues(alpha: 0.66),
        ),
      ),
    );

    return Container(
      width: double.infinity,
      decoration: BoxDecoration(
        color: colorScheme.surfaceContainerHighest,
        borderRadius: BorderRadius.circular(18),
        border: Border.all(
          color: colorScheme.outlineVariant.withValues(alpha: 0.16),
        ),
      ),
      padding: const EdgeInsets.all(AppSpacing.md),
      child: Theme(
        data: controlTheme,
        child: Wrap(
          spacing: AppSpacing.md,
          runSpacing: AppSpacing.sm,
          crossAxisAlignment: WrapCrossAlignment.center,
          children: [
            ConstrainedBox(
              constraints: const BoxConstraints(
                minWidth: 240,
                maxWidth: 360,
              ),
              child: TextField(
                controller: searchController,
                decoration: InputDecoration(
                  hintText: 'Search client, destination, or lead code',
                  prefixIcon: Icon(
                    Icons.search_rounded,
                    size: 18,
                    color: colorScheme.onSurfaceVariant.withValues(
                      alpha: 0.72,
                    ),
                  ),
                  isDense: true,
                ),
              ),
            ),
            SizedBox(
              width: 190,
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
              width: 190,
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
              icon: const Icon(Icons.restart_alt_rounded, size: 17),
              label: const Text('Clear Filters'),
              style: OutlinedButton.styleFrom(
                foregroundColor: colorScheme.onSurface.withValues(alpha: 0.94),
                visualDensity: VisualDensity.compact,
                minimumSize: const Size(0, 44),
                side: BorderSide(
                  color: colorScheme.outlineVariant.withValues(alpha: 0.22),
                ),
                backgroundColor: colorScheme.surface.withValues(alpha: 0.92),
                padding: const EdgeInsets.symmetric(
                  horizontal: AppSpacing.md,
                  vertical: AppSpacing.md,
                ),
                shape: RoundedRectangleBorder(
                  borderRadius: BorderRadius.circular(12),
                ),
              ).copyWith(
                overlayColor: WidgetStateProperty.resolveWith((states) {
                  if (states.contains(WidgetState.pressed)) {
                    return colorScheme.primary.withValues(alpha: 0.08);
                  }
                  if (states.contains(WidgetState.hovered)) {
                    return colorScheme.onSurface.withValues(alpha: 0.03);
                  }
                  return null;
                }),
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
