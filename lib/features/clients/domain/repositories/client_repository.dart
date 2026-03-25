import '../models/client_model.dart';

class ClientActivitySummary {
  const ClientActivitySummary({
    required this.client,
    required this.totalLeads,
    required this.latestActivityDate,
  });

  final ClientModel client;
  final int totalLeads;
  final DateTime? latestActivityDate;
}

abstract class ClientRepository {
  Future<List<ClientModel>> fetchClients();
  Future<List<ClientActivitySummary>> fetchClientsWithActivitySummaries();
  Future<ClientModel?> getClientById(String id);
  Future<void> createClient(ClientModel client);
  Future<void> updateClient(ClientModel client);
  Future<void> archiveClient(String id);
}
