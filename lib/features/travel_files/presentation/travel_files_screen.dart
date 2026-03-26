import 'package:cloud_firestore/cloud_firestore.dart';
import 'package:flutter/material.dart';

import '../../../core/theme/app_spacing.dart';
import '../../../core/utils/app_router.dart';
import '../../../core/widgets/empty_state_view.dart';
import '../../../core/widgets/two_axis_table_viewport.dart';
import '../../clients/domain/models/client_model.dart';
import '../../leads/domain/models/lead_model.dart';
import '../data/datasources/firestore_travel_file_remote_data_source.dart';
import '../data/repositories/travel_file_repository_impl.dart';
import '../domain/models/travel_file_model.dart';
import '../domain/repositories/travel_file_repository.dart';

class TravelFilesScreen extends StatefulWidget {
  const TravelFilesScreen({super.key});

  @override
  State<TravelFilesScreen> createState() => _TravelFilesScreenState();
}

class _TravelFilesScreenState extends State<TravelFilesScreen> {
  late final TravelFileRepository _repository;
  late final TextEditingController _searchController;
  late Future<_TravelFilesViewData> _dataFuture;
  String? _selectedStatus;
  String? _selectedClientId;

  @override
  void initState() {
    super.initState();
    _repository = TravelFileRepositoryImpl(
      remoteDataSource: FirestoreTravelFileRemoteDataSource(
        firestore: FirebaseFirestore.instance,
      ),
    );
    _searchController = TextEditingController()..addListener(_onFilterChange);
    _dataFuture = _loadData();
  }

  @override
  void dispose() {
    _searchController
      ..removeListener(_onFilterChange)
      ..dispose();
    super.dispose();
  }

  void _onFilterChange() => setState(() {});

  Future<_TravelFilesViewData> _loadData() async {
    final firestore = FirebaseFirestore.instance;

    final filesFuture = _repository.fetchTravelFiles();
    final leadsFuture = firestore
        .collection('leads')
        .where('isArchived', isEqualTo: false)
        .get();
    final clientsFuture = firestore
        .collection('clients')
        .where('isActive', isEqualTo: true)
        .get();

    final (travelFiles, leadsSnapshot, clientsSnapshot) =
        await (filesFuture, leadsFuture, clientsFuture).wait;

    final leads = leadsSnapshot.docs
        .map((doc) => LeadModel.fromMap(<String, dynamic>{...doc.data(), 'id': doc.id}))
        .toList(growable: false);
    final clients = clientsSnapshot.docs
        .map((doc) => ClientModel.fromMap(doc.data(), doc.id))
        .toList(growable: false);

    return _TravelFilesViewData(
      travelFiles: travelFiles,
      leads: leads,
      clients: clients,
    );
  }

  void _clearFilters() {
    _searchController.clear();
    setState(() {
      _selectedStatus = null;
      _selectedClientId = null;
    });
  }

  List<_TravelFileListItem> _applyFilters(_TravelFilesViewData data) {
    final query = _searchController.text.trim().toLowerCase();
    final leadsById = {for (final lead in data.leads) lead.id: lead};
    final clientsById = {for (final client in data.clients) client.id: client};

    final rows = data.travelFiles
        .map(
          (travelFile) => _TravelFileListItem(
            travelFile: travelFile,
            leadCode: leadsById[travelFile.leadId]?.leadCode,
            clientName: clientsById[travelFile.clientId]?.name,
          ),
        )
        .toList(growable: false);

    return rows.where((row) {
      final model = row.travelFile;
      final searchMatches =
          query.isEmpty ||
          model.travelFileCode.toLowerCase().contains(query) ||
          model.clientNameSnapshot.toLowerCase().contains(query) ||
          model.destination.toLowerCase().contains(query) ||
          (row.leadCode?.toLowerCase().contains(query) ?? false);

      final statusMatches =
          _selectedStatus == null || model.status == _selectedStatus;
      final clientMatches =
          _selectedClientId == null || model.clientId == _selectedClientId;

      return searchMatches && statusMatches && clientMatches;
    }).toList(growable: false);
  }

