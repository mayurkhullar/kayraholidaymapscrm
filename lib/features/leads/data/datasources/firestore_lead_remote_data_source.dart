import 'package:cloud_firestore/cloud_firestore.dart';

import '../../../../core/constants/firestore_collections.dart';
import '../../domain/models/lead_model.dart';
import 'lead_remote_data_source.dart';

class FirestoreLeadRemoteDataSource implements LeadRemoteDataSource {
  FirestoreLeadRemoteDataSource({required FirebaseFirestore firestore})
    : _firestore = firestore;

  final FirebaseFirestore _firestore;

  CollectionReference<Map<String, dynamic>> get _leadsCollection =>
      _firestore.collection(FirestoreCollections.leads);

  @override
  Future<List<LeadModel>> fetchLeads() async {
    final querySnapshot = await _leadsCollection
        .where('isArchived', isEqualTo: false)
        .limit(20)
        .get();

    return querySnapshot.docs
        .map((doc) => LeadModel.fromMap(<String, dynamic>{
              ...doc.data(),
              'id': doc.id,
            }))
        .toList(growable: false);
  }

  @override
  Future<LeadModel?> getLeadById(String id) async {
    final documentSnapshot = await _leadsCollection.doc(id).get();

    if (!documentSnapshot.exists) {
      return null;
    }

    final data = documentSnapshot.data();
    if (data == null) {
      return null;
    }

    return LeadModel.fromMap(<String, dynamic>{
      ...data,
      'id': documentSnapshot.id,
    });
  }

  @override
  Future<void> createLead(LeadModel lead) async {
    final documentReference = lead.id.isEmpty
        ? _leadsCollection.doc()
        : _leadsCollection.doc(lead.id);
    final leadToCreate = lead.id.isEmpty
        ? lead.copyWith(id: documentReference.id)
        : lead;

    await documentReference.set(leadToCreate.toMap());
  }

  @override
  Future<void> updateLead(LeadModel lead) {
    return _leadsCollection.doc(lead.id).update(lead.toMap());
  }

  @override
  Future<void> archiveLead(String id) {
    return _leadsCollection.doc(id).update(<String, dynamic>{
      'isArchived': true,
      'archivedAt': DateTime.now(),
    });
  }
}
