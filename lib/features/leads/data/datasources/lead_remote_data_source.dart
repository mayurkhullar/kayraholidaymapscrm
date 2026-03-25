import '../../domain/models/lead_model.dart';
import '../../domain/models/lead_note_model.dart';

abstract class LeadRemoteDataSource {
  Future<List<LeadModel>> fetchLeads();
  Future<List<LeadModel>> fetchLeadsByClientId(String clientId);
  Future<LeadModel?> getLeadById(String id);
  Future<void> createLead(LeadModel lead);
  Future<void> updateLead(LeadModel lead);
  Future<void> archiveLead(String id);
  Future<List<LeadNoteModel>> fetchLeadNotes(String leadId);
  Future<void> addLeadNote(LeadNoteModel note);
}
