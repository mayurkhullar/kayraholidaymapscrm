import 'package:cloud_firestore/cloud_firestore.dart';

class AccessAssignmentModel {
  const AccessAssignmentModel({
    required this.id,
    this.userId,
    this.userRole,
    this.accessLevel,
    this.status,
    this.assignedBy,
    this.assignedAt,
    this.revokedBy,
    this.revokedAt,
    this.remarks,
    this.createdBy,
    this.createdAt,
    this.updatedBy,
    this.updatedAt,
    this.isArchived = false,
    this.archivedBy,
    this.archivedAt,
  });

  final String id;
  final String? userId;
  final String? userRole;
  final String? accessLevel;
  final String? status;
  final String? assignedBy;
  final DateTime? assignedAt;
  final String? revokedBy;
  final DateTime? revokedAt;
  final String? remarks;
  final String? createdBy;
  final DateTime? createdAt;
  final String? updatedBy;
  final DateTime? updatedAt;
  final bool isArchived;
  final String? archivedBy;
  final DateTime? archivedAt;

  factory AccessAssignmentModel.fromMap(Map<String, dynamic> map) {
    return AccessAssignmentModel(
      id: (map['id'] as String?) ?? '',
      userId: map['userId'] as String?,
      userRole: map['userRole'] as String?,
      accessLevel: map['accessLevel'] as String?,
      status: map['status'] as String?,
      assignedBy: map['assignedBy'] as String?,
      assignedAt: _dateTimeFromDynamic(map['assignedAt']),
      revokedBy: map['revokedBy'] as String?,
      revokedAt: _dateTimeFromDynamic(map['revokedAt']),
      remarks: map['remarks'] as String?,
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
      'userId': userId,
      'userRole': userRole,
      'accessLevel': accessLevel,
      'status': status,
      'assignedBy': assignedBy,
      'assignedAt': assignedAt,
      'revokedBy': revokedBy,
      'revokedAt': revokedAt,
      'remarks': remarks,
      'createdBy': createdBy,
      'createdAt': createdAt,
      'updatedBy': updatedBy,
      'updatedAt': updatedAt,
      'isArchived': isArchived,
      'archivedBy': archivedBy,
      'archivedAt': archivedAt,
    };
  }

  AccessAssignmentModel copyWith({
    String? id,
    String? userId,
    String? userRole,
    String? accessLevel,
    String? status,
    String? assignedBy,
    DateTime? assignedAt,
    String? revokedBy,
    DateTime? revokedAt,
    String? remarks,
    String? createdBy,
    DateTime? createdAt,
    String? updatedBy,
    DateTime? updatedAt,
    bool? isArchived,
    String? archivedBy,
    DateTime? archivedAt,
  }) {
    return AccessAssignmentModel(
      id: id ?? this.id,
      userId: userId ?? this.userId,
      userRole: userRole ?? this.userRole,
      accessLevel: accessLevel ?? this.accessLevel,
      status: status ?? this.status,
      assignedBy: assignedBy ?? this.assignedBy,
      assignedAt: assignedAt ?? this.assignedAt,
      revokedBy: revokedBy ?? this.revokedBy,
      revokedAt: revokedAt ?? this.revokedAt,
      remarks: remarks ?? this.remarks,
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
