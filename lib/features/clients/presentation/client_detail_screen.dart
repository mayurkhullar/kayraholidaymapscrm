import 'package:cloud_firestore/cloud_firestore.dart';
import 'package:flutter/material.dart';

import '../../../core/theme/app_spacing.dart';
import '../../../core/utils/responsive_utils.dart';
import '../../../core/widgets/empty_state_view.dart';
import '../../leads/presentation/widgets/section_container.dart';
import '../data/datasources/firestore_client_remote_data_source.dart';
import '../data/repositories/client_repository_impl.dart';
import '../domain/models/client_model.dart';

class ClientDetailScreen extends StatefulWidget {
  const ClientDetailScreen({required this.clientId, super.key});

  final String clientId;

  @override
  State<ClientDetailScreen> createState() => _ClientDetailScreenState();
}

class _ClientDetailScreenState extends State<ClientDetailScreen> {
  late final ClientRepositoryImpl _clientRepository;
  late Future<ClientModel?> _clientFuture;

  @override
  void initState() {
    super.initState();
    _clientRepository = ClientRepositoryImpl(
      remoteDataSource: FirestoreClientRemoteDataSource(
        firestore: FirebaseFirestore.instance,
      ),
    );
    _clientFuture = _clientRepository.getClientById(widget.clientId);
  }

  @override
  Widget build(BuildContext context) {
    return FutureBuilder<ClientModel?>(
      future: _clientFuture,
      builder: (context, snapshot) {
                  if (snapshot.connectionState == ConnectionState.waiting) {
                    return const Center(child: CircularProgressIndicator());
                  }

                  if (snapshot.hasError) {
                    return const Padding(
                      padding: EdgeInsets.all(AppSpacing.lg),
                      child: EmptyStateView(
                        title: 'Unable to load client',
                        message:
                            'There was a problem loading this client. Please try again shortly.',
                        icon: Icons.error_outline_rounded,
                      ),
                    );
                  }

                  final client = snapshot.data;
                  if (client == null) {
                    return const Padding(
                      padding: EdgeInsets.all(AppSpacing.lg),
                      child: EmptyStateView(
                        title: 'Client not found',
                        message: 'This client could not be found.',
                        icon: Icons.person_search_rounded,
                      ),
                    );
                  }

                  final baseHorizontalPadding =
                      ResponsiveUtils.horizontalPagePadding(context);
                  final horizontalPadding =
                      (ResponsiveUtils.isDesktop(context) ||
                              ResponsiveUtils.isWide(context))
                          ? (baseHorizontalPadding - 4)
                              .clamp(16.0, double.infinity)
                              .toDouble()
                          : baseHorizontalPadding;
                  final baseContentMaxWidth =
                      ResponsiveUtils.contentMaxWidth(context);
                  final contentMaxWidth =
                      baseContentMaxWidth == double.infinity
                          ? baseContentMaxWidth
                          : baseContentMaxWidth + 48;

                  return SingleChildScrollView(
                    child: Center(
                      child: ConstrainedBox(
                        constraints: BoxConstraints(maxWidth: contentMaxWidth),
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
                              _ClientProfileHeader(client: client),
                              const SizedBox(height: AppSpacing.xl),
                              SectionContainer(
                                title: 'Overview',
                                subtitle: 'Key client details at a glance',
                                bodyTopSpacing: AppSpacing.lg,
                                child: _OverviewSurface(
                                  child: _ClientOverviewGrid(client: client),
                                ),
                              ),
                              const SizedBox(height: AppSpacing.xl),
                              const SectionContainer(
                                title: 'Bookings / Trips',
                                subtitle: 'Client travel activity',
                                bodyTopSpacing: AppSpacing.lg,
                                child: _BookingsContainer(),
                              ),
                            ],
                          ),
                        ),
                      ),
                    ),
                  );
      },
    );
  }
}

class _ClientProfileHeader extends StatelessWidget {
  const _ClientProfileHeader({required this.client});

  final ClientModel client;

