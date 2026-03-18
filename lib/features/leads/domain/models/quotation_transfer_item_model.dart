class QuotationTransferItemModel {
  const QuotationTransferItemModel({
    this.transferType,
    this.mode,
    this.description,
    this.vendorCost,
    this.sellingPrice,
  });

  final String? transferType;
  final String? mode;
  final String? description;
  final num? vendorCost;
  final num? sellingPrice;

  factory QuotationTransferItemModel.fromMap(Map<String, dynamic> map) {
    return QuotationTransferItemModel(
      transferType: map['transferType'] as String?,
      mode: map['mode'] as String?,
      description: map['description'] as String?,
      vendorCost: map['vendorCost'] as num?,
      sellingPrice: map['sellingPrice'] as num?,
    );
  }

  Map<String, dynamic> toMap() {
    return <String, dynamic>{
      'transferType': transferType,
      'mode': mode,
      'description': description,
      'vendorCost': vendorCost,
      'sellingPrice': sellingPrice,
    };
  }

  QuotationTransferItemModel copyWith({
    String? transferType,
    String? mode,
    String? description,
    num? vendorCost,
    num? sellingPrice,
  }) {
    return QuotationTransferItemModel(
      transferType: transferType ?? this.transferType,
      mode: mode ?? this.mode,
      description: description ?? this.description,
      vendorCost: vendorCost ?? this.vendorCost,
      sellingPrice: sellingPrice ?? this.sellingPrice,
    );
  }
}
