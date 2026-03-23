import 'package:cloud_firestore/cloud_firestore.dart';
import 'package:flutter/material.dart';

import '../../../../core/constants/app_enums.dart';
import '../../../../core/theme/app_spacing.dart';
import '../../domain/lead_stage_transition_rules.dart';
import '../../domain/models/lead_model.dart';
import 'stage_change_dialog.dart';

class LeadDetailPanel extends StatefulWidget {
  const LeadDetailPanel({
    required this.lead,
    super.key,
    this.onArchived,
    this.onStageUpdated,
  });

  final LeadModel lead;
  final VoidCallback? onArchived;
  final ValueChanged<String>? onStageUpdated;

  static Future<void> show(
    BuildContext context, {
    required LeadModel lead,
    VoidCallback? onArchived,
    ValueChanged<String>? onStageUpdated,
  }) {
    return showGeneralDialog<void>(
      context: context,
      barrierLabel: 'Lead Details',
      barrierDismissible: true,
      barrierColor: Colors.black54,
      transitionDuration: const Duration(milliseconds: 240),
      pageBuilder: (context, animation, secondaryAnimation) {
        return _LeadDetailPanelDialog(
          lead: lead,
          onArchived: onArchived,
          onStageUpdated: onStageUpdated,
        );
      },
      transitionBuilder: (context, animation, secondaryAnimation, child) {
        final curvedAnimation = CurvedAnimation(
          parent: animation,
          curve: Curves.easeOutCubic,
          reverseCurve: Curves.easeInCubic,
        );

        return FadeTransition(
          opacity: curvedAnimation,
          child: child,
        );
      },
    );
  }

  @override
  State<LeadDetailPanel> createState() => _LeadDetailPanelState();
}

class _LeadDetailPanelDialog extends StatelessWidget {
  const _LeadDetailPanelDialog({
    required this.lead,
    this.onArchived,
    this.onStageUpdated,
  });

  final LeadModel lead;
  final VoidCallback? onArchived;
  final ValueChanged<String>? onStageUpdated;

  @override
  Widget build(BuildContext context) {
    final mediaQuery = MediaQuery.of(context);
    final panelWidth = mediaQuery.size.width >= 1200
        ? 480.0
        : mediaQuery.size.width >= 768
            ? 440.0
            : mediaQuery.size.width;

    return Material(
      color: Colors.transparent,
      child: SafeArea(
        child: Align(
          alignment: Alignment.centerRight,
          child: TweenAnimationBuilder<Offset>(
            tween: Tween<Offset>(
              begin: const Offset(1, 0),
              end: Offset.zero,
            ),
            duration: const Duration(milliseconds: 240),
            curve: Curves.easeOutCubic,
            builder: (context, offset, child) {
              return FractionalTranslation(
                translation: offset,
                child: child,
              );
            },
            child: ConstrainedBox(
              constraints: BoxConstraints.tightFor(
                width: panelWidth,
                height: mediaQuery.size.height,
              ),
              child: LeadDetailPanel(
                lead: lead,
                onArchived: onArchived,
                onStageUpdated: onStageUpdated,
              ),
            ),
          ),
        ),
      ),
    );
  }
}

class _LeadDetailPanelState extends State<LeadDetailPanel> {
  static const List<LeadStage> _stageOptions = LeadStage.values;

  bool _isArchiving = false;
  bool _isUpdatingStage = false;
  _PanelStatus? _status;
  late LeadStage _selectedLeadStage;
  LeadStage? _previousStageBeforeHold;

  @override
  void initState() {
    super.initState();
    _syncStageSelection();
  }

  @override
  void didUpdateWidget(covariant LeadDetailPanel oldWidget) {
    super.didUpdateWidget(oldWidget);

    if (oldWidget.lead.id != widget.lead.id ||
        oldWidget.lead.leadStage != widget.lead.leadStage) {
      _syncStageSelection();
    }
  }

  void _syncStageSelection() {
    _selectedLeadStage = widget.lead.leadStage;
    _previousStageBeforeHold = widget.lead.leadStage == LeadStage.onHold
        ? null
        : widget.lead.leadStage;
  }

