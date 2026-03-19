class CurrentCommercialStateModel {
  const CurrentCommercialStateModel({
    this.totalSellingPrice,
    this.totalVendorCost,
    this.profit,
    this.profitPercentage,
  });

  final double? totalSellingPrice;
  final double? totalVendorCost;
  final double? profit;
  final double? profitPercentage;

  CurrentCommercialStateModel copyWith({
    double? totalSellingPrice,
    double? totalVendorCost,
    double? profit,
    double? profitPercentage,
  }) {
    return CurrentCommercialStateModel(
      totalSellingPrice: totalSellingPrice ?? this.totalSellingPrice,
      totalVendorCost: totalVendorCost ?? this.totalVendorCost,
      profit: profit ?? this.profit,
      profitPercentage: profitPercentage ?? this.profitPercentage,
    );
  }

  factory CurrentCommercialStateModel.fromMap(Map<String, dynamic> map) {
    return CurrentCommercialStateModel(
      totalSellingPrice: (map['totalSellingPrice'] as num?)?.toDouble(),
      totalVendorCost: (map['totalVendorCost'] as num?)?.toDouble(),
      profit: (map['profit'] as num?)?.toDouble(),
      profitPercentage: (map['profitPercentage'] as num?)?.toDouble(),
    );
  }

  Map<String, dynamic> toMap() {
    return <String, dynamic>{
      'totalSellingPrice': totalSellingPrice,
      'totalVendorCost': totalVendorCost,
      'profit': profit,
      'profitPercentage': profitPercentage,
    };
  }
}
