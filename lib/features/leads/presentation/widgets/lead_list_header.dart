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
          padding: EdgeInsets.all(isCompact ? AppSpacing.lg : AppSpacing.xl),
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
                  children: [
                    Container(
                      padding: const EdgeInsets.symmetric(
                        horizontal: AppSpacing.sm,
                        vertical: 6,
                      ),
                      decoration: BoxDecoration(
                        color: colorScheme.primary.withValues(alpha: 0.12),
                        borderRadius: BorderRadius.circular(999),
                      ),
                      child: Text(
                        'Lead workspace',
                        style: theme.textTheme.labelMedium?.copyWith(
                          color: colorScheme.primary,
                          fontWeight: FontWeight.w700,
                          letterSpacing: 0.2,
                        ),
                      ),
                    ),
                    const SizedBox(height: AppSpacing.md),
                    Text(
                      'Leads',
                      style: theme.textTheme.displaySmall?.copyWith(
                        fontWeight: FontWeight.w800,
                        letterSpacing: -1.1,
                        height: 0.98,
                      ),
                    ),
                    const SizedBox(height: AppSpacing.sm),
                    ConstrainedBox(
                      constraints: const BoxConstraints(maxWidth: 620),
                      child: Text(
                        'Manage the active pipeline, triage new inquiries, and keep every opportunity moving with a clear operational view.',
                        style: theme.textTheme.bodyLarge?.copyWith(
                          color: colorScheme.onSurfaceVariant.withValues(
                            alpha: 0.84,
                          ),
                          height: 1.45,
                        ),
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
                  minimumSize: const Size(0, 52),
                  padding: const EdgeInsets.symmetric(
                    horizontal: AppSpacing.xl,
                    vertical: AppSpacing.md,
                  ),
                  textStyle: theme.textTheme.titleSmall?.copyWith(
                    fontWeight: FontWeight.w700,
                    letterSpacing: 0.1,
                  ),
                  shape: RoundedRectangleBorder(
                    borderRadius: BorderRadius.circular(16),
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
