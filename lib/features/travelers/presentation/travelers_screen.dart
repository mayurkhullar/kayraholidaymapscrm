import 'dart:math' as math;

import 'package:cloud_firestore/cloud_firestore.dart';
import 'package:flutter/material.dart';

import '../../../core/theme/app_spacing.dart';
import '../../../core/utils/app_router.dart';
import '../../../core/widgets/empty_state_view.dart';
import '../../clients/data/datasources/firestore_client_remote_data_source.dart';
import '../../clients/data/repositories/client_repository_impl.dart';
import '../../clients/domain/models/client_model.dart';
import '../../clients/domain/repositories/client_repository.dart';
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
  late final ClientRepository _clientRepository;
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
    _clientRepository = ClientRepositoryImpl(
      remoteDataSource: FirestoreClientRemoteDataSource(
        firestore: FirebaseFirestore.instance,
      ),
    );
    _searchController = TextEditingController()..addListener(_onSearchChanged);
    _dataFuture = _loadData();
  }

  @override
  void dispose() {
    _searchController
      ..removeListener(_onSearchChanged)
      ..dispose();
    super.dispose();
  }

  void _onSearchChanged() => setState(() {});

  Future<_TravelersViewData> _loadData() async {
    final firestore = FirebaseFirestore.instance;

    final travelersFuture = _travelerRepository.fetchTravelers();
    final leadsFuture =
        firestore
            .collection('leads')
            .where('isArchived', isEqualTo: false)
            .get();

    final (travelers, leadsSnapshot) = await (travelersFuture, leadsFuture).wait;

    List<ClientModel> clients = const [];
    var hasClientLoadError = false;
    try {
      clients = await _clientRepository.fetchClients();
    } catch (error, stackTrace) {
      debugPrint('Failed to load clients for traveler creation: $error');
      debugPrint('$stackTrace');
      hasClientLoadError = true;
    }

    final leads = leadsSnapshot.docs
        .map(
          (doc) =>
              LeadModel.fromMap(<String, dynamic>{...doc.data(), 'id': doc.id}),
        )
        .toList(growable: false);

    return _TravelersViewData(
      travelers: travelers,
      clients: clients,
      leads: leads,
      hasClientLoadError: hasClientLoadError,
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

    final rows = data.travelers
        .map((traveler) {
          final client = clientById[traveler.clientId];
          return _TravelerListItem(
            traveler: traveler,
            clientName: _clientPrimaryLabel(client),
            leadCode:
                (traveler.leadId == null || traveler.leadId!.isEmpty)
                    ? null
                    : leadById[traveler.leadId!]?.leadCode,
          );
        })
        .toList(growable: false);

    return rows
        .where((row) {
          final traveler = row.traveler;
          final matchesSearch =
              query.isEmpty ||
              traveler.fullName.toLowerCase().contains(query) ||
              (traveler.phone?.toLowerCase().contains(query) ?? false) ||
              (traveler.email?.toLowerCase().contains(query) ?? false) ||
              traveler.travelerCode.toLowerCase().contains(query);

          final matchesClient =
              _selectedClientId == null ||
              traveler.clientId == _selectedClientId;
          final matchesType =
              _selectedTravelerType == null ||
              traveler.travelerType == _selectedTravelerType;

          return matchesSearch && matchesClient && matchesType;
        })
        .toList(growable: false);
  }

  Future<void> _openCreateTravelerPanel(_TravelersViewData data) async {
    final created = await CreateTravelerPanel.show(
      context,
      clients: data.clients,
      leads: data.leads,
      hasClientLoadError: data.hasClientLoadError,
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
        if (data == null || data.travelers.isEmpty) {
          return Column(
            crossAxisAlignment: CrossAxisAlignment.stretch,
            children: [
              Align(
                alignment: Alignment.centerRight,
                child: FilledButton.icon(
                  onPressed:
                      data == null
                          ? null
                          : () => _openCreateTravelerPanel(data),
                  icon: const Icon(Icons.add_rounded),
                  label: const Text('New Traveler'),
                ),
              ),
              const SizedBox(height: AppSpacing.sm),
              const Padding(
                padding: EdgeInsets.symmetric(vertical: AppSpacing.lg),
                child: EmptyStateView(
                  title: 'No travelers yet',
                  message:
                      "Travelers linked to clients and bookings will appear here.\nClick 'New Traveler' to add your first traveler",
                  icon: Icons.luggage_outlined,
                ),
              ),
            ],
          );
        }

        final filteredRows = _applyFilters(data);

        return LayoutBuilder(
          builder: (context, constraints) {
            return SizedBox(
              height: constraints.maxHeight,
              child: Container(
                decoration: BoxDecoration(
                  color: Theme.of(context).colorScheme.surface,
                  borderRadius: BorderRadius.circular(20),
                  border: Border.all(
                    color: Theme.of(
                      context,
                    ).colorScheme.outlineVariant.withValues(alpha: 0.68),
                  ),
                ),
                clipBehavior: Clip.antiAlias,
                child: Column(
                  crossAxisAlignment: CrossAxisAlignment.stretch,
                  children: [
                    _TravelerToolbar(
                      searchController: _searchController,
                      selectedClientId: _selectedClientId,
                      selectedTravelerType: _selectedTravelerType,
                      clients: data.clients,
                      onClientChanged:
                          (value) => setState(() => _selectedClientId = value),
                      onTravelerTypeChanged:
                          (value) =>
                              setState(() => _selectedTravelerType = value),
                      onClearFilters: _clearFilters,
                      onCreateTraveler: () => _openCreateTravelerPanel(data),
                    ),
                    Expanded(
                      child:
                          filteredRows.isEmpty
                              ? const EmptyStateView(
                                title: 'No matching travelers',
                                message:
                                    'Try adjusting your search, client, or traveler type filters.',
                                icon: Icons.filter_alt_off_rounded,
                              )
                              : _TravelersTable(rows: filteredRows),
                    ),
                  ],
                ),
              ),
            );
          },
        );
      },
    );
  }
}

