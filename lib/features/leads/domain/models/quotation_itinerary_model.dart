import 'quotation_itinerary_day_model.dart';

class QuotationItineraryModel {
  const QuotationItineraryModel({
    this.mode,
    this.templateId,
    this.generatedByAi,
    this.days = const <QuotationItineraryDayModel>[],
  });

  final String? mode;
  final String? templateId;
  final bool? generatedByAi;
  final List<QuotationItineraryDayModel> days;

  factory QuotationItineraryModel.fromMap(Map<String, dynamic> map) {
    return QuotationItineraryModel(
      mode: map['mode'] as String?,
      templateId: map['templateId'] as String?,
      generatedByAi: map['generatedByAi'] as bool?,
      days: _itineraryDaysFromDynamic(map['days']),
    );
  }

  Map<String, dynamic> toMap() {
    return <String, dynamic>{
      'mode': mode,
      'templateId': templateId,
      'generatedByAi': generatedByAi,
      'days': days.map((day) => day.toMap()).toList(growable: false),
    };
  }

  QuotationItineraryModel copyWith({
    String? mode,
    String? templateId,
    bool? generatedByAi,
    List<QuotationItineraryDayModel>? days,
  }) {
    return QuotationItineraryModel(
      mode: mode ?? this.mode,
      templateId: templateId ?? this.templateId,
      generatedByAi: generatedByAi ?? this.generatedByAi,
      days: days ?? this.days,
    );
  }
}

List<QuotationItineraryDayModel> _itineraryDaysFromDynamic(dynamic value) {
  if (value is! Iterable) {
    return const <QuotationItineraryDayModel>[];
  }

  return value
      .map(_mapFromDynamic)
      .whereType<Map<String, dynamic>>()
      .map(QuotationItineraryDayModel.fromMap)
      .toList(growable: false);
}

Map<String, dynamic>? _mapFromDynamic(dynamic value) {
  if (value is Map<String, dynamic>) {
    return value;
  }

  if (value is Map) {
    return value.map(
      (key, dynamic nestedValue) => MapEntry('$key', nestedValue),
    );
  }

  return null;
}
