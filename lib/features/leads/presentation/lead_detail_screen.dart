import 'package:cloud_firestore/cloud_firestore.dart';
import 'package:flutter/material.dart';

import '../../../core/constants/app_enums.dart';
import '../../../core/theme/app_spacing.dart';
import '../../../core/widgets/app_top_bar.dart';
import '../../../core/widgets/empty_state_view.dart';
import '../data/datasources/firestore_lead_remote_data_source.dart';
import '../data/repositories/lead_repository_impl.dart';
import '../domain/models/lead_model.dart';

class LeadDetailScreen extends StatefulWidget {
  const LeadDetailScreen({required this.leadId, super.key});

  final String leadId;

  @override
  State<LeadDetailScreen> createState() => _LeadDetailScreenState();
}

class _LeadDetailScreenState extends State<LeadDetailScreen> {
  late final LeadRepositoryImpl _leadRepository;
  late final Future<LeadModel?> _leadFuture;

  @override
  void initState() {
    super.initState();
    _leadRepository = LeadRepositoryImpl(
      remoteDataSource: FirestoreLeadRemoteDataSource(
        firestore: FirebaseFirestore.instance,
      ),
    );
    _leadFuture = _leadRepository.getLeadById(widget.leadId);
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      body: SafeArea(
        child: Column(
          crossAxisAlignment: CrossAxisAlignment.stretch,
          children: [
            const AppTopBar(pageTitle: 'Lead Details'),
            Expanded(
              child: FutureBuilder<LeadModel?>(
                future: _leadFuture,
                builder: (context, snapshot) {
                  if (snapshot.connectionState == ConnectionState.waiting) {
                    return const Center(child: CircularProgressIndicator());
                  }

                  if (snapshot.hasError) {
                    return const Padding(
                      padding: EdgeInsets.all(AppSpacing.lg),
                      child: EmptyStateView(
                        title: 'Unable to load lead',
                        message:
                            'There was a problem loading this lead. Please try again shortly.',
                        icon: Icons.error_outline_rounded,
                      ),
                    );
                  }

                  final lead = snapshot.data;
                  if (lead == null) {
                    return const Padding(
                      padding: EdgeInsets.all(AppSpacing.lg),
                      child: EmptyStateView(
                        title: 'Lead not found',
                        message: 'This lead could not be found.',
                        icon: Icons.person_search_rounded,
                      ),
                    );
                  }

                  return SingleChildScrollView(
                    child: Padding(
                      padding: const EdgeInsets.all(AppSpacing.lg),
                      child: Column(
                        crossAxisAlignment: CrossAxisAlignment.start,
                        children: [
                          _LeadSummaryStrip(lead: lead),
                          const SizedBox(height: AppSpacing.md),
                          SectionContainer(
                            title: 'Overview',
                            child: Column(
                              children: [
                                _OverviewRow(
                                  label: 'Client Name',
                                  value: _displayValue(lead.clientNameSnapshot),
                                ),
                                _OverviewRow(
                                  label: 'Phone',
                                  value: '—',
                                ),
                                _OverviewRow(
                                  label: 'Destination',
                                  value: _displayValue(lead.destination),
                                ),
                                _OverviewRow(
                                  label: 'Travel Dates',
                                  value: _travelDateRange(lead),
                                ),
                                _OverviewRow(
                                  label: 'Travel Type',
                                  value: _travelTypeLabel(lead.travelType),
                                ),
                                _OverviewRow(
                                  label: 'Budget (₹)',
                                  value: _budgetValue(lead.budget),
                                ),
                                _OverviewRow(
                                  label: 'Budget Type',
                                  value: _displayValue(lead.budgetType),
                                ),
                                _OverviewRow(
                                  label: 'Initial Notes',
                                  value: _displayValue(lead.notes),
                                  isLast: true,
                                ),
                              ],
                            ),
                          ),
                          const SizedBox(height: AppSpacing.md),
                          const SectionContainer(
                            title: 'Quotations',
                            child: _PlaceholderMessage('No quotations yet'),
                          ),
                          const SizedBox(height: AppSpacing.md),
                          const SectionContainer(
                            title: 'Tasks / Follow-ups',
                            child: _PlaceholderMessage('No tasks yet'),
                          ),
                          const SizedBox(height: AppSpacing.md),
                          const SectionContainer(
                            title: 'Timeline',
                            child: _PlaceholderMessage('No activity yet'),
                          ),
                        ],
                      ),
                    ),
                  );
                },
              ),
            ),
          ],
        ),
      ),
    );
  }
}

class SectionContainer extends StatelessWidget {
  const SectionContainer({
    required this.title,
    required this.child,
    super.key,
  });

  final String title;
  final Widget child;

  @override
  Widget build(BuildContext context) {
    final theme = Theme.of(context);
    final colorScheme = theme.colorScheme;

    return Container(
      width: double.infinity,
      padding: const EdgeInsets.all(AppSpacing.lg),
      decoration: BoxDecoration(
        color: colorScheme.surface,
        borderRadius: BorderRadius.circular(18),
        border: Border.all(color: colorScheme.outlineVariant),
      ),
      child: Column(
        crossAxisAlignment: CrossAxisAlignment.start,
        children: [
          Text(
            title,
            style: theme.textTheme.titleMedium?.copyWith(
              fontWeight: FontWeight.w700,
              color: colorScheme.onSurface,
            ),
          ),
          const SizedBox(height: AppSpacing.md),
          child,
        ],
      ),
    );
  }
}

class _LeadSummaryStrip extends StatelessWidget {
  const _LeadSummaryStrip({required this.lead});

  final LeadModel lead;

