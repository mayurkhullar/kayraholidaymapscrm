import 'package:cloud_firestore/cloud_firestore.dart';

import '../../../../core/constants/app_enums.dart';
import 'passport_details_model.dart';

class GroupTravelerModel {
  const GroupTravelerModel({
    required this.id,
    this.travelerSerial,
    this.linkedGlobalTravelerId,
    this.title,
    this.firstName,
    this.middleName,
    this.lastName,
    this.displayName,
    this.phone,
    this.alternatePhones = const <String>[],
    this.email,
    this.dateOfBirth,
    this.gender,
    this.nationality,
    this.travelerCategory,
    this.passport,
    this.passportValidityDays,
    this.passportValidityStatus,
    this.passportNameMatchesTravelerName = true,
    this.visaStatus,
    this.visaRejectionReason,
    this.unitId,
    this.roleInUnit,
    this.arrivalFlightAssignmentId,
    this.departureFlightAssignmentId,
    this.hotelAssignmentIds = const <String>[],
    this.transportAssignmentIds = const <String>[],
    this.roomAssignmentId,
    this.passportDocumentId,
    this.searchTokens = const <String>[],
    this.createdBy,
    this.createdAt,
    this.updatedBy,
    this.updatedAt,
    this.isArchived = false,
    this.archivedBy,
    this.archivedAt,
  });

  final String id;
  final String? travelerSerial;
  final String? linkedGlobalTravelerId;
  final String? title;
  final String? firstName;
  final String? middleName;
  final String? lastName;
  final String? displayName;
  final String? phone;
  final List<String> alternatePhones;
  final String? email;
  final DateTime? dateOfBirth;
  final String? gender;
  final String? nationality;
  final TravelerCategory? travelerCategory;
  final PassportDetailsModel? passport;
  final int? passportValidityDays;
  final String? passportValidityStatus;
  final bool passportNameMatchesTravelerName;
  final VisaStatus? visaStatus;
  final String? visaRejectionReason;
  final String? unitId;
  final String? roleInUnit;
  final String? arrivalFlightAssignmentId;
  final String? departureFlightAssignmentId;
  final List<String> hotelAssignmentIds;
  final List<String> transportAssignmentIds;
  final String? roomAssignmentId;
  final String? passportDocumentId;
  final List<String> searchTokens;
  final String? createdBy;
  final DateTime? createdAt;
  final String? updatedBy;
  final DateTime? updatedAt;
  final bool isArchived;
  final String? archivedBy;
  final DateTime? archivedAt;

  factory GroupTravelerModel.fromMap(Map<String, dynamic> map) {
    return GroupTravelerModel(
      id: (map['id'] as String?) ?? '',
      travelerSerial: map['travelerSerial'] as String?,
      linkedGlobalTravelerId: map['linkedGlobalTravelerId'] as String?,
      title: map['title'] as String?,
      firstName: map['firstName'] as String?,
      middleName: map['middleName'] as String?,
      lastName: map['lastName'] as String?,
      displayName: map['displayName'] as String?,
      phone: map['phone'] as String?,
      alternatePhones: _stringListFromDynamic(map['alternatePhones']),
      email: map['email'] as String?,
      dateOfBirth: _dateTimeFromDynamic(map['dateOfBirth']),
      gender: map['gender'] as String?,
      nationality: map['nationality'] as String?,
      travelerCategory: _travelerCategoryFromDynamic(map['travelerCategory']),
      passport: _passportFromDynamic(map['passport']),
      passportValidityDays: _nullableIntFromDynamic(map['passportValidityDays']),
      passportValidityStatus: map['passportValidityStatus'] as String?,
      passportNameMatchesTravelerName:
          (map['passportNameMatchesTravelerName'] as bool?) ?? true,
      visaStatus: _visaStatusFromDynamic(map['visaStatus']),
      visaRejectionReason: map['visaRejectionReason'] as String?,
      unitId: map['unitId'] as String?,
      roleInUnit: map['roleInUnit'] as String?,
      arrivalFlightAssignmentId: map['arrivalFlightAssignmentId'] as String?,
      departureFlightAssignmentId:
          map['departureFlightAssignmentId'] as String?,
      hotelAssignmentIds: _stringListFromDynamic(map['hotelAssignmentIds']),
      transportAssignmentIds: _stringListFromDynamic(
        map['transportAssignmentIds'],
      ),
      roomAssignmentId: map['roomAssignmentId'] as String?,
      passportDocumentId: map['passportDocumentId'] as String?,
      searchTokens: _stringListFromDynamic(map['searchTokens']),
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
      'travelerSerial': travelerSerial,
      'linkedGlobalTravelerId': linkedGlobalTravelerId,
      'title': title,
      'firstName': firstName,
      'middleName': middleName,
      'lastName': lastName,
      'displayName': displayName,
      'phone': phone,
      'alternatePhones': alternatePhones,
      'email': email,
      'dateOfBirth': dateOfBirth,
      'gender': gender,
      'nationality': nationality,
      'travelerCategory': travelerCategory?.firestoreValue,
      'passport': passport?.toMap(),
      'passportValidityDays': passportValidityDays,
      'passportValidityStatus': passportValidityStatus,
      'passportNameMatchesTravelerName': passportNameMatchesTravelerName,
      'visaStatus': visaStatus?.firestoreValue,
      'visaRejectionReason': visaRejectionReason,
      'unitId': unitId,
      'roleInUnit': roleInUnit,
      'arrivalFlightAssignmentId': arrivalFlightAssignmentId,
      'departureFlightAssignmentId': departureFlightAssignmentId,
      'hotelAssignmentIds': hotelAssignmentIds,
      'transportAssignmentIds': transportAssignmentIds,
      'roomAssignmentId': roomAssignmentId,
      'passportDocumentId': passportDocumentId,
      'searchTokens': searchTokens,
      'createdBy': createdBy,
      'createdAt': createdAt,
      'updatedBy': updatedBy,
      'updatedAt': updatedAt,
      'isArchived': isArchived,
      'archivedBy': archivedBy,
      'archivedAt': archivedAt,
    };
  }

