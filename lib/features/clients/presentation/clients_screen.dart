import 'dart:math' as math;

import 'package:cloud_firestore/cloud_firestore.dart';
import 'package:flutter/material.dart';

import '../../../core/theme/app_spacing.dart';
import '../../../core/utils/app_router.dart';
import '../../../core/widgets/empty_state_view.dart';
import '../data/datasources/firestore_client_remote_data_source.dart';
import '../data/repositories/client_repository_impl.dart';
import '../domain/repositories/client_repository.dart';

class ClientsScreen extends StatefulWidget {
  const ClientsScreen({super.key});

  @override
  State<ClientsScreen> createState() => _ClientsScreenState();
}

class _ClientsScreenState extends State<ClientsScreen> {
  late final ClientRepository _clientRepository;
  late Future<List<ClientActivitySummary>> _clientsFuture;

  @override
  void initState() {
    super.initState();
    _clientRepository = ClientRepositoryImpl(
      remoteDataSource: FirestoreClientRemoteDataSource(
        firestore: FirebaseFirestore.instance,
      ),
    );
    _clientsFuture = _clientRepository.fetchClientsWithActivitySummaries();
  }

  @override
  Widget build(BuildContext context) {
    return FutureBuilder<List<ClientActivitySummary>>(
      future: _clientsFuture,
      builder: (context, snapshot) {
        if (snapshot.connectionState == ConnectionState.waiting) {
          return const Center(child: CircularProgressIndicator());
        }

        if (snapshot.hasError) {
          return const EmptyStateView(
            title: 'Unable to load clients',
            message:
                'There was a problem loading clients. Please try again shortly.',
            icon: Icons.error_outline_rounded,
          );
        }

        final clients = snapshot.data ?? const <ClientActivitySummary>[];

        if (clients.isEmpty) {
          return const Center(
            child: Column(
              mainAxisSize: MainAxisSize.min,
              children: [
                Text(
                  'No clients yet',
                  style: TextStyle(fontSize: 20, fontWeight: FontWeight.w700),
                ),
                SizedBox(height: AppSpacing.xs),
                Text('Clients will appear when leads are converted'),
              ],
            ),
          );
        }

        return _ClientsTable(
          clients: clients,
          onClientTap: (client) => Navigator.of(context).pushNamed(
            AppRouter.clientDetailRoute(Uri.encodeComponent(client.client.id)),
          ),
        );
      },
    );
  }
}

class _ClientsTable extends StatefulWidget {
  const _ClientsTable({
    required this.clients,
    required this.onClientTap,
  });

  final List<ClientActivitySummary> clients;
  final ValueChanged<ClientActivitySummary> onClientTap;

  static const List<_ClientTableColumn> _columns = [
    _ClientTableColumn(label: 'Client Name', width: 200),
    _ClientTableColumn(label: 'Phone', width: 160),
    _ClientTableColumn(label: 'Email', width: 220),
    _ClientTableColumn(label: 'Total Bookings', width: 130),
    _ClientTableColumn(label: 'Last Activity', width: 140),
    _ClientTableColumn(label: 'Created Date', width: 140),
  ];

  static const double _minTableWidth = 1100;

  static final double _tableContentWidth = math.max(
    _minTableWidth,
    200 +
        160 +
        220 +
        130 +
        140 +
        140 +
        (AppSpacing.md * (_columns.length - 1)) +
        (16 * 2),
  );

  @override
  State<_ClientsTable> createState() => _ClientsTableState();
}

class _ClientsTableState extends State<_ClientsTable> {
  late final ScrollController _horizontalScrollController;

  @override
  void initState() {
    super.initState();
    _horizontalScrollController = ScrollController();
  }

  @override
  void dispose() {
    _horizontalScrollController.dispose();
    super.dispose();
  }

