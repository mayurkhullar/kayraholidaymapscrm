import 'package:cloud_firestore/cloud_firestore.dart';

class PassportDetailsModel {
  const PassportDetailsModel({
    this.passportNumber,
    this.surname,
    this.givenNames,
    this.nationality,
    this.gender,
    this.dateOfBirth,
    this.placeOfBirth,
    this.dateOfIssue,
    this.dateOfExpiry,
    this.placeOfIssue,
    this.issuingCountry,
    this.passportType,
    this.countryCode,
    this.mrzLine1,
    this.mrzLine2,
  });

  final String? passportNumber;
  final String? surname;
  final String? givenNames;
  final String? nationality;
  final String? gender;
  final DateTime? dateOfBirth;
  final String? placeOfBirth;
  final DateTime? dateOfIssue;
  final DateTime? dateOfExpiry;
  final String? placeOfIssue;
  final String? issuingCountry;
  final String? passportType;
  final String? countryCode;
  final String? mrzLine1;
  final String? mrzLine2;

  factory PassportDetailsModel.fromMap(Map<String, dynamic> map) {
    return PassportDetailsModel(
      passportNumber: map['passportNumber'] as String?,
      surname: map['surname'] as String?,
      givenNames: map['givenNames'] as String?,
      nationality: map['nationality'] as String?,
      gender: map['gender'] as String?,
      dateOfBirth: _dateTimeFromDynamic(map['dateOfBirth']),
      placeOfBirth: map['placeOfBirth'] as String?,
      dateOfIssue: _dateTimeFromDynamic(map['dateOfIssue']),
      dateOfExpiry: _dateTimeFromDynamic(map['dateOfExpiry']),
      placeOfIssue: map['placeOfIssue'] as String?,
      issuingCountry: map['issuingCountry'] as String?,
      passportType: map['passportType'] as String?,
      countryCode: map['countryCode'] as String?,
      mrzLine1: map['mrzLine1'] as String?,
      mrzLine2: map['mrzLine2'] as String?,
    );
  }

  Map<String, dynamic> toMap() {
    return <String, dynamic>{
      'passportNumber': passportNumber,
      'surname': surname,
      'givenNames': givenNames,
      'nationality': nationality,
      'gender': gender,
      'dateOfBirth': dateOfBirth,
      'placeOfBirth': placeOfBirth,
      'dateOfIssue': dateOfIssue,
      'dateOfExpiry': dateOfExpiry,
      'placeOfIssue': placeOfIssue,
      'issuingCountry': issuingCountry,
      'passportType': passportType,
      'countryCode': countryCode,
      'mrzLine1': mrzLine1,
      'mrzLine2': mrzLine2,
    };
  }

  PassportDetailsModel copyWith({
    String? passportNumber,
    String? surname,
    String? givenNames,
    String? nationality,
    String? gender,
    DateTime? dateOfBirth,
    String? placeOfBirth,
    DateTime? dateOfIssue,
    DateTime? dateOfExpiry,
    String? placeOfIssue,
    String? issuingCountry,
    String? passportType,
    String? countryCode,
    String? mrzLine1,
    String? mrzLine2,
  }) {
    return PassportDetailsModel(
      passportNumber: passportNumber ?? this.passportNumber,
      surname: surname ?? this.surname,
      givenNames: givenNames ?? this.givenNames,
      nationality: nationality ?? this.nationality,
      gender: gender ?? this.gender,
      dateOfBirth: dateOfBirth ?? this.dateOfBirth,
      placeOfBirth: placeOfBirth ?? this.placeOfBirth,
      dateOfIssue: dateOfIssue ?? this.dateOfIssue,
      dateOfExpiry: dateOfExpiry ?? this.dateOfExpiry,
      placeOfIssue: placeOfIssue ?? this.placeOfIssue,
      issuingCountry: issuingCountry ?? this.issuingCountry,
      passportType: passportType ?? this.passportType,
      countryCode: countryCode ?? this.countryCode,
      mrzLine1: mrzLine1 ?? this.mrzLine1,
      mrzLine2: mrzLine2 ?? this.mrzLine2,
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
