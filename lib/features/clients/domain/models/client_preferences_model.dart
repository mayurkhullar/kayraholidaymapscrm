import 'client_preference_value_model.dart';

class ClientPreferencesModel {
  const ClientPreferencesModel({
    this.preferredAirline,
    this.preferredHotelCategory,
    this.mealPreference,
    this.seatPreference,
    this.roomPreference,
  });

  final ClientPreferenceValueModel? preferredAirline;
  final ClientPreferenceValueModel? preferredHotelCategory;
  final ClientPreferenceValueModel? mealPreference;
  final ClientPreferenceValueModel? seatPreference;
  final ClientPreferenceValueModel? roomPreference;

  factory ClientPreferencesModel.fromMap(Map<String, dynamic> map) {
    return ClientPreferencesModel(
      preferredAirline: _preferenceFromDynamic(map['preferredAirline']),
      preferredHotelCategory: _preferenceFromDynamic(
        map['preferredHotelCategory'],
      ),
      mealPreference: _preferenceFromDynamic(map['mealPreference']),
      seatPreference: _preferenceFromDynamic(map['seatPreference']),
      roomPreference: _preferenceFromDynamic(map['roomPreference']),
    );
  }

  Map<String, dynamic> toMap() {
    return <String, dynamic>{
      'preferredAirline': preferredAirline?.toMap(),
      'preferredHotelCategory': preferredHotelCategory?.toMap(),
      'mealPreference': mealPreference?.toMap(),
      'seatPreference': seatPreference?.toMap(),
      'roomPreference': roomPreference?.toMap(),
    };
  }

  ClientPreferencesModel copyWith({
    ClientPreferenceValueModel? preferredAirline,
    ClientPreferenceValueModel? preferredHotelCategory,
    ClientPreferenceValueModel? mealPreference,
    ClientPreferenceValueModel? seatPreference,
    ClientPreferenceValueModel? roomPreference,
  }) {
    return ClientPreferencesModel(
      preferredAirline: preferredAirline ?? this.preferredAirline,
      preferredHotelCategory:
          preferredHotelCategory ?? this.preferredHotelCategory,
      mealPreference: mealPreference ?? this.mealPreference,
      seatPreference: seatPreference ?? this.seatPreference,
      roomPreference: roomPreference ?? this.roomPreference,
    );
  }
}

ClientPreferenceValueModel? _preferenceFromDynamic(dynamic value) {
  if (value is Map<String, dynamic>) {
    return ClientPreferenceValueModel.fromMap(value);
  }

  if (value is Map) {
    return ClientPreferenceValueModel.fromMap(
      value.map((key, dynamic nestedValue) => MapEntry('$key', nestedValue)),
    );
  }

  return null;
}
