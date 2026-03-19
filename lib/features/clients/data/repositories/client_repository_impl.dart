import '../../domain/models/client_model.dart';
import '../../domain/repositories/client_repository.dart';
import '../datasources/client_remote_data_source.dart';

class ClientRepositoryImpl implements ClientRepository {
  ClientRepositoryImpl({required ClientRemoteDataSource remoteDataSource})
    : _remoteDataSource = remoteDataSource;

  final ClientRemoteDataSource _remoteDataSource;

  @override
  Future<List<ClientModel>> fetchClients() {
    return _remoteDataSource.fetchClients();
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