  @override
  Widget build(BuildContext context) {
    final theme = Theme.of(context);
    final colorScheme = theme.colorScheme;

    return Container(
      width: double.infinity,
      padding: const EdgeInsets.all(AppSpacing.lg),
      decoration: BoxDecoration(
        color: colorScheme.surfaceContainerHighest.withValues(alpha: 0.35),
        borderRadius: BorderRadius.circular(18),
        border: Border.all(color: colorScheme.outlineVariant),
      ),
      child: Column(
        crossAxisAlignment: CrossAxisAlignment.start,
        children: [
          Row(
            crossAxisAlignment: CrossAxisAlignment.start,
            children: [
              Expanded(
                child: Text(
                  _displayValue(lead.clientNameSnapshot),
                  style: theme.textTheme.titleMedium?.copyWith(
                    fontWeight: FontWeight.w800,
                    color: colorScheme.onSurface,
                  ),
                ),
              ),
              Container(
                padding: const EdgeInsets.symmetric(
                  horizontal: AppSpacing.md,
                  vertical: AppSpacing.xs,
                ),
                decoration: BoxDecoration(
                  color: colorScheme.primary.withValues(alpha: 0.1),
                  borderRadius: BorderRadius.circular(999),
                ),
                child: Text(
                  _leadStageLabel(lead.leadStage),
                  style: theme.textTheme.labelMedium?.copyWith(
                    color: colorScheme.primary,
                    fontWeight: FontWeight.w700,
                  ),
                ),
              ),
            ],
          ),
          const SizedBox(height: AppSpacing.sm),
          Text(
            '${_displayValue(lead.destination)} • ${_travelDateRange(lead)}',
            style: theme.textTheme.bodyMedium?.copyWith(
              color: colorScheme.onSurfaceVariant,
            ),
          ),
          const SizedBox(height: AppSpacing.xs),
          Text(
            'Pax: ${lead.adultCount} Adults / ${lead.childCount} Children / ${lead.infantCount} Infants',
            style: theme.textTheme.bodyMedium?.copyWith(
              color: colorScheme.onSurfaceVariant,
            ),
          ),
        ],
      ),
    );
  }
}

class _OverviewRow extends StatelessWidget {
  const _OverviewRow({
    required this.label,
    required this.value,
    this.isLast = false,
  });

  final String label;
  final String value;
  final bool isLast;

  @override
  Widget build(BuildContext context) {
    final theme = Theme.of(context);
    final colorScheme = theme.colorScheme;

    return Container(
      padding: EdgeInsets.only(bottom: isLast ? 0 : AppSpacing.md),
      margin: EdgeInsets.only(bottom: isLast ? 0 : AppSpacing.md),
      decoration: BoxDecoration(
        border: isLast
            ? null
            : Border(
                bottom: BorderSide(
                  color: colorScheme.outlineVariant.withValues(alpha: 0.5),
                ),
              ),
      ),
      child: Row(
        crossAxisAlignment: CrossAxisAlignment.start,
        children: [
          SizedBox(
            width: 124,
            child: Text(
              label,
              style: theme.textTheme.bodyMedium?.copyWith(
                color: colorScheme.onSurfaceVariant,
                fontWeight: FontWeight.w600,
              ),
            ),
          ),
          const SizedBox(width: AppSpacing.md),
          Expanded(
            child: Text(
              value,
              style: theme.textTheme.bodyMedium?.copyWith(
                color: colorScheme.onSurface,
              ),
            ),
          ),
        ],
      ),
    );
  }
}

class _PlaceholderMessage extends StatelessWidget {
  const _PlaceholderMessage(this.message);

  final String message;

  @override
  Widget build(BuildContext context) {
    return Text(
      message,
      style: Theme.of(context).textTheme.bodyMedium?.copyWith(
            color: Theme.of(context).colorScheme.onSurfaceVariant,
          ),
    );
  }
}

String _displayValue(String? value) {
  final normalizedValue = value?.trim();
  if (normalizedValue == null || normalizedValue.isEmpty) {
    return '—';
  }

  return normalizedValue;
}

String _budgetValue(int? value) {
  if (value == null) {
    return '—';
  }

  return value.toString();
}

String _travelDateRange(LeadModel lead) {
  final travelDates = lead.travelDates;
  if (travelDates == null) {
    return '—';
  }

  final startDate = travelDates.startDate;
  final endDate = travelDates.endDate;

  if (startDate == null && endDate == null) {
    return '—';
  }

  if (startDate != null && endDate != null) {
    return '${_formatDate(startDate)} - ${_formatDate(endDate)}';
  }

  return _formatDate(startDate ?? endDate!);
}

String _formatDate(DateTime value) {
  const months = <String>[
    'Jan',
    'Feb',
    'Mar',
    'Apr',
    'May',
    'Jun',
    'Jul',
    'Aug',
    'Sep',
    'Oct',
    'Nov',
    'Dec',
  ];

  return '${value.day} ${months[value.month - 1]} ${value.year}';
}

String _travelTypeLabel(TravelType travelType) {
  switch (travelType) {
    case TravelType.fit:
      return 'FIT';
    case TravelType.corporate:
      return 'Corporate';
    case TravelType.group:
      return 'Group';
    case TravelType.mice:
      return 'MICE';
  }
}

String _leadStageLabel(LeadStage leadStage) {
  switch (leadStage) {
    case LeadStage.newLead:
      return 'New Lead';
    case LeadStage.contacted:
      return 'Contacted';
    case LeadStage.quotationSent:
      return 'Quotation Sent';
    case LeadStage.negotiation:
      return 'Negotiation';
    case LeadStage.onHold:
      return 'On Hold';
    case LeadStage.confirmed:
      return 'Confirmed';
    case LeadStage.lost:
      return 'Lost';
  }
}
