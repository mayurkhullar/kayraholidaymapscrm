import 'package:cloud_firestore/cloud_firestore.dart';

import '../../../../core/constants/firestore_collections.dart';
import '../../domain/models/client_model.dart';
import 'client_remote_data_source.dart';


class ClientWithActivityRecord {
  const ClientWithActivityRecord({
    required this.client,
    required this.totalLeads,
    required this.latestActivityDate,
  });

  final ClientModel client;
  final int totalLeads;
  final DateTime? latestActivityDate;
}


class FirestoreClientRemoteDataSource implements ClientRemoteDataSource {
  FirestoreClientRemoteDataSource({required FirebaseFirestore firestore})
    : _firestore = firestore;

  final FirebaseFirestore _firestore;

  CollectionReference<Map<String, dynamic>> get _clientsCollection =>
      _firestore.collection(FirestoreCollections.clients);

  @override
  Future<List<ClientModel>> fetchClients() async {
    final querySnapshot = await _clientsCollection
        .where('isArchived', isEqualTo: false)
        .orderBy('createdAt', descending: true)
        .get();

    return querySnapshot.docs
        .map(
          (doc) => ClientModel.fromMap(doc.data(), doc.id),
        )
        .toList(growable: false);
  }


  Future<List<ClientWithActivityRecord>> fetchClientsWithActivity() async {
    final results = await Future.wait([
      _clientsCollection
          .where('isArchived', isEqualTo: false)
          .orderBy('createdAt', descending: true)
          .get(),
      _firestore
          .collection(FirestoreCollections.leads)
          .where('isArchived', isEqualTo: false)
          .get(),
    ]);

    final clientsSnapshot = results[0] as QuerySnapshot<Map<String, dynamic>>;
    final leadsSnapshot = results[1] as QuerySnapshot<Map<String, dynamic>>;

    final statsByClientId = <String, _ClientLeadStats>{};

    for (final leadDoc in leadsSnapshot.docs) {
      final leadData = leadDoc.data();
      final clientId = (leadData['clientId'] as String?)?.trim();
      if (clientId == null || clientId.isEmpty) {
        continue;
      }

      final updatedAt = _dateTimeFromDynamic(leadData['updatedAt']);
      final current = statsByClientId[clientId] ?? const _ClientLeadStats();

      statsByClientId[clientId] = _ClientLeadStats(
        totalLeads: current.totalLeads + 1,
        latestActivityDate: _maxDate(current.latestActivityDate, updatedAt),
      );
    }

    return clientsSnapshot.docs.map((doc) {
      final client = ClientModel.fromMap(doc.data(), doc.id);
      final stats = statsByClientId[doc.id] ?? const _ClientLeadStats();

      return ClientWithActivityRecord(
        client: client,
        totalLeads: stats.totalLeads,
        latestActivityDate: stats.latestActivityDate,
      );
    }).toList(growable: false);
  }

  @override
  Future<ClientModel?> getClientById(String id) async {
    final documentSnapshot = await _clientsCollection.doc(id).get();

    if (!documentSnapshot.exists) {
      return null;
    }

    final data = documentSnapshot.data();
    if (data == null) {
      return null;
    }

    return ClientModel.fromMap(data, documentSnapshot.id);
  }

  @override
  Future<void> createClient(ClientModel client) async {
    final documentReference = client.id.isEmpty
        ? _clientsCollection.doc()
        : _clientsCollection.doc(client.id);
    final now = DateTime.now();
    final clientToCreate = (client.id.isEmpty
            ? client.copyWith(id: documentReference.id)
            : client)
        .copyWith(
          clientCode: client.clientCode.trim().isEmpty
              ? await _nextClientCode()
              : client.clientCode,
          updatedAt: now,
          createdAt: client.createdAt == DateTime.fromMillisecondsSinceEpoch(0)
              ? now
              : client.createdAt,
        );

    await documentReference.set(_normalizeClientContactFields(clientToCreate.toMap()));
  }

  @override
  Future<void> updateClient(ClientModel client) {
    return _clientsCollection
        .doc(client.id)
        .update(_normalizeClientContactFields(client.toMap()));
  }

  @override
  Future<void> archiveClient(String id) {
    return _clientsCollection.doc(id).update(<String, dynamic>{
      'isArchived': true,
      'archivedAt': DateTime.now(),
    });
  }

  Future<String> _nextClientCode() async {
    final counterReference = _firestore.collection('counters').doc('client_2026');

    return _firestore.runTransaction((transaction) async {
      final counterSnapshot = await transaction.get(counterReference);
      final current = (counterSnapshot.data()?['current'] as num?)?.toInt() ?? 0;
      final next = current + 1;

      if (counterSnapshot.exists) {
        transaction.update(counterReference, <String, dynamic>{'current': next});
      } else {
        transaction.set(counterReference, <String, dynamic>{'current': next});
      }

      return 'CL-2026-${next.toString().padLeft(4, '0')}';
    });
  }
}

Map<String, dynamic> _normalizeClientContactFields(Map<String, dynamic> map) {
  final normalized = Map<String, dynamic>.from(map);
  normalized['phone'] = ((normalized['phone'] as String?) ?? '').trim();
  normalized['whatsappNumber'] = _optionalTrimmedString(
    normalized['whatsappNumber'],
  );
  normalized['email'] = _optionalTrimmedString(normalized['email']);
  return normalized;
}

String? _optionalTrimmedString(dynamic value) {
  if (value is String) {
    final trimmed = value.trim();
    return trimmed.isEmpty ? null : trimmed;
  }

  return null;
}

class _ClientLeadStats {
  const _ClientLeadStats({
    this.totalLeads = 0,
    this.latestActivityDate,
  });

  final int totalLeads;
  final DateTime? latestActivityDate;
}

DateTime? _dateTimeFromDynamic(dynamic value) {
  if (value is Timestamp) {
    return value.toDate();
  }

  if (value is DateTime) {
    return value;
  }

  return null;
}

DateTime? _maxDate(DateTime? left, DateTime? right) {
  if (left == null) {
    return right;
  }

  if (right == null) {
    return left;
  }

  return left.isAfter(right) ? left : right;
}
