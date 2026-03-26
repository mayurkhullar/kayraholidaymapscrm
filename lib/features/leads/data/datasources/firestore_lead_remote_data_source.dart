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

  Future<void> _createTravelFileIfNotExists(
    Map<String, dynamic> leadData,
    String leadId,
  ) async {
    final firestore = FirebaseFirestore.instance;

    final existing = await firestore
        .collection('travelFiles')
        .where('leadId', isEqualTo: leadId)
        .limit(1)
        .get();

    if (existing.docs.isNotEmpty) {
      print('Travel file already exists for lead: $leadId');
      return;
    }

    final docRef = firestore.collection('travelFiles').doc();
    final pax = leadData['passengerCount'] ?? <String, dynamic>{};
    await docRef.set(<String, dynamic>{
      'id': docRef.id,
      'travelFileCode': 'TF-${DateTime.now().millisecondsSinceEpoch}',
      'leadId': leadId,
      'clientId': leadData['clientId'],
      'clientNameSnapshot': leadData['clientNameSnapshot'],
      'destination': leadData['destination'],
      'travelType': leadData['travelType'],
      'tripScope': leadData['tripScope'],
      'leadStage': leadData['leadStage'],
      'status': 'Open',
      'adultCount': pax['adults'] ?? 0,
      'childCount': pax['children'] ?? 0,
      'infantCount': pax['infants'] ?? 0,
      'totalPax': pax['totalPax'] ?? 0,
      'notes': leadData['notes'],
      'isArchived': false,
      'createdAt': FieldValue.serverTimestamp(),
      'updatedAt': FieldValue.serverTimestamp(),
    });

    print('Travel file created for lead: $leadId');
  }

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
  Future<List<LeadModel>> fetchLeadsByClientId(String clientId) async {
    final normalizedClientId = clientId.trim();
    if (normalizedClientId.isEmpty) {
      print('fetchLeadsByClientId skipped: clientId is empty');
      return const <LeadModel>[];
    }

    print('fetchLeadsByClientId clientId: $normalizedClientId');
    final QuerySnapshot<Map<String, dynamic>> querySnapshot =
        await _leadsCollection
        .where('clientId', isEqualTo: normalizedClientId)
        .orderBy('updatedAt', descending: true)
        .get();

    final leads = querySnapshot.docs
        .map((doc) {
          final data = doc.data();
          if (data.isEmpty) {
            return null;
          }

          try {
            return LeadModel.fromMap(<String, dynamic>{
              ...data,
              'id': doc.id,
            });
          } catch (_) {
            return null;
          }
        })
        .whereType<LeadModel>()
        .toList(growable: false);

    print('fetchLeadsByClientId fetched leads: ${leads.length}');
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

    Map<String, dynamic>? updatedLeadData;

    await _firestore.runTransaction((transaction) async {
      final leadSnapshot = await transaction.get(leadReference);
      final existingLead = leadSnapshot.data() ?? const <String, dynamic>{};
      final existingClientId = (existingLead['clientId'] as String?)?.trim() ?? '';
      final wasAlreadyConverted = (existingLead['isConverted'] as bool?) ?? false;

      final isNowConfirmed = lead.leadStage == LeadStage.confirmed;
      final isAlreadyConverted = lead.isConverted || wasAlreadyConverted;
      final shouldAttemptConversion = isNowConfirmed && !isAlreadyConverted;

      var convertedClientId = existingClientId;
      var didConvertLead = false;

      if (shouldAttemptConversion) {
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
            lead.phone;
        final leadEmail =
            _stringFromDynamic(existingLead['email']) ??
            _stringFromDynamic(existingLead['clientEmail']) ??
            lead.email;
        final leadWhatsappNumber =
            _stringFromDynamic(existingLead['whatsappNumber']) ??
            lead.whatsappNumber;
        final leadCompanyName =
            _stringFromDynamic(existingLead['companyName']) ??
            lead.companyNameSnapshot;

        if (convertedClientId.isEmpty && leadPhone.isNotEmpty) {
          final QuerySnapshot<Map<String, dynamic>> querySnapshot = await clientsCollection
              .where('phone', isEqualTo: leadPhone)
              .limit(1)
              .get();

          if (querySnapshot.docs.isNotEmpty) {
            convertedClientId = querySnapshot.docs.first.id;
            final existingClientData = querySnapshot.docs.first.data();
            final existingClientWhatsapp = _stringFromDynamic(
              existingClientData['whatsappNumber'],
            );
            final existingClientEmail = _stringFromDynamic(
              existingClientData['email'],
            );
            final hasLeadWhatsapp = leadWhatsappNumber != null;
            final hasLeadEmail = leadEmail != null;

            if ((existingClientWhatsapp == null && hasLeadWhatsapp) ||
                (existingClientEmail == null && hasLeadEmail)) {
              transaction.update(
                querySnapshot.docs.first.reference,
                <String, dynamic>{
                  if (existingClientWhatsapp == null && hasLeadWhatsapp)
                    'whatsappNumber': leadWhatsappNumber,
                  if (existingClientEmail == null && hasLeadEmail) 'email': leadEmail,
                  'updatedAt': Timestamp.fromDate(now),
                },
              );
            }
          }
        }

        if (convertedClientId.isEmpty) {
          final newClientReference = clientsCollection.doc();
          final client = ClientModel(
            id: newClientReference.id,
            clientCode: await _nextClientCode(transaction),
            name: leadName,
            phone: leadPhone,
            whatsappNumber: leadWhatsappNumber,
            email: leadEmail,
            destination: lead.destination,
            travelType: lead.travelType.firestoreValue,
            budget: lead.budget,
            travelers: travelersCount,
            companyName: leadCompanyName,
            createdAt: lead.createdAt ?? now,
            updatedAt: now,
            isActive: true,
          );

          transaction.set(newClientReference, client.toMap());
          convertedClientId = newClientReference.id;
        }

        didConvertLead = convertedClientId.isNotEmpty;

        if (didConvertLead) {
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
      }

      final leadToUpdate = lead.copyWith(
        clientId: convertedClientId.isNotEmpty ? convertedClientId : lead.clientId,
        isConverted:
            isAlreadyConverted ||
            (isNowConfirmed && convertedClientId.isNotEmpty) ||
            didConvertLead,
        updatedAt: DateTime.now(),
      );

      final leadData = leadToUpdate.toMap();
      leadData['clientId'] =
          (leadToUpdate.clientId ?? '').trim().isNotEmpty
              ? (leadToUpdate.clientId ?? '').trim()
              : existingClientId;
      leadData['clientNameSnapshot'] =
          lead.clientNameSnapshot ??
          existingLead['clientNameSnapshot'] ??
          existingLead['clientName'];
      leadData['destination'] = lead.destination ?? existingLead['destination'];
      leadData['travelType'] =
          lead.travelType.firestoreValue.isNotEmpty
              ? lead.travelType.firestoreValue
              : existingLead['travelType'];
      leadData['tripScope'] =
          lead.tripScope.firestoreValue.isNotEmpty
              ? lead.tripScope.firestoreValue
              : existingLead['tripScope'];
      leadData['leadStage'] = leadToUpdate.leadStage.firestoreValue;
      leadData['notes'] = lead.notes ?? existingLead['notes'];
      leadData['passengerCount'] = leadData['passengerCount'] ?? <String, dynamic>{};
      updatedLeadData = leadData;

      transaction.update(leadReference, leadData);
    });

    final leadData = updatedLeadData;
    if (leadData == null) {
      return;
    }

    if (leadData['leadStage'] == 'CONFIRMED') {
      await _createTravelFileIfNotExists(leadData, lead.id);
    }
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
