import 'package:cloud_firestore/cloud_firestore.dart';

class TravelerModel {
  const TravelerModel({
    required this.id,
    required this.travelerCode,
    required this.clientId,
    this.leadId,
    required this.fullName,
    required this.travelerType,
    this.gender,
    this.age,
    this.phone,
    this.email,
    this.notes,
    required this.createdAt,
    required this.updatedAt,
    this.isActive = true,
  });

  final String id;
  final String travelerCode;
  final String clientId;
  final String? leadId;
  final String fullName;
  final String travelerType;
  final String? gender;
  final int? age;
  final String? phone;
  final String? email;
  final String? notes;
  final DateTime createdAt;
  final DateTime updatedAt;
  final bool isActive;

  factory TravelerModel.fromMap(Map<String, dynamic> map) {
    return TravelerModel(
      id: (map['id'] as String?) ?? '',
      travelerCode: (map['travelerCode'] as String?) ?? '',
      clientId: (map['clientId'] as String?) ?? '',
      leadId: _optionalTrimmedStringFromDynamic(map['leadId']),
      fullName: (map['fullName'] as String?) ?? '',
      travelerType: (map['travelerType'] as String?) ?? 'Adult',
      gender: _optionalTrimmedStringFromDynamic(map['gender']),
      age: _nullableIntFromDynamic(map['age']),
      phone: _optionalTrimmedStringFromDynamic(map['phone']),
      email: _optionalTrimmedStringFromDynamic(map['email']),
      notes: _optionalTrimmedStringFromDynamic(map['notes']),
      createdAt: _dateTimeFromDynamic(map['createdAt']) ??
          DateTime.fromMillisecondsSinceEpoch(0),
      updatedAt: _dateTimeFromDynamic(map['updatedAt']) ??
          DateTime.fromMillisecondsSinceEpoch(0),
      isActive: (map['isActive'] as bool?) ?? true,
    );
  }

  Map<String, dynamic> toMap() {
    return <String, dynamic>{
      'id': id,
      'travelerCode': travelerCode,
      'clientId': clientId,
      'leadId': leadId,
      'fullName': fullName,
      'travelerType': travelerType,
      'gender': gender,
      'age': age,
      'phone': phone,
      'email': email,
      'notes': notes,
      'createdAt': Timestamp.fromDate(createdAt),
      'updatedAt': Timestamp.fromDate(updatedAt),
      'isActive': isActive,
    };
  }

  TravelerModel copyWith({
    String? id,
    String? travelerCode,
    String? clientId,
    String? leadId,
    bool clearLeadId = false,
    String? fullName,
    String? travelerType,
    String? gender,
    bool clearGender = false,
    int? age,
    bool clearAge = false,
    String? phone,
    bool clearPhone = false,
    String? email,
    bool clearEmail = false,
    String? notes,
    bool clearNotes = false,
    DateTime? createdAt,
    DateTime? updatedAt,
    bool? isActive,
  }) {
    return TravelerModel(
      id: id ?? this.id,
      travelerCode: travelerCode ?? this.travelerCode,
      clientId: clientId ?? this.clientId,
      leadId: clearLeadId ? null : (leadId ?? this.leadId),
      fullName: fullName ?? this.fullName,
      travelerType: travelerType ?? this.travelerType,
      gender: clearGender ? null : (gender ?? this.gender),
      age: clearAge ? null : (age ?? this.age),
      phone: clearPhone ? null : (phone ?? this.phone),
      email: clearEmail ? null : (email ?? this.email),
      notes: clearNotes ? null : (notes ?? this.notes),
      createdAt: createdAt ?? this.createdAt,
      updatedAt: updatedAt ?? this.updatedAt,
      isActive: isActive ?? this.isActive,
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

int? _nullableIntFromDynamic(dynamic value) {
  if (value is int) {
    return value;
  }

  if (value is num) {
    return value.toInt();
  }

  if (value is String) {
    return int.tryParse(value.trim());
  }

  return null;
}

String? _optionalTrimmedStringFromDynamic(dynamic value) {
  if (value is String) {
    final trimmed = value.trim();
    return trimmed.isEmpty ? null : trimmed;
  }

  return null;
}
