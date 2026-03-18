class QuotationPricingModel {
  const QuotationPricingModel({
    this.adultPrice,
    this.childPrice,
    this.infantPrice,
    this.pricePerPerson,
    this.totalSellingPrice,
    this.totalVendorCost,
    this.profit,
    this.profitPercentage,
  });

  final num? adultPrice;
  final num? childPrice;
  final num? infantPrice;
  final num? pricePerPerson;
  final num? totalSellingPrice;
  final num? totalVendorCost;
  final num? profit;
  final num? profitPercentage;

  factory QuotationPricingModel.fromMap(Map<String, dynamic> map) {
    return QuotationPricingModel(
      adultPrice: map['adultPrice'] as num?,
      childPrice: map['childPrice'] as num?,
      infantPrice: map['infantPrice'] as num?,
      pricePerPerson: map['pricePerPerson'] as num?,
      totalSellingPrice: map['totalSellingPrice'] as num?,
      totalVendorCost: map['totalVendorCost'] as num?,
      profit: map['profit'] as num?,
      profitPercentage: map['profitPercentage'] as num?,
    );
  }

  Map<String, dynamic> toMap() {
    return <String, dynamic>{
      'adultPrice': adultPrice,
      'childPrice': childPrice,
      'infantPrice': infantPrice,
      'pricePerPerson': pricePerPerson,
      'totalSellingPrice': totalSellingPrice,
      'totalVendorCost': totalVendorCost,
      'profit': profit,
      'profitPercentage': profitPercentage,
    };
  }

  QuotationPricingModel copyWith({
    num? adultPrice,
    num? childPrice,
    num? infantPrice,
    num? pricePerPerson,
    num? totalSellingPrice,
    num? totalVendorCost,
    num? profit,
    num? profitPercentage,
  }) {
    return QuotationPricingModel(
      adultPrice: adultPrice ?? this.adultPrice,
      childPrice: childPrice ?? this.childPrice,
      infantPrice: infantPrice ?? this.infantPrice,
      pricePerPerson: pricePerPerson ?? this.pricePerPerson,
      totalSellingPrice: totalSellingPrice ?? this.totalSellingPrice,
      totalVendorCost: totalVendorCost ?? this.totalVendorCost,
      profit: profit ?? this.profit,
      profitPercentage: profitPercentage ?? this.profitPercentage,
    );
  }
}
