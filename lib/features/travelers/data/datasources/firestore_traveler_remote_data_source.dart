import 'package:cloud_firestore/cloud_firestore.dart';

import '../../../../core/constants/firestore_collections.dart';
import '../../domain/models/traveler_model.dart';
import 'traveler_remote_data_source.dart';

class FirestoreTravelerRemoteDataSource implements TravelerRemoteDataSource {
  FirestoreTravelerRemoteDataSource({required FirebaseFirestore firestore})
      : _firestore = firestore;

  final FirebaseFirestore _firestore;

  CollectionReference<Map<String, dynamic>> get _travelersCollection =>
      _firestore.collection(FirestoreCollections.travelers);

  @override
  Future<List<TravelerModel>> fetchTravelers() async {
    final querySnapshot = await _travelersCollection
        .orderBy('updatedAt', descending: true)
        .limit(200)
        .get();

    return querySnapshot.docs
        .map(
          (doc) => TravelerModel.fromMap(<String, dynamic>{
            ...doc.data(),
            'id': doc.id,
          }),
        )
        .where((traveler) => traveler.isActive)
        .toList(growable: false);
  }

  @override
  Future<TravelerModel?> getTravelerById(String id) async {
    final documentSnapshot = await _travelersCollection.doc(id).get();

    if (!documentSnapshot.exists) {
      return null;
    }

    final data = documentSnapshot.data();
    if (data == null) {
      return null;
    }

    return TravelerModel.fromMap(<String, dynamic>{
      ...data,
      'id': documentSnapshot.id,
    });
  }

  @override
  Future<void> createTraveler(TravelerModel traveler) async {
    final now = DateTime.now();
    final documentReference =
        traveler.id.isEmpty ? _travelersCollection.doc() : _travelersCollection.doc(traveler.id);
    final travelerId = traveler.id.isEmpty ? documentReference.id : traveler.id;

    final travelerToCreate = traveler.copyWith(
      id: travelerId,
      travelerCode: traveler.travelerCode.trim().isEmpty
          ? await _nextTravelerCode()
          : traveler.travelerCode,
      createdAt: traveler.createdAt == DateTime.fromMillisecondsSinceEpoch(0)
          ? now
          : traveler.createdAt,
      updatedAt: now,
    );

    await documentReference.set(travelerToCreate.toMap());
  }

  @override
  Future<void> updateTraveler(TravelerModel traveler) {
    return _travelersCollection.doc(traveler.id).update(
      traveler.copyWith(updatedAt: DateTime.now()).toMap(),
    );
  }

  @override
  Future<void> archiveTraveler(String id) {
    return _travelersCollection.doc(id).update(<String, dynamic>{
      'isActive': false,
      'updatedAt': Timestamp.now(),
    });
  }

  Future<String> _nextTravelerCode() async {
    final year = DateTime.now().year;
    final counterReference = _firestore
        .collection('counters')
        .doc('traveler_$year');

    return _firestore.runTransaction((transaction) async {
      final counterSnapshot = await transaction.get(counterReference);
      final current = (counterSnapshot.data()?['current'] as num?)?.toInt() ?? 0;
      final next = current + 1;

      if (counterSnapshot.exists) {
        transaction.update(counterReference, <String, dynamic>{'current': next});
      } else {
        transaction.set(counterReference, <String, dynamic>{'current': next});
      }

      return 'TR-$year-${next.toString().padLeft(4, '0')}';
    });
  }
}
