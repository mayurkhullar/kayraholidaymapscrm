import 'package:cloud_firestore/cloud_firestore.dart';

import 'package:kayraholidaymapscrm/core/constants/app_enums.dart';
import 'package:kayraholidaymapscrm/shared/models/passenger_count_model.dart';

import 'lead_health_model.dart';
import 'lead_travel_dates_model.dart';

class LeadModel {
  const LeadModel({
    required this.id,
    required this.leadCode,
    required this.clientId,
    this.companyId,
    required this.leadOwnerId,
    this.teamId,
    this.leadSourceCode,
    required this.travelType,
    required this.tripScope,
    this.destination,
    this.travelDates,
    this.passengerCount,
    this.adultCount = 0,
    this.childCount = 0,
    this.infantCount = 0,
    this.notes,
    this.budget,
    this.budgetType,
    required this.leadStage,
    this.leadHealth,
    this.onHoldReason,
    this.nextFollowUpDate,
    this.lostReasonCode,
    this.lostNote,
    this.lostAt,
    this.lostBy,
    this.reopenedFromLeadId,
    this.firstAssignedAt,
    this.firstContactAt,
    this.firstQuotationAt,
    this.confirmedAt,
    this.lastMeaningfulActivityAt,
    this.hasActiveQuotation = false,
    this.activeQuotationId,
    this.duplicateWarningShown = false,
    this.clientNameSnapshot,
    this.companyNameSnapshot,
    this.destinationSearch,
    this.normalizedDestination,
    this.travelMonth,
    this.searchTokens = const <String>[],
    this.createdBy,
    this.createdAt,
    this.updatedBy,
    this.updatedAt,
    this.isArchived = false,
    this.archivedBy,
    this.archivedAt,
  });

  final String id;
  final String leadCode;
  final String clientId;
  final String? companyId;
  final String leadOwnerId;
  final String? teamId;
  final String? leadSourceCode;
  final TravelType travelType;
  final TripScope tripScope;
  final String? destination;
  final LeadTravelDatesModel? travelDates;
  final PassengerCountModel? passengerCount;
  final int adultCount;
  final int childCount;
  final int infantCount;
  final String? notes;
  final int? budget;
  final String? budgetType;
  final LeadStage leadStage;
  final LeadHealthModel? leadHealth;
  final String? onHoldReason;
  final DateTime? nextFollowUpDate;
  final String? lostReasonCode;
  final String? lostNote;
  final DateTime? lostAt;
  final String? lostBy;
  final String? reopenedFromLeadId;
  final DateTime? firstAssignedAt;
  final DateTime? firstContactAt;
  final DateTime? firstQuotationAt;
  final DateTime? confirmedAt;
  final DateTime? lastMeaningfulActivityAt;
  final bool hasActiveQuotation;
  final String? activeQuotationId;
  final bool duplicateWarningShown;
  final String? clientNameSnapshot;
  final String? companyNameSnapshot;
  final String? destinationSearch;
  final String? normalizedDestination;
  final String? travelMonth;
  final List<String> searchTokens;
  final String? createdBy;
  final DateTime? createdAt;
  final String? updatedBy;
  final DateTime? updatedAt;
  final bool isArchived;
  final String? archivedBy;
  final DateTime? archivedAt;

