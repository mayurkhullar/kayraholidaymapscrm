import '../../../travelers/domain/models/traveler_model.dart';
import '../models/travel_file_model.dart';

abstract class TravelFileRepository {
  Future<List<TravelFileModel>> fetchTravelFiles();

  Future<TravelFileModel?> getTravelFileById(String id);

  Future<TravelFileModel?> getTravelFileByLeadId(String leadId);

  Future<TravelFileModel> createTravelFile(TravelFileModel travelFile);

  Future<TravelFileModel?> ensureTravelFileForConfirmedLead({
    required String leadId,
    required String clientId,
    required String clientNameSnapshot,
    required String destination,
    required String travelType,
    String? tripScope,
    required String leadStage,
    DateTime? startDate,
    DateTime? endDate,
    required int adultCount,
    required int childCount,
    required int infantCount,
    required int totalPax,
    String? notes,
  });

  Future<List<TravelerModel>> fetchTravelersByLeadId(String leadId);
}
