import 'package:flutter/material.dart';

import '../../../core/theme/app_spacing.dart';
import '../../../core/widgets/empty_state_view.dart';
import '../../../core/widgets/section_header.dart';
import '../../../core/widgets/stat_card.dart';

class DashboardScreen extends StatelessWidget {
  const DashboardScreen({super.key});

  static const List<_DashboardStat> _summaryStats = [
    _DashboardStat(
      title: 'Pipeline Value',
      value: '--',
      subtitle: 'Placeholder metric for upcoming insights',
      icon: Icons.payments_outlined,
    ),
    _DashboardStat(
      title: 'Open Opportunities',
      value: '--',
      subtitle: 'Reusable summary card for key KPIs',
      icon: Icons.stacked_bar_chart_rounded,
    ),
    _DashboardStat(
      title: 'Active Bookings',
      value: '--',
      subtitle: 'Designed for clean dashboard snapshots',
      icon: Icons.luggage_rounded,
    ),
    _DashboardStat(
      title: 'Team Tasks',
      value: '--',
      subtitle: 'Ready for future module integrations',
      icon: Icons.task_alt_rounded,
    ),
  ];

  @override
  Widget build(BuildContext context) {
    return SingleChildScrollView(
      child: const Column(
        crossAxisAlignment: CrossAxisAlignment.start,
        mainAxisSize: MainAxisSize.min,
        children: [
          _DashboardStatGrid(),
          SizedBox(height: AppSpacing.xxl),
          SectionHeader(title: 'Recent Activity'),
          SizedBox(height: AppSpacing.lg),
          EmptyStateView(
            title: 'No activity yet',
            message: 'Recent updates, timeline items, and system events will appear here once modules are connected.',
            icon: Icons.history_toggle_off_rounded,
          ),
        ],
      ),
    );
  }
}

class _DashboardStatGrid extends StatelessWidget {
  const _DashboardStatGrid();

  @override
  Widget build(BuildContext context) {
    return LayoutBuilder(
      builder: (context, constraints) {
        final width = constraints.maxWidth;
        final crossAxisCount = width >= 1200
            ? 4
            : width >= 800
                ? 2
                : 1;
        final aspectRatio = width >= 1200
            ? 1.45
            : width >= 800
                ? 1.6
                : 2.2;

        return GridView.builder(
          shrinkWrap: true,
          physics: const NeverScrollableScrollPhysics(),
          itemCount: DashboardScreen._summaryStats.length,
          gridDelegate: SliverGridDelegateWithFixedCrossAxisCount(
            crossAxisCount: crossAxisCount,
            mainAxisSpacing: AppSpacing.lg,
            crossAxisSpacing: AppSpacing.lg,
            childAspectRatio: aspectRatio,
          ),
          itemBuilder: (context, index) {
            final stat = DashboardScreen._summaryStats[index];

            return StatCard(
              title: stat.title,
              value: stat.value,
              subtitle: stat.subtitle,
              icon: stat.icon,
            );
          },
        );
      },
    );
  }
}

class _DashboardStat {
  const _DashboardStat({
    required this.title,
    required this.value,
    required this.subtitle,
    required this.icon,
  });

  final String title;
  final String value;
  final String subtitle;
  final IconData icon;
}
