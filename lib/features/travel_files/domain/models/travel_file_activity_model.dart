import 'package:cloud_firestore/cloud_firestore.dart';

class TravelFileActivityModel {
  const TravelFileActivityModel({
    required this.id,
    this.activityType,
    this.title,
    this.description,
    this.activityDate,
    this.performedBy,
    this.referenceId,
    this.referenceType,
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
  final String? description;
  final DateTime? activityDate;
  final String? performedBy;
  final String? referenceId;
  final String? referenceType;
  final String? createdBy;
  final DateTime? createdAt;
  final String? updatedBy;
  final DateTime? updatedAt;
  final bool isArchived;
  final String? archivedBy;
  final DateTime? archivedAt;

  factory TravelFileActivityModel.fromMap(Map<String, dynamic> map) {
    return TravelFileActivityModel(
      id: (map['id'] as String?) ?? '',
      activityType: map['activityType'] as String?,
      title: map['title'] as String?,
      description: map['description'] as String?,
      activityDate: _dateTimeFromDynamic(map['activityDate']),
      performedBy: map['performedBy'] as String?,
      referenceId: map['referenceId'] as String?,
      referenceType: map['referenceType'] as String?,
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
      'description': description,
      'activityDate': activityDate,
      'performedBy': performedBy,
      'referenceId': referenceId,
      'referenceType': referenceType,
      'createdBy': createdBy,
      'createdAt': createdAt,
      'updatedBy': updatedBy,
      'updatedAt': updatedAt,
      'isArchived': isArchived,
      'archivedBy': archivedBy,
      'archivedAt': archivedAt,
    };
  }

  TravelFileActivityModel copyWith({
    String? id,
    String? activityType,
    String? title,
    String? description,
    DateTime? activityDate,
    String? performedBy,
    String? referenceId,
    String? referenceType,
    String? createdBy,
    DateTime? createdAt,
    String? updatedBy,
    DateTime? updatedAt,
    bool? isArchived,
    String? archivedBy,
    DateTime? archivedAt,
  }) {
    return TravelFileActivityModel(
      id: id ?? this.id,
      activityType: activityType ?? this.activityType,
      title: title ?? this.title,
      description: description ?? this.description,
      activityDate: activityDate ?? this.activityDate,
      performedBy: performedBy ?? this.performedBy,
      referenceId: referenceId ?? this.referenceId,
      referenceType: referenceType ?? this.referenceType,
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