  factory LeadModel.fromMap(Map<String, dynamic> map) {
    final passengerCountMap = _mapFromDynamic(map['passengerCount']);

    return LeadModel(
      id: (map['id'] as String?) ?? '',
      leadCode: (map['leadCode'] as String?) ?? '',
      clientId: (map['clientId'] as String?) ?? '',
      companyId: map['companyId'] as String?,
      leadOwnerId: (map['leadOwnerId'] as String?) ?? '',
      teamId: map['teamId'] as String?,
      leadSourceCode: map['leadSourceCode'] as String?,
      travelType: _travelTypeFromDynamic(map['travelType']),
      tripScope: _tripScopeFromDynamic(map['tripScope']),
      destination: map['destination'] as String?,
      travelDates: _leadTravelDatesFromDynamic(map['travelDates']),
      passengerCount: _passengerCountFromDynamic(passengerCountMap),
      adultCount: _intFromDynamic(
        map['adultCount'] ?? passengerCountMap?['adults'],
        fallback: 0,
      ),
      childCount: _intFromDynamic(
        map['childCount'] ?? passengerCountMap?['children'],
        fallback: 0,
      ),
      infantCount: _intFromDynamic(
        map['infantCount'] ?? passengerCountMap?['infants'],
        fallback: 0,
      ),
      notes: map['notes'] as String?,
      budget: _budgetFromDynamic(map['budget']),
      budgetType: map['budgetType'] as String?,
      leadStage: _leadStageFromDynamic(map['leadStage']),
      leadHealth: _leadHealthFromDynamic(map['leadHealth']),
      onHoldReason: map['onHoldReason'] as String?,
      nextFollowUpDate: _dateTimeFromDynamic(map['nextFollowUpDate']),
      lostReasonCode: map['lostReasonCode'] as String?,
      lostNote: map['lostNote'] as String?,
      lostAt: _dateTimeFromDynamic(map['lostAt']),
      lostBy: map['lostBy'] as String?,
      reopenedFromLeadId: map['reopenedFromLeadId'] as String?,
      firstAssignedAt: _dateTimeFromDynamic(map['firstAssignedAt']),
      firstContactAt: _dateTimeFromDynamic(map['firstContactAt']),
      firstQuotationAt: _dateTimeFromDynamic(map['firstQuotationAt']),
      confirmedAt: _dateTimeFromDynamic(map['confirmedAt']),
      lastMeaningfulActivityAt:
          _dateTimeFromDynamic(map['lastMeaningfulActivityAt']),
      hasActiveQuotation: (map['hasActiveQuotation'] as bool?) ?? false,
      activeQuotationId: map['activeQuotationId'] as String?,
      duplicateWarningShown:
          (map['duplicateWarningShown'] as bool?) ?? false,
      clientNameSnapshot: map['clientNameSnapshot'] as String?,
      companyNameSnapshot: map['companyNameSnapshot'] as String?,
      destinationSearch: map['destinationSearch'] as String?,
      normalizedDestination: map['normalizedDestination'] as String?,
      travelMonth: map['travelMonth'] as String?,
      searchTokens: _stringListFromDynamic(map['searchTokens']),
      createdBy: map['createdBy'] as String?,
      createdAt: _dateTimeFromDynamic(map['createdAt']),
      updatedBy: map['updatedBy'] as String?,
      updatedAt: _dateTimeFromDynamic(map['updatedAt']),
      isArchived: (map['isArchived'] as bool?) ?? false,
      archivedBy: map['archivedBy'] as String?,
      archivedAt: _dateTimeFromDynamic(map['archivedAt']),
    );
  }

  Map<String, dynamic> toMap() {
    return <String, dynamic>{
      'id': id,
      'leadCode': leadCode,
      'clientId': clientId,
      'companyId': companyId,
      'leadOwnerId': leadOwnerId,
      'teamId': teamId,
      'leadSourceCode': leadSourceCode,
      'travelType': travelType.firestoreValue,
      'tripScope': tripScope.firestoreValue,
      'destination': destination,
      'travelDates': travelDates?.toMap(),
      'passengerCount': (passengerCount ??
              PassengerCountModel.calculate(
                adults: adultCount,
                children: childCount,
                infants: infantCount,
              ))
          .toMap(),
      'adultCount': adultCount,
      'childCount': childCount,
      'infantCount': infantCount,
      'notes': notes,
      'budget': budget,
      'budgetType': budgetType,
      'leadStage': leadStage.firestoreValue,
      'leadHealth': leadHealth?.toMap(),
      'onHoldReason': onHoldReason,
      'nextFollowUpDate': nextFollowUpDate,
      'lostReasonCode': lostReasonCode,
      'lostNote': lostNote,
      'lostAt': lostAt,
      'lostBy': lostBy,
      'reopenedFromLeadId': reopenedFromLeadId,
      'firstAssignedAt': firstAssignedAt,
      'firstContactAt': firstContactAt,
      'firstQuotationAt': firstQuotationAt,
      'confirmedAt': confirmedAt,
      'lastMeaningfulActivityAt': lastMeaningfulActivityAt,
      'hasActiveQuotation': hasActiveQuotation,
      'activeQuotationId': activeQuotationId,
      'duplicateWarningShown': duplicateWarningShown,
      'clientNameSnapshot': clientNameSnapshot,
      'companyNameSnapshot': companyNameSnapshot,
      'destinationSearch': destinationSearch,
      'normalizedDestination': normalizedDestination,
      'travelMonth': travelMonth,
      'searchTokens': searchTokens,
      'createdBy': createdBy,
      'createdAt': createdAt,
      'updatedBy': updatedBy,
      'updatedAt': updatedAt,
      'isArchived': isArchived == true ? true : false,
      'archivedBy': archivedBy,
      'archivedAt': archivedAt,
    };
  }

