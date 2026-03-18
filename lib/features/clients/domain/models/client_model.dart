import 'package:cloud_firestore/cloud_firestore.dart';

import 'client_lifetime_stats_model.dart';
import 'client_preferences_model.dart';

class ClientModel {
  const ClientModel({
    required this.id,
    required this.clientCode,
    required this.clientName,
    this.primaryPhone,
    this.alternatePhones = const <String>[],
    this.email,
    this.companyId,
    this.clientOwnerId,
    this.teamId,
    this.tags = const <String>[],
    this.preferences,
    this.lifetimeStats,
    this.searchTokens = const <String>[],
    this.createdBy,
    this.createdAt,
    this.updatedBy,
    this.updatedAt,
    this.isArchived = false,
    this.archivedBy,
    this.archivedAt,
  });

  final String id;
  final String clientCode;
  final String clientName;
  final String? primaryPhone;
  final List<String> alternatePhones;
  final String? email;
  final String? companyId;
  final String? clientOwnerId;
  final String? teamId;
  final List<String> tags;
  final ClientPreferencesModel? preferences;
  final ClientLifetimeStatsModel? lifetimeStats;
  final List<String> searchTokens;
  final String? createdBy;
  final DateTime? createdAt;
  final String? updatedBy;
  final DateTime? updatedAt;
  final bool isArchived;
  final String? archivedBy;
  final DateTime? archivedAt;

  factory ClientModel.fromMap(Map<String, dynamic> map) {
    return ClientModel(
      id: (map['id'] as String?) ?? '',
      clientCode: (map['clientCode'] as String?) ?? '',
      clientName: (map['clientName'] as String?) ?? '',
      primaryPhone: map['primaryPhone'] as String?,
      alternatePhones: _stringListFromDynamic(map['alternatePhones']),
      email: map['email'] as String?,
      companyId: map['companyId'] as String?,
      clientOwnerId: map['clientOwnerId'] as String?,
      teamId: map['teamId'] as String?,
      tags: _stringListFromDynamic(map['tags']),
      preferences: _preferencesFromDynamic(map['preferences']),
      lifetimeStats: _lifetimeStatsFromDynamic(map['lifetimeStats']),
      searchTokens: _stringListFromDynamic(map['searchTokens']),
      createdBy: map['createdBy'] as String?,
      createdAt: _dateTimeFromDynamic(map['createdAt']),
      updatedBy: map['updatedBy'] as String?,
      updatedAt: _dateTimeFromDynamic(map['updatedAt']),
      isArchived: (map['isArchived'] as bool?) ?? false,
      archivedBy: map['archivedBy'] as String?,
      archivedAt: _dateTimeFromDynamic(map['archivedAt']),
    );
  }

  Map<String, dynamic> toMap() {
    return <String, dynamic>{
      'id': id,
      'clientCode': clientCode,
      'clientName': clientName,
      'primaryPhone': primaryPhone,
      'alternatePhones': alternatePhones,
      'email': email,
      'companyId': companyId,
      'clientOwnerId': clientOwnerId,
      'teamId': teamId,
      'tags': tags,
      'preferences': preferences?.toMap(),
      'lifetimeStats': lifetimeStats?.toMap(),
      'searchTokens': searchTokens,
      'createdBy': createdBy,
      'createdAt': createdAt,
      'updatedBy': updatedBy,
      'updatedAt': updatedAt,
      'isArchived': isArchived,
      'archivedBy': archivedBy,
      'archivedAt': archivedAt,
    };
  }

  ClientModel copyWith({
    String? id,
    String? clientCode,
    String? clientName,
    String? primaryPhone,
    List<String>? alternatePhones,
    String? email,
    String? companyId,
    String? clientOwnerId,
    String? teamId,
    List<String>? tags,
    ClientPreferencesModel? preferences,
    ClientLifetimeStatsModel? lifetimeStats,
    List<String>? searchTokens,
    String? createdBy,
    DateTime? createdAt,
    String? updatedBy,
    DateTime? updatedAt,
    bool? isArchived,
    String? archivedBy,
    DateTime? archivedAt,
  }) {
    return ClientModel(
      id: id ?? this.id,
      clientCode: clientCode ?? this.clientCode,
      clientName: clientName ?? this.clientName,
      primaryPhone: primaryPhone ?? this.primaryPhone,
      alternatePhones: alternatePhones ?? this.alternatePhones,
      email: email ?? this.email,
      companyId: companyId ?? this.companyId,
      clientOwnerId: clientOwnerId ?? this.clientOwnerId,
      teamId: teamId ?? this.teamId,
      tags: tags ?? this.tags,
      preferences: preferences ?? this.preferences,
      lifetimeStats: lifetimeStats ?? this.lifetimeStats,
      searchTokens: searchTokens ?? this.searchTokens,
      createdBy: createdBy ?? this.createdBy,
      createdAt: createdAt ?? this.createdAt,
      updatedBy: updatedBy ?? this.updatedBy,
      updatedAt: updatedAt ?? this.updatedAt,
      isArchived: isArchived ?? this.isArchived,
      archivedBy: archivedBy ?? this.archivedBy,
      archivedAt: archivedAt ?? this.archivedAt,
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

List<String> _stringListFromDynamic(dynamic value) {
  if (value is Iterable) {
    return value.whereType<String>().toList(growable: false);
  }

  return const <String>[];
}

ClientPreferencesModel? _preferencesFromDynamic(dynamic value) {
  if (value is Map<String, dynamic>) {
    return ClientPreferencesModel.fromMap(value);
  }

  if (value is Map) {
    return ClientPreferencesModel.fromMap(
      value.map((key, dynamic nestedValue) => MapEntry('$key', nestedValue)),
    );
  }

  return null;
}

ClientLifetimeStatsModel? _lifetimeStatsFromDynamic(dynamic value) {
  if (value is Map<String, dynamic>) {
    return ClientLifetimeStatsModel.fromMap(value);
  }

  if (value is Map) {
    return ClientLifetimeStatsModel.fromMap(
      value.map((key, dynamic nestedValue) => MapEntry('$key', nestedValue)),
    );
  }

  return null;
}
