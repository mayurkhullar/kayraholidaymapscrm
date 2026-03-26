import 'package:cloud_firestore/cloud_firestore.dart';

import '../../../../core/constants/firestore_collections.dart';
import '../../../travelers/domain/models/traveler_model.dart';
import '../../domain/models/travel_file_model.dart';
import 'travel_file_remote_data_source.dart';

class FirestoreTravelFileRemoteDataSource implements TravelFileRemoteDataSource {
  FirestoreTravelFileRemoteDataSource({required FirebaseFirestore firestore})
      : _firestore = firestore;

  final FirebaseFirestore _firestore;

  CollectionReference<Map<String, dynamic>> get _travelFilesCollection =>
      _firestore.collection(FirestoreCollections.travelFiles);

  @override
  Future<List<TravelFileModel>> fetchTravelFiles() async {
    final querySnapshot = await _travelFilesCollection
        .where('isArchived', isEqualTo: false)
        .limit(300)
        .get();

    print('DEBUG travelFiles count = ${querySnapshot.docs.length}');

    return querySnapshot.docs
        .map(
          (doc) => TravelFileModel.fromMap(<String, dynamic>{
            ...doc.data(),
            'id': doc.id,
          }),
        )
        .toList(growable: false);
  }

  @override
  Future<TravelFileModel?> getTravelFileById(String id) async {
    final snapshot = await _travelFilesCollection.doc(id).get();
    if (!snapshot.exists || snapshot.data() == null) {
      return null;
    }

    return TravelFileModel.fromMap(<String, dynamic>{
      ...snapshot.data()!,
      'id': snapshot.id,
    });
  }

  @override
  Future<TravelFileModel?> getTravelFileByLeadId(String leadId) async {
    final normalizedLeadId = leadId.trim();
    if (normalizedLeadId.isEmpty) {
      return null;
    }

    final snapshot = await _travelFilesCollection
        .where('leadId', isEqualTo: normalizedLeadId)
        .limit(1)
        .get();

    if (snapshot.docs.isEmpty) {
      return null;
    }

    final doc = snapshot.docs.first;
    return TravelFileModel.fromMap(<String, dynamic>{...doc.data(), 'id': doc.id});
  }

  @override
  Future<TravelFileModel> createTravelFile(TravelFileModel travelFile) async {
    final documentReference = travelFile.id.isEmpty
        ? _travelFilesCollection.doc()
        : _travelFilesCollection.doc(travelFile.id);

    final now = DateTime.now();
    final payload = travelFile.copyWith(
      id: documentReference.id,
      createdAt: travelFile.createdAt,
      updatedAt: now,
    );

    await documentReference.set(payload.toMap());
    return payload;
  }

  @override
  Future<TravelFileModel?> ensureTravelFileForConfirmedLead({
    required String leadId,
    required String clientId,
    required String clientNameSnapshot,
    required String destination,
    required String travelType,
    String? tripScope,
    required String leadStage,
    DateTime? startDate,
    DateTime? endDate,
    required int adultCount,
    required int childCount,
    required int infantCount,
    required int totalPax,
    String? notes,
  }) async {
    final normalizedLeadId = leadId.trim();
    final normalizedClientId = clientId.trim();
    if (normalizedLeadId.isEmpty || normalizedClientId.isEmpty) {
      return null;
    }

    final docReference = _travelFilesCollection.doc(normalizedLeadId);

    return _firestore.runTransaction((transaction) async {
      final existingSnapshot = await transaction.get(docReference);
      if (existingSnapshot.exists && existingSnapshot.data() != null) {
        return TravelFileModel.fromMap(<String, dynamic>{
          ...existingSnapshot.data()!,
          'id': existingSnapshot.id,
        });
      }

      final now = DateTime.now();
      final travelFile = TravelFileModel(
        id: docReference.id,
        travelFileCode: await _nextTravelFileCode(transaction, now.year),
        leadId: normalizedLeadId,
        clientId: normalizedClientId,
        clientNameSnapshot: clientNameSnapshot.trim(),
        destination: destination.trim(),
        travelType: travelType.trim(),
        tripScope: _normalizedOptionalString(tripScope),
        leadStage: leadStage.trim(),
        status: 'Open',
        startDate: startDate,
        endDate: endDate,
        adultCount: adultCount,
        childCount: childCount,
        infantCount: infantCount,
        totalPax: totalPax,
        notes: _normalizedOptionalString(notes),
        createdAt: now,
        updatedAt: now,
        isArchived: false,
      );

      transaction.set(docReference, travelFile.toMap());
      return travelFile;
    });
  }

  @override
  Future<List<TravelerModel>> fetchTravelersByLeadId(String leadId) async {
    final normalizedLeadId = leadId.trim();
    if (normalizedLeadId.isEmpty) {
      return const <TravelerModel>[];
    }

    final snapshot = await _firestore
        .collection(FirestoreCollections.travelers)
        .where('leadId', isEqualTo: normalizedLeadId)
        .where('isActive', isEqualTo: true)
        .orderBy('updatedAt', descending: true)
        .limit(100)
        .get();

    return snapshot.docs
        .map(
          (doc) => TravelerModel.fromMap(<String, dynamic>{
            ...doc.data(),
            'id': doc.id,
          }),
        )
        .toList(growable: false);
  }

  Future<String> _nextTravelFileCode(Transaction transaction, int year) async {
    final counterReference = _firestore.collection('counters').doc('travel_file_$year');
    final snapshot = await transaction.get(counterReference);
    final current = (snapshot.data()?['current'] as num?)?.toInt() ?? 0;
    final next = current + 1;

    if (snapshot.exists) {
      transaction.update(counterReference, <String, dynamic>{'current': next});
    } else {
      transaction.set(counterReference, <String, dynamic>{'current': next});
    }

    return 'TF-$year-${next.toString().padLeft(4, '0')}';
  }
}

String? _normalizedOptionalString(String? value) {
  final trimmed = value?.trim() ?? '';
  return trimmed.isEmpty ? null : trimmed;
}
