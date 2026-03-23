import 'package:cloud_firestore/cloud_firestore.dart';
import 'package:flutter/material.dart';

import '../../../core/constants/app_enums.dart';
import '../../../core/theme/app_spacing.dart';
import '../../../core/utils/responsive_utils.dart';
import '../../../core/widgets/app_top_bar.dart';
import '../../../core/widgets/empty_state_view.dart';
import '../data/datasources/firestore_lead_remote_data_source.dart';
import '../data/repositories/lead_repository_impl.dart';
import '../domain/lead_stage_transition_rules.dart';
import '../domain/models/lead_model.dart';
import '../domain/models/lead_note_model.dart';
import 'widgets/section_container.dart';
import 'widgets/stage_change_dialog.dart';

class LeadDetailScreen extends StatefulWidget {
  const LeadDetailScreen({required this.leadId, super.key});

  final String leadId;

  @override
  State<LeadDetailScreen> createState() => _LeadDetailScreenState();
}

class _LeadDetailScreenState extends State<LeadDetailScreen> {
  late final LeadRepositoryImpl _leadRepository;
  late Future<LeadModel?> _leadFuture;
  late Future<List<LeadNoteModel>> _notesFuture;
  LeadStage? _selectedLeadStage;
  LeadStage? _previousStageBeforeHold;
  String? _stageTransitionError;
  bool _isSavingStageChange = false;

  @override
  void initState() {
    super.initState();
    _leadRepository = LeadRepositoryImpl(
      remoteDataSource: FirestoreLeadRemoteDataSource(
        firestore: FirebaseFirestore.instance,
      ),
    );
    _leadFuture = _leadRepository.getLeadById(widget.leadId);
    _notesFuture = _leadRepository.fetchLeadNotes(widget.leadId);
  }

  Future<void> _refreshLead() async {
    setState(() {
      _leadFuture = _leadRepository.getLeadById(widget.leadId);
    });

    final refreshedLead = await _leadFuture;
    if (!mounted || refreshedLead == null) {
      return;
    }

    setState(() {
      _selectedLeadStage = refreshedLead.leadStage;
      _previousStageBeforeHold = refreshedLead.leadStage == LeadStage.onHold
          ? null
          : refreshedLead.leadStage;
      _stageTransitionError = null;
    });
  }

  Future<void> _refreshNotes() async {
    setState(() {
      _notesFuture = _leadRepository.fetchLeadNotes(widget.leadId);
    });
    await _notesFuture;
  }

  Future<void> _showStageUpdateModal(LeadModel lead) async {
    final selectedStage = await showModalBottomSheet<LeadStage>(
      context: context,
      isScrollControlled: true,
      backgroundColor: Colors.transparent,
      builder: (sheetContext) => _StageSelectionSheet(
        currentStage: lead.leadStage,
        selectedStage: _selectedLeadStage ?? lead.leadStage,
        previousStageBeforeHold: _previousStageBeforeHold,
        transitionError: _stageTransitionError,
      ),
    );

    if (!mounted || selectedStage == null) {
      return;
    }

    final isAllowedTransition = LeadStageTransitionRules.isAllowedTransition(
      lead.leadStage,
      selectedStage,
      previousStageBeforeHold: _previousStageBeforeHold,
    );

    setState(() {
      _selectedLeadStage = selectedStage;
      _stageTransitionError = isAllowedTransition || selectedStage == lead.leadStage
          ? null
          : LeadStageTransitionRules.invalidTransitionMessage;

      if (selectedStage == LeadStage.onHold && lead.leadStage != LeadStage.onHold) {
        _previousStageBeforeHold = lead.leadStage;
      }
    });

    if (!isAllowedTransition || selectedStage == lead.leadStage) {
      return;
    }

    await _updateLeadStage(lead, stageOverride: selectedStage);
  }

