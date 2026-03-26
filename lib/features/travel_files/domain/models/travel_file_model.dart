import 'package:cloud_firestore/cloud_firestore.dart';

class TravelFileModel {
  const TravelFileModel({
    required this.id,
    required this.travelFileCode,
    required this.leadId,
    required this.clientId,
    required this.clientNameSnapshot,
    required this.destination,
    required this.travelType,
    this.tripScope,
    required this.leadStage,
    this.status = 'Open',
    this.startDate,
    this.endDate,
    this.adultCount = 0,
    this.childCount = 0,
    this.infantCount = 0,
    this.totalPax = 0,
    this.notes,
    required this.createdAt,
    required this.updatedAt,
    this.isArchived = false,
  });

  final String id;
  final String travelFileCode;
  final String leadId;
  final String clientId;
  final String clientNameSnapshot;
  final String destination;
  final String travelType;
  final String? tripScope;
  final String leadStage;
  final String status;
  final DateTime? startDate;
  final DateTime? endDate;
  final int adultCount;
  final int childCount;
  final int infantCount;
  final int totalPax;
  final String? notes;
  final DateTime createdAt;
  final DateTime updatedAt;
  final bool isArchived;

  factory TravelFileModel.fromMap(Map<String, dynamic> map) {
    return TravelFileModel(
      id: (map['id'] as String?) ?? '',
      travelFileCode: (map['travelFileCode'] as String?) ?? '',
      leadId: (map['leadId'] as String?) ?? '',
      clientId: (map['clientId'] as String?) ?? '',
      clientNameSnapshot: (map['clientNameSnapshot'] as String?) ?? '',
      destination: (map['destination'] as String?) ?? '',
      travelType: (map['travelType'] as String?) ?? '',
      tripScope: _optionalString(map['tripScope']),
      leadStage: (map['leadStage'] as String?) ?? '',
      status: (map['status'] as String?) ?? 'Open',
      startDate: _dateTimeFromDynamic(map['startDate']),
      endDate: _dateTimeFromDynamic(map['endDate']),
      adultCount: _intFromDynamic(map['adultCount']),
      childCount: _intFromDynamic(map['childCount']),
      infantCount: _intFromDynamic(map['infantCount']),
      totalPax: _intFromDynamic(map['totalPax']),
      notes: _optionalString(map['notes']),
      createdAt: _dateTimeFromDynamic(map['createdAt']) ??
          DateTime.fromMillisecondsSinceEpoch(0),
      updatedAt: _dateTimeFromDynamic(map['updatedAt']) ??
          DateTime.fromMillisecondsSinceEpoch(0),
      isArchived: (map['isArchived'] as bool?) ?? false,
    );
  }

  Map<String, dynamic> toMap() {
    return <String, dynamic>{
      'id': id,
      'travelFileCode': travelFileCode,
      'leadId': leadId,
      'clientId': clientId,
      'clientNameSnapshot': clientNameSnapshot,
      'destination': destination,
      'travelType': travelType,
      'tripScope': tripScope,
      'leadStage': leadStage,
      'status': status,
      'startDate': startDate == null ? null : Timestamp.fromDate(startDate!),
      'endDate': endDate == null ? null : Timestamp.fromDate(endDate!),
      'adultCount': adultCount,
      'childCount': childCount,
      'infantCount': infantCount,
      'totalPax': totalPax,
      'notes': notes,
      'createdAt': Timestamp.fromDate(createdAt),
      'updatedAt': Timestamp.fromDate(updatedAt),
      'isArchived': isArchived,
    };
  }

  TravelFileModel copyWith({
    String? id,
    String? travelFileCode,
    String? leadId,
    String? clientId,
    String? clientNameSnapshot,
    String? destination,
    String? travelType,
    String? tripScope,
    bool clearTripScope = false,
    String? leadStage,
    String? status,
    DateTime? startDate,
    bool clearStartDate = false,
    DateTime? endDate,
    bool clearEndDate = false,
    int? adultCount,
    int? childCount,
    int? infantCount,
    int? totalPax,
    String? notes,
    bool clearNotes = false,
    DateTime? createdAt,
    DateTime? updatedAt,
    bool? isArchived,
  }) {
    return TravelFileModel(
      id: id ?? this.id,
      travelFileCode: travelFileCode ?? this.travelFileCode,
      leadId: leadId ?? this.leadId,
      clientId: clientId ?? this.clientId,
      clientNameSnapshot: clientNameSnapshot ?? this.clientNameSnapshot,
      destination: destination ?? this.destination,
      travelType: travelType ?? this.travelType,
      tripScope: clearTripScope ? null : (tripScope ?? this.tripScope),
      leadStage: leadStage ?? this.leadStage,
      status: status ?? this.status,
      startDate: clearStartDate ? null : (startDate ?? this.startDate),
      endDate: clearEndDate ? null : (endDate ?? this.endDate),
      adultCount: adultCount ?? this.adultCount,
      childCount: childCount ?? this.childCount,
      infantCount: infantCount ?? this.infantCount,
      totalPax: totalPax ?? this.totalPax,
      notes: clearNotes ? null : (notes ?? this.notes),
      createdAt: createdAt ?? this.createdAt,
      updatedAt: updatedAt ?? this.updatedAt,
      isArchived: isArchived ?? this.isArchived,
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

int _intFromDynamic(dynamic value) {
  if (value is int) {
    return value;
  }

  if (value is num) {
    return value.toInt();
  }

  if (value is String) {
    return int.tryParse(value.trim()) ?? 0;
  }

  return 0;
}

String? _optionalString(dynamic value) {
  if (value is String) {
    final trimmed = value.trim();
    return trimmed.isEmpty ? null : trimmed;
  }

  return null;
}
