import 'package:cloud_firestore/cloud_firestore.dart';

import '../../core/constants/firestore_fields.dart';

class BaseRecord {
  const BaseRecord({
    required this.id,
    this.createdBy,
    this.createdAt,
    this.updatedBy,
    this.updatedAt,
  });

  final String id;
  final String? createdBy;
  final DateTime? createdAt;
  final String? updatedBy;
  final DateTime? updatedAt;

  factory BaseRecord.fromMap(Map<String, dynamic> map) {
    return BaseRecord(
      id: (map[FirestoreFields.id] as String?) ?? '',
      createdBy: map[FirestoreFields.createdBy] as String?,
      createdAt: _dateTimeFromDynamic(map[FirestoreFields.createdAt]),
      updatedBy: map[FirestoreFields.updatedBy] as String?,
      updatedAt: _dateTimeFromDynamic(map[FirestoreFields.updatedAt]),
    );
  }

  Map<String, dynamic> toMap() {
    return <String, dynamic>{
      FirestoreFields.id: id,
      FirestoreFields.createdBy: createdBy,
      FirestoreFields.createdAt: createdAt,
      FirestoreFields.updatedBy: updatedBy,
      FirestoreFields.updatedAt: updatedAt,
    };
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
