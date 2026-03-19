import 'package:cloud_firestore/cloud_firestore.dart';

class RoomingModel {
  const RoomingModel({
    required this.id,
    this.roomLabel,
    this.actualRoomNumber,
    this.hotelId,
    this.hotelName,
    this.roomCategoryId,
    this.roomCategoryName,
    this.occupantTravelerIds = const <String>[],
    this.occupantTravelerNames = const <String>[],
    this.occupantCount = 0,
    this.recommendedMaxAdults,
    this.recommendedMaxChildren,
    this.recommendedMaxInfants,
    this.capacityWarning = false,
    this.capacityOverrideApproved = false,
    this.capacityOverrideApprovedBy,
    this.capacityOverrideApprovedAt,
    this.extraBedRequired = false,
    this.adjacentRoomRequired = false,
    this.sameFloorRequired = false,
    this.nearLiftRequired = false,
    this.groundFloorPreferred = false,
    this.seniorCitizenInRoom = false,
    this.wheelchairAccessibleRequired = false,
    this.interconnectingRoomRequired = false,
    this.createdBy,
    this.createdAt,
    this.updatedBy,
    this.updatedAt,
    this.isArchived = false,
    this.archivedBy,
    this.archivedAt,
  });

  final String id;
  final String? roomLabel;
  final String? actualRoomNumber;
  final String? hotelId;
  final String? hotelName;
  final String? roomCategoryId;
  final String? roomCategoryName;
  final List<String> occupantTravelerIds;
  final List<String> occupantTravelerNames;
  final int occupantCount;
  final int? recommendedMaxAdults;
  final int? recommendedMaxChildren;
  final int? recommendedMaxInfants;
  final bool capacityWarning;
  final bool capacityOverrideApproved;
  final String? capacityOverrideApprovedBy;
  final DateTime? capacityOverrideApprovedAt;
  final bool extraBedRequired;
  final bool adjacentRoomRequired;
  final bool sameFloorRequired;
  final bool nearLiftRequired;
  final bool groundFloorPreferred;
  final bool seniorCitizenInRoom;
  final bool wheelchairAccessibleRequired;
  final bool interconnectingRoomRequired;
  final String? createdBy;
  final DateTime? createdAt;
  final String? updatedBy;
  final DateTime? updatedAt;
  final bool isArchived;
  final String? archivedBy;
  final DateTime? archivedAt;

  factory RoomingModel.fromMap(Map<String, dynamic> map) {
    return RoomingModel(
      id: (map['id'] as String?) ?? '',
      roomLabel: map['roomLabel'] as String?,
      actualRoomNumber: map['actualRoomNumber'] as String?,
      hotelId: map['hotelId'] as String?,
      hotelName: map['hotelName'] as String?,
      roomCategoryId: map['roomCategoryId'] as String?,
      roomCategoryName: map['roomCategoryName'] as String?,
      occupantTravelerIds: _stringListFromDynamic(map['occupantTravelerIds']),
      occupantTravelerNames: _stringListFromDynamic(map['occupantTravelerNames']),
      occupantCount: (map['occupantCount'] as num?)?.toInt() ?? 0,
      recommendedMaxAdults: (map['recommendedMaxAdults'] as num?)?.toInt(),
      recommendedMaxChildren: (map['recommendedMaxChildren'] as num?)?.toInt(),
      recommendedMaxInfants: (map['recommendedMaxInfants'] as num?)?.toInt(),
      capacityWarning: (map['capacityWarning'] as bool?) ?? false,
      capacityOverrideApproved: (map['capacityOverrideApproved'] as bool?) ?? false,
      capacityOverrideApprovedBy: map['capacityOverrideApprovedBy'] as String?,
      capacityOverrideApprovedAt: _dateTimeFromDynamic(map['capacityOverrideApprovedAt']),
      extraBedRequired: (map['extraBedRequired'] as bool?) ?? false,
      adjacentRoomRequired: (map['adjacentRoomRequired'] as bool?) ?? false,
      sameFloorRequired: (map['sameFloorRequired'] as bool?) ?? false,
      nearLiftRequired: (map['nearLiftRequired'] as bool?) ?? false,
      groundFloorPreferred: (map['groundFloorPreferred'] as bool?) ?? false,
      seniorCitizenInRoom: (map['seniorCitizenInRoom'] as bool?) ?? false,
      wheelchairAccessibleRequired: (map['wheelchairAccessibleRequired'] as bool?) ?? false,
      interconnectingRoomRequired: (map['interconnectingRoomRequired'] as bool?) ?? false,
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
      'roomLabel': roomLabel,
      'actualRoomNumber': actualRoomNumber,
      'hotelId': hotelId,
      'hotelName': hotelName,
      'roomCategoryId': roomCategoryId,
      'roomCategoryName': roomCategoryName,
      'occupantTravelerIds': occupantTravelerIds,
      'occupantTravelerNames': occupantTravelerNames,
      'occupantCount': occupantCount,
      'recommendedMaxAdults': recommendedMaxAdults,
      'recommendedMaxChildren': recommendedMaxChildren,
      'recommendedMaxInfants': recommendedMaxInfants,
      'capacityWarning': capacityWarning,
      'capacityOverrideApproved': capacityOverrideApproved,
      'capacityOverrideApprovedBy': capacityOverrideApprovedBy,
      'capacityOverrideApprovedAt': capacityOverrideApprovedAt,
      'extraBedRequired': extraBedRequired,
      'adjacentRoomRequired': adjacentRoomRequired,
      'sameFloorRequired': sameFloorRequired,
      'nearLiftRequired': nearLiftRequired,
      'groundFloorPreferred': groundFloorPreferred,
      'seniorCitizenInRoom': seniorCitizenInRoom,
      'wheelchairAccessibleRequired': wheelchairAccessibleRequired,
      'interconnectingRoomRequired': interconnectingRoomRequired,
      'createdBy': createdBy,
      'createdAt': createdAt,
      'updatedBy': updatedBy,
      'updatedAt': updatedAt,
      'isArchived': isArchived,
      'archivedBy': archivedBy,
      'archivedAt': archivedAt,
    };
  }

