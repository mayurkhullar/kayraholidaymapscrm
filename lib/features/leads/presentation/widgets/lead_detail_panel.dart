import 'package:cloud_firestore/cloud_firestore.dart';
import 'package:flutter/material.dart';

import '../../../../core/constants/app_enums.dart';
import '../../../../core/theme/app_spacing.dart';
import '../../domain/models/lead_model.dart';

class LeadDetailPanel extends StatefulWidget {
  const LeadDetailPanel({
    required this.lead,
    super.key,
    this.onArchived,
  });

  final LeadModel lead;
  final VoidCallback? onArchived;

  static Future<void> show(
    BuildContext context, {
    required LeadModel lead,
    VoidCallback? onArchived,
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
  });

  final LeadModel lead;
  final VoidCallback? onArchived;

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
              ),
            ),
          ),
        ),
      ),
    );
  }
}

class _LeadDetailPanelState extends State<LeadDetailPanel> {
  bool _isArchiving = false;

  Future<void> _archiveLead() async {
    if (_isArchiving) {
      return;
    }

    final navigator = Navigator.of(context);
    final messenger = ScaffoldMessenger.of(context);

    setState(() {
      _isArchiving = true;
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
      messenger.showSnackBar(
        const SnackBar(
          content: Text('Lead archived successfully'),
        ),
      );
    } catch (_) {
      if (!mounted) {
        return;
      }

      messenger.showSnackBar(
        const SnackBar(
          content: Text('Unable to archive lead right now'),
        ),
      );
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
                      onPressed: _isArchiving
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
                              label: 'Stage',
                              value: _leadStageLabel(widget.lead.leadStage),
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
                      ],
                    ),
                  ),
                ),
                const SizedBox(height: AppSpacing.xl),
                Row(
                  children: [
                    Expanded(
                      child: OutlinedButton(
                        onPressed: _isArchiving
                            ? null
                            : () => Navigator.of(context).pop(),
                        child: const Text('Close'),
                      ),
                    ),
                    const SizedBox(width: AppSpacing.md),
                    Expanded(
                      child: FilledButton(
                        onPressed: _isArchiving ? null : _archiveLead,
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
        children: children,
      ),
    );
  }
}

class _LeadDetailItem extends StatelessWidget {
  const _LeadDetailItem({
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
