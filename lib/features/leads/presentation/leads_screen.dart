import 'package:cloud_firestore/cloud_firestore.dart';
import 'package:flutter/material.dart';

import '../../../core/constants/app_enums.dart';
import '../../../core/theme/app_spacing.dart';
import '../../../core/widgets/app_shell.dart';
import '../../../core/widgets/empty_state_view.dart';
import '../../../core/widgets/page_container.dart';
import '../domain/models/lead_model.dart';
import 'widgets/create_lead_panel.dart';
import 'widgets/lead_detail_panel.dart';
import 'widgets/lead_filters_bar.dart';
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
  late final TextEditingController _searchController;
  String? _selectedStage;
  String? _selectedTravelType;
  String? _successMessage;

  @override
  void initState() {
    super.initState();
    _searchController = TextEditingController()..addListener(_onFiltersChanged);
  }

  @override
  void dispose() {
    _searchController
      ..removeListener(_onFiltersChanged)
      ..dispose();
    super.dispose();
  }

  void _onFiltersChanged() {
    setState(() {});
  }

  void _clearFilters() {
    _searchController.clear();
    setState(() {
      _selectedStage = null;
      _selectedTravelType = null;
    });
  }

  List<LeadModel> _applyFilters(List<LeadModel> leads) {
    final query = _searchController.text.trim().toLowerCase();

    return leads.where((lead) {
      final matchesSearch = query.isEmpty ||
          lead.clientNameSnapshot?.toLowerCase().contains(query) == true ||
          lead.destination?.toLowerCase().contains(query) == true ||
          lead.leadCode.toLowerCase().contains(query);
      final matchesStage =
          _selectedStage == null || lead.leadStage.firestoreValue == _selectedStage;
      final matchesTravelType = _selectedTravelType == null ||
          lead.travelType.firestoreValue == _selectedTravelType;

      return matchesSearch && matchesStage && matchesTravelType;
    }).toList(growable: false);
  }

  Future<void> _openLeadDetails(LeadModel lead) {
    return LeadDetailPanel.show(
      context,
      lead: lead,
      onStageUpdated: _showSuccessMessage,
    );
  }

  void _showSuccessMessage(String message) {
    setState(() {
      _successMessage = message;
    });

    Future<void>.delayed(const Duration(seconds: 3), () {
      if (!mounted || _successMessage != message) {
        return;
      }

      setState(() {
        _successMessage = null;
      });
    });
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
              onCreateLead: () => CreateLeadPanel.show(context),
            ),
            if (_successMessage != null) ...[
              const SizedBox(height: AppSpacing.lg),
              _PageSuccessMessage(message: _successMessage!),
            ],
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

                final filteredLeads = _applyFilters(leads);

                return Column(
                  crossAxisAlignment: CrossAxisAlignment.start,
                  children: [
                    LeadFiltersBar(
                      searchController: _searchController,
                      selectedStage: _selectedStage,
                      selectedTravelType: _selectedTravelType,
                      onStageChanged: (value) {
                        setState(() {
                          _selectedStage = value;
                        });
                      },
                      onTravelTypeChanged: (value) {
                        setState(() {
                          _selectedTravelType = value;
                        });
                      },
                      onClearFilters: _clearFilters,
                    ),
                    const SizedBox(height: AppSpacing.lg),
                    if (filteredLeads.isEmpty)
                      const EmptyStateView(
                        title: 'No matching leads',
                        message:
                            'Try adjusting your search, stage, or travel type filters.',
                        icon: Icons.filter_alt_off_rounded,
                      )
                    else
                      LeadTable(
                        leads: filteredLeads,
                        onLeadTap: _openLeadDetails,
                      ),
                  ],
                );
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

class _PageSuccessMessage extends StatelessWidget {
  const _PageSuccessMessage({required this.message});

  final String message;

  @override
  Widget build(BuildContext context) {
    final theme = Theme.of(context);
    final colorScheme = theme.colorScheme;

    return Container(
      width: double.infinity,
      padding: const EdgeInsets.symmetric(
        horizontal: AppSpacing.lg,
        vertical: AppSpacing.md,
      ),
      decoration: BoxDecoration(
        color: colorScheme.secondaryContainer.withValues(alpha: 0.5),
        borderRadius: BorderRadius.circular(16),
        border: Border.all(color: colorScheme.outlineVariant),
      ),
      child: Row(
        children: [
          Icon(
            Icons.check_circle_outline_rounded,
            color: colorScheme.onSecondaryContainer,
            size: 18,
          ),
          const SizedBox(width: AppSpacing.sm),
          Expanded(
            child: Text(
              message,
              style: theme.textTheme.bodySmall?.copyWith(
                color: colorScheme.onSecondaryContainer,
                fontWeight: FontWeight.w600,
              ),
            ),
          ),
        ],
      ),
    );
  }
}
