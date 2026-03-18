import 'package:cloud_firestore/cloud_firestore.dart';

class TravelerDocumentModel {
  const TravelerDocumentModel({
    required this.id,
    this.documentType,
    this.fileName,
    this.storagePath,
    this.extractionStatus,
    this.reviewedBy,
    this.reviewedAt,
    this.extractedFieldsConfidence = const <String, String>{},
    this.uploadedBy,
    this.uploadedAt,
    this.createdBy,
    this.createdAt,
    this.updatedBy,
    this.updatedAt,
    this.isArchived = false,
    this.archivedBy,
    this.archivedAt,
  });

  final String id;
  final String? documentType;
  final String? fileName;
  final String? storagePath;
  final String? extractionStatus;
  final String? reviewedBy;
  final DateTime? reviewedAt;
  final Map<String, String> extractedFieldsConfidence;
  final String? uploadedBy;
  final DateTime? uploadedAt;
  final String? createdBy;
  final DateTime? createdAt;
  final String? updatedBy;
  final DateTime? updatedAt;
  final bool isArchived;
  final String? archivedBy;
  final DateTime? archivedAt;

  factory TravelerDocumentModel.fromMap(Map<String, dynamic> map) {
    return TravelerDocumentModel(
      id: (map['id'] as String?) ?? '',
      documentType: map['documentType'] as String?,
      fileName: map['fileName'] as String?,
      storagePath: map['storagePath'] as String?,
      extractionStatus: map['extractionStatus'] as String?,
      reviewedBy: map['reviewedBy'] as String?,
      reviewedAt: _dateTimeFromDynamic(map['reviewedAt']),
      extractedFieldsConfidence: _stringMapFromDynamic(
        map['extractedFieldsConfidence'],
      ),
      uploadedBy: map['uploadedBy'] as String?,
      uploadedAt: _dateTimeFromDynamic(map['uploadedAt']),
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
      'documentType': documentType,
      'fileName': fileName,
      'storagePath': storagePath,
      'extractionStatus': extractionStatus,
      'reviewedBy': reviewedBy,
      'reviewedAt': reviewedAt,
      'extractedFieldsConfidence': extractedFieldsConfidence,
      'uploadedBy': uploadedBy,
      'uploadedAt': uploadedAt,
      'createdBy': createdBy,
      'createdAt': createdAt,
      'updatedBy': updatedBy,
      'updatedAt': updatedAt,
      'isArchived': isArchived,
      'archivedBy': archivedBy,
      'archivedAt': archivedAt,
    };
  }

  TravelerDocumentModel copyWith({
    String? id,
    String? documentType,
    String? fileName,
    String? storagePath,
    String? extractionStatus,
    String? reviewedBy,
    DateTime? reviewedAt,
    Map<String, String>? extractedFieldsConfidence,
    String? uploadedBy,
    DateTime? uploadedAt,
    String? createdBy,
    DateTime? createdAt,
    String? updatedBy,
    DateTime? updatedAt,
    bool? isArchived,
    String? archivedBy,
    DateTime? archivedAt,
  }) {
    return TravelerDocumentModel(
      id: id ?? this.id,
      documentType: documentType ?? this.documentType,
      fileName: fileName ?? this.fileName,
      storagePath: storagePath ?? this.storagePath,
      extractionStatus: extractionStatus ?? this.extractionStatus,
      reviewedBy: reviewedBy ?? this.reviewedBy,
      reviewedAt: reviewedAt ?? this.reviewedAt,
      extractedFieldsConfidence:
          extractedFieldsConfidence ?? this.extractedFieldsConfidence,
      uploadedBy: uploadedBy ?? this.uploadedBy,
      uploadedAt: uploadedAt ?? this.uploadedAt,
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

Map<String, String> _stringMapFromDynamic(dynamic value) {
  if (value is Map<String, String>) {
    return value;
  }

  if (value is Map) {
    return value.map(
      (key, dynamic nestedValue) => MapEntry('$key', '${nestedValue ?? ''}'),
    );
  }

  return const <String, String>{};
}
