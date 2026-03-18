import 'package:cloud_firestore/cloud_firestore.dart';

import '../../core/constants/firestore_fields.dart';

class ArchiveMetadata {
  const ArchiveMetadata({
    this.isArchived = false,
    this.archivedBy,
    this.archivedAt,
  });

  final bool isArchived;
  final String? archivedBy;
  final DateTime? archivedAt;

  factory ArchiveMetadata.fromMap(Map<String, dynamic> map) {
    return ArchiveMetadata(
      isArchived: (map[FirestoreFields.isArchived] as bool?) ?? false,
      archivedBy: map[FirestoreFields.archivedBy] as String?,
      archivedAt: _dateTimeFromDynamic(map[FirestoreFields.archivedAt]),
    );
  }

  Map<String, dynamic> toMap() {
    return <String, dynamic>{
      FirestoreFields.isArchived: isArchived,
      FirestoreFields.archivedBy: archivedBy,
      FirestoreFields.archivedAt: archivedAt,
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
