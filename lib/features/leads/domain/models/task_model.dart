import 'package:cloud_firestore/cloud_firestore.dart';

class TaskModel {
  const TaskModel({
    required this.id,
    this.taskCode,
    this.taskType,
    this.title,
    this.description,
    this.linkedEntityType,
    this.linkedEntityId,
    this.linkedEntityCode,
    this.assignedTo,
    this.teamId,
    this.status,
    this.priority,
    this.dueAt,
    this.isSnoozed = false,
    this.snoozedUntil,
    this.snoozedBy,
    this.snoozedAt,
    this.completedAt,
    this.completedBy,
    this.createdBy,
    this.createdAt,
    this.updatedBy,
    this.updatedAt,
    this.isArchived = false,
    this.archivedBy,
    this.archivedAt,
  });

  final String id;
  final String? taskCode;
  final String? taskType;
  final String? title;
  final String? description;
  final String? linkedEntityType;
  final String? linkedEntityId;
  final String? linkedEntityCode;
  final String? assignedTo;
  final String? teamId;
  final String? status;
  final String? priority;
  final DateTime? dueAt;
  final bool isSnoozed;
  final DateTime? snoozedUntil;
  final String? snoozedBy;
  final DateTime? snoozedAt;
  final DateTime? completedAt;
  final String? completedBy;
  final String? createdBy;
  final DateTime? createdAt;
  final String? updatedBy;
  final DateTime? updatedAt;
  final bool isArchived;
  final String? archivedBy;
  final DateTime? archivedAt;

  factory TaskModel.fromMap(Map<String, dynamic> map) {
    return TaskModel(
      id: (map['id'] as String?) ?? '',
      taskCode: map['taskCode'] as String?,
      taskType: map['taskType'] as String?,
      title: map['title'] as String?,
      description: map['description'] as String?,
      linkedEntityType: map['linkedEntityType'] as String?,
      linkedEntityId: map['linkedEntityId'] as String?,
      linkedEntityCode: map['linkedEntityCode'] as String?,
      assignedTo: map['assignedTo'] as String?,
      teamId: map['teamId'] as String?,
      status: map['status'] as String?,
      priority: map['priority'] as String?,
      dueAt: _dateTimeFromDynamic(map['dueAt']),
      isSnoozed: (map['isSnoozed'] as bool?) ?? false,
      snoozedUntil: _dateTimeFromDynamic(map['snoozedUntil']),
      snoozedBy: map['snoozedBy'] as String?,
      snoozedAt: _dateTimeFromDynamic(map['snoozedAt']),
      completedAt: _dateTimeFromDynamic(map['completedAt']),
      completedBy: map['completedBy'] as String?,
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
      'taskCode': taskCode,
      'taskType': taskType,
      'title': title,
      'description': description,
      'linkedEntityType': linkedEntityType,
      'linkedEntityId': linkedEntityId,
      'linkedEntityCode': linkedEntityCode,
      'assignedTo': assignedTo,
      'teamId': teamId,
      'status': status,
      'priority': priority,
      'dueAt': dueAt,
      'isSnoozed': isSnoozed,
      'snoozedUntil': snoozedUntil,
      'snoozedBy': snoozedBy,
      'snoozedAt': snoozedAt,
      'completedAt': completedAt,
      'completedBy': completedBy,
      'createdBy': createdBy,
      'createdAt': createdAt,
      'updatedBy': updatedBy,
      'updatedAt': updatedAt,
      'isArchived': isArchived,
      'archivedBy': archivedBy,
      'archivedAt': archivedAt,
    };
  }

  TaskModel copyWith({
    String? id,
    String? taskCode,
    String? taskType,
    String? title,
    String? description,
    String? linkedEntityType,
    String? linkedEntityId,
    String? linkedEntityCode,
    String? assignedTo,
    String? teamId,
    String? status,
    String? priority,
    DateTime? dueAt,
    bool? isSnoozed,
    DateTime? snoozedUntil,
    String? snoozedBy,
    DateTime? snoozedAt,
    DateTime? completedAt,
    String? completedBy,
    String? createdBy,
    DateTime? createdAt,
    String? updatedBy,
    DateTime? updatedAt,
    bool? isArchived,
    String? archivedBy,
    DateTime? archivedAt,
  }) {
    return TaskModel(
      id: id ?? this.id,
      taskCode: taskCode ?? this.taskCode,
      taskType: taskType ?? this.taskType,
      title: title ?? this.title,
      description: description ?? this.description,
      linkedEntityType: linkedEntityType ?? this.linkedEntityType,
      linkedEntityId: linkedEntityId ?? this.linkedEntityId,
      linkedEntityCode: linkedEntityCode ?? this.linkedEntityCode,
      assignedTo: assignedTo ?? this.assignedTo,
      teamId: teamId ?? this.teamId,
      status: status ?? this.status,
      priority: priority ?? this.priority,
      dueAt: dueAt ?? this.dueAt,
      isSnoozed: isSnoozed ?? this.isSnoozed,
      snoozedUntil: snoozedUntil ?? this.snoozedUntil,
      snoozedBy: snoozedBy ?? this.snoozedBy,
      snoozedAt: snoozedAt ?? this.snoozedAt,
      completedAt: completedAt ?? this.completedAt,
      completedBy: completedBy ?? this.completedBy,
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