  Future<void> _updateLeadStage(
    LeadModel lead, {
    LeadStage? stageOverride,
  }) async {
    if (_isSavingStageChange) {
      return;
    }

    final selectedStage = stageOverride ?? _selectedLeadStage ?? lead.leadStage;
    final isAllowedTransition = LeadStageTransitionRules.isAllowedTransition(
      lead.leadStage,
      selectedStage,
      previousStageBeforeHold: _previousStageBeforeHold,
    );
    if (selectedStage == lead.leadStage) {
      return;
    }

    if (!isAllowedTransition) {
      setState(() {
        _stageTransitionError = LeadStageTransitionRules.invalidTransitionMessage;
      });
      return;
    }

    final stageChangeInput = await showDialog<StageChangeInput>(
      context: context,
      builder: (dialogContext) => StageChangeDialog(
        stage: selectedStage,
        stageLabel: _leadStageLabel(selectedStage),
      ),
    );

    if (!mounted || stageChangeInput == null) {
      return;
    }

    setState(() {
      _isSavingStageChange = true;
    });

    try {
      final firestore = FirebaseFirestore.instance;
      final leadReference = firestore.collection('leads').doc(widget.leadId);
      final noteReference = leadReference.collection('notes').doc();
      final now = Timestamp.now();

      final batch = firestore.batch();
      batch.update(leadReference, <String, dynamic>{
        'leadStage': selectedStage.firestoreValue,
        'stageReason': stageChangeInput.reason,
        'updatedAt': now,
      });
      batch.set(noteReference, <String, dynamic>{
        'id': noteReference.id,
        'leadId': widget.leadId,
        'noteText': stageChangeInput.noteText,
        'noteType': 'stageChange',
        'relatedStage': selectedStage.firestoreValue,
        'reason': stageChangeInput.reason,
        'createdBy': null,
        'createdAt': now,
      });
      await batch.commit();

      if (!mounted) {
        return;
      }

      await Future.wait<void>([
        _refreshLead(),
        _refreshNotes(),
      ]);
    } finally {
      if (mounted) {
        setState(() {
          _isSavingStageChange = false;
        });
      }
    }
  }

