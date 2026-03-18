import 'package:cloud_firestore/cloud_firestore.dart';

class FlightAssignmentModel {
  const FlightAssignmentModel({
    required this.id,
    this.flightId,
    this.flightNumber,
    this.airlineName,
    this.journeyType,
    this.departureDateTime,
    this.arrivalDateTime,
    this.originAirport,
    this.destinationAirport,
    this.assignedTravelerIds = const <String>[],
    this.assignedUnitIds = const <String>[],
    this.createdBy,
    this.createdAt,
    this.updatedBy,
    this.updatedAt,
    this.isArchived = false,
    this.archivedBy,
    this.archivedAt,
  });

  final String id;
  final String? flightId;
  final String? flightNumber;
  final String? airlineName;
  final String? journeyType;
  final DateTime? departureDateTime;
  final DateTime? arrivalDateTime;
  final String? originAirport;
  final String? destinationAirport;
  final List<String> assignedTravelerIds;
  final List<String> assignedUnitIds;
  final String? createdBy;
  final DateTime? createdAt;
  final String? updatedBy;
  final DateTime? updatedAt;
  final bool isArchived;
  final String? archivedBy;
  final DateTime? archivedAt;

  factory FlightAssignmentModel.fromMap(Map<String, dynamic> map) {
    return FlightAssignmentModel(
      id: (map['id'] as String?) ?? '',
      flightId: map['flightId'] as String?,
      flightNumber: map['flightNumber'] as String?,
      airlineName: map['airlineName'] as String?,
      journeyType: map['journeyType'] as String?,
      departureDateTime: _dateTimeFromDynamic(map['departureDateTime']),
      arrivalDateTime: _dateTimeFromDynamic(map['arrivalDateTime']),
      originAirport: map['originAirport'] as String?,
      destinationAirport: map['destinationAirport'] as String?,
      assignedTravelerIds: _stringListFromDynamic(map['assignedTravelerIds']),
      assignedUnitIds: _stringListFromDynamic(map['assignedUnitIds']),
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
      'flightId': flightId,
      'flightNumber': flightNumber,
      'airlineName': airlineName,
      'journeyType': journeyType,
      'departureDateTime': departureDateTime,
      'arrivalDateTime': arrivalDateTime,
      'originAirport': originAirport,
      'destinationAirport': destinationAirport,
      'assignedTravelerIds': assignedTravelerIds,
      'assignedUnitIds': assignedUnitIds,
      'createdBy': createdBy,
      'createdAt': createdAt,
      'updatedBy': updatedBy,
      'updatedAt': updatedAt,
      'isArchived': isArchived,
      'archivedBy': archivedBy,
      'archivedAt': archivedAt,
    };
  }

  FlightAssignmentModel copyWith({
    String? id,
    String? flightId,
    String? flightNumber,
    String? airlineName,
    String? journeyType,
    DateTime? departureDateTime,
    DateTime? arrivalDateTime,
    String? originAirport,
    String? destinationAirport,
    List<String>? assignedTravelerIds,
    List<String>? assignedUnitIds,
    String? createdBy,
    DateTime? createdAt,
    String? updatedBy,
    DateTime? updatedAt,
    bool? isArchived,
    String? archivedBy,
    DateTime? archivedAt,
  }) {
    return FlightAssignmentModel(
      id: id ?? this.id,
      flightId: flightId ?? this.flightId,
      flightNumber: flightNumber ?? this.flightNumber,
      airlineName: airlineName ?? this.airlineName,
      journeyType: journeyType ?? this.journeyType,
      departureDateTime: departureDateTime ?? this.departureDateTime,
      arrivalDateTime: arrivalDateTime ?? this.arrivalDateTime,
      originAirport: originAirport ?? this.originAirport,
      destinationAirport: destinationAirport ?? this.destinationAirport,
      assignedTravelerIds: assignedTravelerIds ?? this.assignedTravelerIds,
      assignedUnitIds: assignedUnitIds ?? this.assignedUnitIds,
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
