import '../../domain/models/lead_model.dart';

abstract class LeadRemoteDataSource {
  Future<List<LeadModel>> fetchLeads();
  Future<LeadModel?> getLeadById(String id);
  Future<void> createLead(LeadModel lead);
  Future<void> updateLead(LeadModel lead);
  Future<void> archiveLead(String id);
}
