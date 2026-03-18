import 'package:cloud_firestore/cloud_firestore.dart';

class PaymentIssueFlagModel {
  const PaymentIssueFlagModel({
    required this.id,
    this.flagType,
    this.reason,
    this.note,
    this.status,
    this.flaggedBy,
    this.flaggedByRole,
    this.flaggedAt,
    this.resolvedBy,
    this.resolvedAt,
    this.resolutionNote,
    this.createdBy,
    this.createdAt,
    this.updatedBy,
    this.updatedAt,
    this.isArchived = false,
    this.archivedBy,
    this.archivedAt,
  });

  final String id;
  final String? flagType;
  final String? reason;
  final String? note;
  final String? status;
  final String? flaggedBy;
  final String? flaggedByRole;
  final DateTime? flaggedAt;
  final String? resolvedBy;
  final DateTime? resolvedAt;
  final String? resolutionNote;
  final String? createdBy;
  final DateTime? createdAt;
  final String? updatedBy;
  final DateTime? updatedAt;
  final bool isArchived;
  final String? archivedBy;
  final DateTime? archivedAt;

  factory PaymentIssueFlagModel.fromMap(Map<String, dynamic> map) {
    return PaymentIssueFlagModel(
      id: (map['id'] as String?) ?? '',
      flagType: map['flagType'] as String?,
      reason: map['reason'] as String?,
      note: map['note'] as String?,
      status: map['status'] as String?,
      flaggedBy: map['flaggedBy'] as String?,
      flaggedByRole: map['flaggedByRole'] as String?,
      flaggedAt: _dateTimeFromDynamic(map['flaggedAt']),
      resolvedBy: map['resolvedBy'] as String?,
      resolvedAt: _dateTimeFromDynamic(map['resolvedAt']),
      resolutionNote: map['resolutionNote'] as String?,
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
      'flagType': flagType,
      'reason': reason,
      'note': note,
      'status': status,
      'flaggedBy': flaggedBy,
      'flaggedByRole': flaggedByRole,
      'flaggedAt': flaggedAt,
      'resolvedBy': resolvedBy,
      'resolvedAt': resolvedAt,
      'resolutionNote': resolutionNote,
      'createdBy': createdBy,
      'createdAt': createdAt,
      'updatedBy': updatedBy,
      'updatedAt': updatedAt,
      'isArchived': isArchived,
      'archivedBy': archivedBy,
      'archivedAt': archivedAt,
    };
  }

  PaymentIssueFlagModel copyWith({
    String? id,
    String? flagType,
    String? reason,
    String? note,
    String? status,
    String? flaggedBy,
    String? flaggedByRole,
    DateTime? flaggedAt,
    String? resolvedBy,
    DateTime? resolvedAt,
    String? resolutionNote,
    String? createdBy,
    DateTime? createdAt,
    String? updatedBy,
    DateTime? updatedAt,
    bool? isArchived,
    String? archivedBy,
    DateTime? archivedAt,
  }) {
    return PaymentIssueFlagModel(
      id: id ?? this.id,
      flagType: flagType ?? this.flagType,
      reason: reason ?? this.reason,
      note: note ?? this.note,
      status: status ?? this.status,
      flaggedBy: flaggedBy ?? this.flaggedBy,
      flaggedByRole: flaggedByRole ?? this.flaggedByRole,
      flaggedAt: flaggedAt ?? this.flaggedAt,
      resolvedBy: resolvedBy ?? this.resolvedBy,
      resolvedAt: resolvedAt ?? this.resolvedAt,
      resolutionNote: resolutionNote ?? this.resolutionNote,
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
