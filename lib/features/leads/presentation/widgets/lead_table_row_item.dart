import 'package:flutter/material.dart';

import '../../../../core/constants/app_enums.dart';
import '../../../../core/theme/app_spacing.dart';
import '../../../../core/widgets/status_tag.dart';
import '../../domain/models/lead_model.dart';

const double leadTableLeadCodeWidth = 120;
const double leadTableClientWidth = 180;
const double leadTableDestinationWidth = 140;
const double leadTableTravelTypeWidth = 120;
const double leadTableBudgetWidth = 120;
const double leadTableStageWidth = 140;
const double leadTableOwnerWidth = 120;
const double leadTableUpdatedWidth = 140;

class LeadTableRowItem extends StatefulWidget {
  const LeadTableRowItem({
    required this.lead,
    super.key,
    this.onTap,
  });

  final LeadModel lead;
  final VoidCallback? onTap;

  @override
  State<LeadTableRowItem> createState() => _LeadTableRowItemState();
}

class _LeadTableRowItemState extends State<LeadTableRowItem> {
  bool _isHovered = false;

  void _setHovered(bool value) {
    if (_isHovered == value) {
      return;
    }

    setState(() {
      _isHovered = value;
    });
  }

  @override
  Widget build(BuildContext context) {
    final theme = Theme.of(context);
    final colorScheme = theme.colorScheme;
    final hoverColor = colorScheme.primary.withValues(alpha: 0.035);

    return MouseRegion(
      cursor: widget.onTap == null
          ? MouseCursor.defer
          : SystemMouseCursors.click,
      onEnter: (_) => _setHovered(true),
      onExit: (_) => _setHovered(false),
      child: AnimatedContainer(
        duration: const Duration(milliseconds: 120),
        curve: Curves.easeOut,
        color: _isHovered ? hoverColor : Colors.transparent,
        child: Material(
          color: Colors.transparent,
          child: InkWell(
            onTap: widget.onTap,
            hoverColor: Colors.transparent,
            highlightColor: colorScheme.primary.withValues(alpha: 0.05),
            splashColor: colorScheme.primary.withValues(alpha: 0.07),
            child: Padding(
              padding: const EdgeInsets.symmetric(
                horizontal: AppSpacing.xl,
                vertical: AppSpacing.lg,
              ),
              child: Row(
                children: [
                  _LeadTableCell(
                    width: leadTableLeadCodeWidth,
                    child: Text(
                      _fallback(widget.lead.leadCode, '—'),
                      style: theme.textTheme.titleSmall?.copyWith(
                        fontWeight: FontWeight.w700,
                      ),
                      overflow: TextOverflow.ellipsis,
                    ),
                  ),
                  _LeadTableCell(
                    width: leadTableClientWidth,
                    child: _PrimarySecondaryText(
                      primary: _fallback(
                        widget.lead.clientNameSnapshot,
                        'Unknown client',
                      ),
                      secondary: widget.lead.companyNameSnapshot,
                    ),
                  ),
                  _LeadTableCell(
                    width: leadTableDestinationWidth,
                    child: Text(
                      _fallback(widget.lead.destination, 'Not specified'),
                      style: theme.textTheme.bodyMedium,
                      overflow: TextOverflow.ellipsis,
                    ),
                  ),
                  _LeadTableCell(
                    width: leadTableTravelTypeWidth,
                    child: Text(
                      _travelTypeLabel(widget.lead.travelType),
                      style: theme.textTheme.bodyMedium,
                      overflow: TextOverflow.ellipsis,
                    ),
                  ),
                  _LeadTableCell(
                    width: leadTableBudgetWidth,
                    child: Text(
                      _formatBudget(widget.lead.budget),
                      style: theme.textTheme.bodyMedium,
                      overflow: TextOverflow.ellipsis,
                    ),
                  ),
                  _LeadTableCell(
                    width: leadTableStageWidth,
                    child: Align(
                      alignment: Alignment.centerLeft,
                      child: StatusTag(
                        label: _leadStageLabel(widget.lead.leadStage),
                        type: _leadStageTagType(widget.lead.leadStage),
                      ),
                    ),
                  ),
                  _LeadTableCell(
                    width: leadTableOwnerWidth,
                    child: Text(
                      _fallback(widget.lead.leadOwnerId, 'Unassigned'),
                      style: theme.textTheme.bodyMedium?.copyWith(
                        color: colorScheme.onSurfaceVariant,
                      ),
                      overflow: TextOverflow.ellipsis,
                    ),
                  ),
                  _LeadTableCell(
                    width: leadTableUpdatedWidth,
                    isLast: true,
                    child: Text(
                      _formatDate(widget.lead.updatedAt),
                      style: theme.textTheme.bodyMedium?.copyWith(
                        color: colorScheme.onSurfaceVariant,
                      ),
                      overflow: TextOverflow.ellipsis,
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

class _LeadTableCell extends StatelessWidget {
  const _LeadTableCell({
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
      child: SizedBox(
        width: width,
        child: child,
      ),
    );
  }
}

class _PrimarySecondaryText extends StatelessWidget {
  const _PrimarySecondaryText({required this.primary, this.secondary});

  final String primary;
  final String? secondary;

  @override
  Widget build(BuildContext context) {
    final theme = Theme.of(context);
    final secondaryText = secondary?.trim();

    return Column(
      crossAxisAlignment: CrossAxisAlignment.start,
      mainAxisSize: MainAxisSize.min,
      children: [
        Text(
          primary,
          style: theme.textTheme.bodyMedium?.copyWith(
            fontWeight: FontWeight.w600,
          ),
          overflow: TextOverflow.ellipsis,
        ),
        if (secondaryText != null && secondaryText.isNotEmpty) ...[
          const SizedBox(height: AppSpacing.xs),
          Text(
            secondaryText,
            style: theme.textTheme.bodySmall?.copyWith(
              color: theme.colorScheme.onSurfaceVariant,
            ),
            overflow: TextOverflow.ellipsis,
          ),
        ],
      ],
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

StatusTagType _leadStageTagType(LeadStage leadStage) {
  switch (leadStage) {
    case LeadStage.newLead:
      return StatusTagType.info;
    case LeadStage.contacted:
      return StatusTagType.neutral;
    case LeadStage.quotationSent:
      return StatusTagType.warning;
    case LeadStage.negotiation:
      return StatusTagType.warning;
    case LeadStage.onHold:
      return StatusTagType.neutral;
    case LeadStage.confirmed:
      return StatusTagType.success;
    case LeadStage.lost:
      return StatusTagType.error;
  }
}

String _formatDate(DateTime? value) {
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
    12 => 'Dec',
    _ => '',
  };

  final day = value.day.toString().padLeft(2, '0');
  return '$day $month ${value.year}';
}

String _formatBudget(int? value) {
  if (value == null) {
    return '—';
  }

  return '₹ $value';
}
