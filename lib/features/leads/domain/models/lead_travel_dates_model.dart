import 'package:cloud_firestore/cloud_firestore.dart';

class LeadTravelDatesModel {
  const LeadTravelDatesModel({
    this.startDate,
    this.endDate,
    this.isApproximate,
  });

  final DateTime? startDate;
  final DateTime? endDate;
  final bool? isApproximate;

  factory LeadTravelDatesModel.fromMap(Map<String, dynamic> map) {
    return LeadTravelDatesModel(
      startDate: _dateTimeFromDynamic(map['startDate']),
      endDate: _dateTimeFromDynamic(map['endDate']),
      isApproximate: map['isApproximate'] as bool?,
    );
  }

  Map<String, dynamic> toMap() {
    return <String, dynamic>{
      'startDate': startDate,
      'endDate': endDate,
      'isApproximate': isApproximate,
    };
  }

  LeadTravelDatesModel copyWith({
    DateTime? startDate,
    DateTime? endDate,
    bool? isApproximate,
  }) {
    return LeadTravelDatesModel(
      startDate: startDate ?? this.startDate,
      endDate: endDate ?? this.endDate,
      isApproximate: isApproximate ?? this.isApproximate,
    );
  }
}

DateTime? _dateTimeFromDynamic(dynamic value) {
  if (value == null) {
    return null;
  }

  if (value is DateTime) {
    return value;
  }

  if (value is Timestamp) {
    return value.toDate();
  }

  if (value is String) {
    return DateTime.tryParse(value);
  }

  return null;
}