  Future<void> _showAddNoteDialog() async {
    final noteText = await showDialog<String>(
      context: context,
      builder: (dialogContext) => const _AddNoteDialog(),
    );

    if (!mounted || noteText == null) {
      return;
    }

    await _leadRepository.addLeadNote(
      LeadNoteModel(
        id: '',
        leadId: widget.leadId,
        noteText: noteText,
        noteType: 'general',
        relatedStage: null,
        createdBy: null,
        createdAt: DateTime.now(),
      ),
    );

    if (!mounted) {
      return;
    }

    await _refreshNotes();
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      backgroundColor: Theme.of(context).colorScheme.surface,
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

                  _selectedLeadStage ??= lead.leadStage;
                  _previousStageBeforeHold ??= lead.leadStage == LeadStage.onHold
                      ? null
                      : lead.leadStage;

                  final horizontalPadding = ResponsiveUtils.horizontalPagePadding(context);
                  final contentMaxWidth = ResponsiveUtils.contentMaxWidth(context);

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
                              _LeadDealHeader(
                                lead: lead,
                                isSavingStageChange: _isSavingStageChange,
                                onUpdateStage: () => _showStageUpdateModal(lead),
                                onAddNote: _showAddNoteDialog,
                              ),
                              const SizedBox(height: AppSpacing.lg),
                              SectionContainer(
                                title: 'Timeline',
                                subtitle: 'Recent activity and stage movements',
                                child: FutureBuilder<List<LeadNoteModel>>(
                                  future: _notesFuture,
                                  builder: (context, notesSnapshot) {
                                    if (notesSnapshot.connectionState ==
                                            ConnectionState.waiting &&
                                        !notesSnapshot.hasData) {
                                      return const Center(
                                        child: Padding(
                                          padding: EdgeInsets.symmetric(
                                            vertical: AppSpacing.md,
                                          ),
                                          child: SizedBox(
                                            height: 20,
                                            width: 20,
                                            child: CircularProgressIndicator(
                                              strokeWidth: 2,
                                            ),
                                          ),
                                        ),
                                      );
                                    }

                                    if (notesSnapshot.hasError) {
                                      return const _SubtleEmptyState(
                                        message: 'Unable to load notes',
                                        icon: Icons.timeline_outlined,
                                      );
                                    }

                                    final notes = notesSnapshot.data ??
                                        const <LeadNoteModel>[];
                                    if (notes.isEmpty) {
                                      return const _SubtleEmptyState(
                                        message: 'No activity yet',
                                        icon: Icons.timeline_outlined,
                                      );
                                    }

                                    return Column(
                                      children: [
                                        for (var index = 0;
                                            index < notes.length;
                                            index++)
                                          _TimelineNoteItem(
                                            note: notes[index],
                                            isLast: index == notes.length - 1,
                                          ),
                                      ],
                                    );
                                  },
                                ),
                              ),
                              const SizedBox(height: AppSpacing.lg),
                              SectionContainer(
                                title: 'Overview',
                                subtitle: 'Key deal details at a glance',
                                child: _LeadOverviewGrid(lead: lead),
                              ),
                              const SizedBox(height: AppSpacing.lg),
                              const SectionContainer(
                                title: 'Tasks',
                                subtitle: 'Next follow-ups and owner actions',
                                child: _SubtleEmptyState(
                                  message: 'No tasks yet',
                                  icon: Icons.checklist_rtl_outlined,
                                  alignToStart: true,
                                ),
                              ),
                              const SizedBox(height: AppSpacing.lg),
                              const SectionContainer(
                                title: 'Quotations',
                                subtitle: 'Active and historical proposals',
                                child: _SubtleEmptyState(
                                  message: 'No quotations yet',
                                  icon: Icons.receipt_long_outlined,
                                  alignToStart: true,
                                ),
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

class _LeadDealHeader extends StatelessWidget {
  const _LeadDealHeader({
    required this.lead,
    required this.isSavingStageChange,
    required this.onUpdateStage,
    required this.onAddNote,
  });

  final LeadModel lead;
  final bool isSavingStageChange;
  final VoidCallback onUpdateStage;
  final VoidCallback onAddNote;

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
          _displayValue(lead.clientNameSnapshot),
          style: theme.textTheme.headlineMedium?.copyWith(
            fontSize: 30,
            fontWeight: FontWeight.w800,
            color: colorScheme.onSurface,
            height: 1.1,
          ),
        ),
        const SizedBox(height: AppSpacing.xs),
        Text(
          '${_displayValue(lead.destination)} • ${_travelDateRange(lead)}',
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
            _HeaderMetaChip(
              icon: Icons.group_outlined,
              label:
                  'Pax ${lead.adultCount}A · ${lead.childCount}C · ${lead.infantCount}I',
            ),
            _HeaderMetaChip(
              icon: Icons.luggage_outlined,
              label: _travelTypeLabel(lead.travelType),
            ),
            _HeaderMetaChip(
              icon: Icons.sell_outlined,
              label: 'Budget ${_budgetValue(lead.budget)}',
            ),
          ],
        ),
      ],
    );

    final rightColumn = ConstrainedBox(
      constraints:
          BoxConstraints(maxWidth: isDesktopLayout ? 340 : double.infinity),
      child: Column(
        mainAxisAlignment: MainAxisAlignment.center,
        crossAxisAlignment:
            isDesktopLayout ? CrossAxisAlignment.end : CrossAxisAlignment.start,
        children: [
          _StageBadge(stage: lead.leadStage),
          const SizedBox(height: AppSpacing.lg),
          Wrap(
            spacing: AppSpacing.sm,
            runSpacing: AppSpacing.sm,
            alignment:
                isDesktopLayout ? WrapAlignment.end : WrapAlignment.start,
            children: [
              FilledButton.icon(
                onPressed: isSavingStageChange ? null : onUpdateStage,
                style: FilledButton.styleFrom(
                  backgroundColor: colorScheme.primary,
                  foregroundColor: colorScheme.onPrimary,
                ),
                icon: const Icon(Icons.swap_horiz_rounded),
                label: Text(
                  isSavingStageChange ? 'Saving...' : 'Update Stage',
                ),
              ),
              OutlinedButton.icon(
                onPressed: onAddNote,
                style: OutlinedButton.styleFrom(
                  side: BorderSide(
                    color: colorScheme.outlineVariant.withValues(alpha: 0.9),
                  ),
                  foregroundColor: colorScheme.onSurfaceVariant,
                ),
                icon: const Icon(Icons.note_add_outlined),
                label: const Text('Add Note'),
              ),
            ],
          ),
        ],
      ),
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
              crossAxisAlignment: CrossAxisAlignment.center,
              children: [
                Expanded(child: leftColumn),
                const SizedBox(width: AppSpacing.lg),
                rightColumn,
              ],
            )
          : Column(
              crossAxisAlignment: CrossAxisAlignment.start,
              children: [
                leftColumn,
                const SizedBox(height: AppSpacing.lg),
                rightColumn,
              ],
            ),
    );
  }
}

