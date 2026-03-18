class QuotationComparisonSummaryModel {
  const QuotationComparisonSummaryModel({
    this.hotelNames = const <String>[],
    this.activityNames = const <String>[],
    this.flightNames = const <String>[],
    this.totalSellingPrice,
  });

  final List<String> hotelNames;
  final List<String> activityNames;
  final List<String> flightNames;
  final num? totalSellingPrice;

  factory QuotationComparisonSummaryModel.fromMap(Map<String, dynamic> map) {
    return QuotationComparisonSummaryModel(
      hotelNames: _stringListFromDynamic(map['hotelNames']),
      activityNames: _stringListFromDynamic(map['activityNames']),
      flightNames: _stringListFromDynamic(map['flightNames']),
      totalSellingPrice: map['totalSellingPrice'] as num?,
    );
  }

  Map<String, dynamic> toMap() {
    return <String, dynamic>{
      'hotelNames': hotelNames,
      'activityNames': activityNames,
      'flightNames': flightNames,
      'totalSellingPrice': totalSellingPrice,
    };
  }

  QuotationComparisonSummaryModel copyWith({
    List<String>? hotelNames,
    List<String>? activityNames,
    List<String>? flightNames,
    num? totalSellingPrice,
  }) {
    return QuotationComparisonSummaryModel(
      hotelNames: hotelNames ?? this.hotelNames,
      activityNames: activityNames ?? this.activityNames,
      flightNames: flightNames ?? this.flightNames,
      totalSellingPrice: totalSellingPrice ?? this.totalSellingPrice,
    );
  }
}

List<String> _stringListFromDynamic(dynamic value) {
  if (value is Iterable) {
    return value.whereType<String>().toList(growable: false);
  }

  return const <String>[];
}
