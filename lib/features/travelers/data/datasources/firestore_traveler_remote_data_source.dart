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
        .where('isArchived', isEqualTo: false)
        .limit(20)
        .get();

    return querySnapshot.docs
        .map((doc) => TravelerModel.fromMap(<String, dynamic>{
              ...doc.data(),
              'id': doc.id,
            }))
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
    final documentReference = traveler.id.isEmpty
        ? _travelersCollection.doc()
        : _travelersCollection.doc(traveler.id);
    final travelerToCreate = traveler.id.isEmpty
        ? traveler.copyWith(id: documentReference.id)
        : traveler;

    await documentReference.set(travelerToCreate.toMap());
  }

  @override
  Future<void> updateTraveler(TravelerModel traveler) {
    return _travelersCollection.doc(traveler.id).update(traveler.toMap());
  }

  @override
  Future<void> archiveTraveler(String id) {
    return _travelersCollection.doc(id).update(<String, dynamic>{
      'isArchived': true,
      'archivedAt': DateTime.now(),
    });
  }
}