  @override
  Widget build(BuildContext context) {
    return FutureBuilder<_TravelFilesViewData>(
      future: _dataFuture,
      builder: (context, snapshot) {
        if (snapshot.connectionState == ConnectionState.waiting) {
          return const Center(child: CircularProgressIndicator());
        }

        if (snapshot.hasError) {
          return const EmptyStateView(
            title: 'Unable to load travel files',
            message:
                'There was a problem loading travel files. Please try again shortly.',
            icon: Icons.error_outline_rounded,
          );
        }

        final data = snapshot.data;
        if (data == null || data.travelFiles.isEmpty) {
          return const EmptyStateView(
            title: 'No travel files yet',
            message:
                'Travel files will appear automatically for confirmed bookings',
            icon: Icons.folder_open_rounded,
          );
        }

        final filteredRows = _applyFilters(data);

        return SizedBox.expand(
          child: Container(
            decoration: BoxDecoration(
              color: Theme.of(context).colorScheme.surface,
              borderRadius: BorderRadius.circular(20),
              border: Border.all(
                color: Theme.of(context)
                    .colorScheme
                    .outlineVariant
                    .withValues(alpha: 0.68),
              ),
            ),
            clipBehavior: Clip.antiAlias,
            child: Column(
              children: [
                _TravelFilesToolbar(
                  searchController: _searchController,
                  selectedStatus: _selectedStatus,
                  selectedClientId: _selectedClientId,
                  clients: data.clients,
                  onStatusChanged: (value) => setState(() => _selectedStatus = value),
                  onClientChanged: (value) => setState(() => _selectedClientId = value),
                  onClearFilters: _clearFilters,
                ),
                Expanded(
                  child: filteredRows.isEmpty
                      ? const EmptyStateView(
                          title: 'No matching travel files',
                          message:
                              'Try adjusting your search, status, or client filters.',
                          icon: Icons.filter_alt_off_rounded,
                        )
                      : _TravelFilesTable(rows: filteredRows),
                ),
              ],
            ),
          ),
        );
      },
    );
  }
}

class _TravelFilesToolbar extends StatelessWidget {
  const _TravelFilesToolbar({
    required this.searchController,
    required this.selectedStatus,
    required this.selectedClientId,
    required this.clients,
    required this.onStatusChanged,
    required this.onClientChanged,
    required this.onClearFilters,
  });

  final TextEditingController searchController;
  final String? selectedStatus;
  final String? selectedClientId;
  final List<ClientModel> clients;
  final ValueChanged<String?> onStatusChanged;
  final ValueChanged<String?> onClientChanged;
  final VoidCallback onClearFilters;

  @override
  Widget build(BuildContext context) {
    final statuses = <String>{'Open'}
      ..addAll(const <String>['In Progress', 'Closed'])
      ..addAll(const <String>['Archived']);

    return Container(
      padding: const EdgeInsets.all(AppSpacing.md),
      decoration: BoxDecoration(
        color: Theme.of(context).colorScheme.surfaceContainerLowest,
        border: Border(
          bottom: BorderSide(
            color:
                Theme.of(context).colorScheme.outlineVariant.withValues(alpha: 0.42),
          ),
        ),
      ),
      child: Wrap(
        spacing: AppSpacing.sm,
        runSpacing: AppSpacing.sm,
        crossAxisAlignment: WrapCrossAlignment.center,
        children: [
          SizedBox(
            width: 280,
            child: TextField(
              controller: searchController,
              decoration: const InputDecoration(
                hintText: 'Search travel file, client, destination, booking',
                prefixIcon: Icon(Icons.search_rounded),
              ),
            ),
          ),
          SizedBox(
            width: 180,
            child: DropdownButtonFormField<String?>(
              value: selectedStatus,
              decoration: const InputDecoration(labelText: 'Status'),
              items: [
                const DropdownMenuItem<String?>(value: null, child: Text('All statuses')),
                ...statuses.map(
                  (status) => DropdownMenuItem<String?>(
                    value: status,
                    child: Text(status),
                  ),
                ),
              ],
              onChanged: onStatusChanged,
            ),
          ),
          SizedBox(
            width: 200,
            child: DropdownButtonFormField<String?>(
              value: selectedClientId,
              decoration: const InputDecoration(labelText: 'Client'),
              items: [
                const DropdownMenuItem<String?>(value: null, child: Text('All clients')),
                ...clients.map(
                  (client) => DropdownMenuItem<String?>(
                    value: client.id,
                    child: Text(client.name),
                  ),
                ),
              ],
              onChanged: onClientChanged,
            ),
          ),
          OutlinedButton.icon(
            onPressed: onClearFilters,
            icon: const Icon(Icons.filter_alt_off_rounded),
            label: const Text('Clear filters'),
          ),
        ],
      ),
    );
  }
}

