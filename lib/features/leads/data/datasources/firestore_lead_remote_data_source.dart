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
    final queryStopwatch = Stopwatch()..start();
    final querySnapshot = await _leadsCollection
        .where('isArchived', isEqualTo: false)
        .limit(20)
        .get();
    queryStopwatch.stop();

    final mappingStopwatch = Stopwatch()..start();
    final leads = querySnapshot.docs
        .map((doc) => LeadModel.fromMap(<String, dynamic>{
              ...doc.data(),
              'id': doc.id,
            }))
        .toList(growable: false);
    mappingStopwatch.stop();

    print('===== LEAD DATASOURCE DIAGNOSTICS =====');
    print('Lead datasource query time: ${queryStopwatch.elapsedMilliseconds} ms');
    print(
      'Lead datasource mapping time: ${mappingStopwatch.elapsedMilliseconds} ms',
    );
    print('Lead datasource total docs: ${querySnapshot.docs.length}');
    print('=======================================');

    return leads;
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

    await _firestore.runTransaction((transaction) async {
      final counterReference = _firestore.collection('counters').doc('lead_2026');
      final counterSnapshot = await transaction.get(counterReference);
      final current = (counterSnapshot.data()?['current'] as num?)?.toInt() ?? 0;
      final next = current + 1;
      final leadCode = 'LD-2026-${next.toString().padLeft(4, '0')}';
      final leadToCreate = (lead.id.isEmpty
              ? lead.copyWith(id: documentReference.id)
              : lead)
          .copyWith(
            leadCode: leadCode,
            budget: lead.budget,
            budgetType: lead.budgetType,
            isArchived: false,
            createdAt: lead.createdAt ?? DateTime.now(),
            updatedAt: lead.updatedAt ?? DateTime.now(),
          );

      if (counterSnapshot.exists) {
        transaction.update(counterReference, <String, dynamic>{
          'current': next,
        });
      } else {
        transaction.set(counterReference, <String, dynamic>{
          'current': next,
        });
      }

      transaction.set(documentReference, leadToCreate.toMap());
    });
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
