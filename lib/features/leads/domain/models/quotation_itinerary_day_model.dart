class QuotationItineraryDayModel {
  const QuotationItineraryDayModel({
    this.dayNumber,
    this.title,
    this.description,
    this.destination,
    this.images = const <String>[],
    this.notes,
  });

  final int? dayNumber;
  final String? title;
  final String? description;
  final String? destination;
  final List<String> images;
  final String? notes;

  factory QuotationItineraryDayModel.fromMap(Map<String, dynamic> map) {
    return QuotationItineraryDayModel(
      dayNumber: (map['dayNumber'] as num?)?.toInt(),
      title: map['title'] as String?,
      description: map['description'] as String?,
      destination: map['destination'] as String?,
      images: _stringListFromDynamic(map['images']),
      notes: map['notes'] as String?,
    );
  }

  Map<String, dynamic> toMap() {
    return <String, dynamic>{
      'dayNumber': dayNumber,
      'title': title,
      'description': description,
      'destination': destination,
      'images': images,
      'notes': notes,
    };
  }

  QuotationItineraryDayModel copyWith({
    int? dayNumber,
    String? title,
    String? description,
    String? destination,
    List<String>? images,
    String? notes,
  }) {
    return QuotationItineraryDayModel(
      dayNumber: dayNumber ?? this.dayNumber,
      title: title ?? this.title,
      description: description ?? this.description,
      destination: destination ?? this.destination,
      images: images ?? this.images,
      notes: notes ?? this.notes,
    );
  }
}

List<String> _stringListFromDynamic(dynamic value) {
  if (value is Iterable) {
    return value.whereType<String>().toList(growable: false);
  }

  return const <String>[];
}
