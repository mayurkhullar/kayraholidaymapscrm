import 'package:cloud_firestore/cloud_firestore.dart';
import 'package:flutter/material.dart';

import '../../../core/theme/app_spacing.dart';
import '../../../core/utils/app_router.dart';
import '../../../core/utils/responsive_utils.dart';
import '../../../core/widgets/empty_state_view.dart';
import '../../clients/domain/models/client_model.dart';
import '../../leads/domain/models/lead_model.dart';
import '../../leads/presentation/widgets/section_container.dart';
import '../data/datasources/firestore_traveler_remote_data_source.dart';
import '../data/repositories/traveler_repository_impl.dart';
import '../domain/models/traveler_model.dart';

class TravelerDetailScreen extends StatefulWidget {
  const TravelerDetailScreen({required this.travelerId, super.key});

  final String travelerId;

  @override
  State<TravelerDetailScreen> createState() => _TravelerDetailScreenState();
}

class _TravelerDetailScreenState extends State<TravelerDetailScreen> {
  late final TravelerRepositoryImpl _repository;
  late Future<_TravelerDetailData?> _detailFuture;

  @override
  void initState() {
    super.initState();
    _repository = TravelerRepositoryImpl(
      remoteDataSource: FirestoreTravelerRemoteDataSource(
        firestore: FirebaseFirestore.instance,
      ),
    );
    _detailFuture = _loadDetail();
  }

  Future<_TravelerDetailData?> _loadDetail() async {
    final traveler = await _repository.getTravelerById(widget.travelerId);
    if (traveler == null) {
      return null;
    }

    final firestore = FirebaseFirestore.instance;
    final clientFuture = firestore.collection('clients').doc(traveler.clientId).get();
    final leadFuture = (traveler.leadId == null || traveler.leadId!.isEmpty)
        ? Future.value(null)
        : firestore.collection('leads').doc(traveler.leadId).get();

    final clientSnapshot = await clientFuture;
    final leadSnapshot = await leadFuture;

    final client = clientSnapshot.exists && clientSnapshot.data() != null
        ? ClientModel.fromMap(clientSnapshot.data()!, clientSnapshot.id)
        : null;

    final lead = leadSnapshot != null && leadSnapshot.exists && leadSnapshot.data() != null
        ? LeadModel.fromMap(<String, dynamic>{...leadSnapshot.data()!, 'id': leadSnapshot.id})
        : null;

    return _TravelerDetailData(traveler: traveler, client: client, lead: lead);
  }

  @override
  Widget build(BuildContext context) {
    return FutureBuilder<_TravelerDetailData?>(
      future: _detailFuture,
      builder: (context, snapshot) {
        if (snapshot.connectionState == ConnectionState.waiting) {
          return const Center(child: CircularProgressIndicator());
        }

        if (snapshot.hasError) {
          return const EmptyStateView(
            title: 'Unable to load traveler',
            message:
                'There was a problem loading this traveler. Please try again shortly.',
            icon: Icons.error_outline_rounded,
          );
        }

        final detail = snapshot.data;
        if (detail == null) {
          return const EmptyStateView(
            title: 'Traveler not found',
            message: 'This traveler could not be found.',
            icon: Icons.person_search_rounded,
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
                _TravelerHeader(detail: detail),
                const SizedBox(height: AppSpacing.xl),
                SectionContainer(
                  title: 'Overview',
                  subtitle: 'Traveler profile details',
                  bodyTopSpacing: AppSpacing.lg,
                  child: _OverviewGrid(detail: detail),
                ),
                const SizedBox(height: AppSpacing.xl),
                SectionContainer(
                  title: 'Linked entities',
                  subtitle: 'Related client and booking references',
                  bodyTopSpacing: AppSpacing.lg,
                  child: _LinkedEntities(detail: detail),
                ),
              ],
            ),
          ),
        );
      },
    );
  }
}