class _StageSelectionSheet extends StatelessWidget {
  const _StageSelectionSheet({
    required this.currentStage,
    required this.selectedStage,
    required this.previousStageBeforeHold,
    required this.transitionError,
  });

  final LeadStage currentStage;
  final LeadStage selectedStage;
  final LeadStage? previousStageBeforeHold;
  final String? transitionError;

  @override
  Widget build(BuildContext context) {
    final theme = Theme.of(context);
    final colorScheme = theme.colorScheme;
    final allowedStages = LeadStageTransitionRules.allowedTransitions(
      currentStage,
      previousStageBeforeHold: previousStageBeforeHold,
    );

    return SafeArea(
      child: Padding(
        padding: const EdgeInsets.fromLTRB(
          AppSpacing.lg,
          AppSpacing.lg,
          AppSpacing.lg,
          AppSpacing.lg,
        ),
        child: Container(
          decoration: BoxDecoration(
            color: colorScheme.surface,
            borderRadius: BorderRadius.circular(28),
            boxShadow: [
              BoxShadow(
                color: colorScheme.shadow.withValues(alpha: 0.14),
                blurRadius: 32,
                offset: const Offset(0, 20),
              ),
            ],
          ),
          child: Padding(
            padding: const EdgeInsets.all(AppSpacing.xl),
            child: Column(
              mainAxisSize: MainAxisSize.min,
              crossAxisAlignment: CrossAxisAlignment.start,
              children: [
                Text(
                  'Update Stage',
                  style: theme.textTheme.headlineSmall?.copyWith(
                    fontWeight: FontWeight.w700,
                  ),
                ),
                const SizedBox(height: AppSpacing.xs),
                Text(
                  'Choose the next stage for this deal. You can only move to valid stages.',
                  style: theme.textTheme.bodyMedium?.copyWith(
                    color: colorScheme.onSurfaceVariant,
                  ),
                ),
                const SizedBox(height: AppSpacing.lg),
                ConstrainedBox(
                  constraints: const BoxConstraints(maxHeight: 360),
                  child: SingleChildScrollView(
                    child: Column(
                      children: LeadStage.values.map((stage) {
                        final isAllowed =
                            stage == currentStage || allowedStages.contains(stage);
                        final isSelected = stage == selectedStage;
                        return Padding(
                          padding: const EdgeInsets.only(bottom: AppSpacing.sm),
                          child: _StageOptionTile(
                            stage: stage,
                            isCurrent: stage == currentStage,
                            isSelected: isSelected,
                            isEnabled: isAllowed,
                            onTap: isAllowed
                                ? () => Navigator.of(context).pop(stage)
                                : null,
                          ),
                        );
                      }).toList(growable: false),
                    ),
                  ),
                ),
                if (transitionError != null) ...[
                  const SizedBox(height: AppSpacing.sm),
                  Text(
                    transitionError!,
                    style: theme.textTheme.bodySmall?.copyWith(
                      color: colorScheme.error,
                    ),
                  ),
                ],
                const SizedBox(height: AppSpacing.sm),
                Align(
                  alignment: Alignment.centerRight,
                  child: TextButton(
                    onPressed: () => Navigator.of(context).pop(),
                    child: const Text('Cancel'),
                  ),
                ),
              ],
            ),
          ),
        ),
      ),
    );
  }
}

class _StageOptionTile extends StatelessWidget {
  const _StageOptionTile({
    required this.stage,
    required this.isCurrent,
    required this.isSelected,
    required this.isEnabled,
    this.onTap,
  });

  final LeadStage stage;
  final bool isCurrent;
  final bool isSelected;
  final bool isEnabled;
  final VoidCallback? onTap;

