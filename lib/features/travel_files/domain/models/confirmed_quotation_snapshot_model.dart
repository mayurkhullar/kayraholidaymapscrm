import 'package:cloud_firestore/cloud_firestore.dart';

import 'package:kayraholidaymapscrm/core/constants/app_enums.dart';
import 'package:kayraholidaymapscrm/shared/models/date_range_model.dart';
import 'package:kayraholidaymapscrm/shared/models/passenger_count_model.dart';

class ConfirmedQuotationSnapshotModel {
  const ConfirmedQuotationSnapshotModel({
    this.quotationId,
    this.quotationCode,
    this.versionNumber,
    this.travelType = TravelType.fit,
    this.tripScope = TripScope.international,
    this.destination,
    this.travelDates,
    this.passengerCount,
    this.totalSellingPrice,
    this.totalVendorCost,
    this.profit,
    this.profitPercentage,
    this.selectedHotelNames = const <String>[],
    this.selectedFlightNames = const <String>[],
    this.confirmedAt,
    this.confirmedBy,
  });

  final String? quotationId;
  final String? quotationCode;
  final int? versionNumber;
  final TravelType travelType;
  final TripScope tripScope;
  final String? destination;
  final DateRangeModel? travelDates;
  final PassengerCountModel? passengerCount;
  final double? totalSellingPrice;
  final double? totalVendorCost;
  final double? profit;
  final double? profitPercentage;
  final List<String> selectedHotelNames;
  final List<String> selectedFlightNames;
  final DateTime? confirmedAt;
  final String? confirmedBy;

  factory ConfirmedQuotationSnapshotModel.fromMap(Map<String, dynamic> map) {
    return ConfirmedQuotationSnapshotModel(
      quotationId: map['quotationId'] as String?,
      quotationCode: map['quotationCode'] as String?,
      versionNumber: (map['versionNumber'] as num?)?.toInt(),
      travelType: _travelTypeFromDynamic(map['travelType']),
      tripScope: _tripScopeFromDynamic(map['tripScope']),
      destination: map['destination'] as String?,
      travelDates: _dateRangeFromDynamic(map['travelDates']),
      passengerCount: _passengerCountFromDynamic(map['passengerCount']),
      totalSellingPrice: (map['totalSellingPrice'] as num?)?.toDouble(),
      totalVendorCost: (map['totalVendorCost'] as num?)?.toDouble(),
      profit: (map['profit'] as num?)?.toDouble(),
      profitPercentage: (map['profitPercentage'] as num?)?.toDouble(),
      selectedHotelNames: _stringListFromDynamic(map['selectedHotelNames']),
      selectedFlightNames: _stringListFromDynamic(map['selectedFlightNames']),
      confirmedAt: _dateTimeFromDynamic(map['confirmedAt']),
      confirmedBy: map['confirmedBy'] as String?,
    );
  }

  Map<String, dynamic> toMap() {
    return <String, dynamic>{
      'quotationId': quotationId,
      'quotationCode': quotationCode,
      'versionNumber': versionNumber,
      'travelType': travelType.firestoreValue,
      'tripScope': tripScope.firestoreValue,
      'destination': destination,
      'travelDates': travelDates?.toMap(),
      'passengerCount': passengerCount?.toMap(),
      'totalSellingPrice': totalSellingPrice,
      'totalVendorCost': totalVendorCost,
      'profit': profit,
      'profitPercentage': profitPercentage,
      'selectedHotelNames': selectedHotelNames,
      'selectedFlightNames': selectedFlightNames,
      'confirmedAt': confirmedAt,
      'confirmedBy': confirmedBy,
    };
  }

  ConfirmedQuotationSnapshotModel copyWith({
    String? quotationId,
    String? quotationCode,
    int? versionNumber,
    TravelType? travelType,
    TripScope? tripScope,
    String? destination,
    DateRangeModel? travelDates,
    PassengerCountModel? passengerCount,
    double? totalSellingPrice,
    double? totalVendorCost,
    double? profit,
    double? profitPercentage,
    List<String>? selectedHotelNames,
    List<String>? selectedFlightNames,
    DateTime? confirmedAt,
    String? confirmedBy,
  }) {
    return ConfirmedQuotationSnapshotModel(
      quotationId: quotationId ?? this.quotationId,
      quotationCode: quotationCode ?? this.quotationCode,
      versionNumber: versionNumber ?? this.versionNumber,
      travelType: travelType ?? this.travelType,
      tripScope: tripScope ?? this.tripScope,
      destination: destination ?? this.destination,
      travelDates: travelDates ?? this.travelDates,
      passengerCount: passengerCount ?? this.passengerCount,
      totalSellingPrice: totalSellingPrice ?? this.totalSellingPrice,
      totalVendorCost: totalVendorCost ?? this.totalVendorCost,
      profit: profit ?? this.profit,
      profitPercentage: profitPercentage ?? this.profitPercentage,
      selectedHotelNames: selectedHotelNames ?? this.selectedHotelNames,
      selectedFlightNames: selectedFlightNames ?? this.selectedFlightNames,
      confirmedAt: confirmedAt ?? this.confirmedAt,
      confirmedBy: confirmedBy ?? this.confirmedBy,
    );
  }
}

DateRangeModel? _dateRangeFromDynamic(dynamic value) {
  final map = _mapFromDynamic(value);
  if (map == null) {
    return null;
  }

  return DateRangeModel.fromMap(map);
}

PassengerCountModel? _passengerCountFromDynamic(dynamic value) {
  final map = _mapFromDynamic(value);
  if (map == null) {
    return null;
  }

  return PassengerCountModel.fromMap(map);
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

Map<String, dynamic>? _mapFromDynamic(dynamic value) {
  if (value is Map<String, dynamic>) {
    return value;
  }

  if (value is Map) {
    return value.map((key, dynamic nestedValue) => MapEntry('$key', nestedValue));
  }

  return null;
}

List<String> _stringListFromDynamic(dynamic value) {
  if (value is Iterable) {
    return value.whereType<String>().toList(growable: false);
  }

  return const <String>[];
}
TravelType _travelTypeFromDynamic(dynamic value) {
  if (value is TravelType) {
    return value;
  }

  if (value is String && value.trim().isNotEmpty) {
    try {
      return TravelTypeX.fromString(value);
    } on ArgumentError {
      return TravelType.fit;
    }
  }

  return TravelType.fit;
}

TripScope _tripScopeFromDynamic(dynamic value) {
  if (value is TripScope) {
    return value;
  }

  if (value is String && value.trim().isNotEmpty) {
    try {
      return TripScopeX.fromString(value);
    } on ArgumentError {
      return TripScope.international;
    }
  }

  return TripScope.international;
}
