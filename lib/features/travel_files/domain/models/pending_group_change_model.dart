import 'package:cloud_firestore/cloud_firestore.dart';

import 'package:kayraholidaymapscrm/core/constants/app_enums.dart';

class PendingGroupChangeModel {
  const PendingGroupChangeModel({
    required this.id,
    this.changeType,
    this.fieldName,
    this.oldValue,
    this.newValue,
    this.reason,
    this.approvalStatus = PendingApprovalStatus.pendingApproval,
    this.requestedBy,
    this.requestedAt,
    this.reviewedBy,
    this.reviewedAt,
    this.rejectionReason,
    this.createdBy,
    this.createdAt,
    this.updatedBy,
    this.updatedAt,
    this.isArchived = false,
    this.archivedBy,
    this.archivedAt,
  });

  final String id;
  final String? changeType;
  final String? fieldName;
  final String? oldValue;
  final String? newValue;
  final String? reason;
  final PendingApprovalStatus approvalStatus;
  final String? requestedBy;
  final DateTime? requestedAt;
  final String? reviewedBy;
  final DateTime? reviewedAt;
  final String? rejectionReason;
  final String? createdBy;
  final DateTime? createdAt;
  final String? updatedBy;
  final DateTime? updatedAt;
  final bool isArchived;
  final String? archivedBy;
  final DateTime? archivedAt;

  factory PendingGroupChangeModel.fromMap(Map<String, dynamic> map) {
    return PendingGroupChangeModel(
      id: (map['id'] as String?) ?? '',
      changeType: map['changeType'] as String?,
      fieldName: map['fieldName'] as String?,
      oldValue: map['oldValue']?.toString(),
      newValue: map['newValue']?.toString(),
      reason: map['reason'] as String?,
      approvalStatus: _pendingApprovalStatusFromDynamic(map['approvalStatus']),
      requestedBy: map['requestedBy'] as String?,
      requestedAt: _dateTimeFromDynamic(map['requestedAt']),
      reviewedBy: map['reviewedBy'] as String?,
      reviewedAt: _dateTimeFromDynamic(map['reviewedAt']),
      rejectionReason: map['rejectionReason'] as String?,
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
      'changeType': changeType,
      'fieldName': fieldName,
      'oldValue': oldValue,
      'newValue': newValue,
      'reason': reason,
      'approvalStatus': approvalStatus.firestoreValue,
      'requestedBy': requestedBy,
      'requestedAt': requestedAt,
      'reviewedBy': reviewedBy,
      'reviewedAt': reviewedAt,
      'rejectionReason': rejectionReason,
      'createdBy': createdBy,
      'createdAt': createdAt,
      'updatedBy': updatedBy,
      'updatedAt': updatedAt,
      'isArchived': isArchived,
      'archivedBy': archivedBy,
      'archivedAt': archivedAt,
    };
  }

  PendingGroupChangeModel copyWith({
    String? id,
    String? changeType,
    String? fieldName,
    String? oldValue,
    String? newValue,
    String? reason,
    PendingApprovalStatus? approvalStatus,
    String? requestedBy,
    DateTime? requestedAt,
    String? reviewedBy,
    DateTime? reviewedAt,
    String? rejectionReason,
    String? createdBy,
    DateTime? createdAt,
    String? updatedBy,
    DateTime? updatedAt,
    bool? isArchived,
    String? archivedBy,
    DateTime? archivedAt,
  }) {
    return PendingGroupChangeModel(
      id: id ?? this.id,
      changeType: changeType ?? this.changeType,
      fieldName: fieldName ?? this.fieldName,
      oldValue: oldValue ?? this.oldValue,
      newValue: newValue ?? this.newValue,
      reason: reason ?? this.reason,
      approvalStatus: approvalStatus ?? this.approvalStatus,
      requestedBy: requestedBy ?? this.requestedBy,
      requestedAt: requestedAt ?? this.requestedAt,
      reviewedBy: reviewedBy ?? this.reviewedBy,
      reviewedAt: reviewedAt ?? this.reviewedAt,
      rejectionReason: rejectionReason ?? this.rejectionReason,
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
  if (value == null) return null;
  if (value is DateTime) return value;
  if (value is Timestamp) return value.toDate();
  if (value is String) return DateTime.tryParse(value);
  return null;
}

List<String> _stringListFromDynamic(dynamic value) {
  if (value is Iterable) {
    return value.whereType<String>().toList(growable: false);
  }

  return const <String>[];
}

Map<String, dynamic>? _mapFromDynamic(dynamic value) {
  if (value is Map<String, dynamic>) return value;
  if (value is Map) return value.map((key, dynamic nestedValue) => MapEntry('$key', nestedValue));
  return null;
}

PendingApprovalStatus _pendingApprovalStatusFromDynamic(dynamic value) {
  if (value is PendingApprovalStatus) return value;
  if (value is String && value.trim().isNotEmpty) {
    try { return PendingApprovalStatusX.fromString(value); } on ArgumentError { return PendingApprovalStatus.pendingApproval; }
  }
  return PendingApprovalStatus.pendingApproval;
}

PaymentType _paymentTypeFromDynamic(dynamic value) {
  if (value is PaymentType) return value;
  if (value is String && value.trim().isNotEmpty) {
    try { return PaymentTypeX.fromString(value); } on ArgumentError { return PaymentType.advance; }
  }
  return PaymentType.advance;
}

PaymentStatus _paymentStatusFromDynamic(dynamic value) {
  if (value is PaymentStatus) return value;
  if (value is String && value.trim().isNotEmpty) {
    try { return PaymentStatusX.fromString(value); } on ArgumentError { return PaymentStatus.pendingAuthorization; }
  }
  return PaymentStatus.pendingAuthorization;
}
