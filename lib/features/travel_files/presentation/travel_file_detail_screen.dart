import 'package:cloud_firestore/cloud_firestore.dart';
import 'package:flutter/material.dart';

import '../../../core/theme/app_spacing.dart';
import '../../../core/utils/app_router.dart';
import '../../../core/utils/responsive_utils.dart';
import '../../../core/widgets/empty_state_view.dart';
import '../../clients/domain/models/client_model.dart';
import '../../leads/domain/models/lead_model.dart';
import '../../leads/presentation/widgets/section_container.dart';
import '../../travelers/domain/models/traveler_model.dart';
import '../data/datasources/firestore_travel_file_remote_data_source.dart';
import '../data/repositories/travel_file_repository_impl.dart';
import '../domain/models/travel_file_model.dart';

class TravelFileDetailScreen extends StatefulWidget {
  const TravelFileDetailScreen({required this.travelFileId, super.key});

  final String travelFileId;

  @override
  State<TravelFileDetailScreen> createState() => _TravelFileDetailScreenState();
}

class _TravelFileDetailScreenState extends State<TravelFileDetailScreen> {
  late final TravelFileRepositoryImpl _repository;
  late Future<_TravelFileDetailData?> _detailFuture;

  @override
  void initState() {
    super.initState();
    _repository = TravelFileRepositoryImpl(
      remoteDataSource: FirestoreTravelFileRemoteDataSource(
        firestore: FirebaseFirestore.instance,
      ),
    );
    _detailFuture = _loadDetail();
  }

  Future<_TravelFileDetailData?> _loadDetail() async {
    final travelFile = await _repository.getTravelFileById(widget.travelFileId);
    if (travelFile == null) {
      return null;
    }

    final firestore = FirebaseFirestore.instance;
    final leadFuture = firestore.collection('leads').doc(travelFile.leadId).get();
    final clientFuture = firestore.collection('clients').doc(travelFile.clientId).get();
    final travelersFuture = _repository.fetchTravelersByLeadId(travelFile.leadId);

    final (leadSnapshot, clientSnapshot, travelers) =
        await (leadFuture, clientFuture, travelersFuture).wait;

    final lead = leadSnapshot.exists && leadSnapshot.data() != null
        ? LeadModel.fromMap(<String, dynamic>{...leadSnapshot.data()!, 'id': leadSnapshot.id})
        : null;
    final client = clientSnapshot.exists && clientSnapshot.data() != null
        ? ClientModel.fromMap(clientSnapshot.data()!, clientSnapshot.id)
        : null;

    return _TravelFileDetailData(
      travelFile: travelFile,
      lead: lead,
      client: client,
      travelers: travelers,
    );
  }

  @override
  Widget build(BuildContext context) {
    return FutureBuilder<_TravelFileDetailData?>(
      future: _detailFuture,
      builder: (context, snapshot) {
        if (snapshot.connectionState == ConnectionState.waiting) {
          return const Center(child: CircularProgressIndicator());
        }

        if (snapshot.hasError) {
          return const EmptyStateView(
            title: 'Unable to load travel file',
            message:
                'There was a problem loading this travel file. Please try again shortly.',
            icon: Icons.error_outline_rounded,
          );
        }

        final detail = snapshot.data;
        if (detail == null) {
          return const EmptyStateView(
            title: 'Travel file not found',
            message: 'This travel file could not be found.',
            icon: Icons.folder_off_rounded,
          );
        }

        final baseHorizontalPadding = ResponsiveUtils.horizontalPagePadding(context);
        final horizontalPadding =
            (ResponsiveUtils.isDesktop(context) || ResponsiveUtils.isWide(context))
                ? (baseHorizontalPadding - 4).clamp(16.0, double.infinity).toDouble()
                : baseHorizontalPadding;

        return SingleChildScrollView(
          child: Padding(
            padding: EdgeInsets.fromLTRB(
              horizontalPadding,
              AppSpacing.xl,
              horizontalPadding,
              AppSpacing.xxl,
            ),
            child: Column(
              crossAxisAlignment: CrossAxisAlignment.start,
              children: [
                _TravelFileHeader(detail: detail),
                const SizedBox(height: AppSpacing.xl),
                SectionContainer(
                  title: 'Overview',
                  subtitle: 'Operational trip snapshot',
                  bodyTopSpacing: AppSpacing.lg,
                  child: _OverviewGrid(detail: detail),
                ),
                const SizedBox(height: AppSpacing.xl),
                SectionContainer(
                  title: 'Linked entities',
                  subtitle: 'Connected client and booking records',
                  bodyTopSpacing: AppSpacing.lg,
                  child: _LinkedEntities(detail: detail),
                ),
                const SizedBox(height: AppSpacing.xl),
                SectionContainer(
                  title: 'Travelers',
                  subtitle: 'Travelers linked to this booking',
                  bodyTopSpacing: AppSpacing.lg,
                  child: _TravelersSection(detail: detail),
                ),
              ],
            ),
          ),
        );
      },
    );
  }
}

class _TravelFileHeader extends StatelessWidget {
  const _TravelFileHeader({required this.detail});

  final _TravelFileDetailData detail;

  @override
  Widget build(BuildContext context) {
    final theme = Theme.of(context);
    final colorScheme = theme.colorScheme;
    final travelFile = detail.travelFile;

    return Container(
      width: double.infinity,
      padding: const EdgeInsets.all(20),
      decoration: BoxDecoration(
        color: colorScheme.surfaceContainerLowest,
        borderRadius: BorderRadius.circular(24),
        border: Border.all(color: colorScheme.outlineVariant.withValues(alpha: 0.24)),
      ),
      child: Wrap(
        spacing: AppSpacing.md,
        runSpacing: AppSpacing.sm,
        crossAxisAlignment: WrapCrossAlignment.center,
        children: [
          Text(
            travelFile.travelFileCode,
            style: theme.textTheme.headlineSmall?.copyWith(fontWeight: FontWeight.w700),
          ),
          Text(_value(detail.client?.name ?? travelFile.clientNameSnapshot)),
          Text(_value(travelFile.destination)),
          _StatusBadge(status: _value(travelFile.status)),
          Text('Booking: ${detail.lead?.leadCode ?? '—'}'),
        ],
      ),
    );
  }
}

