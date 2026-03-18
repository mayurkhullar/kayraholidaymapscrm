import 'package:cloud_firestore/cloud_firestore.dart';

import 'package:kayraholidaymapscrm/core/constants/app_enums.dart';
import 'package:kayraholidaymapscrm/shared/models/date_range_model.dart';
import 'package:kayraholidaymapscrm/shared/models/passenger_count_model.dart';

import 'confirmed_quotation_snapshot_model.dart';
import 'current_commercial_state_model.dart';
import 'group_alerts_model.dart';
import 'group_readiness_model.dart';

class TravelFileModel {
  const TravelFileModel({
    required this.id,
    this.travelFileCode,
    this.sourceLeadId,
    this.sourceLeadCode,
    this.clientId,
    this.companyId,
    this.ownerId,
    this.teamId,
    this.travelType = TravelType.fit,
    this.tripScope = TripScope.international,
    this.title,
    this.destination,
    this.travelDates,
    this.status,
    this.passengerCount,
    this.isGroupDashboardEnabled = false,
    this.confirmedQuotationSnapshot,
    this.currentCommercialState,
    this.groupReadiness,
    this.groupAlerts,
    this.createdBy,
    this.createdAt,
    this.updatedBy,
    this.updatedAt,
    this.isArchived = false,
    this.archivedBy,
    this.archivedAt,
  });

  final String id;
  final String? travelFileCode;
  final String? sourceLeadId;
  final String? sourceLeadCode;
  final String? clientId;
  final String? companyId;
  final String? ownerId;
  final String? teamId;
  final TravelType travelType;
  final TripScope tripScope;
  final String? title;
  final String? destination;
  final DateRangeModel? travelDates;
  final String? status;
  final PassengerCountModel? passengerCount;
  final bool isGroupDashboardEnabled;
  final ConfirmedQuotationSnapshotModel? confirmedQuotationSnapshot;
  final CurrentCommercialStateModel? currentCommercialState;
  final GroupReadinessModel? groupReadiness;
  final GroupAlertsModel? groupAlerts;
  final String? createdBy;
  final DateTime? createdAt;
  final String? updatedBy;
  final DateTime? updatedAt;
  final bool isArchived;
  final String? archivedBy;
  final DateTime? archivedAt;

  factory TravelFileModel.fromMap(Map<String, dynamic> map) {
    return TravelFileModel(
      id: (map['id'] as String?) ?? '',
      travelFileCode: map['travelFileCode'] as String?,
      sourceLeadId: map['sourceLeadId'] as String?,
      sourceLeadCode: map['sourceLeadCode'] as String?,
      clientId: map['clientId'] as String?,
      companyId: map['companyId'] as String?,
      ownerId: map['ownerId'] as String?,
      teamId: map['teamId'] as String?,
      travelType: _travelTypeFromDynamic(map['travelType']),
      tripScope: _tripScopeFromDynamic(map['tripScope']),
      title: map['title'] as String?,
      destination: map['destination'] as String?,
      travelDates: _dateRangeFromDynamic(map['travelDates']),
      status: map['status'] as String?,
      passengerCount: _passengerCountFromDynamic(map['passengerCount']),
      isGroupDashboardEnabled: (map['isGroupDashboardEnabled'] as bool?) ?? false,
      confirmedQuotationSnapshot: _confirmedQuotationSnapshotFromDynamic(map['confirmedQuotationSnapshot']),
      currentCommercialState: _currentCommercialStateFromDynamic(map['currentCommercialState']),
      groupReadiness: _groupReadinessFromDynamic(map['groupReadiness']),
      groupAlerts: _groupAlertsFromDynamic(map['groupAlerts']),
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
      'travelFileCode': travelFileCode,
      'sourceLeadId': sourceLeadId,
      'sourceLeadCode': sourceLeadCode,
      'clientId': clientId,
      'companyId': companyId,
      'ownerId': ownerId,
      'teamId': teamId,
      'travelType': travelType.firestoreValue,
      'tripScope': tripScope.firestoreValue,
      'title': title,
      'destination': destination,
      'travelDates': travelDates?.toMap(),
      'status': status,
      'passengerCount': passengerCount?.toMap(),
      'isGroupDashboardEnabled': isGroupDashboardEnabled,
      'confirmedQuotationSnapshot': confirmedQuotationSnapshot?.toMap(),
      'currentCommercialState': currentCommercialState?.toMap(),
      'groupReadiness': groupReadiness?.toMap(),
      'groupAlerts': groupAlerts?.toMap(),
      'createdBy': createdBy,
      'createdAt': createdAt,
      'updatedBy': updatedBy,
      'updatedAt': updatedAt,
      'isArchived': isArchived,
      'archivedBy': archivedBy,
      'archivedAt': archivedAt,
    };
  }

