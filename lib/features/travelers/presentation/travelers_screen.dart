import 'dart:math' as math;

import 'package:cloud_firestore/cloud_firestore.dart';
import 'package:flutter/material.dart';

import '../../../core/theme/app_spacing.dart';
import '../../../core/utils/app_router.dart';
import '../../../core/widgets/empty_state_view.dart';
import '../../clients/domain/models/client_model.dart';
import '../../leads/domain/models/lead_model.dart';
import '../data/datasources/firestore_traveler_remote_data_source.dart';
import '../data/repositories/traveler_repository_impl.dart';
import '../domain/models/traveler_model.dart';
import '../domain/repositories/traveler_repository.dart';

class TravelersScreen extends StatefulWidget {
  const TravelersScreen({super.key});

  @override
  State<TravelersScreen> createState() => _TravelersScreenState();
}

class _TravelersScreenState extends State<TravelersScreen> {
  late final TravelerRepository _travelerRepository;
  late final TextEditingController _searchController;
  String? _selectedClientId;
  String? _selectedTravelerType;
  late Future<_TravelersViewData> _dataFuture;

  @override
  void initState() {
    super.initState();
    _travelerRepository = TravelerRepositoryImpl(
      remoteDataSource: FirestoreTravelerRemoteDataSource(
        firestore: FirebaseFirestore.instance,
      ),
    );
    _dataFuture = _loadData();
  }

  @override
  void dispose() {
    _searchController
      ..dispose();
    super.dispose();
  }


  Future<_TravelersViewData> _loadData() async {
    final firestore = FirebaseFirestore.instance;

    final travelersFuture = _travelerRepository.fetchTravelers();
    final clientsFuture = firestore
        .collection('clients')
        .where('isArchived', isEqualTo: false)
        .get();
    final leadsFuture = firestore
        .collection('leads')
        .where('isArchived', isEqualTo: false)
        .get();

    final (travelers, clientsSnapshot, leadsSnapshot) =
        await (travelersFuture, clientsFuture, leadsFuture).wait;

    final clients = clientsSnapshot.docs
        .map((doc) => ClientModel.fromMap(doc.data(), doc.id))
        .toList(growable: false);
    final leads = leadsSnapshot.docs
        .map(
          (doc) => LeadModel.fromMap(<String, dynamic>{
            ...doc.data(),
            'id': doc.id,
          }),
        )
        .toList(growable: false);

    return _TravelersViewData(
      travelers: travelers,
      clients: clients,
      leads: leads,
    );
  }

  void _clearFilters() {
    _searchController.clear();
    setState(() {
      _selectedClientId = null;
      _selectedTravelerType = null;
    });
  }

  List<_TravelerListItem> _applyFilters(_TravelersViewData data) {
    final query = _searchController.text.trim().toLowerCase();
    final clientById = {for (final client in data.clients) client.id: client};
    final leadById = {for (final lead in data.leads) lead.id: lead};

    final rows = data.travelers.map((traveler) {
      return _TravelerListItem(
        traveler: traveler,
        clientName: clientById[traveler.clientId]?.name ?? '—',
        leadCode: (traveler.leadId == null || traveler.leadId!.isEmpty)
            ? null
            : leadById[traveler.leadId!]?.leadCode,
      );
    }).toList(growable: false);

    return rows.where((row) {
      final traveler = row.traveler;
      final matchesSearch = query.isEmpty ||
          traveler.fullName.toLowerCase().contains(query) ||
          (traveler.phone?.toLowerCase().contains(query) ?? false) ||
          (traveler.email?.toLowerCase().contains(query) ?? false) ||
          traveler.travelerCode.toLowerCase().contains(query);
      final matchesClient =
          _selectedClientId == null || traveler.clientId == _selectedClientId;
      final matchesType = _selectedTravelerType == null ||
          traveler.travelerType == _selectedTravelerType;

      return matchesSearch && matchesClient && matchesType;
    }).toList(growable: false);
  }

