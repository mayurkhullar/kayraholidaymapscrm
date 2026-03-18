class QuotationActivityItemModel {
  const QuotationActivityItemModel({
    this.activityName,
    this.description,
    this.vendorCost,
    this.sellingPrice,
  });

  final String? activityName;
  final String? description;
  final num? vendorCost;
  final num? sellingPrice;

  factory QuotationActivityItemModel.fromMap(Map<String, dynamic> map) {
    return QuotationActivityItemModel(
      activityName: map['activityName'] as String?,
      description: map['description'] as String?,
      vendorCost: map['vendorCost'] as num?,
      sellingPrice: map['sellingPrice'] as num?,
    );
  }

  Map<String, dynamic> toMap() {
    return <String, dynamic>{
      'activityName': activityName,
      'description': description,
      'vendorCost': vendorCost,
      'sellingPrice': sellingPrice,
    };
  }

  QuotationActivityItemModel copyWith({
    String? activityName,
    String? description,
    num? vendorCost,
    num? sellingPrice,
  }) {
    return QuotationActivityItemModel(
      activityName: activityName ?? this.activityName,
      description: description ?? this.description,
      vendorCost: vendorCost ?? this.vendorCost,
      sellingPrice: sellingPrice ?? this.sellingPrice,
    );
  }
}