  TravelFileModel copyWith({String? id,String? travelFileCode,String? sourceLeadId,String? sourceLeadCode,String? clientId,String? companyId,String? ownerId,String? teamId,TravelType? travelType,TripScope? tripScope,String? title,String? destination,DateRangeModel? travelDates,String? status,PassengerCountModel? passengerCount,bool? isGroupDashboardEnabled,ConfirmedQuotationSnapshotModel? confirmedQuotationSnapshot,CurrentCommercialStateModel? currentCommercialState,GroupReadinessModel? groupReadiness,GroupAlertsModel? groupAlerts,String? createdBy,DateTime? createdAt,String? updatedBy,DateTime? updatedAt,bool? isArchived,String? archivedBy,DateTime? archivedAt,}) {
    return TravelFileModel(id: id ?? this.id,travelFileCode: travelFileCode ?? this.travelFileCode,sourceLeadId: sourceLeadId ?? this.sourceLeadId,sourceLeadCode: sourceLeadCode ?? this.sourceLeadCode,clientId: clientId ?? this.clientId,companyId: companyId ?? this.companyId,ownerId: ownerId ?? this.ownerId,teamId: teamId ?? this.teamId,travelType: travelType ?? this.travelType,tripScope: tripScope ?? this.tripScope,title: title ?? this.title,destination: destination ?? this.destination,travelDates: travelDates ?? this.travelDates,status: status ?? this.status,passengerCount: passengerCount ?? this.passengerCount,isGroupDashboardEnabled: isGroupDashboardEnabled ?? this.isGroupDashboardEnabled,confirmedQuotationSnapshot: confirmedQuotationSnapshot ?? this.confirmedQuotationSnapshot,currentCommercialState: currentCommercialState ?? this.currentCommercialState,groupReadiness: groupReadiness ?? this.groupReadiness,groupAlerts: groupAlerts ?? this.groupAlerts,createdBy: createdBy ?? this.createdBy,createdAt: createdAt ?? this.createdAt,updatedBy: updatedBy ?? this.updatedBy,updatedAt: updatedAt ?? this.updatedAt,isArchived: isArchived ?? this.isArchived,archivedBy: archivedBy ?? this.archivedBy,archivedAt: archivedAt ?? this.archivedAt,);
  }
}

DateRangeModel? _dateRangeFromDynamic(dynamic value) { final map = _mapFromDynamic(value); return map == null ? null : DateRangeModel.fromMap(map); }
PassengerCountModel? _passengerCountFromDynamic(dynamic value) { final map = _mapFromDynamic(value); return map == null ? null : PassengerCountModel.fromMap(map); }
ConfirmedQuotationSnapshotModel? _confirmedQuotationSnapshotFromDynamic(dynamic value) { final map = _mapFromDynamic(value); return map == null ? null : ConfirmedQuotationSnapshotModel.fromMap(map); }
CurrentCommercialStateModel? _currentCommercialStateFromDynamic(dynamic value) { final map = _mapFromDynamic(value); return map == null ? null : CurrentCommercialStateModel.fromMap(map); }
GroupReadinessModel? _groupReadinessFromDynamic(dynamic value) { final map = _mapFromDynamic(value); return map == null ? null : GroupReadinessModel.fromMap(map); }
GroupAlertsModel? _groupAlertsFromDynamic(dynamic value) { final map = _mapFromDynamic(value); return map == null ? null : GroupAlertsModel.fromMap(map); }

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

Map<String, dynamic>? _mapFromDynamic(dynamic value) {
  if (value is Map<String, dynamic>) {
    return value;
  }

  if (value is Map) {
    return value.map((key, dynamic nestedValue) => MapEntry('$key', nestedValue));
  }

  return null;
}

List<String> _stringListFromDynamic(dynamic value) {
  if (value is Iterable) {
    return value.whereType<String>().toList(growable: false);
  }

  return const <String>[];
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

PaymentType _paymentTypeFromDynamic(dynamic value) {
  if (value is PaymentType) {
    return value;
  }

  if (value is String && value.trim().isNotEmpty) {
    try {
      return PaymentTypeX.fromString(value);
    } on ArgumentError {
      return PaymentType.advance;
    }
  }

  return PaymentType.advance;
}

PaymentStatus _paymentStatusFromDynamic(dynamic value) {
  if (value is PaymentStatus) {
    return value;
  }

  if (value is String && value.trim().isNotEmpty) {
    try {
      return PaymentStatusX.fromString(value);
    } on ArgumentError {
      return PaymentStatus.pendingAuthorization;
    }
  }

  return PaymentStatus.pendingAuthorization;
}

PendingApprovalStatus _pendingApprovalStatusFromDynamic(dynamic value) {
  if (value is PendingApprovalStatus) {
    return value;
  }

  if (value is String && value.trim().isNotEmpty) {
    try {
      return PendingApprovalStatusX.fromString(value);
    } on ArgumentError {
      return PendingApprovalStatus.pendingApproval;
    }
  }

  return PendingApprovalStatus.pendingApproval;
}