  @override
  Widget build(BuildContext context) {
    final theme = Theme.of(context);
    final colorScheme = theme.colorScheme;

    return Material(
      color: Colors.transparent,
      child: InkWell(
        onTap: onTap,
        borderRadius: BorderRadius.circular(20),
        child: Ink(
          decoration: BoxDecoration(
            color: isSelected
                ? colorScheme.primaryContainer.withValues(alpha: 0.55)
                : colorScheme.surfaceContainerLowest,
            borderRadius: BorderRadius.circular(20),
            border: Border.all(
              color: isSelected
                  ? colorScheme.primary.withValues(alpha: 0.35)
                  : colorScheme.outlineVariant.withValues(alpha: 0.35),
            ),
          ),
          padding: const EdgeInsets.all(AppSpacing.lg),
          child: Row(
            children: [
              Expanded(
                child: Column(
                  crossAxisAlignment: CrossAxisAlignment.start,
                  children: [
                    Text(
                      _leadStageLabel(stage),
                      style: theme.textTheme.titleMedium?.copyWith(
                        fontWeight: FontWeight.w700,
                        color: isEnabled
                            ? colorScheme.onSurface
                            : colorScheme.onSurfaceVariant,
                      ),
                    ),
                    const SizedBox(height: AppSpacing.xs),
                    Text(
                      isCurrent
                          ? 'Current stage'
                          : isEnabled
                              ? 'Select to log a stage change note'
                              : 'Not available from the current stage',
                      style: theme.textTheme.bodySmall?.copyWith(
                        color: colorScheme.onSurfaceVariant,
                      ),
                    ),
                  ],
                ),
              ),
              if (isCurrent)
                Container(
                  padding: const EdgeInsets.symmetric(
                    horizontal: AppSpacing.md,
                    vertical: AppSpacing.sm,
                  ),
                  decoration: BoxDecoration(
                    color: colorScheme.secondaryContainer,
                    borderRadius: BorderRadius.circular(999),
                  ),
                  child: Text(
                    'Current',
                    style: theme.textTheme.labelLarge?.copyWith(
                      color: colorScheme.onSecondaryContainer,
                      fontWeight: FontWeight.w700,
                    ),
                  ),
                )
              else
                Icon(
                  isEnabled ? Icons.arrow_forward_rounded : Icons.lock_outline_rounded,
                  color: isEnabled
                      ? colorScheme.primary
                      : colorScheme.onSurfaceVariant.withValues(alpha: 0.7),
                ),
            ],
          ),
        ),
      ),
    );
  }
}

class _HeaderMetaChip extends StatelessWidget {
  const _HeaderMetaChip({required this.icon, required this.label});

  final IconData icon;
  final String label;

  @override
  Widget build(BuildContext context) {
    final theme = Theme.of(context);
    final colorScheme = theme.colorScheme;

    return Container(
      padding: const EdgeInsets.symmetric(
        horizontal: AppSpacing.md,
        vertical: 6,
      ),
      decoration: BoxDecoration(
        color: colorScheme.surfaceContainerHigh.withValues(alpha: 0.4),
        borderRadius: BorderRadius.circular(999),
      ),
      child: Row(
        mainAxisSize: MainAxisSize.min,
        children: [
          Icon(icon, size: 16, color: colorScheme.onSurfaceVariant),
          const SizedBox(width: AppSpacing.sm),
          Text(
            label,
            style: theme.textTheme.bodySmall?.copyWith(
              color: colorScheme.onSurfaceVariant.withValues(alpha: 0.86),
              fontWeight: FontWeight.w500,
            ),
          ),
        ],
      ),
    );
  }
}

class _StageBadge extends StatelessWidget {
  const _StageBadge({required this.stage});

  final LeadStage stage;

  @override
  Widget build(BuildContext context) {
    final theme = Theme.of(context);
    final palette = _stagePalette(Theme.of(context).colorScheme, stage);

    return Container(
      padding: const EdgeInsets.symmetric(
        horizontal: AppSpacing.md,
        vertical: 6,
      ),
      decoration: BoxDecoration(
        color: palette.background.withValues(alpha: 0.72),
        borderRadius: BorderRadius.circular(999),
      ),
      child: Text(
        _leadStageLabel(stage),
        style: theme.textTheme.labelMedium?.copyWith(
          color: palette.foreground,
          fontWeight: FontWeight.w700,
          letterSpacing: 0.2,
        ),
      ),
    );
  }
}