  GroupTravelerModel copyWith({
    String? id,
    String? travelerSerial,
    String? linkedGlobalTravelerId,
    String? title,
    String? firstName,
    String? middleName,
    String? lastName,
    String? displayName,
    String? phone,
    List<String>? alternatePhones,
    String? email,
    DateTime? dateOfBirth,
    String? gender,
    String? nationality,
    TravelerCategory? travelerCategory,
    PassportDetailsModel? passport,
    int? passportValidityDays,
    String? passportValidityStatus,
    bool? passportNameMatchesTravelerName,
    VisaStatus? visaStatus,
    String? visaRejectionReason,
    String? unitId,
    String? roleInUnit,
    String? arrivalFlightAssignmentId,
    String? departureFlightAssignmentId,
    List<String>? hotelAssignmentIds,
    List<String>? transportAssignmentIds,
    String? roomAssignmentId,
    String? passportDocumentId,
    List<String>? searchTokens,
    String? createdBy,
    DateTime? createdAt,
    String? updatedBy,
    DateTime? updatedAt,
    bool? isArchived,
    String? archivedBy,
    DateTime? archivedAt,
  }) {
    return GroupTravelerModel(
      id: id ?? this.id,
      travelerSerial: travelerSerial ?? this.travelerSerial,
      linkedGlobalTravelerId:
          linkedGlobalTravelerId ?? this.linkedGlobalTravelerId,
      title: title ?? this.title,
      firstName: firstName ?? this.firstName,
      middleName: middleName ?? this.middleName,
      lastName: lastName ?? this.lastName,
      displayName: displayName ?? this.displayName,
      phone: phone ?? this.phone,
      alternatePhones: alternatePhones ?? this.alternatePhones,
      email: email ?? this.email,
      dateOfBirth: dateOfBirth ?? this.dateOfBirth,
      gender: gender ?? this.gender,
      nationality: nationality ?? this.nationality,
      travelerCategory: travelerCategory ?? this.travelerCategory,
      passport: passport ?? this.passport,
      passportValidityDays: passportValidityDays ?? this.passportValidityDays,
      passportValidityStatus:
          passportValidityStatus ?? this.passportValidityStatus,
      passportNameMatchesTravelerName:
          passportNameMatchesTravelerName ??
          this.passportNameMatchesTravelerName,
      visaStatus: visaStatus ?? this.visaStatus,
      visaRejectionReason: visaRejectionReason ?? this.visaRejectionReason,
      unitId: unitId ?? this.unitId,
      roleInUnit: roleInUnit ?? this.roleInUnit,
      arrivalFlightAssignmentId:
          arrivalFlightAssignmentId ?? this.arrivalFlightAssignmentId,
      departureFlightAssignmentId:
          departureFlightAssignmentId ?? this.departureFlightAssignmentId,
      hotelAssignmentIds: hotelAssignmentIds ?? this.hotelAssignmentIds,
      transportAssignmentIds:
          transportAssignmentIds ?? this.transportAssignmentIds,
      roomAssignmentId: roomAssignmentId ?? this.roomAssignmentId,
      passportDocumentId: passportDocumentId ?? this.passportDocumentId,
      searchTokens: searchTokens ?? this.searchTokens,
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

int? _nullableIntFromDynamic(dynamic value) {
  if (value is int) {
    return value;
  }

  if (value is num) {
    return value.toInt();
  }

  if (value is String) {
    return int.tryParse(value);
  }

  return null;
}

PassportDetailsModel? _passportFromDynamic(dynamic value) {
  if (value is Map<String, dynamic>) {
    return PassportDetailsModel.fromMap(value);
  }

  if (value is Map) {
    return PassportDetailsModel.fromMap(
      value.map((key, dynamic nestedValue) => MapEntry('$key', nestedValue)),
    );
  }

  return null;
}

TravelerCategory? _travelerCategoryFromDynamic(dynamic value) {
  if (value is! String || value.trim().isEmpty) {
    return null;
  }

  try {
    return TravelerCategoryX.fromString(value);
  } on ArgumentError {
    return null;
  }
}

VisaStatus? _visaStatusFromDynamic(dynamic value) {
  if (value is! String || value.trim().isEmpty) {
    return null;
  }

  try {
    return VisaStatusX.fromString(value);
  } on ArgumentError {
    return null;
  }
}
