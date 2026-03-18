import 'package:cloud_firestore/cloud_firestore.dart';

class QuotationHotelItemModel {
  const QuotationHotelItemModel({
    this.hotelId,
    this.hotelName,
    this.destination,
    this.roomCategoryId,
    this.roomCategoryName,
    this.mealPlan,
    this.checkInDate,
    this.checkOutDate,
    this.nightCount,
    this.quantity,
    this.vendorCost,
    this.sellingPrice,
  });

  final String? hotelId;
  final String? hotelName;
  final String? destination;
  final String? roomCategoryId;
  final String? roomCategoryName;
  final String? mealPlan;
  final DateTime? checkInDate;
  final DateTime? checkOutDate;
  final int? nightCount;
  final int? quantity;
  final num? vendorCost;
  final num? sellingPrice;

  factory QuotationHotelItemModel.fromMap(Map<String, dynamic> map) {
    return QuotationHotelItemModel(
      hotelId: map['hotelId'] as String?,
      hotelName: map['hotelName'] as String?,
      destination: map['destination'] as String?,
      roomCategoryId: map['roomCategoryId'] as String?,
      roomCategoryName: map['roomCategoryName'] as String?,
      mealPlan: map['mealPlan'] as String?,
      checkInDate: _dateTimeFromDynamic(map['checkInDate']),
      checkOutDate: _dateTimeFromDynamic(map['checkOutDate']),
      nightCount: (map['nightCount'] as num?)?.toInt(),
      quantity: (map['quantity'] as num?)?.toInt(),
      vendorCost: map['vendorCost'] as num?,
      sellingPrice: map['sellingPrice'] as num?,
    );
  }

  Map<String, dynamic> toMap() {
    return <String, dynamic>{
      'hotelId': hotelId,
      'hotelName': hotelName,
      'destination': destination,
      'roomCategoryId': roomCategoryId,
      'roomCategoryName': roomCategoryName,
      'mealPlan': mealPlan,
      'checkInDate': checkInDate,
      'checkOutDate': checkOutDate,
      'nightCount': nightCount,
      'quantity': quantity,
      'vendorCost': vendorCost,
      'sellingPrice': sellingPrice,
    };
  }

  QuotationHotelItemModel copyWith({
    String? hotelId,
    String? hotelName,
    String? destination,
    String? roomCategoryId,
    String? roomCategoryName,
    String? mealPlan,
    DateTime? checkInDate,
    DateTime? checkOutDate,
    int? nightCount,
    int? quantity,
    num? vendorCost,
    num? sellingPrice,
  }) {
    return QuotationHotelItemModel(
      hotelId: hotelId ?? this.hotelId,
      hotelName: hotelName ?? this.hotelName,
      destination: destination ?? this.destination,
      roomCategoryId: roomCategoryId ?? this.roomCategoryId,
      roomCategoryName: roomCategoryName ?? this.roomCategoryName,
      mealPlan: mealPlan ?? this.mealPlan,
      checkInDate: checkInDate ?? this.checkInDate,
      checkOutDate: checkOutDate ?? this.checkOutDate,
      nightCount: nightCount ?? this.nightCount,
      quantity: quantity ?? this.quantity,
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