  @override
  Widget build(BuildContext context) {
    final theme = Theme.of(context);
    final colorScheme = theme.colorScheme;
    final isDesktopLayout =
        ResponsiveUtils.isDesktop(context) || ResponsiveUtils.isWide(context);

    final leftColumn = Column(
      crossAxisAlignment: CrossAxisAlignment.start,
      children: [
        Text(
          _displayValue(client.name),
          style: theme.textTheme.headlineMedium?.copyWith(
            fontSize: 30,
            fontWeight: FontWeight.w800,
            color: colorScheme.onSurface,
            height: 1.1,
          ),
        ),
        const SizedBox(height: AppSpacing.xs),
        Text(
          'Client profile',
          style: theme.textTheme.titleMedium?.copyWith(
            color: colorScheme.onSurfaceVariant.withValues(alpha: 0.78),
            fontWeight: FontWeight.w400,
          ),
        ),
        const SizedBox(height: AppSpacing.md),
        Wrap(
          spacing: AppSpacing.sm,
          runSpacing: AppSpacing.sm,
          children: [
            _HeaderInfoChip(
              icon: Icons.phone_outlined,
              label: _displayValue(client.phone),
            ),
            if (_hasValue(client.whatsappNumber))
              _HeaderInfoChip(
                icon: Icons.chat_bubble_outline_rounded,
                label: _displayValue(client.whatsappNumber),
              ),
            if (_hasValue(client.email))
              _HeaderInfoChip(
                icon: Icons.email_outlined,
                label: _displayValue(client.email),
              ),
          ],
        ),
      ],
    );

    final rightColumn = Align(
      alignment: isDesktopLayout ? Alignment.topRight : Alignment.centerLeft,
      child: client.isActive ? const _ActiveBadge() : null,
    );

    return Container(
      width: double.infinity,
      padding: const EdgeInsets.all(20),
      decoration: BoxDecoration(
        color: colorScheme.surfaceContainerLowest,
        borderRadius: BorderRadius.circular(24),
        gradient: LinearGradient(
          begin: Alignment.topLeft,
          end: Alignment.bottomRight,
          colors: [
            colorScheme.surfaceContainerLowest,
            colorScheme.surfaceContainerLow.withValues(alpha: 0.85),
          ],
        ),
        border: Border.all(
          color: colorScheme.outlineVariant.withValues(alpha: 0.24),
        ),
        boxShadow: [
          BoxShadow(
            color: colorScheme.shadow.withValues(alpha: 0.035),
            blurRadius: 18,
            offset: const Offset(0, 8),
          ),
        ],
      ),
      child: isDesktopLayout
          ? Row(
              crossAxisAlignment: CrossAxisAlignment.start,
              children: [
                Expanded(child: leftColumn),
                const SizedBox(width: AppSpacing.lg),
                rightColumn,
              ],
            )
          : Column(
              crossAxisAlignment: CrossAxisAlignment.start,
              children: [
                rightColumn,
                if (client.isActive) const SizedBox(height: AppSpacing.md),
                leftColumn,
              ],
            ),
    );
  }
}

class _ActiveBadge extends StatelessWidget {
  const _ActiveBadge();

  @override
  Widget build(BuildContext context) {
    final theme = Theme.of(context);
    final colorScheme = theme.colorScheme;

    return Container(
      padding: const EdgeInsets.symmetric(
        horizontal: AppSpacing.sm,
        vertical: AppSpacing.xs,
      ),
      decoration: BoxDecoration(
        color: Colors.green.withValues(alpha: 0.12),
        borderRadius: BorderRadius.circular(999),
        border: Border.all(
          color: Colors.green.withValues(alpha: 0.34),
        ),
      ),
      child: Text(
        'Active',
        style: theme.textTheme.labelMedium?.copyWith(
          color: Colors.green.shade700,
          fontWeight: FontWeight.w700,
          letterSpacing: 0.2,
        ),
      ),
    );
  }
}

class _HeaderInfoChip extends StatelessWidget {
  const _HeaderInfoChip({required this.icon, required this.label});

  final IconData icon;
  final String label;

  @override
  Widget build(BuildContext context) {
    final theme = Theme.of(context);
    final colorScheme = theme.colorScheme;

    return Container(
      padding: const EdgeInsets.symmetric(
        horizontal: AppSpacing.sm,
        vertical: AppSpacing.xs,
      ),
      decoration: BoxDecoration(
        color: colorScheme.surfaceContainerHighest.withValues(alpha: 0.42),
        borderRadius: BorderRadius.circular(999),
        border: Border.all(
          color: colorScheme.outlineVariant.withValues(alpha: 0.38),
        ),
      ),
      child: Row(
        mainAxisSize: MainAxisSize.min,
        children: [
          Icon(
            icon,
            size: 16,
            color: colorScheme.onSurfaceVariant,
          ),
          const SizedBox(width: AppSpacing.xs),
          Text(
            label,
            style: theme.textTheme.bodySmall?.copyWith(
              color: colorScheme.onSurface,
              fontWeight: FontWeight.w600,
            ),
          ),
        ],
      ),
    );
  }
}

class _OverviewSurface extends StatelessWidget {
  const _OverviewSurface({required this.child});

  final Widget child;

