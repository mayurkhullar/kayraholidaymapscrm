import 'package:cloud_firestore/cloud_firestore.dart';

class ClientLifetimeStatsModel {
  const ClientLifetimeStatsModel({
    this.totalTrips = 0,
    this.totalRevenue = 0,
    this.totalTravelers = 0,
    this.favoriteDestination,
    this.lastTripDate,
  });

  final int totalTrips;
  final num totalRevenue;
  final int totalTravelers;
  final String? favoriteDestination;
  final DateTime? lastTripDate;

  factory ClientLifetimeStatsModel.fromMap(Map<String, dynamic> map) {
    return ClientLifetimeStatsModel(
      totalTrips: _intFromDynamic(map['totalTrips']),
      totalRevenue: _numFromDynamic(map['totalRevenue']),
      totalTravelers: _intFromDynamic(map['totalTravelers']),
      favoriteDestination: map['favoriteDestination'] as String?,
      lastTripDate: _dateTimeFromDynamic(map['lastTripDate']),
    );
  }

  Map<String, dynamic> toMap() {
    return <String, dynamic>{
      'totalTrips': totalTrips,
      'totalRevenue': totalRevenue,
      'totalTravelers': totalTravelers,
      'favoriteDestination': favoriteDestination,
      'lastTripDate': lastTripDate,
    };
  }

  ClientLifetimeStatsModel copyWith({
    int? totalTrips,
    num? totalRevenue,
    int? totalTravelers,
    String? favoriteDestination,
    DateTime? lastTripDate,
  }) {
    return ClientLifetimeStatsModel(
      totalTrips: totalTrips ?? this.totalTrips,
      totalRevenue: totalRevenue ?? this.totalRevenue,
      totalTravelers: totalTravelers ?? this.totalTravelers,
      favoriteDestination: favoriteDestination ?? this.favoriteDestination,
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

num _numFromDynamic(dynamic value) {
  if (value is num) {
    return value;
  }

  if (value is String) {
    final parsedInt = int.tryParse(value);
    if (parsedInt != null) {
      return parsedInt;
    }

    return double.tryParse(value) ?? 0;
  }

  return 0;
}
