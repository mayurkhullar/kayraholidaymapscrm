import 'package:cloud_firestore/cloud_firestore.dart';

import 'package:kayraholidaymapscrm/core/constants/app_enums.dart';

class PriceChangeLogModel {
  const PriceChangeLogModel({
    required this.id,
    this.changeCode,
    this.sourceQuotationId,
    this.sourceQuotationCode,
    this.changeType,
    this.oldSellingPrice,
    this.newSellingPrice,
    this.oldVendorCost,
    this.newVendorCost,
    this.oldProfit,
    this.newProfit,
    this.reason,
    this.requestedBy,
    this.requestedByRole,
    this.requestedAt,
    this.approvalStatus = PendingApprovalStatus.pendingApproval,
    this.approvedBy,
    this.approvedAt,
    this.rejectedBy,
    this.rejectedAt,
    this.rejectionReason,
    this.revisedAmountDue,
    this.revisedAmountReceived,
    this.isResolved = false,
    this.requiresAttention = true,
    this.createdBy,
    this.createdAt,
    this.updatedBy,
    this.updatedAt,
    this.isArchived = false,
    this.archivedBy,
    this.archivedAt,
  });

  final String id;
  final String? changeCode;
  final String? sourceQuotationId;
  final String? sourceQuotationCode;
  final String? changeType;
  final double? oldSellingPrice;
  final double? newSellingPrice;
  final double? oldVendorCost;
  final double? newVendorCost;
  final double? oldProfit;
  final double? newProfit;
  final String? reason;
  final String? requestedBy;
  final String? requestedByRole;
  final DateTime? requestedAt;
  final PendingApprovalStatus approvalStatus;
  final String? approvedBy;
  final DateTime? approvedAt;
  final String? rejectedBy;
  final DateTime? rejectedAt;
  final String? rejectionReason;
  final double? revisedAmountDue;
  final double? revisedAmountReceived;
  final bool isResolved;
  final bool requiresAttention;
  final String? createdBy;
  final DateTime? createdAt;
  final String? updatedBy;
  final DateTime? updatedAt;
  final bool isArchived;
  final String? archivedBy;
  final DateTime? archivedAt;

  factory PriceChangeLogModel.fromMap(Map<String, dynamic> map) {
    return PriceChangeLogModel(
      id: (map['id'] as String?) ?? '',
      changeCode: map['changeCode'] as String?,
      sourceQuotationId: map['sourceQuotationId'] as String?,
      sourceQuotationCode: map['sourceQuotationCode'] as String?,
      changeType: map['changeType'] as String?,
      oldSellingPrice: (map['oldSellingPrice'] as num?)?.toDouble(),
      newSellingPrice: (map['newSellingPrice'] as num?)?.toDouble(),
      oldVendorCost: (map['oldVendorCost'] as num?)?.toDouble(),
      newVendorCost: (map['newVendorCost'] as num?)?.toDouble(),
      oldProfit: (map['oldProfit'] as num?)?.toDouble(),
      newProfit: (map['newProfit'] as num?)?.toDouble(),
      reason: map['reason'] as String?,
      requestedBy: map['requestedBy'] as String?,
      requestedByRole: map['requestedByRole'] as String?,
      requestedAt: _dateTimeFromDynamic(map['requestedAt']),
      approvalStatus: _pendingApprovalStatusFromDynamic(map['approvalStatus']),
      approvedBy: map['approvedBy'] as String?,
      approvedAt: _dateTimeFromDynamic(map['approvedAt']),
      rejectedBy: map['rejectedBy'] as String?,
      rejectedAt: _dateTimeFromDynamic(map['rejectedAt']),
      rejectionReason: map['rejectionReason'] as String?,
      revisedAmountDue: (map['revisedAmountDue'] as num?)?.toDouble(),
      revisedAmountReceived: (map['revisedAmountReceived'] as num?)?.toDouble(),
      isResolved: (map['isResolved'] as bool?) ?? false,
      requiresAttention: (map['requiresAttention'] as bool?) ?? true,
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
      'changeCode': changeCode,
      'sourceQuotationId': sourceQuotationId,
      'sourceQuotationCode': sourceQuotationCode,
      'changeType': changeType,
      'oldSellingPrice': oldSellingPrice,
      'newSellingPrice': newSellingPrice,
      'oldVendorCost': oldVendorCost,
      'newVendorCost': newVendorCost,
      'oldProfit': oldProfit,
      'newProfit': newProfit,
      'reason': reason,
      'requestedBy': requestedBy,
      'requestedByRole': requestedByRole,
      'requestedAt': requestedAt,
      'approvalStatus': approvalStatus.firestoreValue,
      'approvedBy': approvedBy,
      'approvedAt': approvedAt,
      'rejectedBy': rejectedBy,
      'rejectedAt': rejectedAt,
      'rejectionReason': rejectionReason,
      'revisedAmountDue': revisedAmountDue,
      'revisedAmountReceived': revisedAmountReceived,
      'isResolved': isResolved,
      'requiresAttention': requiresAttention,
      'createdBy': createdBy,
      'createdAt': createdAt,
      'updatedBy': updatedBy,
      'updatedAt': updatedAt,
      'isArchived': isArchived,
      'archivedBy': archivedBy,
      'archivedAt': archivedAt,
    };
  }