  Future<void> _openCreateTravelerPanel(_TravelersViewData data) async {
    final created = await CreateTravelerPanel.show(
      context,
      clients: data.clients,
      leads: data.leads,
      travelerRepository: _travelerRepository,
    );

    if (created == true && mounted) {
      setState(() {
        _dataFuture = _loadData();
      });
    }
  }

  @override
  Widget build(BuildContext context) {
    return FutureBuilder<_TravelersViewData>(
      future: _dataFuture,
      builder: (context, snapshot) {
        if (snapshot.connectionState == ConnectionState.waiting) {
          return const Center(child: CircularProgressIndicator());
        }

        if (snapshot.hasError) {
          return const EmptyStateView(
            title: 'Unable to load travelers',
            message:
                'There was a problem loading travelers. Please try again shortly.',
            icon: Icons.error_outline_rounded,
          );
        }

        final data = snapshot.data;
        }

        final filteredRows = _applyFilters(data);

        return Column(
          crossAxisAlignment: CrossAxisAlignment.stretch,
          children: [
              searchController: _searchController,
              selectedClientId: _selectedClientId,
              selectedTravelerType: _selectedTravelerType,
              clients: data.clients,
              onClientChanged: (value) => setState(() => _selectedClientId = value),
              onTravelerTypeChanged: (value) =>
                  setState(() => _selectedTravelerType = value),
              onClearFilters: _clearFilters,
              onCreateTraveler: () => _openCreateTravelerPanel(data),
            ),
            const SizedBox(height: AppSpacing.sm),
            Expanded(
                  ? const EmptyStateView(
                      title: 'No matching travelers',
                      message:
                          'Try adjusting your search, client, or traveler type filters.',
                      icon: Icons.filter_alt_off_rounded,
                    )
                  : _TravelersTable(rows: filteredRows),
            ),
          ],
        );
      },
    );
  }
}

    required this.searchController,
    required this.selectedClientId,
    required this.selectedTravelerType,
    required this.clients,
    required this.onClientChanged,
    required this.onTravelerTypeChanged,
    required this.onClearFilters,
    required this.onCreateTraveler,
  });

  final TextEditingController searchController;
  final String? selectedClientId;
  final String? selectedTravelerType;
  final List<ClientModel> clients;
  final ValueChanged<String?> onClientChanged;
  final ValueChanged<String?> onTravelerTypeChanged;
  final VoidCallback onClearFilters;
  final VoidCallback onCreateTraveler;

  @override
  Widget build(BuildContext context) {
    return Column(
      children: [
        Align(
          alignment: Alignment.centerRight,
          child: FilledButton.icon(
            onPressed: onCreateTraveler,
            icon: const Icon(Icons.add_rounded),
            label: const Text('New Traveler'),
          ),
        ),
        const SizedBox(height: AppSpacing.sm),
        Wrap(
          spacing: AppSpacing.sm,
          crossAxisAlignment: WrapCrossAlignment.center,
          children: [
            SizedBox(
              child: TextField(
                controller: searchController,
                decoration: const InputDecoration(
                  prefixIcon: Icon(Icons.search_rounded),
                ),
              ),
            ),
            SizedBox(
              width: 220,
              child: DropdownButtonFormField<String?>(
                value: selectedClientId,
                isExpanded: true,
                decoration: const InputDecoration(labelText: 'Client'),
                items: [
                  const DropdownMenuItem<String?>(
                    value: null,
                    child: Text('All Clients'),
                  ),
                        (client) => DropdownMenuItem<String?>(
                          value: client.id,
                          child: Text(client.name),
                        ),
                ],
                onChanged: onClientChanged,
              ),
            ),
            SizedBox(
              width: 180,
              child: DropdownButtonFormField<String?>(
                value: selectedTravelerType,
                decoration: const InputDecoration(labelText: 'Traveler Type'),
                items: const [
                  DropdownMenuItem<String?>(
                    value: null,
                    child: Text('All Types'),
                  ),
                  DropdownMenuItem(value: 'Adult', child: Text('Adult')),
                  DropdownMenuItem(value: 'Child', child: Text('Child')),
                  DropdownMenuItem(value: 'Infant', child: Text('Infant')),
                ],
                onChanged: onTravelerTypeChanged,
              ),
            ),
            OutlinedButton(
              onPressed: onClearFilters,
              child: const Text('Clear Filters'),
            ),
          ],
        ),
      ],
    );
  }
}