  Set<LeadStage> get _allowedStageOptions =>
      LeadStageTransitionRules.allowedTransitions(
        widget.lead.leadStage,
        previousStageBeforeHold: _previousStageBeforeHold,
      );

  void _handleStageChanged(LeadStage? value) {
    if (value == null) {
      return;
    }

    final currentStage = widget.lead.leadStage;
    final isAllowed = LeadStageTransitionRules.isAllowedTransition(
      currentStage,
      value,
      previousStageBeforeHold: _previousStageBeforeHold,
    );

    setState(() {
      _selectedLeadStage = value;
      _status = isAllowed || value == currentStage
          ? null
          : const _PanelStatus.error(
              LeadStageTransitionRules.invalidTransitionMessage,
            );

      if (value == LeadStage.onHold && currentStage != LeadStage.onHold) {
        _previousStageBeforeHold = currentStage;
      }
    });
  }

  Future<void> _updateLeadStage() async {
    if (_isUpdatingStage || _isArchiving) {
      return;
    }

    if (_selectedLeadStage == widget.lead.leadStage) {
      setState(() {
        _status = const _PanelStatus.message('No changes to update');
      });
      return;
    }

    final isAllowedTransition = LeadStageTransitionRules.isAllowedTransition(
      widget.lead.leadStage,
      _selectedLeadStage,
      previousStageBeforeHold: _previousStageBeforeHold,
    );

    if (!isAllowedTransition) {
      setState(() {
        _status = const _PanelStatus.error(
          LeadStageTransitionRules.invalidTransitionMessage,
        );
      });
      return;
    }

    final stageChangeInput = await showDialog<StageChangeInput>(
      context: context,
      builder: (dialogContext) => StageChangeDialog(
        stage: _selectedLeadStage,
        stageLabel: _leadStageLabel(_selectedLeadStage),
      ),
    );

    if (!mounted || stageChangeInput == null) {
      return;
    }

    setState(() {
      _isUpdatingStage = true;
      _status = null;
    });

    try {
      final firestore = FirebaseFirestore.instance;
      final leadReference = firestore.collection('leads').doc(widget.lead.id);
      final noteReference = leadReference.collection('notes').doc();
      final now = Timestamp.now();

      final batch = firestore.batch();
      batch.update(leadReference, {
        'leadStage': _selectedLeadStage.firestoreValue,
        'stageReason': stageChangeInput.reason,
        'updatedAt': now,
      });
      batch.set(noteReference, {
        'id': noteReference.id,
        'leadId': widget.lead.id,
        'noteText': stageChangeInput.noteText,
        'noteType': 'stageChange',
        'relatedStage': _selectedLeadStage.firestoreValue,
        'reason': stageChangeInput.reason,
        'createdBy': null,
        'createdAt': now,
      });
      await batch.commit();

      if (!mounted) {
        return;
      }

      widget.onStageUpdated?.call('Lead stage updated successfully');
      Navigator.of(context).pop();
    } catch (_) {
      if (!mounted) {
        return;
      }

      setState(() {
        _status = const _PanelStatus.error(
          'Unable to update lead stage right now',
        );
      });
    } finally {
      if (mounted) {
        setState(() {
          _isUpdatingStage = false;
        });
      }
    }
  }

  Future<void> _archiveLead() async {
    if (_isArchiving) {
      return;
    }

    final navigator = Navigator.of(context);

    setState(() {
      _isArchiving = true;
      _status = null;
    });

    try {
      await FirebaseFirestore.instance
          .collection('leads')
          .doc(widget.lead.id)
          .update({
            'isArchived': true,
            'archivedAt': Timestamp.now(),
            'updatedAt': Timestamp.now(),
          });

      if (!mounted) {
        return;
      }

      navigator.pop();
      widget.onArchived?.call();
    } catch (_) {
      if (!mounted) {
        return;
      }

      setState(() {
        _status = const _PanelStatus.error(
          'Unable to archive lead right now',
        );
      });
    } finally {
      if (mounted) {
        setState(() {
          _isArchiving = false;
        });
      }
    }
  }

