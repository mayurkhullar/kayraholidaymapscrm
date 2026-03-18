import 'package:cloud_firestore/cloud_firestore.dart';

class TravelerTripStatsModel {
  const TravelerTripStatsModel({
    this.totalTrips = 0,
    this.lastTripDate,
  });

  final int totalTrips;
  final DateTime? lastTripDate;

  factory TravelerTripStatsModel.fromMap(Map<String, dynamic> map) {
    return TravelerTripStatsModel(
      totalTrips: _intFromDynamic(map['totalTrips']),
      lastTripDate: _dateTimeFromDynamic(map['lastTripDate']),
    );
  }

  Map<String, dynamic> toMap() {
    return <String, dynamic>{
      'totalTrips': totalTrips,
      'lastTripDate': lastTripDate,
    };
  }

  TravelerTripStatsModel copyWith({
    int? totalTrips,
    DateTime? lastTripDate,
  }) {
    return TravelerTripStatsModel(
      totalTrips: totalTrips ?? this.totalTrips,
      lastTripDate: lastTripDate ?? this.lastTripDate,
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
    return int.tryParse(value) ?? 0;
  }

  return 0;
}
