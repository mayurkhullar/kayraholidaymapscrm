import 'package:cloud_firestore/cloud_firestore.dart';

import 'passport_details_model.dart';
import 'traveler_trip_stats_model.dart';

class TravelerModel {
  const TravelerModel({
    required this.id,
    required this.travelerCode,
    this.title,
    this.firstName,
    this.middleName,
    this.lastName,
    this.displayName,
    this.phone,
    this.alternatePhones = const <String>[],
    this.email,
    this.companyId,
    this.dateOfBirth,
    this.gender,
    this.nationality,
    this.passport,
    this.passportValidityDays,
    this.passportValidityStatus,
    this.passportNameMatchesTravelerName = true,
    this.tripStats,
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
  final String travelerCode;
  final String? title;
  final String? firstName;
  final String? middleName;
  final String? lastName;
  final String? displayName;
  final String? phone;
  final List<String> alternatePhones;
  final String? email;
  final String? companyId;
  final DateTime? dateOfBirth;
  final String? gender;
  final String? nationality;
  final PassportDetailsModel? passport;
  final int? passportValidityDays;
  final String? passportValidityStatus;
  final bool passportNameMatchesTravelerName;
  final TravelerTripStatsModel? tripStats;
  final List<String> searchTokens;
  final String? createdBy;
  final DateTime? createdAt;
  final String? updatedBy;
  final DateTime? updatedAt;
  final bool isArchived;
  final String? archivedBy;
  final DateTime? archivedAt;

  factory TravelerModel.fromMap(Map<String, dynamic> map) {
    return TravelerModel(
      id: (map['id'] as String?) ?? '',
      travelerCode: (map['travelerCode'] as String?) ?? '',
      title: map['title'] as String?,
      firstName: map['firstName'] as String?,
      middleName: map['middleName'] as String?,
      lastName: map['lastName'] as String?,
      displayName: map['displayName'] as String?,
      phone: map['phone'] as String?,
      alternatePhones: _stringListFromDynamic(map['alternatePhones']),
      email: map['email'] as String?,
      companyId: map['companyId'] as String?,
      dateOfBirth: _dateTimeFromDynamic(map['dateOfBirth']),
      gender: map['gender'] as String?,
      nationality: map['nationality'] as String?,
      passport: _passportFromDynamic(map['passport']),
      passportValidityDays: _nullableIntFromDynamic(map['passportValidityDays']),
      passportValidityStatus: map['passportValidityStatus'] as String?,
      passportNameMatchesTravelerName:
          (map['passportNameMatchesTravelerName'] as bool?) ?? true,
      tripStats: _tripStatsFromDynamic(map['tripStats']),
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
      'travelerCode': travelerCode,
      'title': title,
      'firstName': firstName,
      'middleName': middleName,
      'lastName': lastName,
      'displayName': displayName,
      'phone': phone,
      'alternatePhones': alternatePhones,
      'email': email,
      'companyId': companyId,
      'dateOfBirth': dateOfBirth,
      'gender': gender,
      'nationality': nationality,
      'passport': passport?.toMap(),
      'passportValidityDays': passportValidityDays,
      'passportValidityStatus': passportValidityStatus,
      'passportNameMatchesTravelerName': passportNameMatchesTravelerName,
      'tripStats': tripStats?.toMap(),
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

  TravelerModel copyWith({
    String? id,
    String? travelerCode,
    String? title,
    String? firstName,
    String? middleName,
    String? lastName,
    String? displayName,
    String? phone,
    List<String>? alternatePhones,
    String? email,
    String? companyId,
    DateTime? dateOfBirth,
    String? gender,
    String? nationality,
    PassportDetailsModel? passport,
    int? passportValidityDays,
    String? passportValidityStatus,
    bool? passportNameMatchesTravelerName,
    TravelerTripStatsModel? tripStats,
    List<String>? searchTokens,
    String? createdBy,
    DateTime? createdAt,
    String? updatedBy,
    DateTime? updatedAt,
    bool? isArchived,
    String? archivedBy,
    DateTime? archivedAt,
  }) {
    return TravelerModel(
      id: id ?? this.id,
      travelerCode: travelerCode ?? this.travelerCode,
      title: title ?? this.title,
      firstName: firstName ?? this.firstName,
      middleName: middleName ?? this.middleName,
      lastName: lastName ?? this.lastName,
      displayName: displayName ?? this.displayName,
      phone: phone ?? this.phone,
      alternatePhones: alternatePhones ?? this.alternatePhones,
      email: email ?? this.email,
      companyId: companyId ?? this.companyId,
      dateOfBirth: dateOfBirth ?? this.dateOfBirth,
      gender: gender ?? this.gender,
      nationality: nationality ?? this.nationality,
      passport: passport ?? this.passport,
      passportValidityDays: passportValidityDays ?? this.passportValidityDays,
      passportValidityStatus:
          passportValidityStatus ?? this.passportValidityStatus,
      passportNameMatchesTravelerName:
          passportNameMatchesTravelerName ??
          this.passportNameMatchesTravelerName,
      tripStats: tripStats ?? this.tripStats,
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

TravelerTripStatsModel? _tripStatsFromDynamic(dynamic value) {
  if (value is Map<String, dynamic>) {
    return TravelerTripStatsModel.fromMap(value);
  }

  if (value is Map) {
    return TravelerTripStatsModel.fromMap(
      value.map((key, dynamic nestedValue) => MapEntry('$key', nestedValue)),
    );
  }

  return null;
}
