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

    return LayoutBuilder(
      builder: (context, constraints) {
        final isCompact = constraints.maxWidth < 760;

        return Padding(
          padding: const EdgeInsets.only(bottom: AppSpacing.xs),
          child: Flex(
            direction: isCompact ? Axis.vertical : Axis.horizontal,
            crossAxisAlignment: isCompact
                ? CrossAxisAlignment.start
                : CrossAxisAlignment.center,
            children: [
              Expanded(
                flex: isCompact ? 0 : 1,
                child: Column(
                  crossAxisAlignment: CrossAxisAlignment.start,
                  mainAxisSize: MainAxisSize.min,
                  children: [
                    Text(
                      'Leads',
                      style: theme.textTheme.headlineMedium?.copyWith(
                        fontWeight: FontWeight.w700,
                        letterSpacing: -0.55,
                        height: 1.06,
                      ),
                    ),
                    const SizedBox(height: 4),
                    Text(
                      'Manage and monitor all active lead inquiries',
                      style: theme.textTheme.bodyMedium?.copyWith(
                        color: colorScheme.onSurfaceVariant.withValues(alpha: 0.88),
                        height: 1.28,
                      ),
                    ),
                  ],
                ),
              ),
              SizedBox(
                height: isCompact ? AppSpacing.md : 0,
                width: isCompact ? 0 : AppSpacing.lg,
              ),
              ElevatedButton.icon(
                onPressed: onCreateLead,
                icon: const Icon(Icons.add_rounded, size: 18),
                label: const Text('New Lead'),
                style: ElevatedButton.styleFrom(
                  visualDensity: VisualDensity.compact,
                  minimumSize: const Size(0, 44),
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
        );
      },
    );
  }
}
