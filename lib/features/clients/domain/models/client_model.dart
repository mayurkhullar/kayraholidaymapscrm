import 'package:cloud_firestore/cloud_firestore.dart';

class ClientModel {
  const ClientModel({
    required this.id,
    required this.clientCode,
    required this.name,
    required this.email,
    required this.phone,
    this.destination,
    this.travelType,
    this.budget,
    this.travelers,
    this.companyName,
    required this.createdAt,
    required this.updatedAt,
    this.isActive = true,
  });

  final String id;
  final String clientCode;
  final String name;
  final String email;
  final String phone;
  final String? destination;
  final String? travelType;
  final int? budget;
  final int? travelers;
  final String? companyName;
  final DateTime createdAt;
  final DateTime updatedAt;
  final bool isActive;

  factory ClientModel.fromMap(Map<String, dynamic> map, String id) {
    return ClientModel(
      id: id,
      clientCode: (map['clientCode'] as String?) ?? '',
      name: (map['name'] as String?) ?? '',
      email: (map['email'] as String?) ?? '',
      phone: (map['phone'] as String?) ?? '',
      destination: map['destination'] as String?,
      travelType: map['travelType'] as String?,
      budget: _intFromDynamic(map['budget']),
      travelers: _intFromDynamic(map['travelers']),
      companyName: map['companyName'] as String?,
      createdAt: map['createdAt'] is Timestamp
          ? (map['createdAt'] as Timestamp).toDate()
          : map['createdAt'] is DateTime
              ? map['createdAt'] as DateTime
              : DateTime.fromMillisecondsSinceEpoch(0),
      updatedAt: map['updatedAt'] is Timestamp
          ? (map['updatedAt'] as Timestamp).toDate()
          : map['updatedAt'] is DateTime
              ? map['updatedAt'] as DateTime
              : DateTime.fromMillisecondsSinceEpoch(0),
      isActive: (map['isActive'] as bool?) ?? true,
    );
  }

  ClientModel copyWith({
    String? id,
    String? clientCode,
    String? name,
    String? email,
    String? phone,
    String? destination,
    String? travelType,
    int? budget,
    int? travelers,
    String? companyName,
    DateTime? createdAt,
    DateTime? updatedAt,
    bool? isActive,
  }) {
    return ClientModel(
      id: id ?? this.id,
      clientCode: clientCode ?? this.clientCode,
      name: name ?? this.name,
      email: email ?? this.email,
      phone: phone ?? this.phone,
      destination: destination ?? this.destination,
      travelType: travelType ?? this.travelType,
      budget: budget ?? this.budget,
      travelers: travelers ?? this.travelers,
      companyName: companyName ?? this.companyName,
      createdAt: createdAt ?? this.createdAt,
      updatedAt: updatedAt ?? this.updatedAt,
      isActive: isActive ?? this.isActive,
    );
  }

  Map<String, dynamic> toMap() {
    return <String, dynamic>{
      'clientCode': clientCode,
      'name': name,
      'email': email,
      'phone': phone,
      'destination': destination,
      'travelType': travelType,
      'budget': budget,
      'travelers': travelers,
      'companyName': companyName,
      'createdAt': Timestamp.fromDate(createdAt),
      'updatedAt': Timestamp.fromDate(updatedAt),
      'isActive': isActive,
    };
  }
}

int? _intFromDynamic(dynamic value) {
  if (value == null) {
    return null;
  }

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