  RoomingModel copyWith({
    String? id,
    String? roomLabel,
    String? actualRoomNumber,
    String? hotelId,
    String? hotelName,
    String? roomCategoryId,
    String? roomCategoryName,
    List<String>? occupantTravelerIds,
    List<String>? occupantTravelerNames,
    int? occupantCount,
    int? recommendedMaxAdults,
    int? recommendedMaxChildren,
    int? recommendedMaxInfants,
    bool? capacityWarning,
    bool? capacityOverrideApproved,
    String? capacityOverrideApprovedBy,
    DateTime? capacityOverrideApprovedAt,
    bool? extraBedRequired,
    bool? adjacentRoomRequired,
    bool? sameFloorRequired,
    bool? nearLiftRequired,
    bool? groundFloorPreferred,
    bool? seniorCitizenInRoom,
    bool? wheelchairAccessibleRequired,
    bool? interconnectingRoomRequired,
    String? createdBy,
    DateTime? createdAt,
    String? updatedBy,
    DateTime? updatedAt,
    bool? isArchived,
    String? archivedBy,
    DateTime? archivedAt,
  }) {
    return RoomingModel(
      id: id ?? this.id,
      roomLabel: roomLabel ?? this.roomLabel,
      actualRoomNumber: actualRoomNumber ?? this.actualRoomNumber,
      hotelId: hotelId ?? this.hotelId,
      hotelName: hotelName ?? this.hotelName,
      roomCategoryId: roomCategoryId ?? this.roomCategoryId,
      roomCategoryName: roomCategoryName ?? this.roomCategoryName,
      occupantTravelerIds: occupantTravelerIds ?? this.occupantTravelerIds,
      occupantTravelerNames: occupantTravelerNames ?? this.occupantTravelerNames,
      occupantCount: occupantCount ?? this.occupantCount,
      recommendedMaxAdults: recommendedMaxAdults ?? this.recommendedMaxAdults,
      recommendedMaxChildren: recommendedMaxChildren ?? this.recommendedMaxChildren,
      recommendedMaxInfants: recommendedMaxInfants ?? this.recommendedMaxInfants,
      capacityWarning: capacityWarning ?? this.capacityWarning,
      capacityOverrideApproved: capacityOverrideApproved ?? this.capacityOverrideApproved,
      capacityOverrideApprovedBy: capacityOverrideApprovedBy ?? this.capacityOverrideApprovedBy,
      capacityOverrideApprovedAt: capacityOverrideApprovedAt ?? this.capacityOverrideApprovedAt,
      extraBedRequired: extraBedRequired ?? this.extraBedRequired,
      adjacentRoomRequired: adjacentRoomRequired ?? this.adjacentRoomRequired,
      sameFloorRequired: sameFloorRequired ?? this.sameFloorRequired,
      nearLiftRequired: nearLiftRequired ?? this.nearLiftRequired,
      groundFloorPreferred: groundFloorPreferred ?? this.groundFloorPreferred,
      seniorCitizenInRoom: seniorCitizenInRoom ?? this.seniorCitizenInRoom,
      wheelchairAccessibleRequired: wheelchairAccessibleRequired ?? this.wheelchairAccessibleRequired,
      interconnectingRoomRequired: interconnectingRoomRequired ?? this.interconnectingRoomRequired,
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
