import 'package:cloud_firestore/cloud_firestore.dart';

class CompanyContactModel {
  const CompanyContactModel({
    required this.id,
    required this.contactName,
    this.phone,
    this.alternatePhones = const <String>[],
    this.email,
    this.linkedClientId,
    this.createdBy,
    this.createdAt,
    this.updatedBy,
    this.updatedAt,
    this.isArchived = false,
    this.archivedBy,
    this.archivedAt,
  });

  final String id;
  final String contactName;
  final String? phone;
  final List<String> alternatePhones;
  final String? email;
  final String? linkedClientId;
  final String? createdBy;
  final DateTime? createdAt;
  final String? updatedBy;
  final DateTime? updatedAt;
  final bool isArchived;
  final String? archivedBy;
  final DateTime? archivedAt;

  factory CompanyContactModel.fromMap(Map<String, dynamic> map) {
    return CompanyContactModel(
      id: (map['id'] as String?) ?? '',
      contactName: (map['contactName'] as String?) ?? '',
      phone: map['phone'] as String?,
      alternatePhones: _stringListFromDynamic(map['alternatePhones']),
      email: map['email'] as String?,
      linkedClientId: map['linkedClientId'] as String?,
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
      'contactName': contactName,
      'phone': phone,
      'alternatePhones': alternatePhones,
      'email': email,
      'linkedClientId': linkedClientId,
      'createdBy': createdBy,
      'createdAt': createdAt,
      'updatedBy': updatedBy,
      'updatedAt': updatedAt,
      'isArchived': isArchived,
      'archivedBy': archivedBy,
      'archivedAt': archivedAt,
    };
  }

  CompanyContactModel copyWith({
    String? id,
    String? contactName,
    String? phone,
    List<String>? alternatePhones,
    String? email,
    String? linkedClientId,
    String? createdBy,
    DateTime? createdAt,
    String? updatedBy,
    DateTime? updatedAt,
    bool? isArchived,
    String? archivedBy,
    DateTime? archivedAt,
  }) {
    return CompanyContactModel(
      id: id ?? this.id,
      contactName: contactName ?? this.contactName,
      phone: phone ?? this.phone,
      alternatePhones: alternatePhones ?? this.alternatePhones,
      email: email ?? this.email,
      linkedClientId: linkedClientId ?? this.linkedClientId,
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

List<String> _stringListFromDynamic(dynamic value) {
  if (value is Iterable) {
    return value.whereType<String>().toList(growable: false);
  }

  return const <String>[];
}