class _TravelersTable extends StatefulWidget {
  const _TravelersTable({required this.rows});

  final List<_TravelerListItem> rows;

  static const double _minTableWidth = 1120;

  @override
  State<_TravelersTable> createState() => _TravelersTableState();
}

class _TravelersTableState extends State<_TravelersTable> {

  @override
  void initState() {
    super.initState();
  }

  @override
  void dispose() {
    super.dispose();
  }

  @override
  Widget build(BuildContext context) {
    final colorScheme = Theme.of(context).colorScheme;

    return LayoutBuilder(
      builder: (context, constraints) {
        final viewportWidth = constraints.maxWidth.isFinite
            ? constraints.maxWidth
            : _TravelersTable._minTableWidth;
        final tableWidth = math.max(viewportWidth, _TravelersTable._minTableWidth);

        return Container(
          decoration: BoxDecoration(
            color: colorScheme.surface,
            borderRadius: BorderRadius.circular(20),
            border: Border.all(
              color: colorScheme.outlineVariant.withValues(alpha: 0.68),
            ),
          ),
          clipBehavior: Clip.antiAlias,
          child: Scrollbar(
            thumbVisibility: tableWidth > viewportWidth,
            trackVisibility: tableWidth > viewportWidth,
            child: SingleChildScrollView(
              scrollDirection: Axis.horizontal,
              child: SizedBox(
                width: tableWidth,
                child: Column(
                  children: [
                    Container(
                      decoration: BoxDecoration(
                        color:
                            colorScheme.surfaceContainerHighest.withValues(alpha: 0.82),
                        border: Border(
                          bottom: BorderSide(
                          ),
                        ),
                      ),
                      child: const Row(
                        children: [
                          _HeaderCell(label: 'Traveler Code', width: 160),
                          _HeaderCell(label: 'Full Name', width: 220),
                          _HeaderCell(label: 'Traveler Type', width: 140),
                          _HeaderCell(label: 'Client', width: 220),
                          _HeaderCell(label: 'Linked Booking', width: 160),
                          _HeaderCell(label: 'Phone', width: 150),
                          _HeaderCell(label: 'Updated Date', width: 140, isLast: true),
                        ],
                      ),
                    ),
                          height: 1,
                          thickness: 1,
                          color: colorScheme.outlineVariant.withValues(alpha: 0.35),
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

class _HeaderCell extends StatelessWidget {
  const _HeaderCell({required this.label, required this.width, this.isLast = false});

  final String label;
  final double width;
  final bool isLast;

  @override
  Widget build(BuildContext context) {
    return Padding(
      padding: EdgeInsets.only(right: isLast ? 0 : AppSpacing.md),
    );
  }
}

class _TravelerRow extends StatefulWidget {
  const _TravelerRow({required this.item, required this.index});

  final _TravelerListItem item;
  final int index;

  @override
  State<_TravelerRow> createState() => _TravelerRowState();
}

class _TravelerRowState extends State<_TravelerRow> {
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
        color: _isHovered ? hoverColor : baseColor,
        child: Material(
          color: Colors.transparent,
          child: InkWell(
            onTap: () => Navigator.of(context).pushNamed(
              ),
            child: Padding(
              child: Row(
                children: [
                  _BodyCell(width: 160, value: item.traveler.travelerCode),
                  _BodyCell(width: 220, value: item.traveler.fullName),
                  _BodyCell(width: 140, value: item.traveler.travelerType),
                  _BodyCell(width: 220, value: item.clientName),
                  _BodyCell(width: 160, value: item.leadCode ?? '—'),
                  _BodyCell(width: 150, value: item.traveler.phone ?? '—'),
                  _BodyCell(
                    width: 140,
                    value: _formatDate(item.traveler.updatedAt),
                    isLast: true,
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

class _BodyCell extends StatelessWidget {
  const _BodyCell({required this.width, required this.value, this.isLast = false});

  final double width;
  final String value;
  final bool isLast;

  @override
  Widget build(BuildContext context) {
    return Padding(
      padding: EdgeInsets.only(right: isLast ? 0 : AppSpacing.md),
      child: SizedBox(
        width: width,
        child: Text(
          value,
          overflow: TextOverflow.ellipsis,
        ),
      ),
    );
  }
}

class _TravelerListItem {
  const _TravelerListItem({
    required this.traveler,
    required this.clientName,
    required this.leadCode,
  });

  final TravelerModel traveler;
  final String clientName;
  final String? leadCode;
}

class _TravelersViewData {
  const _TravelersViewData({
    required this.travelers,
    required this.clients,
    required this.leads,
  });

  final List<TravelerModel> travelers;
  final List<ClientModel> clients;
  final List<LeadModel> leads;
}

class CreateTravelerPanel extends StatefulWidget {
  const CreateTravelerPanel({
    required this.clients,
    required this.leads,
    required this.travelerRepository,
    super.key,
  });

  final List<ClientModel> clients;
  final List<LeadModel> leads;
  final TravelerRepository travelerRepository;

  static Future<bool?> show(
    BuildContext context, {
    required List<ClientModel> clients,
    required List<LeadModel> leads,
    required TravelerRepository travelerRepository,
  }) {
    return showModalBottomSheet<bool>(
      context: context,
      isScrollControlled: true,
      showDragHandle: true,
        padding: EdgeInsets.only(
        ),
        child: CreateTravelerPanel(
          clients: clients,
          leads: leads,
          travelerRepository: travelerRepository,
        ),
      ),
    );
  }

  @override
  State<CreateTravelerPanel> createState() => _CreateTravelerPanelState();
}

class _CreateTravelerPanelState extends State<CreateTravelerPanel> {
  final _formKey = GlobalKey<FormState>();
  final _fullNameController = TextEditingController();
  final _ageController = TextEditingController();
  final _phoneController = TextEditingController();
  final _emailController = TextEditingController();
  final _notesController = TextEditingController();

  String? _clientId;
  String? _leadId;
  String _travelerType = 'Adult';
  String? _gender;
  bool _isSaving = false;

  @override
  void dispose() {
    _fullNameController.dispose();
    _ageController.dispose();
    _phoneController.dispose();
    _emailController.dispose();
    _notesController.dispose();
    super.dispose();
  }

  Future<void> _createTraveler() async {
    final form = _formKey.currentState;
    if (form == null || !form.validate()) {
      return;
    }

    setState(() => _isSaving = true);

    try {
      await widget.travelerRepository.createTraveler(
        TravelerModel(
          id: '',
          travelerCode: '',
          clientId: _clientId!,
          leadId: _leadId,
          travelerType: _travelerType,
          gender: _gender,
          createdAt: DateTime.fromMillisecondsSinceEpoch(0),
          updatedAt: DateTime.fromMillisecondsSinceEpoch(0),
          isActive: true,
        ),
      );

      Navigator.of(context).pop(true);
    } catch (_) {
      setState(() => _isSaving = false);
    }
  }

  List<LeadModel> get _leadOptions {
    if (_clientId == null || _clientId!.isEmpty) {
      return widget.leads;
    }

    return widget.leads
        .where((lead) => lead.clientId == _clientId)
        .toList(growable: false);
  }

  @override
  Widget build(BuildContext context) {
    return SafeArea(
      child: SingleChildScrollView(
        child: Form(
          key: _formKey,
          child: Column(
            crossAxisAlignment: CrossAxisAlignment.stretch,
            children: [
              Text('New Traveler', style: Theme.of(context).textTheme.titleLarge),
              const SizedBox(height: AppSpacing.md),
              DropdownButtonFormField<String?>(
                value: _clientId,
                isExpanded: true,
                decoration: const InputDecoration(labelText: 'Client'),
                items: widget.clients
                    .map(
                      (client) => DropdownMenuItem<String?>(
                        value: client.id,
                        child: Text(client.name),
                      ),
                    )
                    .toList(growable: false),
                validator: (value) =>
                    (value == null || value.isEmpty) ? 'Client is required' : null,
                onChanged: _isSaving
                    ? null
                    : (value) {
                        setState(() {
                          _clientId = value;
                          if (_leadId != null &&
                              !_leadOptions.any((lead) => lead.id == _leadId)) {
                            _leadId = null;
                          }
                        });
                      },
              ),
              const SizedBox(height: AppSpacing.sm),
              DropdownButtonFormField<String?>(
                value: _leadId,
                isExpanded: true,
                decoration: const InputDecoration(labelText: 'Linked Booking / Lead'),
                items: [
                  ..._leadOptions.map(
                    (lead) => DropdownMenuItem<String?>(
                      value: lead.id,
                      child: Text(lead.leadCode),
                    ),
                  ),
                ],
                onChanged: _isSaving ? null : (value) => setState(() => _leadId = value),
              ),
              const SizedBox(height: AppSpacing.sm),
              TextFormField(
                controller: _fullNameController,
                enabled: !_isSaving,
                decoration: const InputDecoration(labelText: 'Full Name'),
                validator: (value) =>
                    (value == null || value.trim().isEmpty) ? 'Full name is required' : null,
              ),
              const SizedBox(height: AppSpacing.sm),
              DropdownButtonFormField<String>(
                value: _travelerType,
                decoration: const InputDecoration(labelText: 'Traveler Type'),
                items: const [
                  DropdownMenuItem(value: 'Adult', child: Text('Adult')),
                  DropdownMenuItem(value: 'Child', child: Text('Child')),
                  DropdownMenuItem(value: 'Infant', child: Text('Infant')),
                ],
                validator: (value) =>
                    (value == null || value.isEmpty) ? 'Traveler type is required' : null,
                onChanged: _isSaving
                    ? null
                    : (value) => setState(() => _travelerType = value ?? 'Adult'),
              ),
              const SizedBox(height: AppSpacing.sm),
                value: _gender,
                decoration: const InputDecoration(labelText: 'Gender'),
                items: const [
                  DropdownMenuItem(value: null, child: Text('Not provided')),
                  DropdownMenuItem(value: 'Male', child: Text('Male')),
                  DropdownMenuItem(value: 'Female', child: Text('Female')),
                  DropdownMenuItem(value: 'Other', child: Text('Other')),
                ],
              ),
                controller: _ageController,
                enabled: !_isSaving,
                keyboardType: TextInputType.number,
                decoration: const InputDecoration(labelText: 'Age'),
                validator: (value) {
                  final normalized = value?.trim() ?? '';
                  final parsed = int.tryParse(normalized);
                  if (parsed == null || parsed < 0) {
                    return 'Enter a valid age';
                  }
                  return null;
                },
              ),
              const SizedBox(height: AppSpacing.sm),
                controller: _phoneController,
                enabled: !_isSaving,
                decoration: const InputDecoration(labelText: 'Phone'),
              ),
                controller: _emailController,
                enabled: !_isSaving,
                decoration: const InputDecoration(labelText: 'Email'),
              ),
              const SizedBox(height: AppSpacing.sm),
              TextFormField(
                controller: _notesController,
                enabled: !_isSaving,
                minLines: 2,
                maxLines: 4,
                decoration: const InputDecoration(labelText: 'Notes'),
              ),
              Align(
                alignment: Alignment.centerRight,
                child: FilledButton(
                  onPressed: _isSaving ? null : _createTraveler,
                  child: _isSaving
                      ? const SizedBox(
                          width: 16,
                          height: 16,
                          child: CircularProgressIndicator(strokeWidth: 2),
                        )
                      : const Text('Save Traveler'),
                ),
              ),
            ],
          ),
        ),
      ),
    );
  }
}

String _formatDate(DateTime? value) {
  if (value == null) {
    return '—';
  }

  final month = value.month.toString().padLeft(2, '0');
  final day = value.day.toString().padLeft(2, '0');
  return '${value.year}-$month-$day';
}

String? _optional(String value) {
  final trimmed = value.trim();
  return trimmed.isEmpty ? null : trimmed;
}