class _OverviewGrid extends StatelessWidget {
  const _OverviewGrid({required this.detail});

  final _TravelFileDetailData detail;

  @override
  Widget build(BuildContext context) {
    final travelFile = detail.travelFile;

    return Wrap(
      spacing: AppSpacing.lg,
      runSpacing: AppSpacing.md,
      children: [
        _InfoItem(label: 'Destination', value: _value(travelFile.destination)),
        _InfoItem(label: 'Travel Type', value: _value(travelFile.travelType)),
        _InfoItem(label: 'Trip Scope', value: _value(travelFile.tripScope)),
        _InfoItem(
          label: 'Pax Summary',
          value:
              '${travelFile.totalPax} pax (${travelFile.adultCount}A / ${travelFile.childCount}C / ${travelFile.infantCount}I)',
        ),
        _InfoItem(
          label: 'Start Date',
          value: _formatDate(context, travelFile.startDate),
        ),
        _InfoItem(
          label: 'End Date',
          value: _formatDate(context, travelFile.endDate),
        ),
        _InfoItem(label: 'Notes', value: _value(travelFile.notes, empty: 'Not provided')),
      ],
    );
  }
}

class _LinkedEntities extends StatelessWidget {
  const _LinkedEntities({required this.detail});

  final _TravelFileDetailData detail;

  @override
  Widget build(BuildContext context) {
    final client = detail.client;
    final lead = detail.lead;

    return Column(
      crossAxisAlignment: CrossAxisAlignment.start,
      children: [
        Wrap(
          spacing: AppSpacing.sm,
          runSpacing: AppSpacing.sm,
          children: [
            Text('Client: ${client?.name ?? detail.travelFile.clientNameSnapshot}'),
            if (client != null)
              TextButton(
                onPressed: () => Navigator.of(context).pushNamed(
                  AppRouter.clientDetailRoute(Uri.encodeComponent(client.id)),
                ),
                child: const Text('Open Client'),
              ),
          ],
        ),
        const SizedBox(height: AppSpacing.xs),
        Wrap(
          spacing: AppSpacing.sm,
          runSpacing: AppSpacing.sm,
          children: [
            Text('Lead / Booking: ${lead?.leadCode ?? '—'}'),
            if (lead != null)
              TextButton(
                onPressed: () => Navigator.of(context).pushNamed(
                  AppRouter.leadsDetailRoute(Uri.encodeComponent(lead.id)),
                ),
                child: const Text('Open Booking'),
              ),
          ],
        ),
      ],
    );
  }
}

class _TravelersSection extends StatelessWidget {
  const _TravelersSection({required this.detail});

  final _TravelFileDetailData detail;

  @override
  Widget build(BuildContext context) {
    if (detail.travelers.isEmpty) {
      return const Text('No travelers linked yet');
    }

    return Column(
      children: detail.travelers
          .map(
            (traveler) => ListTile(
              contentPadding: EdgeInsets.zero,
              title: Text(traveler.fullName),
              subtitle: Text('Type: ${traveler.travelerType} • Code: ${traveler.travelerCode}'),
              trailing: TextButton(
                onPressed: () => Navigator.of(context).pushNamed(
                  AppRouter.travelerDetailRoute(Uri.encodeComponent(traveler.id)),
                ),
                child: const Text('Open'),
              ),
            ),
          )
          .toList(growable: false),
    );
  }
}

class _StatusBadge extends StatelessWidget {
  const _StatusBadge({required this.status});

  final String status;

  @override
  Widget build(BuildContext context) {
    final theme = Theme.of(context);
    final colorScheme = theme.colorScheme;

    return Container(
      padding: const EdgeInsets.symmetric(horizontal: 10, vertical: 6),
      decoration: BoxDecoration(
        color: colorScheme.primaryContainer,
        borderRadius: BorderRadius.circular(999),
      ),
      child: Text(
        status,
        style: theme.textTheme.labelLarge?.copyWith(fontWeight: FontWeight.w600),
      ),
    );
  }
}

class _InfoItem extends StatelessWidget {
  const _InfoItem({required this.label, required this.value});

  final String label;
  final String value;

  @override
  Widget build(BuildContext context) {
    final theme = Theme.of(context);
    return SizedBox(
      width: 280,
      child: Column(
        crossAxisAlignment: CrossAxisAlignment.start,
        children: [
          Text(
            label,
            style: theme.textTheme.labelMedium?.copyWith(
              color: theme.colorScheme.onSurfaceVariant,
            ),
          ),
          const SizedBox(height: 4),
          Text(value),
        ],
      ),
    );
  }
}

class _TravelFileDetailData {
  const _TravelFileDetailData({
    required this.travelFile,
    required this.lead,
    required this.client,
    required this.travelers,
  });

  final TravelFileModel travelFile;
  final LeadModel? lead;
  final ClientModel? client;
  final List<TravelerModel> travelers;
}

String _value(String? value, {String empty = '—'}) {
  final trimmed = value?.trim() ?? '';
  return trimmed.isEmpty ? empty : trimmed;
}

String _formatDate(BuildContext context, DateTime? date) {
  if (date == null) {
    return '—';
  }

  return MaterialLocalizations.of(context).formatShortDate(date);
}
