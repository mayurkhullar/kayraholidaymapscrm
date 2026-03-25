import '../../domain/models/client_model.dart';
import '../../domain/repositories/client_repository.dart';
import '../datasources/client_remote_data_source.dart';
import '../datasources/firestore_client_remote_data_source.dart';

class ClientRepositoryImpl implements ClientRepository {
  ClientRepositoryImpl({required ClientRemoteDataSource remoteDataSource})
    : _remoteDataSource = remoteDataSource;

  final ClientRemoteDataSource _remoteDataSource;

  @override
  Future<List<ClientModel>> fetchClients() {
    return _remoteDataSource.fetchClients();
  }

  @override
  Future<List<ClientActivitySummary>> fetchClientsWithActivitySummaries() async {
    if (_remoteDataSource is! FirestoreClientRemoteDataSource) {
      final clients = await _remoteDataSource.fetchClients();
      return clients
          .map(
            (client) => ClientActivitySummary(
              client: client,
              totalLeads: 0,
              latestActivityDate: null,
            ),
          )
          .toList(growable: false);
    }

    final records = await (_remoteDataSource as FirestoreClientRemoteDataSource)
        .fetchClientsWithActivity();

    return records
        .map(
          (record) => ClientActivitySummary(
            client: record.client,
            totalLeads: record.totalLeads,
            latestActivityDate: record.latestActivityDate,
          ),
        )
        .toList(growable: false);
  }

  @override
  Future<ClientModel?> getClientById(String id) {
    return _remoteDataSource.getClientById(id);
  }

  @override
  Future<void> createClient(ClientModel client) {
    return _remoteDataSource.createClient(client);
  }

  @override
  Future<void> updateClient(ClientModel client) {
    return _remoteDataSource.updateClient(client);
  }

  @override
  Future<void> archiveClient(String id) {
    return _remoteDataSource.archiveClient(id);
  }
}