  @override
  Widget build(BuildContext context) {
    final colorScheme = Theme.of(context).colorScheme;

    return Container(
      width: double.infinity,
      padding: const EdgeInsets.all(AppSpacing.lg),
      decoration: BoxDecoration(
        color: colorScheme.surfaceContainerLowest,
        borderRadius: BorderRadius.circular(20),
        border: Border.all(
          color: colorScheme.outlineVariant.withValues(alpha: 0.4),
        ),
      ),
      child: child,
    );
  }
}

class _ClientOverviewGrid extends StatelessWidget {
  const _ClientOverviewGrid({required this.client});

  final ClientModel client;

  @override
  Widget build(BuildContext context) {
    final createdDate = MaterialLocalizations.of(context).formatMediumDate(
      client.createdAt,
    );

    final leftItems = <_OverviewItemData>[
      _OverviewItemData('Name', _displayValue(client.name)),
      _OverviewItemData('Phone', _displayValue(client.phone)),
      _OverviewItemData('WhatsApp', _optionalValue(client.whatsappNumber)),
    ];

    final rightItems = <_OverviewItemData>[
      _OverviewItemData('Email', _optionalValue(client.email)),
      _OverviewItemData('Client Code', _displayValue(client.clientCode)),
      _OverviewItemData('Created Date', createdDate),
    ];

    return LayoutBuilder(
      builder: (context, constraints) {
        final useTwoColumns = constraints.maxWidth >= 640;

        if (!useTwoColumns) {
          return Column(
            children: [
              for (final item in [...leftItems, ...rightItems])
                _OverviewCell(item: item),
            ],
          );
        }

        return Row(
          crossAxisAlignment: CrossAxisAlignment.start,
          children: [
            Expanded(
              child: Column(
                children: [
                  for (final item in leftItems) _OverviewCell(item: item),
                ],
              ),
            ),
            const SizedBox(width: AppSpacing.lg),
            Expanded(
              child: Column(
                children: [
                  for (final item in rightItems) _OverviewCell(item: item),
                ],
              ),
            ),
          ],
        );
      },
    );
  }
}

class _OverviewItemData {
  const _OverviewItemData(this.label, this.value);

  final String label;
  final String value;
}

class _OverviewCell extends StatelessWidget {
  const _OverviewCell({required this.item});

  final _OverviewItemData item;

  @override
  Widget build(BuildContext context) {
    final theme = Theme.of(context);
    final colorScheme = theme.colorScheme;

    return Container(
      width: double.infinity,
      margin: const EdgeInsets.only(bottom: AppSpacing.md),
      padding: const EdgeInsets.symmetric(
        horizontal: AppSpacing.md,
        vertical: AppSpacing.sm,
      ),
      decoration: BoxDecoration(
        color: colorScheme.surfaceContainerLow.withValues(alpha: 0.45),
        borderRadius: BorderRadius.circular(14),
      ),
      child: Column(
        crossAxisAlignment: CrossAxisAlignment.start,
        children: [
          Text(
            item.label,
            style: theme.textTheme.bodySmall?.copyWith(
              color: colorScheme.onSurfaceVariant,
              fontWeight: FontWeight.w500,
            ),
          ),
          const SizedBox(height: AppSpacing.xs),
          Text(
            item.value,
            style: theme.textTheme.titleSmall?.copyWith(
              color: colorScheme.onSurface,
              fontWeight: FontWeight.w700,
            ),
          ),
        ],
      ),
    );
  }
}

class _BookingsContainer extends StatelessWidget {
  const _BookingsContainer();

  @override
  Widget build(BuildContext context) {
    final theme = Theme.of(context);
    final colorScheme = theme.colorScheme;

    return Container(
      width: double.infinity,
      padding: const EdgeInsets.all(AppSpacing.lg),
      decoration: BoxDecoration(
        color: colorScheme.surfaceContainerLowest,
        borderRadius: BorderRadius.circular(20),
        border: Border.all(
          color: colorScheme.outlineVariant.withValues(alpha: 0.4),
        ),
      ),
      child: Column(
        children: [
          Icon(
            Icons.flight_takeoff_rounded,
            size: 26,
            color: colorScheme.onSurfaceVariant,
          ),
          const SizedBox(height: AppSpacing.sm),
          Text(
            'No bookings yet',
            textAlign: TextAlign.center,
            style: theme.textTheme.bodyLarge?.copyWith(
              color: colorScheme.onSurfaceVariant,
            ),
          ),
        ],
      ),
    );
  }
}

String _displayValue(String? value) {
  final normalized = value?.trim() ?? '';
  return normalized.isEmpty ? '—' : normalized;
}

String _optionalValue(String? value) {
  final normalized = value?.trim() ?? '';
  return normalized.isEmpty ? 'Not provided' : normalized;
}

bool _hasValue(String? value) {
  return value?.trim().isNotEmpty ?? false;
}
