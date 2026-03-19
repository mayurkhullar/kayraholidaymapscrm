import 'package:cloud_firestore/cloud_firestore.dart';

import '../../../../core/constants/firestore_collections.dart';
import '../../domain/models/client_model.dart';
import 'client_remote_data_source.dart';

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
        .get();

    return querySnapshot.docs
        .map((doc) => ClientModel.fromMap(<String, dynamic>{
              ...doc.data(),
              'id': doc.id,
            }))
        .toList(growable: false);
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

    return ClientModel.fromMap(<String, dynamic>{
      ...data,
      'id': documentSnapshot.id,
    });
  }

  @override
  Future<void> createClient(ClientModel client) async {
    final documentReference = client.id.isEmpty
        ? _clientsCollection.doc()
        : _clientsCollection.doc(client.id);
    final clientToCreate = client.id.isEmpty
        ? client.copyWith(id: documentReference.id)
        : client;

    await documentReference.set(clientToCreate.toMap());
  }

  @override
  Future<void> updateClient(ClientModel client) {
    return _clientsCollection.doc(client.id).update(client.toMap());
  }

  @override
  Future<void> archiveClient(String id) {
    return _clientsCollection.doc(id).update(<String, dynamic>{
      'isArchived': true,
      'archivedAt': DateTime.now(),
    });
  }
}
