import 'package:cloud_firestore/cloud_firestore.dart';

class LeadNoteModel {
  const LeadNoteModel({
    required this.id,
    required this.leadId,
    required this.noteText,
    required this.noteType,
    this.relatedStage,
    this.reason,
    this.createdBy,
    required this.createdAt,
  });

  final String id;
  final String leadId;
  final String noteText;
  final String noteType;
  final String? relatedStage;
  final String? reason;
  final String? createdBy;
  final DateTime createdAt;

  factory LeadNoteModel.fromMap(Map<String, dynamic> map) {
    return LeadNoteModel(
      id: (map['id'] as String?) ?? '',
      leadId: (map['leadId'] as String?) ?? '',
      noteText: (map['noteText'] as String?) ?? '',
      noteType: (map['noteType'] as String?) ?? 'general',
      relatedStage: map['relatedStage'] as String?,
      reason: map['reason'] as String?,
      createdBy: map['createdBy'] as String?,
      createdAt: _dateTimeFromDynamic(map['createdAt']) ?? DateTime.now(),
    );
  }

  Map<String, dynamic> toMap() {
    return <String, dynamic>{
      'id': id,
      'leadId': leadId,
      'noteText': noteText,
      'noteType': noteType,
      'relatedStage': relatedStage,
      'reason': reason,
      'createdBy': createdBy,
      'createdAt': createdAt,
    };
  }

  LeadNoteModel copyWith({
    String? id,
    String? leadId,
    String? noteText,
    String? noteType,
    String? relatedStage,
    String? reason,
    String? createdBy,
    DateTime? createdAt,
  }) {
    return LeadNoteModel(
      id: id ?? this.id,
      leadId: leadId ?? this.leadId,
      noteText: noteText ?? this.noteText,
      noteType: noteType ?? this.noteType,
      relatedStage: relatedStage ?? this.relatedStage,
      reason: reason ?? this.reason,
      createdBy: createdBy ?? this.createdBy,
      createdAt: createdAt ?? this.createdAt,
    );
  }

  static DateTime? _dateTimeFromDynamic(dynamic value) {
    if (value is Timestamp) {
      return value.toDate();
    }

    if (value is DateTime) {
      return value;
    }

    if (value is String) {
      return DateTime.tryParse(value);
    }

    return null;
  }
}
