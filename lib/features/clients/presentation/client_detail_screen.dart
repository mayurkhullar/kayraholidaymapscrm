import 'package:cloud_firestore/cloud_firestore.dart';
import 'package:flutter/material.dart';

import '../../../core/theme/app_spacing.dart';
import '../../../core/utils/responsive_utils.dart';
import '../../../core/widgets/app_top_bar.dart';
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
    return Scaffold(
      backgroundColor: Theme.of(context).colorScheme.surface,
      body: SafeArea(
        child: Column(
          crossAxisAlignment: CrossAxisAlignment.stretch,
          children: [
            const AppTopBar(pageTitle: 'Client Details'),
            Expanded(
              child: FutureBuilder<ClientModel?>(
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

                  final horizontalPadding =
                      ResponsiveUtils.horizontalPagePadding(context);
                  final contentMaxWidth = ResponsiveUtils.contentMaxWidth(
                    context,
                  );

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
                              SectionContainer(
                                title: client.name,
                                subtitle: 'Client profile',
                                bodyTopSpacing: AppSpacing.lg,
                                child: _ClientOverview(client: client),
                              ),
                              const SizedBox(height: AppSpacing.lg),
                              const SectionContainer(
                                title: 'Bookings / Trips',
                                subtitle: 'Client travel activity',
                                child: _BookingsPlaceholder(),
                              ),
                            ],
                          ),
                        ),
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

class _ClientOverview extends StatelessWidget {
  const _ClientOverview({required this.client});

  final ClientModel client;

  @override
  Widget build(BuildContext context) {
    final createdDate = MaterialLocalizations.of(context).formatMediumDate(
      client.createdAt,
    );

    return Column(
      children: [
        _DetailRow(label: 'Name', value: _displayValue(client.name)),
        _DetailRow(label: 'Phone', value: _displayValue(client.phone)),
        _DetailRow(
          label: 'WhatsApp',
          value: _optionalValue(client.whatsappNumber),
        ),
        _DetailRow(label: 'Email', value: _optionalValue(client.email)),
        _DetailRow(label: 'Client Code', value: _displayValue(client.clientCode)),
        _DetailRow(label: 'Created Date', value: createdDate, isLast: true),
      ],
    );
  }
}

class _BookingsPlaceholder extends StatelessWidget {
  const _BookingsPlaceholder();

  @override
  Widget build(BuildContext context) {
    final theme = Theme.of(context);

    return Align(
      alignment: Alignment.centerLeft,
      child: Text(
        'No bookings yet',
        style: theme.textTheme.bodyLarge?.copyWith(
          color: theme.colorScheme.onSurfaceVariant,
        ),
      ),
    );
  }
}

class _DetailRow extends StatelessWidget {
  const _DetailRow({
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
      padding: const EdgeInsets.symmetric(vertical: AppSpacing.md),
      decoration: BoxDecoration(
        border: Border(
          bottom: isLast
              ? BorderSide.none
              : BorderSide(
                  color: colorScheme.outlineVariant.withValues(alpha: 0.5),
                ),
        ),
      ),
      child: Row(
        crossAxisAlignment: CrossAxisAlignment.start,
        children: [
          SizedBox(
            width: 120,
            child: Text(
              label,
              style: theme.textTheme.bodyMedium?.copyWith(
                color: colorScheme.onSurfaceVariant,
                fontWeight: FontWeight.w600,
              ),
            ),
          ),
          const SizedBox(width: AppSpacing.sm),
          Expanded(
            child: Text(
              value,
              style: theme.textTheme.bodyLarge?.copyWith(
                color: colorScheme.onSurface,
              ),
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
