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

        return Container(
          padding: EdgeInsets.symmetric(
            horizontal: isCompact ? AppSpacing.lg : AppSpacing.xl,
            vertical: isCompact ? AppSpacing.lg : AppSpacing.xl,
          ),
          decoration: BoxDecoration(
            color: const Color(0xFF1B2637),
            borderRadius: BorderRadius.circular(24),
            border: Border.all(
              color: colorScheme.outlineVariant.withValues(alpha: 0.18),
            ),
          ),
          child: Flex(
            direction: isCompact ? Axis.vertical : Axis.horizontal,
            crossAxisAlignment:
                isCompact ? CrossAxisAlignment.start : CrossAxisAlignment.center,
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
                        fontWeight: FontWeight.w800,
                        letterSpacing: -0.8,
                        height: 1,
                      ),
                    ),
                    const SizedBox(height: AppSpacing.xs),
                    Text(
                      'Track active opportunities and keep the pipeline moving.',
                      style: theme.textTheme.bodyMedium?.copyWith(
                        color: colorScheme.onSurfaceVariant.withValues(
                          alpha: 0.8,
                        ),
                        height: 1.35,
                      ),
                    ),
                  ],
                ),
              ),
              SizedBox(
                height: isCompact ? AppSpacing.lg : 0,
                width: isCompact ? 0 : AppSpacing.xl,
              ),
              FilledButton.icon(
                onPressed: onCreateLead,
                icon: const Icon(Icons.add_rounded, size: 18),
                label: const Text('New Lead'),
                style: FilledButton.styleFrom(
                  backgroundColor: colorScheme.primary,
                  foregroundColor: colorScheme.onPrimary,
                  minimumSize: const Size(0, 48),
                  padding: const EdgeInsets.symmetric(
                    horizontal: AppSpacing.xl,
                    vertical: AppSpacing.md,
                  ),
                  textStyle: theme.textTheme.titleSmall?.copyWith(
                    fontWeight: FontWeight.w700,
                    letterSpacing: 0.1,
                  ),
                  shape: RoundedRectangleBorder(
                    borderRadius: BorderRadius.circular(14),
                  ),
                  elevation: 0,
                ),
              ),
            ],
          ),
        );
      },
    );
  }
}
