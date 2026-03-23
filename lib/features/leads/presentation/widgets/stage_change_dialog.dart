import 'package:flutter/material.dart';

import '../../../../core/constants/app_enums.dart';
import '../../../../core/theme/app_spacing.dart';

class StageChangeInput {
  const StageChangeInput({
    required this.noteText,
    this.reason,
  });

  final String noteText;
  final String? reason;
}

class StageChangeDialog extends StatefulWidget {
  const StageChangeDialog({
    required this.stage,
    required this.stageLabel,
    super.key,
  });

  final LeadStage stage;
  final String stageLabel;

  @override
  State<StageChangeDialog> createState() => _StageChangeDialogState();
}

class _StageChangeDialogState extends State<StageChangeDialog> {
  final TextEditingController _noteController = TextEditingController();
  String? _selectedReason;
  String? _noteErrorText;
  String? _reasonErrorText;

  bool get _requiresReason => widget.stage.requiresReason;

  @override
  void dispose() {
    _noteController.dispose();
    super.dispose();
  }

  void _save() {
    final note = _noteController.text.trim();
    final reason = _selectedReason?.trim();
    final noteError = note.isEmpty ? 'A note is required' : null;
    final reasonError = _requiresReason && (reason == null || reason.isEmpty)
        ? 'A reason is required'
        : null;

    if (noteError != null || reasonError != null) {
      setState(() {
        _noteErrorText = noteError;
        _reasonErrorText = reasonError;
      });
      return;
    }

    Navigator.of(context).pop(
      StageChangeInput(
        noteText: note,
        reason: reason,
      ),
    );
  }

  @override
  Widget build(BuildContext context) {
    final reasonOptions = widget.stage.stageReasons;

    return AlertDialog(
      title: Text('Update Stage to ${widget.stageLabel}'),
      content: SizedBox(
        width: 420,
        child: Column(
          mainAxisSize: MainAxisSize.min,
          children: [
            if (_requiresReason) ...[
              DropdownButtonFormField<String>(
                value: _selectedReason,
                isExpanded: true,
                decoration: InputDecoration(
                  labelText: '${widget.stageLabel} reason',
                  border: const OutlineInputBorder(),
                  errorText: _reasonErrorText,
                ),
                items: reasonOptions
                    .map(
                      (reason) => DropdownMenuItem<String>(
                        value: reason,
                        child: Text(reason),
                      ),
                    )
                    .toList(growable: false),
                onChanged: (value) {
                  setState(() {
                    _selectedReason = value;
                    _reasonErrorText = null;
                  });
                },
              ),
              const SizedBox(height: AppSpacing.md),
            ],
            TextField(
              controller: _noteController,
              autofocus: true,
              minLines: 4,
              maxLines: 6,
              textCapitalization: TextCapitalization.sentences,
              decoration: InputDecoration(
                labelText: 'Note',
                hintText: 'Add context for this stage change',
                border: const OutlineInputBorder(),
                errorText: _noteErrorText,
              ),
              onChanged: (_) {
                if (_noteErrorText != null) {
                  setState(() {
                    _noteErrorText = null;
                  });
                }
              },
              onSubmitted: (_) => _save(),
            ),
          ],
        ),
      ),
      actions: [
        TextButton(
          onPressed: () => Navigator.of(context).pop(),
          child: const Text('Cancel'),
        ),
        FilledButton(
          onPressed: _save,
          child: const Text('Save'),
        ),
      ],
    );
  }
}

extension LeadStageReasonX on LeadStage {
  bool get requiresReason => this == LeadStage.lost || this == LeadStage.onHold;

  List<String> get stageReasons {
    switch (this) {
      case LeadStage.lost:
        return LeadLostReason.values.map((reason) => reason.label).toList();
      case LeadStage.onHold:
        return LeadOnHoldReason.values.map((reason) => reason.label).toList();
      default:
        return const <String>[];
    }
  }
}