class _TravelFilesTable extends StatelessWidget {
  const _TravelFilesTable({required this.rows});

  final List<_TravelFileListItem> rows;

  static const _flex = <int>[
    18,
    18,
    15,
    13,
    8,
    10,
    14,
    14,
  ];

  @override
  Widget build(BuildContext context) {
    return TwoAxisTableViewport(
      minContentWidth: 1120,
      header: Container(
        color: Theme.of(context).colorScheme.surfaceContainerLowest,
        padding: const EdgeInsets.symmetric(horizontal: AppSpacing.sm),
        child: const _TravelFilesRow(
          isHeader: true,
          columns: [
            'Travel File Code',
            'Client',
            'Destination',
            'Travel Type',
            'Pax',
            'Status',
            'Linked Booking',
            'Updated Date',
          ],
        ),
      ),
      bodyBuilder: (context, verticalController) => ListView.separated(
        controller: verticalController,
        itemCount: rows.length,
        separatorBuilder: (_, __) => Divider(
          height: 1,
          color: Theme.of(context).colorScheme.outlineVariant.withValues(alpha: 0.24),
        ),
        itemBuilder: (context, index) {
          final row = rows[index];
          final travelFile = row.travelFile;
          final updatedDateLabel = _formatDate(context, travelFile.updatedAt);

          return InkWell(
            onTap: () => Navigator.of(context).pushNamed(
              AppRouter.travelFileDetailRoute(Uri.encodeComponent(travelFile.id)),
            ),
            child: Padding(
              padding: const EdgeInsets.symmetric(horizontal: AppSpacing.sm),
              child: _TravelFilesRow(
                columns: [
                  travelFile.travelFileCode,
                  row.clientName ?? travelFile.clientNameSnapshot,
                  _safeText(travelFile.destination),
                  _safeText(travelFile.travelType),
                  '${travelFile.totalPax}',
                  _safeText(travelFile.status),
                  row.leadCode ?? '—',
                  updatedDateLabel,
                ],
              ),
            ),
          );
        },
      ),
    );
  }
}

class _TravelFilesRow extends StatelessWidget {
  const _TravelFilesRow({required this.columns, this.isHeader = false});

  final List<String> columns;
  final bool isHeader;

  static const _flex = _TravelFilesTable._flex;

  @override
  Widget build(BuildContext context) {
    final theme = Theme.of(context);

    return SizedBox(
      height: isHeader ? 52 : 56,
      child: Row(
        children: List.generate(columns.length, (index) {
          return Expanded(
            flex: _flex[index],
            child: Padding(
              padding: const EdgeInsets.symmetric(horizontal: AppSpacing.sm),
              child: Text(
                columns[index],
                maxLines: 1,
                overflow: TextOverflow.ellipsis,
                style: isHeader
                    ? theme.textTheme.labelLarge?.copyWith(fontWeight: FontWeight.w700)
                    : theme.textTheme.bodyMedium,
              ),
            ),
          );
        }),
      ),
    );
  }
}

class _TravelFilesViewData {
  const _TravelFilesViewData({
    required this.travelFiles,
    required this.leads,
    required this.clients,
  });

  final List<TravelFileModel> travelFiles;
  final List<LeadModel> leads;
  final List<ClientModel> clients;
}

class _TravelFileListItem {
  const _TravelFileListItem({
    required this.travelFile,
    required this.leadCode,
    required this.clientName,
  });

  final TravelFileModel travelFile;
  final String? leadCode;
  final String? clientName;
}

String _safeText(String? value) {
  final trimmed = value?.trim() ?? '';
  return trimmed.isEmpty ? '—' : trimmed;
}

String _formatDate(BuildContext context, DateTime? date) {
  if (date == null) {
    return '—';
  }

  final materialLocalizations = MaterialLocalizations.of(context);
  return materialLocalizations.formatShortDate(date);
}
