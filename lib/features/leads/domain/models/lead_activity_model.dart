import 'package:cloud_firestore/cloud_firestore.dart';

class LeadActivityModel {
  const LeadActivityModel({
    required this.id,
    this.activityType,
    this.title,
    this.note,
    this.relatedQuotationId,
    this.relatedTaskId,
    this.performedBy,
    this.performedByName,
    this.performedAt,
    this.createdBy,
    this.createdAt,
    this.updatedBy,
    this.updatedAt,
    this.isArchived = false,
    this.archivedBy,
    this.archivedAt,
  });

  final String id;
  final String? activityType;
  final String? title;
  final String? note;
  final String? relatedQuotationId;
  final String? relatedTaskId;
  final String? performedBy;
  final String? performedByName;
  final DateTime? performedAt;
  final String? createdBy;
  final DateTime? createdAt;
  final String? updatedBy;
  final DateTime? updatedAt;
  final bool isArchived;
  final String? archivedBy;
  final DateTime? archivedAt;

  factory LeadActivityModel.fromMap(Map<String, dynamic> map) {
    return LeadActivityModel(
      id: (map['id'] as String?) ?? '',
      activityType: map['activityType'] as String?,
      title: map['title'] as String?,
      note: map['note'] as String?,
      relatedQuotationId: map['relatedQuotationId'] as String?,
      relatedTaskId: map['relatedTaskId'] as String?,
      performedBy: map['performedBy'] as String?,
      performedByName: map['performedByName'] as String?,
      performedAt: _dateTimeFromDynamic(map['performedAt']),
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
      'activityType': activityType,
      'title': title,
      'note': note,
      'relatedQuotationId': relatedQuotationId,
      'relatedTaskId': relatedTaskId,
      'performedBy': performedBy,
      'performedByName': performedByName,
      'performedAt': performedAt,
      'createdBy': createdBy,
      'createdAt': createdAt,
      'updatedBy': updatedBy,
      'updatedAt': updatedAt,
      'isArchived': isArchived,
      'archivedBy': archivedBy,
      'archivedAt': archivedAt,
    };
  }

  LeadActivityModel copyWith({
    String? id,
    String? activityType,
    String? title,
    String? note,
    String? relatedQuotationId,
    String? relatedTaskId,
    String? performedBy,
    String? performedByName,
    DateTime? performedAt,
    String? createdBy,
    DateTime? createdAt,
    String? updatedBy,
    DateTime? updatedAt,
    bool? isArchived,
    String? archivedBy,
    DateTime? archivedAt,
  }) {
    return LeadActivityModel(
      id: id ?? this.id,
      activityType: activityType ?? this.activityType,
      title: title ?? this.title,
      note: note ?? this.note,
      relatedQuotationId: relatedQuotationId ?? this.relatedQuotationId,
      relatedTaskId: relatedTaskId ?? this.relatedTaskId,
      performedBy: performedBy ?? this.performedBy,
      performedByName: performedByName ?? this.performedByName,
      performedAt: performedAt ?? this.performedAt,
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