  LeadModel copyWith({
    String? id,
    String? leadCode,
    String? clientId,
    String? companyId,
    String? leadOwnerId,
    String? teamId,
    String? leadSourceCode,
    TravelType? travelType,
    TripScope? tripScope,
    String? destination,
    LeadTravelDatesModel? travelDates,
    PassengerCountModel? passengerCount,
    int? adultCount,
    int? childCount,
    int? infantCount,
    String? notes,
    int? budget,
    String? budgetType,
    LeadStage? leadStage,
    LeadHealthModel? leadHealth,
    String? onHoldReason,
    DateTime? nextFollowUpDate,
    String? lostReasonCode,
    String? lostNote,
    DateTime? lostAt,
    String? lostBy,
    String? reopenedFromLeadId,
    DateTime? firstAssignedAt,
    DateTime? firstContactAt,
    DateTime? firstQuotationAt,
    DateTime? confirmedAt,
    DateTime? lastMeaningfulActivityAt,
    bool? hasActiveQuotation,
    String? activeQuotationId,
    bool? duplicateWarningShown,
    String? clientNameSnapshot,
    String? companyNameSnapshot,
    String? destinationSearch,
    String? normalizedDestination,
    String? travelMonth,
    List<String>? searchTokens,
    String? createdBy,
    DateTime? createdAt,
    String? updatedBy,
    DateTime? updatedAt,
    bool? isArchived,
    String? archivedBy,
    DateTime? archivedAt,
  }) {
    return LeadModel(
      id: id ?? this.id,
      leadCode: leadCode ?? this.leadCode,
      clientId: clientId ?? this.clientId,
      companyId: companyId ?? this.companyId,
      leadOwnerId: leadOwnerId ?? this.leadOwnerId,
      teamId: teamId ?? this.teamId,
      leadSourceCode: leadSourceCode ?? this.leadSourceCode,
      travelType: travelType ?? this.travelType,
      tripScope: tripScope ?? this.tripScope,
      destination: destination ?? this.destination,
      travelDates: travelDates ?? this.travelDates,
      passengerCount: passengerCount ?? this.passengerCount,
      adultCount: adultCount ?? this.adultCount,
      childCount: childCount ?? this.childCount,
      infantCount: infantCount ?? this.infantCount,
      notes: notes ?? this.notes,
      budget: budget ?? this.budget,
      budgetType: budgetType ?? this.budgetType,
      leadStage: leadStage ?? this.leadStage,
      leadHealth: leadHealth ?? this.leadHealth,
      onHoldReason: onHoldReason ?? this.onHoldReason,
      nextFollowUpDate: nextFollowUpDate ?? this.nextFollowUpDate,
      lostReasonCode: lostReasonCode ?? this.lostReasonCode,
      lostNote: lostNote ?? this.lostNote,
      lostAt: lostAt ?? this.lostAt,
      lostBy: lostBy ?? this.lostBy,
      reopenedFromLeadId: reopenedFromLeadId ?? this.reopenedFromLeadId,
      firstAssignedAt: firstAssignedAt ?? this.firstAssignedAt,
      firstContactAt: firstContactAt ?? this.firstContactAt,
      firstQuotationAt: firstQuotationAt ?? this.firstQuotationAt,
      confirmedAt: confirmedAt ?? this.confirmedAt,
      lastMeaningfulActivityAt:
          lastMeaningfulActivityAt ?? this.lastMeaningfulActivityAt,
      hasActiveQuotation: hasActiveQuotation ?? this.hasActiveQuotation,
      activeQuotationId: activeQuotationId ?? this.activeQuotationId,
      duplicateWarningShown:
          duplicateWarningShown ?? this.duplicateWarningShown,
      clientNameSnapshot: clientNameSnapshot ?? this.clientNameSnapshot,
      companyNameSnapshot: companyNameSnapshot ?? this.companyNameSnapshot,
      destinationSearch: destinationSearch ?? this.destinationSearch,
      normalizedDestination:
          normalizedDestination ?? this.normalizedDestination,
      travelMonth: travelMonth ?? this.travelMonth,
      searchTokens: searchTokens ?? this.searchTokens,
      createdBy: createdBy ?? this.createdBy,
      createdAt: createdAt ?? this.createdAt,
      updatedBy: updatedBy ?? this.updatedBy,
      updatedAt: updatedAt ?? this.updatedAt,
      isArchived: isArchived ?? this.isArchived,
      archivedBy: archivedBy ?? this.archivedBy,
      archivedAt: archivedAt ?? this.archivedAt,
    );
  }
}

