import 'package:cloud_firestore/cloud_firestore.dart';
import 'package:flutter/material.dart';

import '../../../core/theme/app_spacing.dart';
import '../../../core/widgets/app_shell.dart';
import '../../../core/widgets/empty_state_view.dart';
import '../../../core/widgets/page_container.dart';
import '../domain/models/lead_model.dart';
import 'widgets/lead_list_header.dart';
import 'widgets/lead_table.dart';

class LeadsScreen extends StatefulWidget {
  const LeadsScreen({super.key});

  static final Stream<List<LeadModel>> _leadsStream = FirebaseFirestore.instance
      .collection('leads')
      .where('isArchived', isEqualTo: false)
      .limit(20)
      .snapshots()
      .map(
        (snapshot) => snapshot.docs
            .map(
              (doc) => LeadModel.fromMap(<String, dynamic>{
                ...doc.data(),
                'id': doc.id,
              }),
            )
            .toList(growable: false),
      );

  @override
  State<LeadsScreen> createState() => _LeadsScreenState();
}

class _LeadsScreenState extends State<LeadsScreen> {
  bool _isSeedingDummyLeads = false;

  Future<void> _seedDummyLeads() async {
    setState(() {
      _isSeedingDummyLeads = true;
    });

    final leadsCollection = FirebaseFirestore.instance.collection('leads');
    final leadOne = <String, dynamic>{
      'leadCode': 'LD-001',
      'clientNameSnapshot': 'John Doe',
      'destination': 'Dubai',
      'travelType': 'fit',
      'tripScope': 'international',
      'leadStage': 'newLead',
      'leadOwnerId': 'EMP001',
      'isArchived': false,
      'createdAt': Timestamp.now(),
      'updatedAt': Timestamp.now(),
    };
    final leadTwo = <String, dynamic>{
      'leadCode': 'LD-002',
      'clientNameSnapshot': 'Sarah Khan',
      'destination': 'Singapore',
      'travelType': 'corporate',
      'tripScope': 'international',
      'leadStage': 'contacted',
      'leadOwnerId': 'EMP002',
      'isArchived': false,
      'createdAt': Timestamp.now(),
      'updatedAt': Timestamp.now(),
    };
    final leadThree = <String, dynamic>{
      'leadCode': 'LD-003',
      'clientNameSnapshot': 'Rahul Mehta',
      'destination': 'Bali',
      'travelType': 'fit',
      'tripScope': 'international',
      'leadStage': 'quotationSent',
      'leadOwnerId': 'EMP001',
      'isArchived': false,
      'createdAt': Timestamp.now(),
      'updatedAt': Timestamp.now(),
    };

    try {
      await Future.wait<void>([
        leadsCollection.doc('seed_ld_001').set(leadOne),
        leadsCollection.doc('seed_ld_002').set(leadTwo),
        leadsCollection.doc('seed_ld_003').set(leadThree),
      ]);
      print('Dummy leads seeded successfully');

      if (!mounted) {
        return;
      }

      ScaffoldMessenger.of(context).showSnackBar(
        const SnackBar(
          content: Text('Dummy leads seeded successfully'),
        ),
      );
    } finally {
      if (mounted) {
        setState(() {
          _isSeedingDummyLeads = false;
        });
      }
    }
  }

  @override
  Widget build(BuildContext context) {
    return AppShell(
      pageTitle: 'Leads',
      child: PageContainer(
        child: Column(
          crossAxisAlignment: CrossAxisAlignment.start,
          children: [
            LeadListHeader(
              onCreateLead: () {},
            ),
            const SizedBox(height: AppSpacing.md),
            Align(
              alignment: Alignment.centerRight,
              child: OutlinedButton(
                onPressed: _isSeedingDummyLeads ? null : _seedDummyLeads,
                child: Text(
                  _isSeedingDummyLeads
                      ? 'Seeding Dummy Leads...'
                      : 'Seed Dummy Leads',
                ),
              ),
            ),
            const SizedBox(height: AppSpacing.xl),
            StreamBuilder<List<LeadModel>>(
              stream: LeadsScreen._leadsStream,
              builder: (context, snapshot) {
                if (snapshot.hasError) {
                  return EmptyStateView(
                    title: 'Unable to load leads',
                    message:
                        'There was a problem loading active leads. Please try again shortly.',
                    icon: Icons.error_outline_rounded,
                  );
                }

                if (snapshot.connectionState == ConnectionState.waiting &&
                    !snapshot.hasData) {
                  return const _LeadTableLoadingState();
                }

                final leads = snapshot.data ?? const <LeadModel>[];

                if (leads.isEmpty) {
                  return const EmptyStateView(
                    title: 'No leads found',
                    message: 'Create your first lead to get started.',
                    icon: Icons.people_outline_rounded,
                  );
                }

                return LeadTable(leads: leads);
              },
            ),
          ],
        ),
      ),
    );
  }
}

class _LeadTableLoadingState extends StatelessWidget {
  const _LeadTableLoadingState();

  @override
  Widget build(BuildContext context) {
    final theme = Theme.of(context);
    final colorScheme = theme.colorScheme;

    return Card(
      child: Padding(
        padding: const EdgeInsets.all(AppSpacing.xl),
        child: Column(
          crossAxisAlignment: CrossAxisAlignment.start,
          children: [
            Row(
              children: List<Widget>.generate(
                4,
                (index) => Expanded(
                  child: Padding(
                    padding: EdgeInsets.only(
                      right: index == 3 ? 0 : AppSpacing.lg,
                    ),
                    child: _LoadingBar(
                      widthFactor: index.isEven ? 0.72 : 0.54,
                      color: colorScheme.surfaceContainerHighest,
                    ),
                  ),
                ),
              ),
            ),
            const SizedBox(height: AppSpacing.lg),
            Divider(color: theme.dividerColor),
            const SizedBox(height: AppSpacing.md),
            ...List<Widget>.generate(
              5,
              (index) => Padding(
                padding: EdgeInsets.only(bottom: index == 4 ? 0 : AppSpacing.md),
                child: _LoadingRow(color: colorScheme.surfaceContainerHighest),
              ),
            ),
          ],
        ),
      ),
    );
  }
}

class _LoadingRow extends StatelessWidget {
  const _LoadingRow({required this.color});

  final Color color;

  @override
  Widget build(BuildContext context) {
    return Container(
      padding: const EdgeInsets.symmetric(
        horizontal: AppSpacing.lg,
        vertical: AppSpacing.lg,
      ),
      decoration: BoxDecoration(
        borderRadius: BorderRadius.circular(16),
        color: color.withValues(alpha: 0.35),
      ),
      child: Row(
        children: List<Widget>.generate(
          7,
          (index) => Expanded(
            flex: index == 1 || index == 2 ? 2 : 1,
            child: Padding(
              padding: EdgeInsets.only(right: index == 6 ? 0 : AppSpacing.md),
              child: _LoadingBar(
                widthFactor: index.isEven ? 0.78 : 0.58,
                color: color,
              ),
            ),
          ),
        ),
      ),
    );
  }
}

class _LoadingBar extends StatelessWidget {
  const _LoadingBar({required this.widthFactor, required this.color});

  final double widthFactor;
  final Color color;

  @override
  Widget build(BuildContext context) {
    return FractionallySizedBox(
      alignment: Alignment.centerLeft,
      widthFactor: widthFactor,
      child: Container(
        height: 12,
        decoration: BoxDecoration(
          borderRadius: BorderRadius.circular(999),
          color: color,
        ),
      ),
    );
  }
}
