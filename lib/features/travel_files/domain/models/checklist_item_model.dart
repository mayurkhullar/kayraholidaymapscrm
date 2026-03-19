import 'package:cloud_firestore/cloud_firestore.dart';

class ChecklistItemModel {
  const ChecklistItemModel({
    required this.id,
    this.title,
    this.description,
    this.status,
    this.isCompleted = false,
    this.completedBy,
    this.completedAt,
    this.dueDate,
    this.sortOrder = 0,
    this.createdBy,
    this.createdAt,
    this.updatedBy,
    this.updatedAt,
    this.isArchived = false,
    this.archivedBy,
    this.archivedAt,
  });

  final String id;
  final String? title;
  final String? description;
  final String? status;
  final bool isCompleted;
  final String? completedBy;
  final DateTime? completedAt;
  final DateTime? dueDate;
  final int sortOrder;
  final String? createdBy;
  final DateTime? createdAt;
  final String? updatedBy;
  final DateTime? updatedAt;
  final bool isArchived;
  final String? archivedBy;
  final DateTime? archivedAt;

  factory ChecklistItemModel.fromMap(Map<String, dynamic> map) {
    return ChecklistItemModel(
      id: (map['id'] as String?) ?? '',
      title: map['title'] as String?,
      description: map['description'] as String?,
      status: map['status'] as String?,
      isCompleted: (map['isCompleted'] as bool?) ?? false,
      completedBy: map['completedBy'] as String?,
      completedAt: _dateTimeFromDynamic(map['completedAt']),
      dueDate: _dateTimeFromDynamic(map['dueDate']),
      sortOrder: (map['sortOrder'] as num?)?.toInt() ?? 0,
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
      'title': title,
      'description': description,
      'status': status,
      'isCompleted': isCompleted,
      'completedBy': completedBy,
      'completedAt': completedAt,
      'dueDate': dueDate,
      'sortOrder': sortOrder,
      'createdBy': createdBy,
      'createdAt': createdAt,
      'updatedBy': updatedBy,
      'updatedAt': updatedAt,
      'isArchived': isArchived,
      'archivedBy': archivedBy,
      'archivedAt': archivedAt,
    };
  }

  ChecklistItemModel copyWith({
    String? id,
    String? title,
    String? description,
    String? status,
    bool? isCompleted,
    String? completedBy,
    DateTime? completedAt,
    DateTime? dueDate,
    int? sortOrder,
    String? createdBy,
    DateTime? createdAt,
    String? updatedBy,
    DateTime? updatedAt,
    bool? isArchived,
    String? archivedBy,
    DateTime? archivedAt,
  }) {
    return ChecklistItemModel(
      id: id ?? this.id,
      title: title ?? this.title,
      description: description ?? this.description,
      status: status ?? this.status,
      isCompleted: isCompleted ?? this.isCompleted,
      completedBy: completedBy ?? this.completedBy,
      completedAt: completedAt ?? this.completedAt,
      dueDate: dueDate ?? this.dueDate,
      sortOrder: sortOrder ?? this.sortOrder,
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
