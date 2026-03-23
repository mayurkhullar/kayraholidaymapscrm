enum UserRole {
  director,
  manager,
  teamLeader,
  employee,
  freelancer,
}

enum AvailabilityStatus {
  activeAssignable,
  activeNotAssignable,
  onLeave,
  inactive,
}

enum LeadStage {
  newLead,
  contacted,
  quotationSent,
  negotiation,
  onHold,
  confirmed,
  lost,
}

enum LeadLostReason {
  priceTooHigh,
  clientNotResponding,
  bookedElsewhere,
  planDropped,
  other,
}

enum LeadOnHoldReason {
  clientDelayedDecision,
  waitingForInternalApproval,
  budgetNotFinalized,
  travelPostponed,
  other,
}

enum TravelType {
  fit,
  corporate,
  group,
  mice,
}

enum TripScope {
  domestic,
  international,
}

enum PaymentType {
  advance,
  partPayment,
  fullPayment,
  adjustment,
  refund,
}

enum PaymentStatus {
  pendingAuthorization,
  authorized,
  rejected,
}

enum TravelerCategory {
  adult,
  child,
  infant,
}

enum VisaStatus {
  applied,
  processing,
  approved,
  rejected,
}

enum NotificationCategory {
  info,
  action,
  warning,
  critical,
}

enum NotificationPriority {
  low,
  medium,
  high,
  urgent,
}

enum MarginAlertLevel {
  none,
  lowMargin,
  zeroMargin,
  negativeMargin,
}

enum PendingApprovalStatus {
  pendingApproval,
  approved,
  rejected,
  applied,
}

enum StatusTagType {
  neutral,
  info,
  success,
  warning,
  error,
}

String _enumToFirestoreValue(String name) {
  final buffer = StringBuffer();

  for (var index = 0; index < name.length; index++) {
    final character = name[index];
    final isUppercase = character.toUpperCase() == character &&
        character.toLowerCase() != character;

    if (isUppercase && index > 0) {
      buffer.write('_');
    }

    buffer.write(character.toUpperCase());
  }

  return buffer.toString();
}

T _enumFromString<T extends Enum>(String value, List<T> values) {
  final normalizedValue = value.trim().toUpperCase();

  return values.firstWhere(
    (enumValue) => _enumToFirestoreValue(enumValue.name) == normalizedValue,
    orElse: () => throw ArgumentError(
      'Unsupported ${T.toString()} value: $value',
    ),
  );
}

extension UserRoleX on UserRole {
  String get firestoreValue => _enumToFirestoreValue(name);

  static UserRole fromString(String value) {
    return _enumFromString(value, UserRole.values);
  }
}

extension AvailabilityStatusX on AvailabilityStatus {
  String get firestoreValue => _enumToFirestoreValue(name);

  static AvailabilityStatus fromString(String value) {
    return _enumFromString(value, AvailabilityStatus.values);
  }
}

extension LeadStageX on LeadStage {
  String get firestoreValue => _enumToFirestoreValue(name);

  static LeadStage fromString(String value) {
    return _enumFromString(value, LeadStage.values);
  }
}

extension TravelTypeX on TravelType {
  String get firestoreValue => _enumToFirestoreValue(name);

  static TravelType fromString(String value) {
    return _enumFromString(value, TravelType.values);
  }
}

extension TripScopeX on TripScope {
  String get firestoreValue => _enumToFirestoreValue(name);

  static TripScope fromString(String value) {
    return _enumFromString(value, TripScope.values);
  }
}

extension PaymentTypeX on PaymentType {
  String get firestoreValue => _enumToFirestoreValue(name);

  static PaymentType fromString(String value) {
    return _enumFromString(value, PaymentType.values);
  }
}

extension PaymentStatusX on PaymentStatus {
  String get firestoreValue => _enumToFirestoreValue(name);

  static PaymentStatus fromString(String value) {
    return _enumFromString(value, PaymentStatus.values);
  }
}

extension TravelerCategoryX on TravelerCategory {
  String get firestoreValue => _enumToFirestoreValue(name);

  static TravelerCategory fromString(String value) {
    return _enumFromString(value, TravelerCategory.values);
  }
}

extension VisaStatusX on VisaStatus {
  String get firestoreValue => _enumToFirestoreValue(name);

  static VisaStatus fromString(String value) {
    return _enumFromString(value, VisaStatus.values);
  }
}

extension NotificationCategoryX on NotificationCategory {
  String get firestoreValue => _enumToFirestoreValue(name);

  static NotificationCategory fromString(String value) {
    return _enumFromString(value, NotificationCategory.values);
  }
}

extension NotificationPriorityX on NotificationPriority {
  String get firestoreValue => _enumToFirestoreValue(name);

  static NotificationPriority fromString(String value) {
    return _enumFromString(value, NotificationPriority.values);
  }
}

extension MarginAlertLevelX on MarginAlertLevel {
  String get firestoreValue => _enumToFirestoreValue(name);

  static MarginAlertLevel fromString(String value) {
    return _enumFromString(value, MarginAlertLevel.values);
  }
}

extension PendingApprovalStatusX on PendingApprovalStatus {
  String get firestoreValue => _enumToFirestoreValue(name);

  static PendingApprovalStatus fromString(String value) {
    return _enumFromString(value, PendingApprovalStatus.values);
  }
}

extension StatusTagTypeX on StatusTagType {
  String get firestoreValue => _enumToFirestoreValue(name);

  static StatusTagType fromString(String value) {
    return _enumFromString(value, StatusTagType.values);
  }
}

extension LeadLostReasonX on LeadLostReason {
  String get label {
    switch (this) {
      case LeadLostReason.priceTooHigh:
        return 'Price too high';
      case LeadLostReason.clientNotResponding:
        return 'Client not responding';
      case LeadLostReason.bookedElsewhere:
        return 'Booked elsewhere';
      case LeadLostReason.planDropped:
        return 'Plan dropped';
      case LeadLostReason.other:
        return 'Other';
    }
  }
}

extension LeadOnHoldReasonX on LeadOnHoldReason {
  String get label {
    switch (this) {
      case LeadOnHoldReason.clientDelayedDecision:
        return 'Client delayed decision';
      case LeadOnHoldReason.waitingForInternalApproval:
        return 'Waiting for internal approval';
      case LeadOnHoldReason.budgetNotFinalized:
        return 'Budget not finalized';
      case LeadOnHoldReason.travelPostponed:
        return 'Travel postponed';
      case LeadOnHoldReason.other:
        return 'Other';
    }
  }
}