  @override
  Widget build(BuildContext context) {
    final theme = Theme.of(context);
    final colorScheme = theme.colorScheme;

    return Material(
      color: colorScheme.surface,
      elevation: 16,
      child: DecoratedBox(
        decoration: BoxDecoration(
          border: Border(
            left: BorderSide(
              color: theme.dividerColor.withValues(alpha: 0.5),
            ),
          ),
          boxShadow: [
            BoxShadow(
              color: Colors.black.withValues(alpha: 0.12),
              blurRadius: 32,
              offset: const Offset(-8, 0),
            ),
          ],
        ),
        child: SafeArea(
          child: Padding(
            padding: const EdgeInsets.all(AppSpacing.xl),
            child: Column(
              crossAxisAlignment: CrossAxisAlignment.start,
              children: [
                Row(
                  crossAxisAlignment: CrossAxisAlignment.start,
                  children: [
                    Expanded(
                      child: Column(
                        crossAxisAlignment: CrossAxisAlignment.start,
                        children: [
                          Text(
                            _fallback(widget.lead.leadCode, '—'),
                            style: theme.textTheme.headlineSmall?.copyWith(
                              fontWeight: FontWeight.w700,
                            ),
                          ),
                          const SizedBox(height: AppSpacing.sm),
                          Text(
                            'Lead Details',
                            style: theme.textTheme.bodyMedium?.copyWith(
                              color: colorScheme.onSurfaceVariant,
                            ),
                          ),
                        ],
                      ),
                    ),
                    const SizedBox(width: AppSpacing.md),
                    IconButton(
                      tooltip: 'Close',
                      onPressed: _isArchiving || _isUpdatingStage
                          ? null
                          : () => Navigator.of(context).pop(),
                      icon: const Icon(Icons.close_rounded),
                    ),
                  ],
                ),
                const SizedBox(height: AppSpacing.xl),
                Expanded(
                  child: SingleChildScrollView(
                    child: Column(
                      crossAxisAlignment: CrossAxisAlignment.start,
                      children: [
                        _LeadDetailCard(
                          children: [
                            _LeadDetailItem(
                              label: 'Client',
                              value: _fallback(
                                widget.lead.clientNameSnapshot,
                                'Unknown client',
                              ),
                            ),
                            _LeadDetailItem(
                              label: 'Destination',
                              value: _fallback(
                                widget.lead.destination,
                                'Not specified',
                              ),
                            ),
                            _LeadDetailItem(
                              label: 'Travel Type',
                              value: _travelTypeLabel(widget.lead.travelType),
                            ),
                            _LeadDetailItem(
                              label: 'Trip Scope',
                              value: _tripScopeLabel(widget.lead.tripScope),
                            ),
                            _LeadDetailItem(
                              label: 'Owner',
                              value: _fallback(
                                widget.lead.leadOwnerId,
                                'Unassigned',
                              ),
                            ),
                            _LeadDetailItem(
                              label: 'Budget',
                              value: _formatBudget(widget.lead.budget),
                            ),
                            _LeadDetailItem(
                              label: 'Budget Type',
                              value: _formatBudgetType(widget.lead.budgetType),
                            ),
                            const SizedBox(height: AppSpacing.xs),
                            const _LeadSectionHeader(
                              title: 'Travellers',
                              subtitle:
                                  'Passenger counts needed for quotation prep.',
                            ),
                            const SizedBox(height: AppSpacing.lg),
                            _LeadDetailItem(
                              label: 'Adults',
                              value: widget.lead.adultCount.toString(),
                            ),
                            _LeadDetailItem(
                              label: 'Children',
                              value: widget.lead.childCount.toString(),
                            ),
                            _LeadDetailItem(
                              label: 'Infants',
                              value: widget.lead.infantCount.toString(),
                            ),
                            const SizedBox(height: AppSpacing.xs),
                            const _LeadSectionHeader(
                              title: 'Requirement Notes',
                              subtitle:
                                  'Saved trip requirements and briefing notes.',
                            ),
                            const SizedBox(height: AppSpacing.lg),
                            _LeadDetailItem(
                              label: 'Notes',
                              value: _notesValue(widget.lead.notes),
                              useMutedValueStyle:
                                  _isNotesEmpty(widget.lead.notes),
                            ),
                            _LeadDetailItem(
                              label: 'Created',
                              value: _formatDateTime(widget.lead.createdAt),
                            ),
                            _LeadDetailItem(
                              label: 'Updated',
                              value: _formatDateTime(widget.lead.updatedAt),
                              isLast: true,
                            ),
                          ],
                        ),
                        const SizedBox(height: AppSpacing.lg),
                        _LeadDetailCard(
                          children: [
                            _LeadSectionHeader(
                              title: 'Lead Stage',
                              subtitle:
                                  'Update the stage directly without changing other lead details.',
                            ),
                            const SizedBox(height: AppSpacing.lg),
                            DropdownButtonFormField<LeadStage>(
                              value: _selectedLeadStage,
                              decoration: const InputDecoration(
                                labelText: 'Lead Stage',
                              ),
                              items: _stageOptions
                                  .map(
                                    (stage) => DropdownMenuItem<LeadStage>(
                                      value: stage,
                                      enabled: stage == widget.lead.leadStage ||
                                          _allowedStageOptions.contains(stage),
                                      child: Text(_leadStageLabel(stage)),
                                    ),
                                  )
                                  .toList(growable: false),
                              onChanged: _isUpdatingStage || _isArchiving
                                  ? null
                                  : _handleStageChanged,
                            ),
                            if (_status != null) ...[
                              const SizedBox(height: AppSpacing.md),
                              _InlineStatusMessage(status: _status!),
                            ],
                            const SizedBox(height: AppSpacing.lg),
                            SizedBox(
                              width: double.infinity,
                              child: FilledButton(
                                onPressed: _isUpdatingStage || _isArchiving
                                    ? null
                                    : _updateLeadStage,
                                child: Text(
                                  _isUpdatingStage
                                      ? 'Updating Stage...'
                                      : 'Update Stage',
                                ),
                              ),
                            ),
                          ],
                        ),
                      ],
                    ),
                  ),
                ),
                const SizedBox(height: AppSpacing.xl),
                Row(
                  children: [
                    Expanded(
                      child: OutlinedButton(
                        onPressed: _isArchiving || _isUpdatingStage
                            ? null
                            : () => Navigator.of(context).pop(),
                        child: const Text('Close'),
                      ),
                    ),
                    const SizedBox(width: AppSpacing.md),
                    Expanded(
                      child: FilledButton(
                        onPressed: _isArchiving || _isUpdatingStage
                            ? null
                            : _archiveLead,
                        style: FilledButton.styleFrom(
                          backgroundColor: colorScheme.error,
                          foregroundColor: colorScheme.onError,
                        ),
                        child: Text(
                          _isArchiving ? 'Archiving...' : 'Archive Lead',
                        ),
                      ),
                    ),
                  ],
                ),
              ],
            ),
          ),
        ),
      ),
    );
  }
}

