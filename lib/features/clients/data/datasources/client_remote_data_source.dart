import '../../domain/models/client_model.dart';

abstract class ClientRemoteDataSource {
  Future<List<ClientModel>> fetchClients();
  Future<ClientModel?> getClientById(String id);
  Future<void> createClient(ClientModel client);
  Future<void> updateClient(ClientModel client);
  Future<void> archiveClient(String id);
}
