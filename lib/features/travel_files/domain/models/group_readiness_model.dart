class GroupReadinessModel {
  const GroupReadinessModel({
    this.travelersAdded = 0,
    this.passportCompleted = 0,
    this.passportReviewPending = 0,
    this.visaCompleted = 0,
    this.flightsAssigned = 0,
    this.roomingAssigned = 0,
    this.transportAssigned = 0,
    this.checklistCompleted = 0,
    this.checklistTotal = 0,
    this.overallReadinessPercent = 0,
  });

  final int travelersAdded;
  final int passportCompleted;
  final int passportReviewPending;
  final int visaCompleted;
  final int flightsAssigned;
  final int roomingAssigned;
  final int transportAssigned;
  final int checklistCompleted;
  final int checklistTotal;
  final int overallReadinessPercent;

  GroupReadinessModel copyWith({
    int? travelersAdded,
    int? passportCompleted,
    int? passportReviewPending,
    int? visaCompleted,
    int? flightsAssigned,
    int? roomingAssigned,
    int? transportAssigned,
    int? checklistCompleted,
    int? checklistTotal,
    int? overallReadinessPercent,
  }) {
    return GroupReadinessModel(
      travelersAdded: travelersAdded ?? this.travelersAdded,
      passportCompleted: passportCompleted ?? this.passportCompleted,
      passportReviewPending:
          passportReviewPending ?? this.passportReviewPending,
      visaCompleted: visaCompleted ?? this.visaCompleted,
      flightsAssigned: flightsAssigned ?? this.flightsAssigned,
      roomingAssigned: roomingAssigned ?? this.roomingAssigned,
      transportAssigned: transportAssigned ?? this.transportAssigned,
      checklistCompleted: checklistCompleted ?? this.checklistCompleted,
      checklistTotal: checklistTotal ?? this.checklistTotal,
      overallReadinessPercent:
          overallReadinessPercent ?? this.overallReadinessPercent,
    );
  }

  factory GroupReadinessModel.fromMap(Map<String, dynamic> map) {
    return GroupReadinessModel(
      travelersAdded: (map['travelersAdded'] as num?)?.toInt() ?? 0,
      passportCompleted: (map['passportCompleted'] as num?)?.toInt() ?? 0,
      passportReviewPending: (map['passportReviewPending'] as num?)?.toInt() ?? 0,
      visaCompleted: (map['visaCompleted'] as num?)?.toInt() ?? 0,
      flightsAssigned: (map['flightsAssigned'] as num?)?.toInt() ?? 0,
      roomingAssigned: (map['roomingAssigned'] as num?)?.toInt() ?? 0,
      transportAssigned: (map['transportAssigned'] as num?)?.toInt() ?? 0,
      checklistCompleted: (map['checklistCompleted'] as num?)?.toInt() ?? 0,
      checklistTotal: (map['checklistTotal'] as num?)?.toInt() ?? 0,
      overallReadinessPercent:
          (map['overallReadinessPercent'] as num?)?.toInt() ?? 0,
    );
  }

  Map<String, dynamic> toMap() {
    return <String, dynamic>{
      'travelersAdded': travelersAdded,
      'passportCompleted': passportCompleted,
      'passportReviewPending': passportReviewPending,
      'visaCompleted': visaCompleted,
      'flightsAssigned': flightsAssigned,
      'roomingAssigned': roomingAssigned,
      'transportAssigned': transportAssigned,
      'checklistCompleted': checklistCompleted,
      'checklistTotal': checklistTotal,
      'overallReadinessPercent': overallReadinessPercent,
    };
  }
}
