class PassengerCountModel {
  const PassengerCountModel({
    this.adults = 0,
    this.children = 0,
    this.childrenAges = const <int>[],
    this.infants = 0,
    int? totalPax,
  }) : totalPax = totalPax ?? adults + children + infants;

  final int adults;
  final int children;
  final List<int> childrenAges;
  final int infants;
  final int totalPax;

  factory PassengerCountModel.fromMap(Map<String, dynamic> map) {
    final adults = (map['adults'] as num?)?.toInt() ?? 0;
    final children = (map['children'] as num?)?.toInt() ?? 0;
    final infants = (map['infants'] as num?)?.toInt() ?? 0;
    final childrenAges = ((map['childrenAges'] as List<dynamic>?) ?? const [])
        .whereType<num>()
        .map((age) => age.toInt())
        .toList(growable: false);

    return PassengerCountModel(
      adults: adults,
      children: children,
      childrenAges: childrenAges,
      infants: infants,
      totalPax: (map['totalPax'] as num?)?.toInt(),
    );
  }

  factory PassengerCountModel.calculate({
    int adults = 0,
    int children = 0,
    List<int> childrenAges = const <int>[],
    int infants = 0,
  }) {
    return PassengerCountModel(
      adults: adults,
      children: children,
      childrenAges: childrenAges,
      infants: infants,
      totalPax: adults + children + infants,
    );
  }

  Map<String, dynamic> toMap() {
    return <String, dynamic>{
      'adults': adults,
      'children': children,
      'childrenAges': childrenAges,
      'infants': infants,
      'totalPax': totalPax,
    };
  }

  PassengerCountModel withComputedTotal() {
    return PassengerCountModel.calculate(
      adults: adults,
      children: children,
      childrenAges: childrenAges,
      infants: infants,
    );
  }
}
