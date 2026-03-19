import 'package:cloud_firestore/cloud_firestore.dart';

class HotelAssignmentModel {
  const HotelAssignmentModel({
    required this.id,
    this.hotelId,
    this.hotelName,
    this.bookingId,
    this.roomCategoryId,
    this.roomCategoryName,
    this.mealPlan,
    this.checkInDate,
    this.checkOutDate,
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
  final String? hotelId;
  final String? hotelName;
  final String? bookingId;
  final String? roomCategoryId;
  final String? roomCategoryName;
  final String? mealPlan;
  final DateTime? checkInDate;
  final DateTime? checkOutDate;
  final List<String> assignedTravelerIds;
  final List<String> assignedUnitIds;
  final String? createdBy;
  final DateTime? createdAt;
  final String? updatedBy;
  final DateTime? updatedAt;
  final bool isArchived;
  final String? archivedBy;
  final DateTime? archivedAt;

  factory HotelAssignmentModel.fromMap(Map<String, dynamic> map) {
    return HotelAssignmentModel(
      id: (map['id'] as String?) ?? '',
      hotelId: map['hotelId'] as String?,
      hotelName: map['hotelName'] as String?,
      bookingId: map['bookingId'] as String?,
      roomCategoryId: map['roomCategoryId'] as String?,
      roomCategoryName: map['roomCategoryName'] as String?,
      mealPlan: map['mealPlan'] as String?,
      checkInDate: _dateTimeFromDynamic(map['checkInDate']),
      checkOutDate: _dateTimeFromDynamic(map['checkOutDate']),
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
      'hotelId': hotelId,
      'hotelName': hotelName,
      'bookingId': bookingId,
      'roomCategoryId': roomCategoryId,
      'roomCategoryName': roomCategoryName,
      'mealPlan': mealPlan,
      'checkInDate': checkInDate,
      'checkOutDate': checkOutDate,
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

  HotelAssignmentModel copyWith({
    String? id,
    String? hotelId,
    String? hotelName,
    String? bookingId,
    String? roomCategoryId,
    String? roomCategoryName,
    String? mealPlan,
    DateTime? checkInDate,
    DateTime? checkOutDate,
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
    return HotelAssignmentModel(
      id: id ?? this.id,
      hotelId: hotelId ?? this.hotelId,
      hotelName: hotelName ?? this.hotelName,
      bookingId: bookingId ?? this.bookingId,
      roomCategoryId: roomCategoryId ?? this.roomCategoryId,
      roomCategoryName: roomCategoryName ?? this.roomCategoryName,
      mealPlan: mealPlan ?? this.mealPlan,
      checkInDate: checkInDate ?? this.checkInDate,
      checkOutDate: checkOutDate ?? this.checkOutDate,
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
