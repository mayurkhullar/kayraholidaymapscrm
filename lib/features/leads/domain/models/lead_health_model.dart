import 'package:cloud_firestore/cloud_firestore.dart';

class LeadHealthModel {
  const LeadHealthModel({
    this.leadHealthScore,
    this.leadHealthStatus,
    this.lastHealthCalculatedAt,
  });

  final num? leadHealthScore;
  final String? leadHealthStatus;
  final DateTime? lastHealthCalculatedAt;

  factory LeadHealthModel.fromMap(Map<String, dynamic> map) {
    return LeadHealthModel(
      leadHealthScore: map['leadHealthScore'] as num?,
      leadHealthStatus: map['leadHealthStatus'] as String?,
      lastHealthCalculatedAt:
          _dateTimeFromDynamic(map['lastHealthCalculatedAt']),
    );
  }

  Map<String, dynamic> toMap() {
    return <String, dynamic>{
      'leadHealthScore': leadHealthScore,
      'leadHealthStatus': leadHealthStatus,
      'lastHealthCalculatedAt': lastHealthCalculatedAt,
    };
  }

  LeadHealthModel copyWith({
    num? leadHealthScore,
    String? leadHealthStatus,
    DateTime? lastHealthCalculatedAt,
  }) {
    return LeadHealthModel(
      leadHealthScore: leadHealthScore ?? this.leadHealthScore,
      leadHealthStatus: leadHealthStatus ?? this.leadHealthStatus,
      lastHealthCalculatedAt:
          lastHealthCalculatedAt ?? this.lastHealthCalculatedAt,
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