  PriceChangeLogModel copyWith({
    String? id,
    String? changeCode,
    String? sourceQuotationId,
    String? sourceQuotationCode,
    String? changeType,
    double? oldSellingPrice,
    double? newSellingPrice,
    double? oldVendorCost,
    double? newVendorCost,
    double? oldProfit,
    double? newProfit,
    String? reason,
    String? requestedBy,
    String? requestedByRole,
    DateTime? requestedAt,
    PendingApprovalStatus? approvalStatus,
    String? approvedBy,
    DateTime? approvedAt,
    String? rejectedBy,
    DateTime? rejectedAt,
    String? rejectionReason,
    double? revisedAmountDue,
    double? revisedAmountReceived,
    bool? isResolved,
    bool? requiresAttention,
    String? createdBy,
    DateTime? createdAt,
    String? updatedBy,
    DateTime? updatedAt,
    bool? isArchived,
    String? archivedBy,
    DateTime? archivedAt,
  }) {
    return PriceChangeLogModel(
      id: id ?? this.id,
      changeCode: changeCode ?? this.changeCode,
      sourceQuotationId: sourceQuotationId ?? this.sourceQuotationId,
      sourceQuotationCode: sourceQuotationCode ?? this.sourceQuotationCode,
      changeType: changeType ?? this.changeType,
      oldSellingPrice: oldSellingPrice ?? this.oldSellingPrice,
      newSellingPrice: newSellingPrice ?? this.newSellingPrice,
      oldVendorCost: oldVendorCost ?? this.oldVendorCost,
      newVendorCost: newVendorCost ?? this.newVendorCost,
      oldProfit: oldProfit ?? this.oldProfit,
      newProfit: newProfit ?? this.newProfit,
      reason: reason ?? this.reason,
      requestedBy: requestedBy ?? this.requestedBy,
      requestedByRole: requestedByRole ?? this.requestedByRole,
      requestedAt: requestedAt ?? this.requestedAt,
      approvalStatus: approvalStatus ?? this.approvalStatus,
      approvedBy: approvedBy ?? this.approvedBy,
      approvedAt: approvedAt ?? this.approvedAt,
      rejectedBy: rejectedBy ?? this.rejectedBy,
      rejectedAt: rejectedAt ?? this.rejectedAt,
      rejectionReason: rejectionReason ?? this.rejectionReason,
      revisedAmountDue: revisedAmountDue ?? this.revisedAmountDue,
      revisedAmountReceived: revisedAmountReceived ?? this.revisedAmountReceived,
      isResolved: isResolved ?? this.isResolved,
      requiresAttention: requiresAttention ?? this.requiresAttention,
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