DateTime? _dateTimeFromDynamic(dynamic value) {
  if (value == null) {
    return null;
  }

  if (value is DateTime) {
    return value;
  }

  if (value is Timestamp) {
    return value.toDate();
  }

  if (value is String) {
    return DateTime.tryParse(value);
  }

  return null;
}

List<String> _stringListFromDynamic(dynamic value) {
  if (value is Iterable) {
    return value.whereType<String>().toList(growable: false);
  }

  return const <String>[];
}


int _intFromDynamic(dynamic value, {int fallback = 0}) {
  if (value == null) {
    return fallback;
  }

  if (value is int) {
    return value;
  }

  if (value is num) {
    return value.toInt();
  }

  if (value is String) {
    return int.tryParse(value.trim()) ?? fallback;
  }

  return fallback;
}

int? _budgetFromDynamic(dynamic value) {
  if (value == null) {
    return null;
  }

  if (value is int) {
    return value;
  }

  if (value is num) {
    return value.toInt();
  }

  if (value is String) {
    return int.tryParse(value.trim());
  }

  return null;
}

Map<String, dynamic>? _mapFromDynamic(dynamic value) {
  if (value is Map<String, dynamic>) {
    return value;
  }

  if (value is Map) {
    return value.map(
      (key, dynamic nestedValue) => MapEntry('$key', nestedValue),
    );
  }

  return null;
}

LeadTravelDatesModel? _leadTravelDatesFromDynamic(dynamic value) {
  final map = _mapFromDynamic(value);
  if (map == null) {
    return null;
  }

  return LeadTravelDatesModel.fromMap(map);
}

LeadHealthModel? _leadHealthFromDynamic(dynamic value) {
  final map = _mapFromDynamic(value);
  if (map == null) {
    return null;
  }

  return LeadHealthModel.fromMap(map);
}

PassengerCountModel? _passengerCountFromDynamic(dynamic value) {
  final map = _mapFromDynamic(value);
  if (map == null) {
    return null;
  }

  return PassengerCountModel.fromMap(map);
}

TravelType _travelTypeFromDynamic(dynamic value) {
  if (value is TravelType) {
    return value;
  }

  if (value is String && value.trim().isNotEmpty) {
    try {
      return TravelTypeX.fromString(value);
    } on ArgumentError {
      return TravelType.fit;
    }
  }

  return TravelType.fit;
}

TripScope _tripScopeFromDynamic(dynamic value) {
  if (value is TripScope) {
    return value;
  }

  if (value is String && value.trim().isNotEmpty) {
    try {
      return TripScopeX.fromString(value);
    } on ArgumentError {
      return TripScope.international;
    }
  }

  return TripScope.international;
}

LeadStage _leadStageFromDynamic(dynamic value) {
  if (value is LeadStage) {
    return value;
  }

  if (value is String && value.trim().isNotEmpty) {
    try {
      return LeadStageX.fromString(value);
    } on ArgumentError {
      return LeadStage.newLead;
    }
  }

  return LeadStage.newLead;
}
