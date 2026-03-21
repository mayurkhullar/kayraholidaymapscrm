import 'package:cloud_firestore/cloud_firestore.dart';
import 'package:flutter/material.dart';

import '../../../../core/theme/app_spacing.dart';

class CreateLeadPanel extends StatefulWidget {
  const CreateLeadPanel({super.key});

  static Future<void> show(BuildContext context) {
    return showGeneralDialog<void>(
      context: context,
      barrierLabel: 'Create Lead',
      barrierDismissible: true,
      barrierColor: Colors.black54,
      transitionDuration: const Duration(milliseconds: 240),
      pageBuilder: (context, animation, secondaryAnimation) {
        return const _CreateLeadPanelDialog();
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
  State<CreateLeadPanel> createState() => _CreateLeadPanelState();
}

class _CreateLeadPanelDialog extends StatelessWidget {
  const _CreateLeadPanelDialog();

  @override
  Widget build(BuildContext context) {
    final mediaQuery = MediaQuery.of(context);
    final panelWidth = mediaQuery.size.width >= 1200
        ? 460.0
        : mediaQuery.size.width >= 768
            ? 420.0
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
              child: const CreateLeadPanel(),
            ),
          ),
        ),
      ),
    );
  }
}

class _CreateLeadPanelState extends State<CreateLeadPanel> {
  final _formKey = GlobalKey<FormState>();
  final _clientNameController = TextEditingController();
  final _destinationController = TextEditingController();
  final _budgetController = TextEditingController();

  String _travelType = 'fit';
  String _tripScope = 'international';
  bool _isSubmitting = false;

  static const List<DropdownMenuItem<String>> _travelTypeItems = [
    DropdownMenuItem(value: 'fit', child: Text('fit')),
    DropdownMenuItem(value: 'corporate', child: Text('corporate')),
    DropdownMenuItem(value: 'group', child: Text('group')),
    DropdownMenuItem(value: 'mice', child: Text('mice')),
  ];

  static const List<DropdownMenuItem<String>> _tripScopeItems = [
    DropdownMenuItem(value: 'domestic', child: Text('domestic')),
    DropdownMenuItem(value: 'international', child: Text('international')),
  ];

  @override
  void dispose() {
    _clientNameController.dispose();
    _destinationController.dispose();
    _budgetController.dispose();
    super.dispose();
  }

  Future<void> _createLead() async {
    final formState = _formKey.currentState;
    if (formState == null || !formState.validate()) {
      return;
    }

    final navigator = Navigator.of(context);
    final messenger = ScaffoldMessenger.of(context);
    final clientName = _clientNameController.text.trim();
    final destination = _destinationController.text.trim();
    final normalizedDestination = destination.toLowerCase();
    final budgetValue = _budgetController.text.trim();
    final budget = budgetValue.isEmpty ? null : num.tryParse(budgetValue);
    final timestamp = Timestamp.now();

    setState(() {
      _isSubmitting = true;
    });

    try {
      await FirebaseFirestore.instance.collection('leads').add({
        'leadCode': 'LD-${DateTime.now().millisecondsSinceEpoch}',
        'clientNameSnapshot': clientName,
        'destination': destination,
        'destinationSearch': normalizedDestination,
        'normalizedDestination': normalizedDestination,
        'travelType': _travelType,
        'tripScope': _tripScope,
        'leadStage': 'newLead',
        'leadOwnerId': 'EMP001',
        'isArchived': false,
        'budget': budget,
        'createdAt': timestamp,
        'updatedAt': timestamp,
      });

      if (!mounted) {
        return;
      }

      navigator.pop();
      messenger.showSnackBar(
        const SnackBar(
          content: Text('Lead created successfully'),
        ),
      );
    } catch (_) {
      if (!mounted) {
        return;
      }

      messenger.showSnackBar(
        const SnackBar(
          content: Text('Unable to create lead right now'),
        ),
      );
    } finally {
      if (mounted) {
        setState(() {
          _isSubmitting = false;
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
                            'Create Lead',
                            style: theme.textTheme.headlineSmall?.copyWith(
                              fontWeight: FontWeight.w700,
                            ),
                          ),
                          const SizedBox(height: AppSpacing.sm),
                          Text(
                            'Add a new travel inquiry',
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
                      onPressed: _isSubmitting
                          ? null
                          : () => Navigator.of(context).pop(),
                      icon: const Icon(Icons.close_rounded),
                    ),
                  ],
                ),
                const SizedBox(height: AppSpacing.xl),
                Expanded(
                  child: SingleChildScrollView(
                    child: Form(
                      key: _formKey,
                      child: Column(
                        crossAxisAlignment: CrossAxisAlignment.start,
                        children: [
                          TextFormField(
                            controller: _clientNameController,
                            textInputAction: TextInputAction.next,
                            decoration: const InputDecoration(
                              labelText: 'Client Name',
                            ),
                            validator: (value) {
                              if (value == null || value.trim().isEmpty) {
                                return 'Client Name is required';
                              }

                              return null;
                            },
                          ),
                          const SizedBox(height: AppSpacing.lg),
                          TextFormField(
                            controller: _destinationController,
                            textInputAction: TextInputAction.next,
                            decoration: const InputDecoration(
                              labelText: 'Destination',
                            ),
                            validator: (value) {
                              if (value == null || value.trim().isEmpty) {
                                return 'Destination is required';
                              }

                              return null;
                            },
                          ),
                          const SizedBox(height: AppSpacing.lg),
                          DropdownButtonFormField<String>(
                            value: _travelType,
                            decoration: const InputDecoration(
                              labelText: 'Travel Type',
                            ),
                            items: _travelTypeItems,
                            onChanged: _isSubmitting
                                ? null
                                : (value) {
                                    if (value == null) {
                                      return;
                                    }

                                    setState(() {
                                      _travelType = value;
                                    });
                                  },
                          ),
                          const SizedBox(height: AppSpacing.lg),
                          DropdownButtonFormField<String>(
                            value: _tripScope,
                            decoration: const InputDecoration(
                              labelText: 'Trip Scope',
                            ),
                            items: _tripScopeItems,
                            onChanged: _isSubmitting
                                ? null
                                : (value) {
                                    if (value == null) {
                                      return;
                                    }

                                    setState(() {
                                      _tripScope = value;
                                    });
                                  },
                          ),
                          const SizedBox(height: AppSpacing.lg),
                          TextFormField(
                            controller: _budgetController,
                            keyboardType: const TextInputType.numberWithOptions(
                              decimal: true,
                            ),
                            decoration: const InputDecoration(
                              labelText: 'Budget (optional)',
                            ),
                          ),
                        ],
                      ),
                    ),
                  ),
                ),
                const SizedBox(height: AppSpacing.xl),
                Row(
                  children: [
                    Expanded(
                      child: OutlinedButton(
                        onPressed: _isSubmitting
                            ? null
                            : () => Navigator.of(context).pop(),
                        child: const Text('Cancel'),
                      ),
                    ),
                    const SizedBox(width: AppSpacing.md),
                    Expanded(
                      child: ElevatedButton(
                        onPressed: _isSubmitting ? null : _createLead,
                        child: Text(
                          _isSubmitting ? 'Creating...' : 'Create Lead',
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
