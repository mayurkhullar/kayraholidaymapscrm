import 'package:cloud_firestore/cloud_firestore.dart';

class UnitModel {
  const UnitModel({
    required this.id,
    this.unitLabel,
    this.primaryContactName,
    this.primaryContactPhone,
    this.alternatePhone,
    this.primaryContactTravelerId,
    this.primaryContactCompanyContactId,
    this.memberCount = 0,
    this.createdBy,
    this.createdAt,
    this.updatedBy,
    this.updatedAt,
    this.isArchived = false,
    this.archivedBy,
    this.archivedAt,
  });

  final String id;
  final String? unitLabel;
  final String? primaryContactName;
  final String? primaryContactPhone;
  final String? alternatePhone;
  final String? primaryContactTravelerId;
  final String? primaryContactCompanyContactId;
  final int memberCount;
  final String? createdBy;
  final DateTime? createdAt;
  final String? updatedBy;
  final DateTime? updatedAt;
  final bool isArchived;
  final String? archivedBy;
  final DateTime? archivedAt;

  factory UnitModel.fromMap(Map<String, dynamic> map) {
    return UnitModel(
      id: (map['id'] as String?) ?? '',
      unitLabel: map['unitLabel'] as String?,
      primaryContactName: map['primaryContactName'] as String?,
      primaryContactPhone: map['primaryContactPhone'] as String?,
      alternatePhone: map['alternatePhone'] as String?,
      primaryContactTravelerId: map['primaryContactTravelerId'] as String?,
      primaryContactCompanyContactId: map['primaryContactCompanyContactId'] as String?,
      memberCount: (map['memberCount'] as num?)?.toInt() ?? 0,
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
      'unitLabel': unitLabel,
      'primaryContactName': primaryContactName,
      'primaryContactPhone': primaryContactPhone,
      'alternatePhone': alternatePhone,
      'primaryContactTravelerId': primaryContactTravelerId,
      'primaryContactCompanyContactId': primaryContactCompanyContactId,
      'memberCount': memberCount,
      'createdBy': createdBy,
      'createdAt': createdAt,
      'updatedBy': updatedBy,
      'updatedAt': updatedAt,
      'isArchived': isArchived,
      'archivedBy': archivedBy,
      'archivedAt': archivedAt,
    };
  }

  UnitModel copyWith({
    String? id,
    String? unitLabel,
    String? primaryContactName,
    String? primaryContactPhone,
    String? alternatePhone,
    String? primaryContactTravelerId,
    String? primaryContactCompanyContactId,
    int? memberCount,
    String? createdBy,
    DateTime? createdAt,
    String? updatedBy,
    DateTime? updatedAt,
    bool? isArchived,
    String? archivedBy,
    DateTime? archivedAt,
  }) {
    return UnitModel(
      id: id ?? this.id,
      unitLabel: unitLabel ?? this.unitLabel,
      primaryContactName: primaryContactName ?? this.primaryContactName,
      primaryContactPhone: primaryContactPhone ?? this.primaryContactPhone,
      alternatePhone: alternatePhone ?? this.alternatePhone,
      primaryContactTravelerId: primaryContactTravelerId ?? this.primaryContactTravelerId,
      primaryContactCompanyContactId: primaryContactCompanyContactId ?? this.primaryContactCompanyContactId,
      memberCount: memberCount ?? this.memberCount,
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
