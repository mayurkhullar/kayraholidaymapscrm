class ClientPreferenceValueModel {
  const ClientPreferenceValueModel({
    this.value,
    this.source,
  });

  final String? value;
  final String? source;

  factory ClientPreferenceValueModel.fromMap(Map<String, dynamic> map) {
    return ClientPreferenceValueModel(
      value: map['value'] as String?,
      source: map['source'] as String?,
    );
  }

  Map<String, dynamic> toMap() {
    return <String, dynamic>{
      'value': value,
      'source': source,
    };
  }

  ClientPreferenceValueModel copyWith({
    String? value,
    String? source,
  }) {
    return ClientPreferenceValueModel(
      value: value ?? this.value,
      source: source ?? this.source,
    );
  }
}
