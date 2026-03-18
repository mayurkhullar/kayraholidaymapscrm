import 'package:cloud_firestore/cloud_firestore.dart';

class LeadOwnershipHistoryModel {
  const LeadOwnershipHistoryModel({
    required this.id,
    this.fromOwnerId,
    this.toOwnerId,
    this.changedBy,
    this.changedByRole,
    this.reason,
    this.changedAt,
    this.createdBy,
    this.createdAt,
    this.updatedBy,
    this.updatedAt,
    this.isArchived = false,
    this.archivedBy,
    this.archivedAt,
  });

  final String id;
  final String? fromOwnerId;
  final String? toOwnerId;
  final String? changedBy;
  final String? changedByRole;
  final String? reason;
  final DateTime? changedAt;
  final String? createdBy;
  final DateTime? createdAt;
  final String? updatedBy;
  final DateTime? updatedAt;
  final bool isArchived;
  final String? archivedBy;
  final DateTime? archivedAt;

  factory LeadOwnershipHistoryModel.fromMap(Map<String, dynamic> map) {
    return LeadOwnershipHistoryModel(
      id: (map['id'] as String?) ?? '',
      fromOwnerId: map['fromOwnerId'] as String?,
      toOwnerId: map['toOwnerId'] as String?,
      changedBy: map['changedBy'] as String?,
      changedByRole: map['changedByRole'] as String?,
      reason: map['reason'] as String?,
      changedAt: _dateTimeFromDynamic(map['changedAt']),
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
      'fromOwnerId': fromOwnerId,
      'toOwnerId': toOwnerId,
      'changedBy': changedBy,
      'changedByRole': changedByRole,
      'reason': reason,
      'changedAt': changedAt,
      'createdBy': createdBy,
      'createdAt': createdAt,
      'updatedBy': updatedBy,
      'updatedAt': updatedAt,
      'isArchived': isArchived,
      'archivedBy': archivedBy,
      'archivedAt': archivedAt,
    };
  }

  LeadOwnershipHistoryModel copyWith({
    String? id,
    String? fromOwnerId,
    String? toOwnerId,
    String? changedBy,
    String? changedByRole,
    String? reason,
    DateTime? changedAt,
    String? createdBy,
    DateTime? createdAt,
    String? updatedBy,
    DateTime? updatedAt,
    bool? isArchived,
    String? archivedBy,
    DateTime? archivedAt,
  }) {
    return LeadOwnershipHistoryModel(
      id: id ?? this.id,
      fromOwnerId: fromOwnerId ?? this.fromOwnerId,
      toOwnerId: toOwnerId ?? this.toOwnerId,
      changedBy: changedBy ?? this.changedBy,
      changedByRole: changedByRole ?? this.changedByRole,
      reason: reason ?? this.reason,
      changedAt: changedAt ?? this.changedAt,
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
