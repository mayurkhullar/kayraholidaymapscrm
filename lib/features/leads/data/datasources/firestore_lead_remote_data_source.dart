import 'package:cloud_firestore/cloud_firestore.dart';

import '../../../../core/constants/app_enums.dart';
import '../../../../core/constants/firestore_collections.dart';
import '../../../clients/domain/models/client_model.dart';
import '../../../../shared/models/passenger_count_model.dart';
import '../../domain/models/lead_model.dart';
import '../../domain/models/lead_note_model.dart';
import 'lead_remote_data_source.dart';

class FirestoreLeadRemoteDataSource implements LeadRemoteDataSource {
  FirestoreLeadRemoteDataSource({required FirebaseFirestore firestore})
    : _firestore = firestore;

  final FirebaseFirestore _firestore;

  CollectionReference<Map<String, dynamic>> get _leadsCollection =>
      _firestore.collection(FirestoreCollections.leads);

  CollectionReference<Map<String, dynamic>> _leadNotesCollection(
    String leadId,
  ) => _leadsCollection.doc(leadId).collection('notes');

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
            passengerCount: (lead.passengerCount ??
                    PassengerCountModel.calculate(
                      adults: lead.adultCount,
                      children: lead.childCount,
                      infants: lead.infantCount,
                    ))
                .withComputedTotal(),
            adultCount: lead.adultCount,
            childCount: lead.childCount,
            infantCount: lead.infantCount,
            notes: lead.notes,
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
  Future<void> updateLead(LeadModel lead) async {
    final leadReference = _leadsCollection.doc(lead.id);
    final clientsCollection = _firestore.collection(FirestoreCollections.clients);

    await _firestore.runTransaction((transaction) async {
      final leadSnapshot = await transaction.get(leadReference);
      final existingLead = leadSnapshot.data() ?? const <String, dynamic>{};
      final existingClientId =
          (existingLead['clientId'] as String?)?.trim() ?? '';
      final wasAlreadyConverted =
          (existingLead['isConverted'] as bool?) ?? false;

      final isNowConfirmed = lead.leadStage == LeadStage.confirmed;
      final shouldConvert =
          isNowConfirmed &&
          !lead.isConverted &&
          !wasAlreadyConverted &&
          existingClientId.isEmpty;

      var convertedClientId = existingClientId;

      if (shouldConvert) {
        final now = DateTime.now();
        final travelersCount = lead.passengerCount?.totalPax ??
            _travelersFromLeadCounts(
              adults: lead.adultCount,
              children: lead.childCount,
              infants: lead.infantCount,
            );
        final leadName =
            _stringFromDynamic(existingLead['name']) ??
            _stringFromDynamic(existingLead['clientName']) ??
            lead.clientNameSnapshot ??
            '';
        final leadPhone =
            _stringFromDynamic(existingLead['phone']) ??
            _stringFromDynamic(existingLead['clientPhone']) ??
            '';
        final leadEmail =
            _stringFromDynamic(existingLead['email']) ??
            _stringFromDynamic(existingLead['clientEmail']);
        final leadCompanyName =
            _stringFromDynamic(existingLead['companyName']) ??
            lead.companyNameSnapshot;

        if (leadPhone != null && leadPhone.isNotEmpty) {
          final duplicateClientQuery = await transaction.get(
            clientsCollection.where('phone', isEqualTo: leadPhone).limit(1),
          );
          if (duplicateClientQuery.docs.isNotEmpty) {
            convertedClientId = duplicateClientQuery.docs.first.id;
          }
        }

        if (convertedClientId.isEmpty) {
          final newClientReference = clientsCollection.doc();
          final client = ClientModel(
            id: newClientReference.id,
            clientCode: await _nextClientCode(transaction),
            name: leadName,
            email: leadEmail ?? '',
            phone: leadPhone ?? '',
            destination: lead.destination,
            travelType: lead.travelType.firestoreValue,
            budget: lead.budget,
            travelers: travelersCount,
            companyName: leadCompanyName,
            createdAt: now,
            updatedAt: now,
            isActive: true,
          );

          transaction.set(newClientReference, client.toMap());
          convertedClientId = newClientReference.id;
        }

        final timelineReference = _leadNotesCollection(lead.id).doc();
        transaction.set(timelineReference, <String, dynamic>{
          'id': timelineReference.id,
          'leadId': lead.id,
          'noteText': 'Lead converted to client',
          'noteType': 'system',
          'relatedStage': LeadStage.confirmed.firestoreValue,
          'createdBy': null,
          'createdAt': now,
        });
      }

      final leadToUpdate = lead.copyWith(
        clientId: convertedClientId.isNotEmpty
            ? convertedClientId
            : lead.clientId,
        isConverted: shouldConvert || wasAlreadyConverted || lead.isConverted,
        updatedAt: DateTime.now(),
      );

      transaction.update(leadReference, leadToUpdate.toMap());
    });
  }

  @override
  Future<void> archiveLead(String id) {
    return _leadsCollection.doc(id).update(<String, dynamic>{
      'isArchived': true,
      'archivedAt': DateTime.now(),
    });
  }

  @override
  Future<List<LeadNoteModel>> fetchLeadNotes(String leadId) async {
    final querySnapshot = await _leadNotesCollection(leadId)
        .orderBy('createdAt', descending: true)
        .get();

    return querySnapshot.docs
        .map(
          (doc) => LeadNoteModel.fromMap(<String, dynamic>{
            ...doc.data(),
            'id': doc.id,
            'leadId': leadId,
          }),
        )
        .toList(growable: false);
  }

  @override
  Future<void> addLeadNote(LeadNoteModel note) async {
    final notesCollection = _leadNotesCollection(note.leadId);
    final documentReference = note.id.isEmpty
        ? notesCollection.doc()
        : notesCollection.doc(note.id);

    final noteToCreate = note.id.isEmpty
        ? note.copyWith(id: documentReference.id)
        : note;

    await documentReference.set(noteToCreate.toMap());
  }

  Future<String> _nextClientCode(Transaction transaction) async {
    final counterReference = _firestore.collection('counters').doc('client_2026');
    final counterSnapshot = await transaction.get(counterReference);
    final current = (counterSnapshot.data()?['current'] as num?)?.toInt() ?? 0;
    final next = current + 1;

    if (counterSnapshot.exists) {
      transaction.update(counterReference, <String, dynamic>{'current': next});
    } else {
      transaction.set(counterReference, <String, dynamic>{'current': next});
    }

    return 'CL-2026-${next.toString().padLeft(4, '0')}';
  }
}

int? _travelersFromLeadCounts({
  required int adults,
  required int children,
  required int infants,
}) {
  final total = adults + children + infants;
  return total > 0 ? total : null;
}

String? _stringFromDynamic(dynamic value) {
  if (value is String) {
    final trimmed = value.trim();
    return trimmed.isEmpty ? null : trimmed;
  }

  return null;
}
