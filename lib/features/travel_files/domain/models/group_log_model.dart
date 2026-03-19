import 'package:cloud_firestore/cloud_firestore.dart';

class GroupLogModel {
  const GroupLogModel({
    required this.id,
    this.logType,
    this.message,
    this.note,
    this.loggedBy,
    this.loggedAt,
    this.createdBy,
    this.createdAt,
    this.updatedBy,
    this.updatedAt,
    this.isArchived = false,
    this.archivedBy,
    this.archivedAt,
  });

  final String id;
  final String? logType;
  final String? message;
  final String? note;
  final String? loggedBy;
  final DateTime? loggedAt;
  final String? createdBy;
  final DateTime? createdAt;
  final String? updatedBy;
  final DateTime? updatedAt;
  final bool isArchived;
  final String? archivedBy;
  final DateTime? archivedAt;

  factory GroupLogModel.fromMap(Map<String, dynamic> map) {
    return GroupLogModel(
      id: (map['id'] as String?) ?? '',
      logType: map['logType'] as String?,
      message: map['message'] as String?,
      note: map['note'] as String?,
      loggedBy: map['loggedBy'] as String?,
      loggedAt: _dateTimeFromDynamic(map['loggedAt']),
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
      'logType': logType,
      'message': message,
      'note': note,
      'loggedBy': loggedBy,
      'loggedAt': loggedAt,
      'createdBy': createdBy,
      'createdAt': createdAt,
      'updatedBy': updatedBy,
      'updatedAt': updatedAt,
      'isArchived': isArchived,
      'archivedBy': archivedBy,
      'archivedAt': archivedAt,
    };
  }

  GroupLogModel copyWith({
    String? id,
    String? logType,
    String? message,
    String? note,
    String? loggedBy,
    DateTime? loggedAt,
    String? createdBy,
    DateTime? createdAt,
    String? updatedBy,
    DateTime? updatedAt,
    bool? isArchived,
    String? archivedBy,
    DateTime? archivedAt,
  }) {
    return GroupLogModel(
      id: id ?? this.id,
      logType: logType ?? this.logType,
      message: message ?? this.message,
      note: note ?? this.note,
      loggedBy: loggedBy ?? this.loggedBy,
      loggedAt: loggedAt ?? this.loggedAt,
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
