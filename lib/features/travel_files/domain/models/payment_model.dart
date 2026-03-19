import 'package:cloud_firestore/cloud_firestore.dart';

import 'package:kayraholidaymapscrm/core/constants/app_enums.dart';

class PaymentModel {
  const PaymentModel({
    required this.id,
    this.paymentCode,
    this.travelFileId,
    this.travelFileCode,
    this.clientId,
    this.companyId,
    this.amount,
    this.currency = 'INR',
    this.paymentType = PaymentType.advance,
    this.paymentMethod,
    this.creditedAccountId,
    this.creditedAccountName,
    this.paymentDate,
    this.referenceNumber,
    this.remarks,
    this.status = PaymentStatus.pendingAuthorization,
    this.authorizedBy,
    this.authorizedAt,
    this.rejectedBy,
    this.rejectedAt,
    this.rejectionReason,
    this.flagCount = 0,
    this.hasOpenIssueFlag = false,
    this.createdBy,
    this.createdAt,
    this.updatedBy,
    this.updatedAt,
    this.isArchived = false,
    this.archivedBy,
    this.archivedAt,
  });

  final String id;
  final String? paymentCode;
  final String? travelFileId;
  final String? travelFileCode;
  final String? clientId;
  final String? companyId;
  final double? amount;
  final String currency;
  final PaymentType paymentType;
  final String? paymentMethod;
  final String? creditedAccountId;
  final String? creditedAccountName;
  final DateTime? paymentDate;
  final String? referenceNumber;
  final String? remarks;
  final PaymentStatus status;
  final String? authorizedBy;
  final DateTime? authorizedAt;
  final String? rejectedBy;
  final DateTime? rejectedAt;
  final String? rejectionReason;
  final int flagCount;
  final bool hasOpenIssueFlag;
  final String? createdBy;
  final DateTime? createdAt;
  final String? updatedBy;
  final DateTime? updatedAt;
  final bool isArchived;
  final String? archivedBy;
  final DateTime? archivedAt;

  factory PaymentModel.fromMap(Map<String, dynamic> map) {
    return PaymentModel(
      id: (map['id'] as String?) ?? '',
      paymentCode: map['paymentCode'] as String?,
      travelFileId: map['travelFileId'] as String?,
      travelFileCode: map['travelFileCode'] as String?,
      clientId: map['clientId'] as String?,
      companyId: map['companyId'] as String?,
      amount: (map['amount'] as num?)?.toDouble(),
      currency: (map['currency'] as String?)?.trim().isNotEmpty == true ? (map['currency'] as String).trim() : 'INR',
      paymentType: _paymentTypeFromDynamic(map['paymentType']),
      paymentMethod: map['paymentMethod'] as String?,
      creditedAccountId: map['creditedAccountId'] as String?,
      creditedAccountName: map['creditedAccountName'] as String?,
      paymentDate: _dateTimeFromDynamic(map['paymentDate']),
      referenceNumber: map['referenceNumber'] as String?,
      remarks: map['remarks'] as String?,
      status: _paymentStatusFromDynamic(map['status']),
      authorizedBy: map['authorizedBy'] as String?,
      authorizedAt: _dateTimeFromDynamic(map['authorizedAt']),
      rejectedBy: map['rejectedBy'] as String?,
      rejectedAt: _dateTimeFromDynamic(map['rejectedAt']),
      rejectionReason: map['rejectionReason'] as String?,
      flagCount: (map['flagCount'] as num?)?.toInt() ?? 0,
      hasOpenIssueFlag: (map['hasOpenIssueFlag'] as bool?) ?? false,
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
      'paymentCode': paymentCode,
      'travelFileId': travelFileId,
      'travelFileCode': travelFileCode,
      'clientId': clientId,
      'companyId': companyId,
      'amount': amount,
      'currency': currency,
      'paymentType': paymentType.firestoreValue,
      'paymentMethod': paymentMethod,
      'creditedAccountId': creditedAccountId,
      'creditedAccountName': creditedAccountName,
      'paymentDate': paymentDate,
      'referenceNumber': referenceNumber,
      'remarks': remarks,
      'status': status.firestoreValue,
      'authorizedBy': authorizedBy,
      'authorizedAt': authorizedAt,
      'rejectedBy': rejectedBy,
      'rejectedAt': rejectedAt,
      'rejectionReason': rejectionReason,
      'flagCount': flagCount,
      'hasOpenIssueFlag': hasOpenIssueFlag,
      'createdBy': createdBy,
      'createdAt': createdAt,
      'updatedBy': updatedBy,
      'updatedAt': updatedAt,
      'isArchived': isArchived,
      'archivedBy': archivedBy,
      'archivedAt': archivedAt,
    };
  }

  PaymentModel copyWith({
    String? id,
    String? paymentCode,
    String? travelFileId,
    String? travelFileCode,
    String? clientId,
    String? companyId,
    double? amount,
    String? currency,
    PaymentType? paymentType,
    String? paymentMethod,
    String? creditedAccountId,
    String? creditedAccountName,
    DateTime? paymentDate,
    String? referenceNumber,
    String? remarks,
    PaymentStatus? status,
    String? authorizedBy,
    DateTime? authorizedAt,
    String? rejectedBy,
    DateTime? rejectedAt,
    String? rejectionReason,
    int? flagCount,
    bool? hasOpenIssueFlag,
    String? createdBy,
    DateTime? createdAt,
    String? updatedBy,
    DateTime? updatedAt,
    bool? isArchived,
    String? archivedBy,
    DateTime? archivedAt,
  }) {
    return PaymentModel(
      id: id ?? this.id,
      paymentCode: paymentCode ?? this.paymentCode,
      travelFileId: travelFileId ?? this.travelFileId,
      travelFileCode: travelFileCode ?? this.travelFileCode,
      clientId: clientId ?? this.clientId,
      companyId: companyId ?? this.companyId,
      amount: amount ?? this.amount,
      currency: currency ?? this.currency,
      paymentType: paymentType ?? this.paymentType,
      paymentMethod: paymentMethod ?? this.paymentMethod,
      creditedAccountId: creditedAccountId ?? this.creditedAccountId,
      creditedAccountName: creditedAccountName ?? this.creditedAccountName,
      paymentDate: paymentDate ?? this.paymentDate,
      referenceNumber: referenceNumber ?? this.referenceNumber,
      remarks: remarks ?? this.remarks,
      status: status ?? this.status,
      authorizedBy: authorizedBy ?? this.authorizedBy,
      authorizedAt: authorizedAt ?? this.authorizedAt,
      rejectedBy: rejectedBy ?? this.rejectedBy,
      rejectedAt: rejectedAt ?? this.rejectedAt,
      rejectionReason: rejectionReason ?? this.rejectionReason,
      flagCount: flagCount ?? this.flagCount,
      hasOpenIssueFlag: hasOpenIssueFlag ?? this.hasOpenIssueFlag,
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