class _LeadOverviewGrid extends StatelessWidget {
  const _LeadOverviewGrid({required this.lead});

  final LeadModel lead;

  @override
  Widget build(BuildContext context) {
    final overviewRows = <List<_OverviewItemData>>[
      [
        _OverviewItemData('Client Name', _displayValue(lead.clientNameSnapshot)),
        const _OverviewItemData('Phone', '—'),
      ],
      [
        _OverviewItemData('Destination', _displayValue(lead.destination)),
        _OverviewItemData('Travel Dates', _travelDateRange(lead)),
      ],
      [
        _OverviewItemData('Travel Type', _travelTypeLabel(lead.travelType)),
        _OverviewItemData('Budget', _budgetValue(lead.budget)),
      ],
      [
        _OverviewItemData('Budget Type', _displayValue(lead.budgetType)),
        _OverviewItemData('Initial Notes', _displayValue(lead.notes)),
      ],
    ];

    final isDesktopLayout =
        ResponsiveUtils.isDesktop(context) || ResponsiveUtils.isWide(context);

    return Column(
      children: [
        for (var index = 0; index < overviewRows.length; index++) ...[
          if (isDesktopLayout)
            Row(
              crossAxisAlignment: CrossAxisAlignment.start,
              children: [
                for (var columnIndex = 0;
                    columnIndex < overviewRows[index].length;
                    columnIndex++) ...[
                  Expanded(child: _OverviewCell(item: overviewRows[index][columnIndex])),
                  if (columnIndex < overviewRows[index].length - 1)
                    const SizedBox(width: AppSpacing.xl),
                ],
              ],
            )
          else
            Column(
              children: [
                for (var columnIndex = 0;
                    columnIndex < overviewRows[index].length;
                    columnIndex++) ...[
                  _OverviewCell(item: overviewRows[index][columnIndex]),
                  if (columnIndex < overviewRows[index].length - 1)
                    const SizedBox(height: AppSpacing.md),
                ],
              ],
            ),
          if (index < overviewRows.length - 1) ...[
            const SizedBox(height: AppSpacing.md),
            Divider(
              height: 1,
              thickness: 1,
              color: Theme.of(context)
                  .colorScheme
                  .outlineVariant
                  .withValues(alpha: 0.28),
            ),
            const SizedBox(height: AppSpacing.md),
          ],
        ],
      ],
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

    return Padding(
      padding: const EdgeInsets.symmetric(vertical: 2),
      child: Column(
        crossAxisAlignment: CrossAxisAlignment.start,
        children: [
          Text(
            item.label,
            style: theme.textTheme.labelSmall?.copyWith(
              fontSize: 11,
              color: colorScheme.onSurfaceVariant.withValues(alpha: 0.78),
              fontWeight: FontWeight.w500,
              letterSpacing: 0.15,
              height: 1.15,
            ),
          ),
          const SizedBox(height: 4),
          Text(
            item.value,
            maxLines: item.label == 'Initial Notes' ? 4 : 2,
            overflow: TextOverflow.ellipsis,
            style: theme.textTheme.bodyLarge?.copyWith(
              color: colorScheme.onSurface,
              fontWeight: FontWeight.w600,
              height: 1.25,
            ),
          ),
        ],
      ),
    );
  }
}

class _TimelineNoteItem extends StatelessWidget {
  const _TimelineNoteItem({required this.note, required this.isLast});

  final LeadNoteModel note;
  final bool isLast;

  bool get _isStageChange => note.noteType == 'stageChange';

