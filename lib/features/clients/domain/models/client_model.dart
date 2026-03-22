import 'package:cloud_firestore/cloud_firestore.dart';

class ClientModel {
  const ClientModel({
    required this.id,
    required this.clientCode,
    required this.name,
    required this.email,
    required this.phone,
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

  Map<String, dynamic> toMap() {
    return <String, dynamic>{
      'clientCode': clientCode,
      'name': name,
      'email': email,
      'phone': phone,
      'companyName': companyName,
      'createdAt': Timestamp.fromDate(createdAt),
      'updatedAt': Timestamp.fromDate(updatedAt),
      'isActive': isActive,
    };
  }
}