class _TravelerToolbar extends StatelessWidget {
  const _TravelerToolbar({
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
    final theme = Theme.of(context);
    final colorScheme = theme.colorScheme;
    final inputDecorationTheme = theme.inputDecorationTheme;
    final controlTheme = theme.copyWith(
      inputDecorationTheme: inputDecorationTheme.copyWith(
        filled: true,
        fillColor: colorScheme.surface,
        contentPadding: const EdgeInsets.symmetric(
          horizontal: AppSpacing.md,
          vertical: 10,
        ),
        border: OutlineInputBorder(
          borderRadius: BorderRadius.circular(12),
          borderSide: BorderSide(color: colorScheme.outlineVariant),
        ),
        enabledBorder: OutlineInputBorder(
          borderRadius: BorderRadius.circular(12),
          borderSide: BorderSide(color: colorScheme.outlineVariant),
        ),
        focusedBorder: OutlineInputBorder(
          borderRadius: BorderRadius.circular(12),
          borderSide: BorderSide(color: colorScheme.primary, width: 1.2),
        ),
        labelStyle: theme.textTheme.bodySmall?.copyWith(
          color: colorScheme.onSurfaceVariant,
        ),
        hintStyle: theme.textTheme.bodyMedium?.copyWith(
          color: colorScheme.onSurfaceVariant,
        ),
      ),
    );

    return Container(
      padding: const EdgeInsets.fromLTRB(AppSpacing.md, 8, AppSpacing.md, 6),
      decoration: BoxDecoration(
        color: colorScheme.surfaceContainerHighest.withValues(alpha: 0.45),
        border: Border(
          bottom: BorderSide(
            color: colorScheme.outlineVariant.withValues(alpha: 0.72),
          ),
        ),
      ),
      child: LayoutBuilder(
        builder: (context, constraints) {
          final isCompact = constraints.maxWidth < 1120;
          final compactFieldWidth = constraints.maxWidth - (AppSpacing.md * 2);
          final searchWidth = isCompact ? compactFieldWidth : 320.0;
          final clientWidth = isCompact ? compactFieldWidth : 210.0;
          final typeWidth = isCompact ? compactFieldWidth : 170.0;

          return Theme(
            data: controlTheme,
            child: Wrap(
              runSpacing: AppSpacing.xs,
              spacing: AppSpacing.sm,
              crossAxisAlignment: WrapCrossAlignment.center,
              children: [
                SizedBox(
                  width: searchWidth.clamp(0.0, 320.0).toDouble(),
                  child: TextField(
                    controller: searchController,
                    decoration: InputDecoration(
                      hintText: 'Search travelers by name, phone, email, or code',
                      prefixIcon: Icon(
                        Icons.search_rounded,
                        size: 18,
                        color: colorScheme.onSurfaceVariant,
                      ),
                      isDense: true,
                    ),
                  ),
                ),
                SizedBox(
                  width: clientWidth.clamp(0.0, 210.0).toDouble(),
                  child: DropdownButtonFormField<String?>(
                    value: selectedClientId,
                    isExpanded: true,
                    decoration: const InputDecoration(
                      labelText: 'Client',
                      isDense: true,
                    ),
                    items: [
                      const DropdownMenuItem<String?>(
                        value: null,
                        child: Text('All Clients'),
                      ),
                      ...clients
                          .map(
                            (client) => DropdownMenuItem<String?>(
                              value: client.id,
                              child: Text(client.name),
                            ),
                          )
                          .toList(growable: false),
                    ],
                    onChanged: onClientChanged,
                  ),
                ),
                SizedBox(
                  width: typeWidth.clamp(0.0, 170.0).toDouble(),
                  child: DropdownButtonFormField<String?>(
                    value: selectedTravelerType,
                    decoration: const InputDecoration(
                      labelText: 'Traveler Type',
                      isDense: true,
                    ),
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
                OutlinedButton.icon(
                  onPressed: onClearFilters,
                  icon: const Icon(Icons.restart_alt_rounded, size: 16),
                  label: const Text('Clear Filters'),
                  style: OutlinedButton.styleFrom(
                    visualDensity: VisualDensity.compact,
                    minimumSize: const Size(0, 40),
                    backgroundColor: colorScheme.surface,
                    padding: const EdgeInsets.symmetric(
                      horizontal: AppSpacing.md,
                      vertical: 10,
                    ),
                    shape: RoundedRectangleBorder(
                      borderRadius: BorderRadius.circular(12),
                    ),
                  ),
                ),
                FilledButton.icon(
                  onPressed: onCreateTraveler,
                  icon: const Icon(Icons.add_rounded),
                  label: const Text('New Traveler'),
                ),
              ],
            ),
          );
        },
      ),
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
  late final ScrollController _horizontalController;

  @override
  void initState() {
    super.initState();
    _horizontalController = ScrollController();
  }

  @override
  void dispose() {
    _horizontalController.dispose();
    super.dispose();
  }

  @override
  Widget build(BuildContext context) {
    final colorScheme = Theme.of(context).colorScheme;

    return LayoutBuilder(
      builder: (context, constraints) {
        final viewportWidth =
            constraints.maxWidth.isFinite
                ? constraints.maxWidth
                : _TravelersTable._minTableWidth;
        final tableWidth = math.max(
          viewportWidth,
          _TravelersTable._minTableWidth,
        );

        return Scrollbar(
          controller: _horizontalController,
          thumbVisibility: tableWidth > viewportWidth,
          trackVisibility: tableWidth > viewportWidth,
          child: SizedBox(
            width: tableWidth,
            child: Column(
              children: [
                Container(
                  padding: const EdgeInsets.symmetric(
                    horizontal: 16,
                    vertical: 8,
                  ),
                  decoration: BoxDecoration(
                    color: colorScheme.surfaceContainerHighest.withValues(
                      alpha: 0.58,
                    ),
                    border: Border(
                      bottom: BorderSide(
                        color: colorScheme.outlineVariant.withValues(alpha: 0.75),
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
                      _HeaderCell(
                        label: 'Updated Date',
                        width: 140,
                        isLast: true,
                      ),
                    ],
                  ),
                ),
                Expanded(
                  child: SingleChildScrollView(
                    controller: _horizontalController,
                    scrollDirection: Axis.horizontal,
                    child: SizedBox(
                      width: tableWidth,
                      child: LayoutBuilder(
                        builder: (context, bodyConstraints) {
                          const rowHeight = 44.0;
                          final minRowsToFill = math.max(
                            1,
                            (bodyConstraints.maxHeight / rowHeight).ceil(),
                          );
                          final visualRowCount = math.max(
                            widget.rows.length,
                            minRowsToFill,
                          );

                          return ListView.separated(
                            padding: EdgeInsets.zero,
                            itemCount: visualRowCount,
                            separatorBuilder:
                                (context, index) => Divider(
                                  height: 1,
                                  thickness: 1,
                                  color: colorScheme.outlineVariant.withValues(
                                    alpha: 0.35,
                                  ),
                                ),
                            itemBuilder: (context, index) {
                              if (index < widget.rows.length) {
                                final item = widget.rows[index];
                                return _TravelerRow(item: item, index: index);
                              }
                              return _TravelerPlaceholderRow(index: index);
                            },
                          );
                        },
                      ),
                    ),
                  ),
                ),
              ],
            ),
          ),
        );
      },
    );
  }
}

class _HeaderCell extends StatelessWidget {
  const _HeaderCell({
    required this.label,
    required this.width,
    this.isLast = false,
  });

  final String label;
  final double width;
  final bool isLast;

  @override
  Widget build(BuildContext context) {
    return Padding(
      padding: EdgeInsets.only(right: isLast ? 0 : AppSpacing.md),
      child: SizedBox(
        width: width,
        child: Text(
          label,
          style: Theme.of(
            context,
          ).textTheme.labelLarge?.copyWith(fontWeight: FontWeight.w700),
        ),
      ),
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
    final item = widget.item;
    final theme = Theme.of(context);
    final colorScheme = theme.colorScheme;
    final baseColor =
        widget.index.isEven
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
            onTap:
                () => Navigator.of(context).pushNamed(
                  AppRouter.travelerDetailRoute(
                    Uri.encodeComponent(item.traveler.id),
                  ),
                ),
            child: Padding(
              padding: const EdgeInsets.symmetric(horizontal: 16, vertical: 6),
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

class _TravelerPlaceholderRow extends StatelessWidget {
  const _TravelerPlaceholderRow({required this.index});

  final int index;

  @override
  Widget build(BuildContext context) {
    final colorScheme = Theme.of(context).colorScheme;
    final baseColor =
        index.isEven
            ? colorScheme.surface
            : colorScheme.surfaceContainerHighest.withValues(alpha: 0.18);

    return Container(height: 44, color: baseColor);
  }
}

class _BodyCell extends StatelessWidget {
  const _BodyCell({
    required this.width,
    required this.value,
    this.isLast = false,
  });

  final double width;
  final String value;
  final bool isLast;

  @override
  Widget build(BuildContext context) {
    return Padding(
      padding: EdgeInsets.only(right: isLast ? 0 : AppSpacing.md),
      child: SizedBox(
        width: width,
        child: Text(value, overflow: TextOverflow.ellipsis),
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
    this.hasClientLoadError = false,
  });

  final List<TravelerModel> travelers;
  final List<ClientModel> clients;
  final List<LeadModel> leads;
  final bool hasClientLoadError;
}

class CreateTravelerPanel extends StatefulWidget {
  const CreateTravelerPanel({
    required this.clients,
    required this.leads,
    required this.hasClientLoadError,
    required this.travelerRepository,
    super.key,
  });

  final List<ClientModel> clients;
  final List<LeadModel> leads;
  final bool hasClientLoadError;
  final TravelerRepository travelerRepository;

  static Future<bool?> show(
    BuildContext context, {
    required List<ClientModel> clients,
    required List<LeadModel> leads,
    required bool hasClientLoadError,
    required TravelerRepository travelerRepository,
  }) {
    return showDialog<bool>(
      context: context,
      builder:
          (context) => Dialog(
            insetPadding: const EdgeInsets.symmetric(
              horizontal: AppSpacing.lg,
              vertical: AppSpacing.sm,
            ),
            child: Padding(
              padding: EdgeInsets.only(
                bottom: MediaQuery.of(context).viewInsets.bottom,
              ),
              child: ConstrainedBox(
                constraints: BoxConstraints(
                  maxWidth: 720,
                  maxHeight: math.min(
                    MediaQuery.sizeOf(context).height * 0.74,
                    640,
                  ),
                ),
                child: CreateTravelerPanel(
                  clients: clients,
                  leads: leads,
                  hasClientLoadError: hasClientLoadError,
                  travelerRepository: travelerRepository,
                ),
              ),
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

  bool get _hasClients => widget.clients.isNotEmpty;
  bool get _canCreateTraveler =>
      _hasClients && !widget.hasClientLoadError && !_isSaving;

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
    if (!_hasClients || widget.hasClientLoadError) {
      return;
    }

    final form = _formKey.currentState;
    if (form == null || !form.validate()) {
      return;
    }

    setState(() => _isSaving = true);

    final fullName = _fullNameController.text.trim();
    final age = int.tryParse(_ageController.text.trim());
    final phone = _optional(_phoneController.text);
    final email = _optional(_emailController.text);
    final notes = _optional(_notesController.text);

    try {
      await widget.travelerRepository.createTraveler(
        TravelerModel(
          id: '',
          travelerCode: '',
          clientId: _clientId!,
          leadId: _leadId,
          fullName: fullName,
          travelerType: _travelerType,
          gender: _gender,
          age: age,
          phone: phone,
          email: email,
          notes: notes,
          createdAt: DateTime.fromMillisecondsSinceEpoch(0),
          updatedAt: DateTime.fromMillisecondsSinceEpoch(0),
          isActive: true,
        ),
      );

      if (!mounted) return;
      Navigator.of(context).pop(true);
    } catch (_) {
      if (!mounted) return;
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
    final theme = Theme.of(context);
    final labelStyle = theme.textTheme.bodySmall?.copyWith(
      fontWeight: FontWeight.w600,
      color: theme.colorScheme.onSurfaceVariant,
    );

    return SafeArea(
      child: Theme(
        data: theme.copyWith(
          inputDecorationTheme: theme.inputDecorationTheme.copyWith(
            labelStyle: labelStyle,
            floatingLabelStyle: labelStyle,
          ),
        ),
        child: Form(
          key: _formKey,
          child: Column(
            crossAxisAlignment: CrossAxisAlignment.stretch,
            children: [
              Expanded(
                child: SingleChildScrollView(
                  padding: const EdgeInsets.fromLTRB(20, 6, 20, AppSpacing.sm),
                  child: Column(
                    crossAxisAlignment: CrossAxisAlignment.stretch,
                    children: [
                Text(
                  'New Traveler',
                  style: theme.textTheme.titleLarge?.copyWith(
                    fontWeight: FontWeight.w700,
                  ),
                ),
                const SizedBox(height: AppSpacing.sm),
                const _PanelSectionLabel(label: 'Client & Booking', isFirst: true),
                DropdownButtonFormField<String?>(
                  value: _clientId,
                  isExpanded: true,
                  decoration: const InputDecoration(labelText: 'Client'),
                  items: widget.clients
                      .map(
                        (client) => DropdownMenuItem<String?>(
                          value: client.id,
                          child: Text(_clientLabel(client)),
                        ),
                      )
                      .toList(growable: false),
                  validator:
                      (value) =>
                          (value == null || value.isEmpty)
                              ? 'Client is required'
                              : null,
                  onChanged:
                      !_canCreateTraveler
                          ? null
                          : (value) {
                            setState(() {
                              _clientId = value;
                              if (_leadId != null &&
                                  !_leadOptions.any(
                                    (lead) => lead.id == _leadId,
                                  )) {
                                _leadId = null;
                              }
                            });
                          },
                ),
                if (widget.hasClientLoadError) ...[
                  const SizedBox(height: AppSpacing.xs),
                  Text(
                    'Unable to load clients. Please try again.',
                    style: theme.textTheme.bodySmall?.copyWith(
                      color: theme.colorScheme.error,
                    ),
                  ),
                ] else if (!_hasClients) ...[
                  const SizedBox(height: AppSpacing.xs),
                  Text(
                    'No clients available...',
                    style: theme.textTheme.bodySmall?.copyWith(
                      color: theme.colorScheme.onSurfaceVariant,
                    ),
                  ),
                ],
                const SizedBox(height: AppSpacing.md),
                DropdownButtonFormField<String?>(
                  value: _leadId,
                  isExpanded: true,
                  decoration: const InputDecoration(
                    labelText: 'Linked Booking / Lead',
                  ),
                  items: [
                    const DropdownMenuItem<String?>(
                      value: null,
                      child: Text('None'),
                    ),
                    ..._leadOptions.map(
                      (lead) => DropdownMenuItem<String?>(
                        value: lead.id,
                        child: Text(lead.leadCode),
                      ),
                    ),
                  ],
                  onChanged:
                      !_canCreateTraveler
                          ? null
                          : (value) => setState(() => _leadId = value),
                ),
                const _PanelSectionLabel(label: 'Traveler Information'),
                TextFormField(
                  controller: _fullNameController,
                  enabled: _canCreateTraveler,
                  decoration: const InputDecoration(labelText: 'Full Name'),
                  validator:
                      (value) =>
                          (value == null || value.trim().isEmpty)
                              ? 'Full name is required'
                              : null,
                ),
                const SizedBox(height: AppSpacing.md),
                DropdownButtonFormField<String>(
                  value: _travelerType,
                  decoration: const InputDecoration(labelText: 'Traveler Type'),
                  items: const [
                    DropdownMenuItem(value: 'Adult', child: Text('Adult')),
                    DropdownMenuItem(value: 'Child', child: Text('Child')),
                    DropdownMenuItem(value: 'Infant', child: Text('Infant')),
                  ],
                  validator:
                      (value) =>
                          (value == null || value.isEmpty)
                              ? 'Traveler type is required'
                              : null,
                  onChanged:
                      !_canCreateTraveler
                          ? null
                          : (value) =>
                              setState(() => _travelerType = value ?? 'Adult'),
                ),
                const SizedBox(height: AppSpacing.md),
                DropdownButtonFormField<String?>(
                  value: _gender,
                  decoration: const InputDecoration(labelText: 'Gender'),
                  items: const [
                    DropdownMenuItem(value: null, child: Text('Not provided')),
                    DropdownMenuItem(value: 'Male', child: Text('Male')),
                    DropdownMenuItem(value: 'Female', child: Text('Female')),
                    DropdownMenuItem(value: 'Other', child: Text('Other')),
                  ],
                  onChanged:
                      !_canCreateTraveler
                          ? null
                          : (value) => setState(() => _gender = value),
                ),
                const SizedBox(height: AppSpacing.md),
                TextFormField(
                  controller: _ageController,
                  enabled: _canCreateTraveler,
                  keyboardType: TextInputType.number,
                  decoration: const InputDecoration(labelText: 'Age'),
                  validator: (value) {
                    final normalized = value?.trim() ?? '';
                    if (normalized.isEmpty) return null;
                    final parsed = int.tryParse(normalized);
                    if (parsed == null || parsed < 0) {
                      return 'Enter a valid age';
                    }
                    return null;
                  },
                ),
                const _PanelSectionLabel(label: 'Contact Information'),
                TextFormField(
                  controller: _phoneController,
                  enabled: _canCreateTraveler,
                  decoration: const InputDecoration(labelText: 'Phone'),
                ),
                const SizedBox(height: AppSpacing.md),
                TextFormField(
                  controller: _emailController,
                  enabled: _canCreateTraveler,
                  decoration: const InputDecoration(labelText: 'Email'),
                ),
                const _PanelSectionLabel(label: 'Notes'),
                TextFormField(
                  controller: _notesController,
                  enabled: _canCreateTraveler,
                  minLines: 2,
                  maxLines: 4,
                  decoration: const InputDecoration(labelText: 'Notes'),
                ),
                    ],
                  ),
                ),
              ),
              Container(
                padding: const EdgeInsets.fromLTRB(
                  20,
                  AppSpacing.xs,
                  20,
                  AppSpacing.sm,
                ),
                decoration: BoxDecoration(
                  color: theme.colorScheme.surface,
                  border: Border(
                    top: BorderSide(
                      color: theme.colorScheme.outlineVariant.withValues(
                        alpha: 0.55,
                      ),
                    ),
                  ),
                ),
                child: Align(
                  alignment: Alignment.centerRight,
                  child: FilledButton(
                    onPressed: _canCreateTraveler ? _createTraveler : null,
                    child:
                        _isSaving
                            ? const SizedBox(
                              width: 16,
                              height: 16,
                              child: CircularProgressIndicator(strokeWidth: 2),
                            )
                            : const Text('Save Traveler'),
                  ),
                ),
              ),
            ],
          ),
        ),
      ),
    );
  }
}

String _clientLabel(ClientModel client) {
  final primary = _clientPrimaryLabel(client);
  final phone = client.phone.trim();
  if (phone.isEmpty) {
    return primary;
  }
  return '$primary — $phone';
}

String _clientPrimaryLabel(ClientModel? client) {
  if (client == null) {
    return '—';
  }

  final name = client.name.trim();
  if (name.isNotEmpty) {
    return name;
  }

  final code = client.clientCode.trim();
  if (code.isNotEmpty) {
    return code;
  }

  return 'Unnamed';
}

class _PanelSectionLabel extends StatelessWidget {
  const _PanelSectionLabel({required this.label, this.isFirst = false});

  final String label;
  final bool isFirst;

  @override
  Widget build(BuildContext context) {
    return Padding(
      padding: EdgeInsets.only(
        top: isFirst ? 0 : AppSpacing.md,
        bottom: AppSpacing.xs,
      ),
      child: Text(
        label,
        style: Theme.of(
          context,
        ).textTheme.titleSmall?.copyWith(fontWeight: FontWeight.w700),
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
