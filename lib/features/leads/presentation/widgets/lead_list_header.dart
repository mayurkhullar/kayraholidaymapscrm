import 'package:flutter/material.dart';

import '../../../../core/theme/app_spacing.dart';

class LeadListHeader extends StatelessWidget {
  const LeadListHeader({
    required this.onCreateLead,
    super.key,
  });

  final VoidCallback onCreateLead;

  @override
  Widget build(BuildContext context) {
    final theme = Theme.of(context);
    final colorScheme = theme.colorScheme;

    return Wrap(
      spacing: AppSpacing.lg,
      runSpacing: AppSpacing.sm,
      crossAxisAlignment: WrapCrossAlignment.center,
      alignment: WrapAlignment.spaceBetween,
      children: [
        ConstrainedBox(
          constraints: const BoxConstraints(maxWidth: 680),
          child: Column(
            crossAxisAlignment: CrossAxisAlignment.start,
            mainAxisSize: MainAxisSize.min,
            children: [
              Text(
                'Leads',
                style: theme.textTheme.headlineSmall?.copyWith(
                  fontWeight: FontWeight.w700,
                ),
              ),
              const SizedBox(height: AppSpacing.xs),
              Text(
                'Manage and monitor all active lead inquiries',
                style: theme.textTheme.bodyLarge?.copyWith(
                  color: colorScheme.onSurfaceVariant,
                ),
              ),
            ],
          ),
        ),
        ElevatedButton.icon(
          onPressed: onCreateLead,
          icon: const Icon(Icons.add_rounded),
          label: const Text('+ New Lead'),
        ),
      ],
    );
  }
}
