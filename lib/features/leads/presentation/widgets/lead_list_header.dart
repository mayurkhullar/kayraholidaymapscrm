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

        return Flex(
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
                    'Track active opportunities, review the pipeline, and take the next action quickly.',
                    style: theme.textTheme.bodyMedium?.copyWith(
                      color: colorScheme.onSurfaceVariant,
                      height: 1.35,
                    ),
                  ),
                ],
              ),
            ),
            SizedBox(
              width: isCompact ? 0 : AppSpacing.lg,
              height: isCompact ? AppSpacing.md : 0,
            ),
            FilledButton.icon(
              onPressed: onCreateLead,
              icon: const Icon(Icons.add_rounded, size: 18),
              label: const Text('New Lead'),
              style: FilledButton.styleFrom(
                minimumSize: const Size(0, 44),
                padding: const EdgeInsets.symmetric(
                  horizontal: AppSpacing.lg,
                  vertical: AppSpacing.md,
                ),
                textStyle: theme.textTheme.titleSmall?.copyWith(
                  fontWeight: FontWeight.w700,
                  letterSpacing: 0.1,
                ),
                shape: RoundedRectangleBorder(
                  borderRadius: BorderRadius.circular(12),
                ),
              ),
            ),
          ],
        );
      },
    );
  }
}
