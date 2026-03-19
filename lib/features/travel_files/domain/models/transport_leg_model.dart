import 'package:cloud_firestore/cloud_firestore.dart';

class TransportLegModel {
  const TransportLegModel({
    required this.id,
    this.transportType,
    this.vehicleSubType,
    this.vehicleLabel,
    this.pickupLocation,
    this.dropLocation,
    this.pickupDateTime,
    this.assignedTravelerIds = const <String>[],
    this.assignedTravelerNames = const <String>[],
    this.assignedUnitIds = const <String>[],
    this.vendorId,
    this.vendorName,
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
  final String? transportType;
  final String? vehicleSubType;
  final String? vehicleLabel;
  final String? pickupLocation;
  final String? dropLocation;
  final DateTime? pickupDateTime;
  final List<String> assignedTravelerIds;
  final List<String> assignedTravelerNames;
  final List<String> assignedUnitIds;
  final String? vendorId;
  final String? vendorName;
  final String? remarks;
  final String? createdBy;
  final DateTime? createdAt;
  final String? updatedBy;
  final DateTime? updatedAt;
  final bool isArchived;
  final String? archivedBy;
  final DateTime? archivedAt;

  factory TransportLegModel.fromMap(Map<String, dynamic> map) {
    return TransportLegModel(
      id: (map['id'] as String?) ?? '',
      transportType: map['transportType'] as String?,
      vehicleSubType: map['vehicleSubType'] as String?,
      vehicleLabel: map['vehicleLabel'] as String?,
      pickupLocation: map['pickupLocation'] as String?,
      dropLocation: map['dropLocation'] as String?,
      pickupDateTime: _dateTimeFromDynamic(map['pickupDateTime']),
      assignedTravelerIds: _stringListFromDynamic(map['assignedTravelerIds']),
      assignedTravelerNames: _stringListFromDynamic(map['assignedTravelerNames']),
      assignedUnitIds: _stringListFromDynamic(map['assignedUnitIds']),
      vendorId: map['vendorId'] as String?,
      vendorName: map['vendorName'] as String?,
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
      'transportType': transportType,
      'vehicleSubType': vehicleSubType,
      'vehicleLabel': vehicleLabel,
      'pickupLocation': pickupLocation,
      'dropLocation': dropLocation,
      'pickupDateTime': pickupDateTime,
      'assignedTravelerIds': assignedTravelerIds,
      'assignedTravelerNames': assignedTravelerNames,
      'assignedUnitIds': assignedUnitIds,
      'vendorId': vendorId,
      'vendorName': vendorName,
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

  TransportLegModel copyWith({
    String? id,
    String? transportType,
    String? vehicleSubType,
    String? vehicleLabel,
    String? pickupLocation,
    String? dropLocation,
    DateTime? pickupDateTime,
    List<String>? assignedTravelerIds,
    List<String>? assignedTravelerNames,
    List<String>? assignedUnitIds,
    String? vendorId,
    String? vendorName,
    String? remarks,
    String? createdBy,
    DateTime? createdAt,
    String? updatedBy,
    DateTime? updatedAt,
    bool? isArchived,
    String? archivedBy,
    DateTime? archivedAt,
  }) {
    return TransportLegModel(
      id: id ?? this.id,
      transportType: transportType ?? this.transportType,
      vehicleSubType: vehicleSubType ?? this.vehicleSubType,
      vehicleLabel: vehicleLabel ?? this.vehicleLabel,
      pickupLocation: pickupLocation ?? this.pickupLocation,
      dropLocation: dropLocation ?? this.dropLocation,
      pickupDateTime: pickupDateTime ?? this.pickupDateTime,
      assignedTravelerIds: assignedTravelerIds ?? this.assignedTravelerIds,
      assignedTravelerNames: assignedTravelerNames ?? this.assignedTravelerNames,
      assignedUnitIds: assignedUnitIds ?? this.assignedUnitIds,
      vendorId: vendorId ?? this.vendorId,
      vendorName: vendorName ?? this.vendorName,
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
