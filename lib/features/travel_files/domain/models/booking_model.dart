import 'package:cloud_firestore/cloud_firestore.dart';

class BookingModel {
  const BookingModel({
    required this.id,
    this.bookingCode,
    this.bookingType,
    this.vendorId,
    this.vendorName,
    this.status,
    this.costToCompany,
    this.sellingPrice,
    this.bookingDate,
    this.serviceStartDate,
    this.serviceEndDate,
    this.refundable = false,
    this.remarks,
    this.createdBy,
    this.createdAt,
    this.updatedBy,
    this.updatedAt,
    this.isArchived = false,
    this.archivedBy,
    this.archivedAt,
  });

  final String id;
  final String? bookingCode;
  final String? bookingType;
  final String? vendorId;
  final String? vendorName;
  final String? status;
  final double? costToCompany;
  final double? sellingPrice;
  final DateTime? bookingDate;
  final DateTime? serviceStartDate;
  final DateTime? serviceEndDate;
  final bool refundable;
  final String? remarks;
  final String? createdBy;
  final DateTime? createdAt;
  final String? updatedBy;
  final DateTime? updatedAt;
  final bool isArchived;
  final String? archivedBy;
  final DateTime? archivedAt;

  factory BookingModel.fromMap(Map<String, dynamic> map) {
    return BookingModel(
      id: (map['id'] as String?) ?? '',
      bookingCode: map['bookingCode'] as String?,
      bookingType: map['bookingType'] as String?,
      vendorId: map['vendorId'] as String?,
      vendorName: map['vendorName'] as String?,
      status: map['status'] as String?,
      costToCompany: (map['costToCompany'] as num?)?.toDouble(),
      sellingPrice: (map['sellingPrice'] as num?)?.toDouble(),
      bookingDate: _dateTimeFromDynamic(map['bookingDate']),
      serviceStartDate: _dateTimeFromDynamic(map['serviceStartDate']),
      serviceEndDate: _dateTimeFromDynamic(map['serviceEndDate']),
      refundable: (map['refundable'] as bool?) ?? false,
      remarks: map['remarks'] as String?,
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
      'bookingCode': bookingCode,
      'bookingType': bookingType,
      'vendorId': vendorId,
      'vendorName': vendorName,
      'status': status,
      'costToCompany': costToCompany,
      'sellingPrice': sellingPrice,
      'bookingDate': bookingDate,
      'serviceStartDate': serviceStartDate,
      'serviceEndDate': serviceEndDate,
      'refundable': refundable,
      'remarks': remarks,
      'createdBy': createdBy,
      'createdAt': createdAt,
      'updatedBy': updatedBy,
      'updatedAt': updatedAt,
      'isArchived': isArchived,
      'archivedBy': archivedBy,
      'archivedAt': archivedAt,
    };
  }

  BookingModel copyWith({
    String? id,
    String? bookingCode,
    String? bookingType,
    String? vendorId,
    String? vendorName,
    String? status,
    double? costToCompany,
    double? sellingPrice,
    DateTime? bookingDate,
    DateTime? serviceStartDate,
    DateTime? serviceEndDate,
    bool? refundable,
    String? remarks,
    String? createdBy,
    DateTime? createdAt,
    String? updatedBy,
    DateTime? updatedAt,
    bool? isArchived,
    String? archivedBy,
    DateTime? archivedAt,
  }) {
    return BookingModel(
      id: id ?? this.id,
      bookingCode: bookingCode ?? this.bookingCode,
      bookingType: bookingType ?? this.bookingType,
      vendorId: vendorId ?? this.vendorId,
      vendorName: vendorName ?? this.vendorName,
      status: status ?? this.status,
      costToCompany: costToCompany ?? this.costToCompany,
      sellingPrice: sellingPrice ?? this.sellingPrice,
      bookingDate: bookingDate ?? this.bookingDate,
      serviceStartDate: serviceStartDate ?? this.serviceStartDate,
      serviceEndDate: serviceEndDate ?? this.serviceEndDate,
      refundable: refundable ?? this.refundable,
      remarks: remarks ?? this.remarks,
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