class _TravelerHeader extends StatelessWidget {
  const _TravelerHeader({required this.detail});

  final _TravelerDetailData detail;

  @override
  Widget build(BuildContext context) {
    final traveler = detail.traveler;
    final theme = Theme.of(context);
    final colorScheme = theme.colorScheme;

    return Container(
      width: double.infinity,
      padding: const EdgeInsets.all(20),
      decoration: BoxDecoration(
        color: colorScheme.surfaceContainerLowest,
        borderRadius: BorderRadius.circular(24),
        border: Border.all(color: colorScheme.outlineVariant.withValues(alpha: 0.24)),
      ),
      child: Wrap(
        runSpacing: AppSpacing.sm,
        spacing: AppSpacing.md,
        crossAxisAlignment: WrapCrossAlignment.center,
        children: [
          Text(
            traveler.fullName,
            style: theme.textTheme.headlineSmall?.copyWith(fontWeight: FontWeight.w700),
          ),
          Container(
            padding: const EdgeInsets.symmetric(horizontal: 10, vertical: 6),
            decoration: BoxDecoration(
              color: colorScheme.primaryContainer,
              borderRadius: BorderRadius.circular(999),
            ),
            child: Text(traveler.travelerType),
          ),
          Text('Client: ${detail.client?.name ?? '—'}'),
          Text('Booking: ${detail.lead?.leadCode ?? '—'}'),
        ],
      ),
    );
  }
}

class _OverviewGrid extends StatelessWidget {
  const _OverviewGrid({required this.detail});

  final _TravelerDetailData detail;

  @override
  Widget build(BuildContext context) {
    final traveler = detail.traveler;

    return Wrap(
      spacing: AppSpacing.lg,
      runSpacing: AppSpacing.md,
      children: [
        _InfoItem(label: 'Traveler Code', value: _value(traveler.travelerCode)),
        _InfoItem(label: 'Full Name', value: _value(traveler.fullName)),
        _InfoItem(label: 'Traveler Type', value: _value(traveler.travelerType)),
        _InfoItem(label: 'Gender', value: _value(traveler.gender)),
        _InfoItem(label: 'Age', value: traveler.age?.toString() ?? '—'),
        _InfoItem(label: 'Phone', value: _value(traveler.phone)),
        _InfoItem(label: 'Email', value: _value(traveler.email)),
        _InfoItem(label: 'Notes', value: _value(traveler.notes, empty: 'Not provided')),
      ],
    );
  }
}

class _LinkedEntities extends StatelessWidget {
  const _LinkedEntities({required this.detail});

  final _TravelerDetailData detail;

  @override
  Widget build(BuildContext context) {
    return Column(
      crossAxisAlignment: CrossAxisAlignment.start,
      children: [
        Wrap(
          spacing: AppSpacing.sm,
          runSpacing: AppSpacing.sm,
          children: [
            Text('Client: ${detail.client?.name ?? '—'}'),
            if (detail.client != null)
              TextButton(
                onPressed: () => Navigator.of(context).pushNamed(
                  AppRouter.clientDetailRoute(Uri.encodeComponent(detail.client!.id)),
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
            Text('Booking / Lead: ${detail.lead?.leadCode ?? '—'}'),
            if (detail.lead != null)
              TextButton(
                onPressed: () => Navigator.of(context).pushNamed(
                  AppRouter.leadsDetailRoute(Uri.encodeComponent(detail.lead!.id)),
                ),
                child: const Text('Open Booking'),
              ),
          ],
        ),
      ],
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

class _TravelerDetailData {
  const _TravelerDetailData({
    required this.traveler,
    required this.client,
    required this.lead,
  });

  final TravelerModel traveler;
  final ClientModel? client;
  final LeadModel? lead;
}

String _value(String? value, {String empty = '—'}) {
  final trimmed = value?.trim() ?? '';
  return trimmed.isEmpty ? empty : trimmed;
}