class _InlineStatusMessage extends StatelessWidget {
  const _InlineStatusMessage({required this.status});

  final _PanelStatus status;

  @override
  Widget build(BuildContext context) {
    final theme = Theme.of(context);
    final colorScheme = theme.colorScheme;
    final isError = status.isError;
    final foregroundColor =
        isError ? colorScheme.onErrorContainer : colorScheme.onSurfaceVariant;
    final backgroundColor =
        isError ? colorScheme.errorContainer : colorScheme.surfaceContainerHigh;
    final icon =
        isError ? Icons.error_outline_rounded : Icons.info_outline_rounded;

    return Container(
      width: double.infinity,
      padding: const EdgeInsets.all(AppSpacing.md),
      decoration: BoxDecoration(
        color: backgroundColor,
        borderRadius: BorderRadius.circular(16),
      ),
      child: Row(
        crossAxisAlignment: CrossAxisAlignment.start,
        children: [
          Icon(icon, size: 18, color: foregroundColor),
          const SizedBox(width: AppSpacing.sm),
          Expanded(
            child: Text(
              status.message,
              style: theme.textTheme.bodySmall?.copyWith(
                color: foregroundColor,
                fontWeight: FontWeight.w500,
              ),
            ),
          ),
        ],
      ),
    );
  }
}

