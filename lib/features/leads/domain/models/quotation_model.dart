import 'package:cloud_firestore/cloud_firestore.dart';

import 'package:kayraholidaymapscrm/core/constants/app_enums.dart';
import 'package:kayraholidaymapscrm/shared/models/passenger_count_model.dart';

import 'lead_travel_dates_model.dart';
import 'quotation_activity_item_model.dart';
import 'quotation_comparison_summary_model.dart';
import 'quotation_flight_item_model.dart';
import 'quotation_hotel_item_model.dart';
import 'quotation_itinerary_model.dart';
import 'quotation_pricing_model.dart';
import 'quotation_transfer_item_model.dart';

class QuotationModel {
  const QuotationModel({
    required this.id,
    this.quotationCode,
    this.versionNumber,
    this.isActive = false,
    this.revisionType,
    this.createdFromQuotationId,
    this.leadId,
    this.leadCode,
    this.clientId,
    this.companyId,
    this.travelType = TravelType.fit,
    this.tripScope = TripScope.international,
    this.destination,
    this.travelDates,
    this.passengerCount,
    this.currency = 'INR',
    this.pricing,
    this.pricingIncludeInClientPdf = true,
    this.hotels = const <QuotationHotelItemModel>[],
    this.flights = const <QuotationFlightItemModel>[],
    this.transfers = const <QuotationTransferItemModel>[],
    this.activities = const <QuotationActivityItemModel>[],
    this.inclusions = const <String>[],
    this.exclusions = const <String>[],
    this.itinerary,
    this.comparisonSummary,
    this.status,
    this.validityDate,
    this.confirmedSnapshotRef,
    this.notes,
    this.marginAlertLevel = MarginAlertLevel.none,
    this.validationStateHasPricing = false,
    this.validationStateHasAtLeastOneServiceComponent = false,
    this.validationStateHasItinerary = false,
    this.validationStateHasValidityDate = false,
    this.clientNameSnapshot,
    this.companyNameSnapshot,
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
  final String? quotationCode;
  final int? versionNumber;
  final bool isActive;
  final String? revisionType;
  final String? createdFromQuotationId;
  final String? leadId;
  final String? leadCode;
  final String? clientId;
  final String? companyId;
  final TravelType travelType;
  final TripScope tripScope;
  final String? destination;
  final LeadTravelDatesModel? travelDates;
  final PassengerCountModel? passengerCount;
  final String currency;
  final QuotationPricingModel? pricing;
  final bool pricingIncludeInClientPdf;
  final List<QuotationHotelItemModel> hotels;
  final List<QuotationFlightItemModel> flights;
  final List<QuotationTransferItemModel> transfers;
  final List<QuotationActivityItemModel> activities;
  final List<String> inclusions;
  final List<String> exclusions;
  final QuotationItineraryModel? itinerary;
  final QuotationComparisonSummaryModel? comparisonSummary;
  final String? status;
  final DateTime? validityDate;
  final String? confirmedSnapshotRef;
  final String? notes;
  final MarginAlertLevel marginAlertLevel;
  final bool validationStateHasPricing;
  final bool validationStateHasAtLeastOneServiceComponent;
  final bool validationStateHasItinerary;
  final bool validationStateHasValidityDate;
  final String? clientNameSnapshot;
  final String? companyNameSnapshot;
  final List<String> searchTokens;
  final String? createdBy;
  final DateTime? createdAt;
  final String? updatedBy;
  final DateTime? updatedAt;
  final bool isArchived;
  final String? archivedBy;
  final DateTime? archivedAt;

  factory QuotationModel.fromMap(Map<String, dynamic> map) {
    return QuotationModel(
      id: (map['id'] as String?) ?? '',
      quotationCode: map['quotationCode'] as String?,
      versionNumber: (map['versionNumber'] as num?)?.toInt(),
      isActive: (map['isActive'] as bool?) ?? false,
      revisionType: map['revisionType'] as String?,
      createdFromQuotationId: map['createdFromQuotationId'] as String?,
      leadId: map['leadId'] as String?,
      leadCode: map['leadCode'] as String?,
      clientId: map['clientId'] as String?,
      companyId: map['companyId'] as String?,
      travelType: _travelTypeFromDynamic(map['travelType']),
      tripScope: _tripScopeFromDynamic(map['tripScope']),
      destination: map['destination'] as String?,
      travelDates: _leadTravelDatesFromDynamic(map['travelDates']),
      passengerCount: _passengerCountFromDynamic(map['passengerCount']),
      currency: (map['currency'] as String?)?.trim().isNotEmpty == true
          ? (map['currency'] as String).trim()
          : 'INR',
      pricing: _quotationPricingFromDynamic(map['pricing']),
      pricingIncludeInClientPdf:
          (map['pricingIncludeInClientPdf'] as bool?) ?? true,
      hotels: _quotationHotelsFromDynamic(map['hotels']),
      flights: _quotationFlightsFromDynamic(map['flights']),
      transfers: _quotationTransfersFromDynamic(map['transfers']),
      activities: _quotationActivitiesFromDynamic(map['activities']),
      inclusions: _stringListFromDynamic(map['inclusions']),
      exclusions: _stringListFromDynamic(map['exclusions']),
      itinerary: _quotationItineraryFromDynamic(map['itinerary']),
      comparisonSummary: _comparisonSummaryFromDynamic(map['comparisonSummary']),
      status: map['status'] as String?,
      validityDate: _dateTimeFromDynamic(map['validityDate']),
      confirmedSnapshotRef: map['confirmedSnapshotRef'] as String?,
      notes: map['notes'] as String?,
      marginAlertLevel: _marginAlertLevelFromDynamic(map['marginAlertLevel']),
      validationStateHasPricing:
          (map['validationStateHasPricing'] as bool?) ?? false,
      validationStateHasAtLeastOneServiceComponent:
          (map['validationStateHasAtLeastOneServiceComponent'] as bool?) ??
          false,
      validationStateHasItinerary:
          (map['validationStateHasItinerary'] as bool?) ?? false,
      validationStateHasValidityDate:
          (map['validationStateHasValidityDate'] as bool?) ?? false,
      clientNameSnapshot: map['clientNameSnapshot'] as String?,
      companyNameSnapshot: map['companyNameSnapshot'] as String?,
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
      'quotationCode': quotationCode,
      'versionNumber': versionNumber,
      'isActive': isActive,
      'revisionType': revisionType,
      'createdFromQuotationId': createdFromQuotationId,
      'leadId': leadId,
      'leadCode': leadCode,
      'clientId': clientId,
      'companyId': companyId,
      'travelType': travelType.firestoreValue,
      'tripScope': tripScope.firestoreValue,
      'destination': destination,
      'travelDates': travelDates?.toMap(),
      'passengerCount': passengerCount?.toMap(),
      'currency': currency,
      'pricing': pricing?.toMap(),
      'pricingIncludeInClientPdf': pricingIncludeInClientPdf,
      'hotels': hotels.map((hotel) => hotel.toMap()).toList(growable: false),
      'flights': flights.map((flight) => flight.toMap()).toList(growable: false),
      'transfers':
          transfers.map((transfer) => transfer.toMap()).toList(growable: false),
      'activities':
          activities.map((activity) => activity.toMap()).toList(growable: false),
      'inclusions': inclusions,
      'exclusions': exclusions,
      'itinerary': itinerary?.toMap(),
      'comparisonSummary': comparisonSummary?.toMap(),
      'status': status,
      'validityDate': validityDate,
      'confirmedSnapshotRef': confirmedSnapshotRef,
      'notes': notes,
      'marginAlertLevel': marginAlertLevel.firestoreValue,
      'validationStateHasPricing': validationStateHasPricing,
      'validationStateHasAtLeastOneServiceComponent':
          validationStateHasAtLeastOneServiceComponent,
      'validationStateHasItinerary': validationStateHasItinerary,
      'validationStateHasValidityDate': validationStateHasValidityDate,
      'clientNameSnapshot': clientNameSnapshot,
      'companyNameSnapshot': companyNameSnapshot,
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

  QuotationModel copyWith({
    String? id,
    String? quotationCode,
    int? versionNumber,
    bool? isActive,
    String? revisionType,
    String? createdFromQuotationId,
    String? leadId,
    String? leadCode,
    String? clientId,
    String? companyId,
    TravelType? travelType,
    TripScope? tripScope,
    String? destination,
    LeadTravelDatesModel? travelDates,
    PassengerCountModel? passengerCount,
    String? currency,
    QuotationPricingModel? pricing,
    bool? pricingIncludeInClientPdf,
    List<QuotationHotelItemModel>? hotels,
    List<QuotationFlightItemModel>? flights,
    List<QuotationTransferItemModel>? transfers,
    List<QuotationActivityItemModel>? activities,
    List<String>? inclusions,
    List<String>? exclusions,
    QuotationItineraryModel? itinerary,
    QuotationComparisonSummaryModel? comparisonSummary,
    String? status,
    DateTime? validityDate,
    String? confirmedSnapshotRef,
    String? notes,
    MarginAlertLevel? marginAlertLevel,
    bool? validationStateHasPricing,
    bool? validationStateHasAtLeastOneServiceComponent,
    bool? validationStateHasItinerary,
    bool? validationStateHasValidityDate,
    String? clientNameSnapshot,
    String? companyNameSnapshot,
    List<String>? searchTokens,
    String? createdBy,
    DateTime? createdAt,
    String? updatedBy,
    DateTime? updatedAt,
    bool? isArchived,
    String? archivedBy,
    DateTime? archivedAt,
  }) {
    return QuotationModel(
      id: id ?? this.id,
      quotationCode: quotationCode ?? this.quotationCode,
      versionNumber: versionNumber ?? this.versionNumber,
      isActive: isActive ?? this.isActive,
      revisionType: revisionType ?? this.revisionType,
      createdFromQuotationId:
          createdFromQuotationId ?? this.createdFromQuotationId,
      leadId: leadId ?? this.leadId,
      leadCode: leadCode ?? this.leadCode,
      clientId: clientId ?? this.clientId,
      companyId: companyId ?? this.companyId,
      travelType: travelType ?? this.travelType,
      tripScope: tripScope ?? this.tripScope,
      destination: destination ?? this.destination,
      travelDates: travelDates ?? this.travelDates,
      passengerCount: passengerCount ?? this.passengerCount,
      currency: currency ?? this.currency,
      pricing: pricing ?? this.pricing,
      pricingIncludeInClientPdf:
          pricingIncludeInClientPdf ?? this.pricingIncludeInClientPdf,
      hotels: hotels ?? this.hotels,
      flights: flights ?? this.flights,
      transfers: transfers ?? this.transfers,
      activities: activities ?? this.activities,
      inclusions: inclusions ?? this.inclusions,
      exclusions: exclusions ?? this.exclusions,
      itinerary: itinerary ?? this.itinerary,
      comparisonSummary: comparisonSummary ?? this.comparisonSummary,
      status: status ?? this.status,
      validityDate: validityDate ?? this.validityDate,
      confirmedSnapshotRef: confirmedSnapshotRef ?? this.confirmedSnapshotRef,
      notes: notes ?? this.notes,
      marginAlertLevel: marginAlertLevel ?? this.marginAlertLevel,
      validationStateHasPricing:
          validationStateHasPricing ?? this.validationStateHasPricing,
      validationStateHasAtLeastOneServiceComponent:
          validationStateHasAtLeastOneServiceComponent ??
          this.validationStateHasAtLeastOneServiceComponent,
      validationStateHasItinerary:
          validationStateHasItinerary ?? this.validationStateHasItinerary,
      validationStateHasValidityDate:
          validationStateHasValidityDate ?? this.validationStateHasValidityDate,
      clientNameSnapshot: clientNameSnapshot ?? this.clientNameSnapshot,
      companyNameSnapshot: companyNameSnapshot ?? this.companyNameSnapshot,
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

LeadTravelDatesModel? _leadTravelDatesFromDynamic(dynamic value) {
  final map = _mapFromDynamic(value);
  if (map == null) {
    return null;
  }

  return LeadTravelDatesModel.fromMap(map);
}

PassengerCountModel? _passengerCountFromDynamic(dynamic value) {
  final map = _mapFromDynamic(value);
  if (map == null) {
    return null;
  }

  return PassengerCountModel.fromMap(map);
}

QuotationPricingModel? _quotationPricingFromDynamic(dynamic value) {
  final map = _mapFromDynamic(value);
  if (map == null) {
    return null;
  }

  return QuotationPricingModel.fromMap(map);
}

QuotationItineraryModel? _quotationItineraryFromDynamic(dynamic value) {
  final map = _mapFromDynamic(value);
  if (map == null) {
    return null;
  }

  return QuotationItineraryModel.fromMap(map);
}

QuotationComparisonSummaryModel? _comparisonSummaryFromDynamic(dynamic value) {
  final map = _mapFromDynamic(value);
  if (map == null) {
    return null;
  }

  return QuotationComparisonSummaryModel.fromMap(map);
}

List<QuotationHotelItemModel> _quotationHotelsFromDynamic(dynamic value) {
  if (value is! Iterable) {
    return const <QuotationHotelItemModel>[];
  }

  return value
      .map(_mapFromDynamic)
      .whereType<Map<String, dynamic>>()
      .map(QuotationHotelItemModel.fromMap)
      .toList(growable: false);
}

List<QuotationFlightItemModel> _quotationFlightsFromDynamic(dynamic value) {
  if (value is! Iterable) {
    return const <QuotationFlightItemModel>[];
  }

  return value
      .map(_mapFromDynamic)
      .whereType<Map<String, dynamic>>()
      .map(QuotationFlightItemModel.fromMap)
      .toList(growable: false);
}

List<QuotationTransferItemModel> _quotationTransfersFromDynamic(dynamic value) {
  if (value is! Iterable) {
    return const <QuotationTransferItemModel>[];
  }

  return value
      .map(_mapFromDynamic)
      .whereType<Map<String, dynamic>>()
      .map(QuotationTransferItemModel.fromMap)
      .toList(growable: false);
}

List<QuotationActivityItemModel> _quotationActivitiesFromDynamic(dynamic value) {
  if (value is! Iterable) {
    return const <QuotationActivityItemModel>[];
  }

  return value
      .map(_mapFromDynamic)
      .whereType<Map<String, dynamic>>()
      .map(QuotationActivityItemModel.fromMap)
      .toList(growable: false);
}

TravelType _travelTypeFromDynamic(dynamic value) {
  if (value is TravelType) {
    return value;
  }

  if (value is String && value.trim().isNotEmpty) {
    try {
      return TravelTypeX.fromString(value);
    } on ArgumentError {
      return TravelType.fit;
    }
  }

  return TravelType.fit;
}

TripScope _tripScopeFromDynamic(dynamic value) {
  if (value is TripScope) {
    return value;
  }

  if (value is String && value.trim().isNotEmpty) {
    try {
      return TripScopeX.fromString(value);
    } on ArgumentError {
      return TripScope.international;
    }
  }

  return TripScope.international;
}

MarginAlertLevel _marginAlertLevelFromDynamic(dynamic value) {
  if (value is MarginAlertLevel) {
    return value;
  }

  if (value is String && value.trim().isNotEmpty) {
    try {
      return MarginAlertLevelX.fromString(value);
    } on ArgumentError {
      return MarginAlertLevel.none;
    }
  }

  return MarginAlertLevel.none;
}
