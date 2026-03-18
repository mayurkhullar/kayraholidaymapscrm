import 'package:cloud_firestore/cloud_firestore.dart';

class DateRangeModel {
  const DateRangeModel({
    this.startDate,
    this.endDate,
  });

  final DateTime? startDate;
  final DateTime? endDate;

  factory DateRangeModel.fromMap(Map<String, dynamic> map) {
    return DateRangeModel(
      startDate: _dateTimeFromDynamic(map['startDate']),
      endDate: _dateTimeFromDynamic(map['endDate']),
    );
  }

  Map<String, dynamic> toMap() {
    return <String, dynamic>{
      'startDate': startDate,
      'endDate': endDate,
    };
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
