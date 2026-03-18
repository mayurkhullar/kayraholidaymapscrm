import 'package:cloud_firestore/cloud_firestore.dart';

class QuotationFlightItemModel {
  const QuotationFlightItemModel({
    this.flightId,
    this.displayName,
    this.fromAirport,
    this.toAirport,
    this.departureDateTime,
    this.arrivalDateTime,
    this.stoppageCount,
    this.vendorCost,
    this.sellingPrice,
  });

  final String? flightId;
  final String? displayName;
  final String? fromAirport;
  final String? toAirport;
  final DateTime? departureDateTime;
  final DateTime? arrivalDateTime;
  final int? stoppageCount;
  final num? vendorCost;
  final num? sellingPrice;

  factory QuotationFlightItemModel.fromMap(Map<String, dynamic> map) {
    return QuotationFlightItemModel(
      flightId: map['flightId'] as String?,
      displayName: map['displayName'] as String?,
      fromAirport: map['fromAirport'] as String?,
      toAirport: map['toAirport'] as String?,
      departureDateTime: _dateTimeFromDynamic(map['departureDateTime']),
      arrivalDateTime: _dateTimeFromDynamic(map['arrivalDateTime']),
      stoppageCount: (map['stoppageCount'] as num?)?.toInt(),
      vendorCost: map['vendorCost'] as num?,
      sellingPrice: map['sellingPrice'] as num?,
    );
  }

  Map<String, dynamic> toMap() {
    return <String, dynamic>{
      'flightId': flightId,
      'displayName': displayName,
      'fromAirport': fromAirport,
      'toAirport': toAirport,
      'departureDateTime': departureDateTime,
      'arrivalDateTime': arrivalDateTime,
      'stoppageCount': stoppageCount,
      'vendorCost': vendorCost,
      'sellingPrice': sellingPrice,
    };
  }

  QuotationFlightItemModel copyWith({
    String? flightId,
    String? displayName,
    String? fromAirport,
    String? toAirport,
    DateTime? departureDateTime,
    DateTime? arrivalDateTime,
    int? stoppageCount,
    num? vendorCost,
    num? sellingPrice,
  }) {
    return QuotationFlightItemModel(
      flightId: flightId ?? this.flightId,
      displayName: displayName ?? this.displayName,
      fromAirport: fromAirport ?? this.fromAirport,
      toAirport: toAirport ?? this.toAirport,
      departureDateTime: departureDateTime ?? this.departureDateTime,
      arrivalDateTime: arrivalDateTime ?? this.arrivalDateTime,
      stoppageCount: stoppageCount ?? this.stoppageCount,
      vendorCost: vendorCost ?? this.vendorCost,
      sellingPrice: sellingPrice ?? this.sellingPrice,
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