  @override
  Widget build(BuildContext context) {
    final colorScheme = Theme.of(context).colorScheme;

    return LayoutBuilder(
      builder: (context, constraints) {
        final viewportWidth = constraints.maxWidth.isFinite
            ? constraints.maxWidth
            : _ClientsTable._tableContentWidth;
        final tableWidth = math.max(viewportWidth, _ClientsTable._tableContentWidth);

        return Container(
          width: double.infinity,
          decoration: BoxDecoration(
            color: colorScheme.surface,
            borderRadius: BorderRadius.circular(20),
            border: Border.all(
              color: colorScheme.outlineVariant.withValues(alpha: 0.68),
            ),
            boxShadow: const [
              BoxShadow(
                color: Color(0x050F172A),
                blurRadius: 10,
                offset: Offset(0, 2),
              ),
            ],
          ),
          clipBehavior: Clip.antiAlias,
          child: Scrollbar(
            controller: _horizontalScrollController,
            thumbVisibility: tableWidth > viewportWidth,
            trackVisibility: tableWidth > viewportWidth,
            child: SingleChildScrollView(
              controller: _horizontalScrollController,
              scrollDirection: Axis.horizontal,
              child: SizedBox(
                width: tableWidth,
                child: Column(
                  children: [
                    Container(
                      decoration: BoxDecoration(
                        color: colorScheme.surfaceContainerHighest.withValues(
                          alpha: 0.82,
                        ),
                        border: Border(
                          bottom: BorderSide(
                            color: colorScheme.outlineVariant.withValues(
                              alpha: 0.7,
                            ),
                          ),
                        ),
                      ),
                      padding: const EdgeInsets.symmetric(
                        horizontal: 16,
                        vertical: 10,
                      ),
                      child: const Row(
                        children: [
                          _ClientHeaderCell(label: 'Client Name', width: 200),
                          _ClientHeaderCell(label: 'Phone', width: 160),
                          _ClientHeaderCell(label: 'Email', width: 220),
                          _ClientHeaderCell(label: 'Total Bookings', width: 130),
                          _ClientHeaderCell(label: 'Last Activity', width: 140),
                          _ClientHeaderCell(
                            label: 'Created Date',
                            width: 140,
                            isLast: true,
                          ),
                        ],
                      ),
                    ),
                    for (var index = 0; index < widget.clients.length; index++) ...[
                      _ClientRow(
                        summary: widget.clients[index],
                        index: index,
                        onTap: () => widget.onClientTap(widget.clients[index]),
                      ),
                      if (index < widget.clients.length - 1)
                        Divider(
                          height: 1,
                          thickness: 1,
                          color: colorScheme.outlineVariant.withValues(alpha: 0.35),
                        ),
                    ],
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

class _ClientHeaderCell extends StatelessWidget {
  const _ClientHeaderCell({
    required this.label,
    required this.width,
    this.isLast = false,
  });

  final String label;
  final double width;
  final bool isLast;

  @override
  Widget build(BuildContext context) {
    final style = Theme.of(context).textTheme.labelLarge?.copyWith(
      fontWeight: FontWeight.w600,
      letterSpacing: 0.05,
    );

    return Padding(
      padding: EdgeInsets.only(right: isLast ? 0 : AppSpacing.md),
      child: SizedBox(width: width, child: Text(label, style: style)),
    );
  }
}

class _ClientRow extends StatefulWidget {
  const _ClientRow({
    required this.summary,
    required this.index,
    required this.onTap,
  });

  final ClientActivitySummary summary;
  final int index;
  final VoidCallback onTap;

  @override
  State<_ClientRow> createState() => _ClientRowState();
}

class _ClientRowState extends State<_ClientRow> {
  bool _isHovered = false;

  @override
  Widget build(BuildContext context) {
    final theme = Theme.of(context);
    final colorScheme = theme.colorScheme;
    final baseColor = widget.index.isEven
        ? colorScheme.surface
        : colorScheme.surfaceContainerHighest.withValues(alpha: 0.28);
    final hoverColor = colorScheme.onSurface.withValues(alpha: 0.035);

    return MouseRegion(
      cursor: SystemMouseCursors.click,
      onEnter: (_) => setState(() => _isHovered = true),
      onExit: (_) => setState(() => _isHovered = false),
      child: AnimatedContainer(
        duration: const Duration(milliseconds: 120),
        curve: Curves.easeOut,
        color: _isHovered ? hoverColor : baseColor,
        child: Material(
          color: Colors.transparent,
          child: InkWell(
            onTap: widget.onTap,
            hoverColor: Colors.transparent,
            highlightColor: colorScheme.primary.withValues(alpha: 0.04),
            splashColor: colorScheme.primary.withValues(alpha: 0.06),
            child: Padding(
              padding: const EdgeInsets.symmetric(horizontal: 16, vertical: 9),
              child: Row(
                children: [
                  _ClientCell(
                    width: 200,
                    child: Text(
                      _fallback(widget.summary.client.name, 'Unknown client'),
                      style: theme.textTheme.bodyMedium?.copyWith(
                        fontWeight: FontWeight.w600,
                      ),
                      overflow: TextOverflow.ellipsis,
                    ),
                  ),
                  _ClientCell(
                    width: 160,
                    child: Text(
                      _fallback(widget.summary.client.phone, '—'),
                      style: theme.textTheme.bodyMedium,
                      overflow: TextOverflow.ellipsis,
                    ),
                  ),
                  _ClientCell(
                    width: 220,
                    child: Text(
                      _fallback(widget.summary.client.email, '—'),
                      style: theme.textTheme.bodyMedium,
                      overflow: TextOverflow.ellipsis,
                    ),
                  ),
                  _ClientCell(
                    width: 130,
                    child: Text(
                      widget.summary.totalLeads.toString(),
                      style: theme.textTheme.bodyMedium?.copyWith(
                        fontWeight: FontWeight.w600,
                      ),
                    ),
                  ),
                  _ClientCell(
                    width: 140,
                    child: Text(
                      _formatDate(widget.summary.latestActivityDate),
                      style: theme.textTheme.bodyMedium?.copyWith(
                        color: colorScheme.onSurfaceVariant,
                      ),
                    ),
                  ),
                  _ClientCell(
                    width: 140,
                    isLast: true,
                    child: Text(
                      _formatDate(widget.summary.client.createdAt),
                      style: theme.textTheme.bodyMedium?.copyWith(
                        color: colorScheme.onSurfaceVariant,
                      ),
                    ),
                  ),
                ],
              ),
            ),
          ),
        ),
      ),
    );
  }
}

class _ClientCell extends StatelessWidget {
  const _ClientCell({
    required this.width,
    required this.child,
    this.isLast = false,
  });

  final double width;
  final Widget child;
  final bool isLast;

  @override
  Widget build(BuildContext context) {
    return Padding(
      padding: EdgeInsets.only(right: isLast ? 0 : AppSpacing.md),
      child: SizedBox(width: width, child: child),
    );
  }
}

class _ClientTableColumn {
  const _ClientTableColumn({required this.label, required this.width});

  final String label;
  final double width;
}

String _fallback(String? value, String placeholder) {
  final normalized = value?.trim();
  if (normalized == null || normalized.isEmpty) {
    return placeholder;
  }

  return normalized;
}

String _formatDate(DateTime? value) {
  if (value == null || value == DateTime.fromMillisecondsSinceEpoch(0)) {
    return '—';
  }

  final month = switch (value.month) {
    1 => 'Jan',
    2 => 'Feb',
    3 => 'Mar',
    4 => 'Apr',
    5 => 'May',
    6 => 'Jun',
    7 => 'Jul',
    8 => 'Aug',
    9 => 'Sep',
    10 => 'Oct',
    11 => 'Nov',
    12 => 'Dec',
    _ => '',
  };

  return '${value.day.toString().padLeft(2, '0')} $month ${value.year}';
}