  @override
  Widget build(BuildContext context) {
    final theme = Theme.of(context);
    final colorScheme = theme.colorScheme;
    final stage = _isStageChange && note.relatedStage != null
        ? LeadStageX.fromString(note.relatedStage!)
        : null;
    final palette = stage == null
        ? _StagePalette(
            background: colorScheme.primaryContainer.withValues(alpha: 0.28),
            foreground: colorScheme.primary,
          )
        : _stagePalette(colorScheme, stage);

    return Padding(
      padding: EdgeInsets.only(bottom: isLast ? 0 : AppSpacing.xl),
      child: IntrinsicHeight(
        child: Row(
          crossAxisAlignment: CrossAxisAlignment.start,
          children: [
            Padding(
              padding: const EdgeInsets.only(top: 2),
              child: Column(
                children: [
                  Container(
                    width: 14,
                    height: 14,
                    decoration: BoxDecoration(
                      color: palette.background.withValues(alpha: 0.2),
                      shape: BoxShape.circle,
                      border: Border.all(
                        color: palette.foreground.withValues(alpha: 0.45),
                        width: 1.5,
                      ),
                    ),
                    child: Center(
                      child: Container(
                        width: 5,
                        height: 5,
                        decoration: BoxDecoration(
                          color: palette.foreground,
                          shape: BoxShape.circle,
                        ),
                      ),
                    ),
                  ),
                  if (!isLast)
                    Expanded(
                      child: Container(
                        width: 2,
                        margin: const EdgeInsets.symmetric(vertical: AppSpacing.sm),
                        decoration: BoxDecoration(
                          color: colorScheme.outlineVariant.withValues(alpha: 0.3),
                          borderRadius: BorderRadius.circular(999),
                        ),
                      ),
                    ),
                ],
              ),
            ),
            const SizedBox(width: AppSpacing.md),
            Expanded(
              child: Container(
                padding: const EdgeInsets.all(AppSpacing.lg),
                decoration: BoxDecoration(
                  color: _isStageChange
                      ? palette.background.withValues(alpha: 0.12)
                      : colorScheme.surfaceContainerLowest,
                  borderRadius: BorderRadius.circular(18),
                  border: Border.all(
                    color: _isStageChange
                        ? palette.foreground.withValues(alpha: 0.08)
                        : colorScheme.outlineVariant.withValues(alpha: 0.18),
                  ),
                ),
                child: Column(
                  crossAxisAlignment: CrossAxisAlignment.start,
                  children: [
                    Wrap(
                      spacing: AppSpacing.sm,
                      runSpacing: AppSpacing.sm,
                      crossAxisAlignment: WrapCrossAlignment.center,
                      children: [
                        Text(
                          _isStageChange
                              ? 'Stage: ${_leadStageLabel(stage!)}'
                              : _labelizeNoteType(note.noteType),
                          style: theme.textTheme.titleMedium?.copyWith(
                            color: colorScheme.onSurface,
                            fontWeight: FontWeight.w700,
                            height: 1.2,
                          ),
                        ),
                        Text(
                          _formatTimelineDateTime(context, note.createdAt),
                          style: theme.textTheme.bodySmall?.copyWith(
                            color: colorScheme.onSurfaceVariant.withValues(alpha: 0.84),
                          ),
                        ),
                      ],
                    ),
                    if (_isStageChange &&
                        note.reason != null &&
                        note.reason!.trim().isNotEmpty) ...[
                      const SizedBox(height: AppSpacing.xs),
                      Text(
                        note.reason!.trim(),
                        style: theme.textTheme.bodySmall?.copyWith(
                          color: palette.foreground.withValues(alpha: 0.92),
                          fontWeight: FontWeight.w600,
                        ),
                      ),
                    ],
                    const SizedBox(height: AppSpacing.sm),
                    Text(
                      note.noteText.trim(),
                      style: theme.textTheme.bodyMedium?.copyWith(
                        color: colorScheme.onSurface.withValues(alpha: 0.92),
                        height: 1.5,
                      ),
                    ),
                  ],
                ),
              ),
            ),
          ],
        ),
      ),
    );
  }
}

class _SubtleEmptyState extends StatelessWidget {
  const _SubtleEmptyState({
    required this.message,
    required this.icon,
    this.alignToStart = false,
  });

  final String message;
  final IconData icon;
  final bool alignToStart;