class _PanelStatus {
  const _PanelStatus._({
    required this.message,
    required this.isError,
  });

  const _PanelStatus.message(String message)
      : this._(message: message, isError: false);

  const _PanelStatus.error(String message)
      : this._(message: message, isError: true);

  final String message;
  final bool isError;
}

class _LeadDetailCard extends StatelessWidget {
  const _LeadDetailCard({required this.children});

  final List<Widget> children;

  @override
  Widget build(BuildContext context) {
    final colorScheme = Theme.of(context).colorScheme;

    return Container(
      width: double.infinity,
      padding: const EdgeInsets.all(AppSpacing.lg),
      decoration: BoxDecoration(
        color: colorScheme.surfaceContainerLowest,
        borderRadius: BorderRadius.circular(20),
        border: Border.all(color: colorScheme.outlineVariant),
      ),
      child: Column(
        crossAxisAlignment: CrossAxisAlignment.start,
        children: children,
      ),
    );
  }
}

class _LeadSectionHeader extends StatelessWidget {
  const _LeadSectionHeader({required this.title, required this.subtitle});

  final String title;
  final String subtitle;

  @override
  Widget build(BuildContext context) {
    final theme = Theme.of(context);
    final colorScheme = theme.colorScheme;

    return Column(
      crossAxisAlignment: CrossAxisAlignment.start,
      children: [
        Text(
          title,
          style: theme.textTheme.titleMedium?.copyWith(
            fontWeight: FontWeight.w700,
          ),
        ),
        const SizedBox(height: AppSpacing.xs),
        Text(
          subtitle,
          style: theme.textTheme.bodySmall?.copyWith(
            color: colorScheme.onSurfaceVariant,
          ),
        ),
      ],
    );
  }
}

class _LeadDetailItem extends StatelessWidget {
  const _LeadDetailItem({
    required this.label,
    required this.value,
    this.isLast = false,
    this.useMutedValueStyle = false,
  });

  final String label;
  final String value;
  final bool isLast;
  final bool useMutedValueStyle;

  @override
  Widget build(BuildContext context) {
    final theme = Theme.of(context);
    final colorScheme = theme.colorScheme;

    return Padding(
      padding: EdgeInsets.only(bottom: isLast ? 0 : AppSpacing.lg),
      child: Row(
        crossAxisAlignment: CrossAxisAlignment.start,
        children: [
          SizedBox(
            width: 108,
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
              style: theme.textTheme.bodyLarge?.copyWith(
                fontWeight: FontWeight.w600,
                color: useMutedValueStyle
                    ? colorScheme.onSurfaceVariant
                    : colorScheme.onSurface,
              ),
            ),
          ),
        ],
      ),
    );
  }
}

String _fallback(String? value, String fallback) {
  final normalized = value?.trim();
  if (normalized == null || normalized.isEmpty) {
    return fallback;
  }

  return normalized;
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

String _tripScopeLabel(TripScope tripScope) {
  switch (tripScope) {
    case TripScope.domestic:
      return 'Domestic';
    case TripScope.international:
      return 'International';
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

String _formatBudget(int? value) {
  if (value == null) {
    return '—';
  }

  return '₹ $value';
}

String _formatBudgetType(String? value) {
  switch (value) {
    case 'WITH_FLIGHTS':
      return 'With Flights';
    case 'WITHOUT_FLIGHTS':
      return 'Without Flights';
    default:
      return '—';
  }
}

String _notesValue(String? value) {
  final normalized = value?.trim();
  if (normalized == null || normalized.isEmpty) {
    return 'No notes added';
  }

  return normalized;
}

bool _isNotesEmpty(String? value) {
  final normalized = value?.trim();
  return normalized == null || normalized.isEmpty;
}

String _formatDateTime(DateTime? value) {
  if (value == null) {
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
    _ => 'Dec',
  };
  final hour = value.hour % 12 == 0 ? 12 : value.hour % 12;
  final minute = value.minute.toString().padLeft(2, '0');
  final period = value.hour >= 12 ? 'PM' : 'AM';

  return '$month ${value.day}, ${value.year} · $hour:$minute $period';
}
