import '../../../core/constants/app_enums.dart';

class LeadStageTransitionRules {
  const LeadStageTransitionRules._();

  static const String invalidTransitionMessage = 'Invalid stage transition';

  static const Map<LeadStage, Set<LeadStage>> _forwardTransitions = {
    LeadStage.newLead: {LeadStage.contacted, LeadStage.onHold},
    LeadStage.contacted: {LeadStage.quotationSent, LeadStage.onHold},
    LeadStage.quotationSent: {LeadStage.negotiation, LeadStage.onHold},
    LeadStage.negotiation: {
      LeadStage.confirmed,
      LeadStage.lost,
      LeadStage.onHold,
    },
    LeadStage.onHold: {LeadStage.contacted},
    LeadStage.confirmed: {LeadStage.onHold},
    LeadStage.lost: {LeadStage.onHold},
  };

  static Set<LeadStage> allowedTransitions(
    LeadStage currentStage, {
    LeadStage? previousStageBeforeHold,
  }) {
    final allowedStages = Set<LeadStage>.from(
      _forwardTransitions[currentStage] ?? const <LeadStage>{},
    );

    if (currentStage == LeadStage.onHold &&
        previousStageBeforeHold != null &&
        previousStageBeforeHold != LeadStage.onHold) {
      allowedStages.add(previousStageBeforeHold);
    }

    return allowedStages;
  }

  static bool isAllowedTransition(
    LeadStage currentStage,
    LeadStage nextStage, {
    LeadStage? previousStageBeforeHold,
  }) {
    if (currentStage == nextStage) {
      return true;
    }

    return allowedTransitions(
      currentStage,
      previousStageBeforeHold: previousStageBeforeHold,
    ).contains(nextStage);
  }
}