  @override
  Widget build(BuildContext context) {
    final theme = Theme.of(context);
    final colorScheme = theme.colorScheme;

    final content = Column(
      mainAxisSize: MainAxisSize.min,
      crossAxisAlignment:
          alignToStart ? CrossAxisAlignment.start : CrossAxisAlignment.center,
      children: [
        Icon(
          icon,
          size: 18,
          color: colorScheme.onSurfaceVariant.withValues(alpha: 0.48),
        ),
        const SizedBox(height: 10),
        Text(
          message,
          textAlign: alignToStart ? TextAlign.left : TextAlign.center,
          style: theme.textTheme.bodyMedium?.copyWith(
            color: colorScheme.onSurfaceVariant.withValues(alpha: 0.8),
            height: 1.3,
          ),
        ),
      ],
    );

    return Padding(
      padding: EdgeInsets.only(
        top: alignToStart ? AppSpacing.xs : AppSpacing.md,
        bottom: AppSpacing.sm,
      ),
      child: alignToStart ? content : Center(child: content),
    );
  }
}

class _AddNoteDialog extends StatefulWidget {
  const _AddNoteDialog();

  @override
  State<_AddNoteDialog> createState() => _AddNoteDialogState();
}

class _AddNoteDialogState extends State<_AddNoteDialog> {
  final TextEditingController _controller = TextEditingController();

  @override
  void dispose() {
    _controller.dispose();
    super.dispose();
  }

  void _save() {
    final value = _controller.text.trim();
    if (value.isEmpty) {
      return;
    }

    Navigator.of(context).pop(value);
  }

  @override
  Widget build(BuildContext context) {
    return AlertDialog(
      title: const Text('Add Note'),
      content: SizedBox(
        width: 420,
        child: TextField(
          controller: _controller,
          autofocus: true,
          minLines: 4,
          maxLines: 8,
          textCapitalization: TextCapitalization.sentences,
          decoration: const InputDecoration(
            hintText: 'Write a quick note',
            border: OutlineInputBorder(),
          ),
          onSubmitted: (_) => _save(),
        ),
      ),
      actions: [
        TextButton(
          onPressed: () => Navigator.of(context).pop(),
          child: const Text('Cancel'),
        ),
        FilledButton(
          onPressed: _save,
          child: const Text('Save Note'),
        ),
      ],
    );
  }
}

class _StagePalette {
  const _StagePalette({required this.background, required this.foreground});

  final Color background;
  final Color foreground;
}

_StagePalette _stagePalette(ColorScheme colorScheme, LeadStage stage) {
  switch (stage) {
    case LeadStage.newLead:
      return _StagePalette(
        background: colorScheme.secondaryContainer,
        foreground: colorScheme.onSecondaryContainer,
      );
    case LeadStage.contacted:
      return _StagePalette(
        background: colorScheme.primaryContainer,
        foreground: colorScheme.onPrimaryContainer,
      );
    case LeadStage.quotationSent:
      return _StagePalette(
        background: Colors.indigo.withValues(alpha: 0.16),
        foreground: Colors.indigo.shade700,
      );
    case LeadStage.negotiation:
      return _StagePalette(
        background: Colors.deepPurple.withValues(alpha: 0.14),
        foreground: Colors.deepPurple.shade700,
      );
    case LeadStage.onHold:
      return _StagePalette(
        background: Colors.amber.withValues(alpha: 0.20),
        foreground: Colors.amber.shade900,
      );
    case LeadStage.confirmed:
      return _StagePalette(
        background: Colors.green.withValues(alpha: 0.18),
        foreground: Colors.green.shade800,
      );
    case LeadStage.lost:
      return _StagePalette(
        background: colorScheme.errorContainer,
        foreground: colorScheme.onErrorContainer,
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

  return '₹${value.toString()}';
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

String _formatTimelineDateTime(BuildContext context, DateTime value) {
  final localizations = MaterialLocalizations.of(context);
  final dateText = localizations.formatMediumDate(value);
  final timeText = localizations.formatTimeOfDay(
    TimeOfDay.fromDateTime(value),
    alwaysUse24HourFormat: false,
  );

  return '$dateText • $timeText';
}

String _labelizeNoteType(String noteType) {
  final trimmedValue = noteType.trim();
  if (trimmedValue.isEmpty) {
    return 'General';
  }

  final words = trimmedValue
      .replaceAllMapped(
        RegExp(r'([a-z])([A-Z])'),
        (match) => '${match.group(1)} ${match.group(2)}',
      )
      .split(RegExp(r'[_\s]+'));
  return words
      .where((word) => word.isNotEmpty)
      .map(
        (word) => '${word[0].toUpperCase()}${word.substring(1).toLowerCase()}',
      )
      .join(' ');
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
