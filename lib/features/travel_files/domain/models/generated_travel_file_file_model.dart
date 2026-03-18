import 'package:cloud_firestore/cloud_firestore.dart';

class GeneratedTravelFileFileModel {
  const GeneratedTravelFileFileModel({
    required this.id,
    this.fileType,
    this.fileName,
    this.storagePath,
    this.travelFileId,
    this.travelFileCode,
    this.generatedBy,
    this.generatedAt,
    this.markedSent = false,
    this.markedSentBy,
    this.markedSentAt,
    this.createdBy,
    this.createdAt,
    this.updatedBy,
    this.updatedAt,
    this.isArchived = false,
    this.archivedBy,
    this.archivedAt,
  });

  final String id;
  final String? fileType;
  final String? fileName;
  final String? storagePath;
  final String? travelFileId;
  final String? travelFileCode;
  final String? generatedBy;
  final DateTime? generatedAt;
  final bool markedSent;
  final String? markedSentBy;
  final DateTime? markedSentAt;
  final String? createdBy;
  final DateTime? createdAt;
  final String? updatedBy;
  final DateTime? updatedAt;
  final bool isArchived;
  final String? archivedBy;
  final DateTime? archivedAt;

  factory GeneratedTravelFileFileModel.fromMap(Map<String, dynamic> map) {
    return GeneratedTravelFileFileModel(
      id: (map['id'] as String?) ?? '',
      fileType: map['fileType'] as String?,
      fileName: map['fileName'] as String?,
      storagePath: map['storagePath'] as String?,
      travelFileId: map['travelFileId'] as String?,
      travelFileCode: map['travelFileCode'] as String?,
      generatedBy: map['generatedBy'] as String?,
      generatedAt: _dateTimeFromDynamic(map['generatedAt']),
      markedSent: (map['markedSent'] as bool?) ?? false,
      markedSentBy: map['markedSentBy'] as String?,
      markedSentAt: _dateTimeFromDynamic(map['markedSentAt']),
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
      'fileType': fileType,
      'fileName': fileName,
      'storagePath': storagePath,
      'travelFileId': travelFileId,
      'travelFileCode': travelFileCode,
      'generatedBy': generatedBy,
      'generatedAt': generatedAt,
      'markedSent': markedSent,
      'markedSentBy': markedSentBy,
      'markedSentAt': markedSentAt,
      'createdBy': createdBy,
      'createdAt': createdAt,
      'updatedBy': updatedBy,
      'updatedAt': updatedAt,
      'isArchived': isArchived,
      'archivedBy': archivedBy,
      'archivedAt': archivedAt,
    };
  }

  GeneratedTravelFileFileModel copyWith({
    String? id,
    String? fileType,
    String? fileName,
    String? storagePath,
    String? travelFileId,
    String? travelFileCode,
    String? generatedBy,
    DateTime? generatedAt,
    bool? markedSent,
    String? markedSentBy,
    DateTime? markedSentAt,
    String? createdBy,
    DateTime? createdAt,
    String? updatedBy,
    DateTime? updatedAt,
    bool? isArchived,
    String? archivedBy,
    DateTime? archivedAt,
  }) {
    return GeneratedTravelFileFileModel(
      id: id ?? this.id,
      fileType: fileType ?? this.fileType,
      fileName: fileName ?? this.fileName,
      storagePath: storagePath ?? this.storagePath,
      travelFileId: travelFileId ?? this.travelFileId,
      travelFileCode: travelFileCode ?? this.travelFileCode,
      generatedBy: generatedBy ?? this.generatedBy,
      generatedAt: generatedAt ?? this.generatedAt,
      markedSent: markedSent ?? this.markedSent,
      markedSentBy: markedSentBy ?? this.markedSentBy,
      markedSentAt: markedSentAt ?? this.markedSentAt,
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
