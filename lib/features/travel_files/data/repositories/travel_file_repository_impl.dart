import '../../../travelers/domain/models/traveler_model.dart';
import '../../domain/models/travel_file_model.dart';
import '../../domain/repositories/travel_file_repository.dart';
import '../datasources/travel_file_remote_data_source.dart';

class TravelFileRepositoryImpl implements TravelFileRepository {
  TravelFileRepositoryImpl({required TravelFileRemoteDataSource remoteDataSource})
      : _remoteDataSource = remoteDataSource;

  final TravelFileRemoteDataSource _remoteDataSource;

  @override
  Future<List<TravelFileModel>> fetchTravelFiles() {
    return _remoteDataSource.fetchTravelFiles();
  }

  @override
  Future<TravelFileModel?> getTravelFileById(String id) {
    return _remoteDataSource.getTravelFileById(id);
  }

  @override
  Future<TravelFileModel?> getTravelFileByLeadId(String leadId) {
    return _remoteDataSource.getTravelFileByLeadId(leadId);
  }

  @override
  Future<TravelFileModel> createTravelFile(TravelFileModel travelFile) {
    return _remoteDataSource.createTravelFile(travelFile);
  }

  @override
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
  }) {
    return _remoteDataSource.ensureTravelFileForConfirmedLead(
      leadId: leadId,
      clientId: clientId,
      clientNameSnapshot: clientNameSnapshot,
      destination: destination,
      travelType: travelType,
      tripScope: tripScope,
      leadStage: leadStage,
      startDate: startDate,
      endDate: endDate,
      adultCount: adultCount,
      childCount: childCount,
      infantCount: infantCount,
      totalPax: totalPax,
      notes: notes,
    );
  }

  @override
  Future<List<TravelerModel>> fetchTravelersByLeadId(String leadId) {
    return _remoteDataSource.fetchTravelersByLeadId(leadId);
  }
}
