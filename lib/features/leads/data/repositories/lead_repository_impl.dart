import '../../domain/models/lead_model.dart';
import '../../domain/repositories/lead_repository.dart';
import '../datasources/lead_remote_data_source.dart';

class LeadRepositoryImpl implements LeadRepository {
  LeadRepositoryImpl({required LeadRemoteDataSource remoteDataSource})
    : _remoteDataSource = remoteDataSource;

  final LeadRemoteDataSource _remoteDataSource;

  @override
  Future<List<LeadModel>> fetchLeads() {
    return _remoteDataSource.fetchLeads();
  }

  @override
  Future<LeadModel?> getLeadById(String id) {
    return _remoteDataSource.getLeadById(id);
  }

  @override
  Future<void> createLead(LeadModel lead) {
    return _remoteDataSource.createLead(lead);
  }

  @override
  Future<void> updateLead(LeadModel lead) {
    return _remoteDataSource.updateLead(lead);
  }

  @override
  Future<void> archiveLead(String id) {
    return _remoteDataSource.archiveLead(id);
  }
}
