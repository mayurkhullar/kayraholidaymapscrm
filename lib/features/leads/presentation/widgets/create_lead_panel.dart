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
  final _adultCountController = TextEditingController(text: '1');
  final _childCountController = TextEditingController(text: '0');
  final _infantCountController = TextEditingController(text: '0');
  final _notesController = TextEditingController();

  String _travelType = 'fit';
  String _tripScope = 'international';
  String? _budgetType;
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

  static const List<DropdownMenuItem<String>> _budgetTypeItems = [
    DropdownMenuItem(
      value: 'WITH_FLIGHTS',
      child: Text('With Flights'),
    ),
    DropdownMenuItem(
      value: 'WITHOUT_FLIGHTS',
      child: Text('Without Flights'),
    ),
  ];

  @override
  void dispose() {
    _clientNameController.dispose();
    _destinationController.dispose();
    _budgetController.dispose();
    _adultCountController.dispose();
    _childCountController.dispose();
    _infantCountController.dispose();
    _notesController.dispose();
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
    final budget = budgetValue.isEmpty ? null : int.tryParse(budgetValue);
    final budgetType = _budgetType;
    final adultCount = int.parse(_adultCountController.text.trim());
    final childCount = int.tryParse(_childCountController.text.trim()) ?? 0;
    final infantCount = int.tryParse(_infantCountController.text.trim()) ?? 0;
    final notesValue = _notesController.text.trim();
    final notes = notesValue.isEmpty ? null : notesValue;

    setState(() {
      _isSubmitting = true;
    });

    try {
      final firestore = FirebaseFirestore.instance;
      final leadsCollection = firestore.collection('leads');
      final leadDocument = leadsCollection.doc();

      await firestore.runTransaction((transaction) async {
        final counterReference = firestore.collection('counters').doc('lead_2026');
        final counterSnapshot = await transaction.get(counterReference);
        final current = (counterSnapshot.data()?['current'] as num?)?.toInt() ?? 0;
        final next = current + 1;
        final now = Timestamp.now();
        final leadCode = 'LD-2026-${next.toString().padLeft(4, '0')}';

        if (counterSnapshot.exists) {
          transaction.update(counterReference, <String, dynamic>{
            'current': next,
          });
        } else {
          transaction.set(counterReference, <String, dynamic>{
            'current': next,
          });
        }

        transaction.set(leadDocument, <String, dynamic>{
          'leadCode': leadCode,
          'clientNameSnapshot': clientName,
          'destination': destination,
          'destinationSearch': normalizedDestination,
          'normalizedDestination': normalizedDestination,
          'travelType': _travelType,
          'tripScope': _tripScope,
          'leadStage': 'newLead',
          'leadOwnerId': 'EMP001',
          'isArchived': false,
          'adultCount': adultCount,
          'childCount': childCount,
          'infantCount': infantCount,
          'passengerCount': <String, dynamic>{
            'adults': adultCount,
            'children': childCount,
            'childrenAges': const <int>[],
            'infants': infantCount,
            'totalPax': adultCount + childCount + infantCount,
          },
          'notes': notes,
          'budget': budget,
          'budgetType': budgetType,
          'createdAt': now,
          'updatedAt': now,
        });
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

  String? _validateRequiredCount(String? value, {required String label}) {
    final normalized = value?.trim() ?? '';
    if (normalized.isEmpty) {
      return '$label is required';
    }

    final parsed = int.tryParse(normalized);
    if (parsed == null) {
      return '$label must be a whole number';
    }

    if (parsed < 1) {
      return '$label must be at least 1';
    }

    return null;
  }

  String? _validateOptionalCount(String? value, {required String label}) {
    final normalized = value?.trim() ?? '';
    if (normalized.isEmpty) {
      return null;
    }

    final parsed = int.tryParse(normalized);
    if (parsed == null) {
      return '$label must be a whole number';
    }

    if (parsed < 0) {
      return '$label cannot be negative';
    }

    return null;
  }

  Widget _buildCountField({
    required TextEditingController controller,
    required String label,
    required String? Function(String? value) validator,
  }) {
    return Expanded(
      child: TextFormField(
        controller: controller,
        enabled: !_isSubmitting,
        keyboardType: TextInputType.number,
        textInputAction: TextInputAction.next,
        decoration: InputDecoration(
          labelText: label,
          isDense: true,
        ),
        validator: validator,
      ),
    );
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
                            enabled: !_isSubmitting,
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
                            enabled: !_isSubmitting,
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
                          Row(
                            children: [
                              _buildCountField(
                                controller: _adultCountController,
                                label: 'Adults',
                                validator: (value) => _validateRequiredCount(
                                  value,
                                  label: 'Adults',
                                ),
                              ),
                              const SizedBox(width: AppSpacing.md),
                              _buildCountField(
                                controller: _childCountController,
                                label: 'Children',
                                validator: (value) => _validateOptionalCount(
                                  value,
                                  label: 'Children',
                                ),
                              ),
                              const SizedBox(width: AppSpacing.md),
                              _buildCountField(
                                controller: _infantCountController,
                                label: 'Infants',
                                validator: (value) => _validateOptionalCount(
                                  value,
                                  label: 'Infants',
                                ),
                              ),
                            ],
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
                            enabled: !_isSubmitting,
                            keyboardType: TextInputType.number,
                            textInputAction: TextInputAction.next,
                            decoration: const InputDecoration(
                              labelText: 'Budget (optional)',
                            ),
                            validator: (value) {
                              final normalizedValue = value?.trim() ?? '';
                              if (normalizedValue.isEmpty) {
                                return null;
                              }

                              if (int.tryParse(normalizedValue) == null) {
                                return 'Enter budget in INR as a whole number';
                              }

                              return null;
                            },
                          ),
                          const SizedBox(height: AppSpacing.lg),
                          DropdownButtonFormField<String>(
                            value: _budgetType,
                            decoration: const InputDecoration(
                              labelText: 'Budget Type',
                            ),
                            items: _budgetTypeItems,
                            validator: (value) {
                              if (value == null || value.trim().isEmpty) {
                                return 'Budget Type is required';
                              }

                              return null;
                            },
                            onChanged: _isSubmitting
                                ? null
                                : (value) {
                                    setState(() {
                                      _budgetType = value;
                                    });
                                  },
                          ),
                          const SizedBox(height: AppSpacing.lg),
                          TextFormField(
                            controller: _notesController,
                            enabled: !_isSubmitting,
                            minLines: 3,
                            maxLines: 5,
                            textInputAction: TextInputAction.newline,
                            decoration: const InputDecoration(
                              labelText: 'Notes',
                              alignLabelWithHint: true,
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
