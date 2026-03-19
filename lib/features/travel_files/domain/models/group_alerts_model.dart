class GroupAlertsModel {
  const GroupAlertsModel({
    this.missingPassportCount = 0,
    this.missingFlightCount = 0,
    this.missingRoomingCount = 0,
    this.missingTransportCount = 0,
    this.earlyArrivalRiskCount = 0,
    this.pendingTeamLeaderApprovalCount = 0,
  });

  final int missingPassportCount;
  final int missingFlightCount;
  final int missingRoomingCount;
  final int missingTransportCount;
  final int earlyArrivalRiskCount;
  final int pendingTeamLeaderApprovalCount;

  GroupAlertsModel copyWith({
    int? missingPassportCount,
    int? missingFlightCount,
    int? missingRoomingCount,
    int? missingTransportCount,
    int? earlyArrivalRiskCount,
    int? pendingTeamLeaderApprovalCount,
  }) {
    return GroupAlertsModel(
      missingPassportCount: missingPassportCount ?? this.missingPassportCount,
      missingFlightCount: missingFlightCount ?? this.missingFlightCount,
      missingRoomingCount: missingRoomingCount ?? this.missingRoomingCount,
      missingTransportCount: missingTransportCount ?? this.missingTransportCount,
      earlyArrivalRiskCount: earlyArrivalRiskCount ?? this.earlyArrivalRiskCount,
      pendingTeamLeaderApprovalCount:
          pendingTeamLeaderApprovalCount ?? this.pendingTeamLeaderApprovalCount,
    );
  }

  factory GroupAlertsModel.fromMap(Map<String, dynamic> map) {
    return GroupAlertsModel(
      missingPassportCount: (map['missingPassportCount'] as num?)?.toInt() ?? 0,
      missingFlightCount: (map['missingFlightCount'] as num?)?.toInt() ?? 0,
      missingRoomingCount: (map['missingRoomingCount'] as num?)?.toInt() ?? 0,
      missingTransportCount: (map['missingTransportCount'] as num?)?.toInt() ?? 0,
      earlyArrivalRiskCount: (map['earlyArrivalRiskCount'] as num?)?.toInt() ?? 0,
      pendingTeamLeaderApprovalCount:
          (map['pendingTeamLeaderApprovalCount'] as num?)?.toInt() ?? 0,
    );
  }

  Map<String, dynamic> toMap() {
    return <String, dynamic>{
      'missingPassportCount': missingPassportCount,
      'missingFlightCount': missingFlightCount,
      'missingRoomingCount': missingRoomingCount,
      'missingTransportCount': missingTransportCount,
      'earlyArrivalRiskCount': earlyArrivalRiskCount,
      'pendingTeamLeaderApprovalCount': pendingTeamLeaderApprovalCount,
    };
  }
}
