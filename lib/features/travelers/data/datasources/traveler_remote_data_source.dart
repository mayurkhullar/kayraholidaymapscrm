import '../../domain/models/traveler_model.dart';

abstract class TravelerRemoteDataSource {
  Future<List<TravelerModel>> fetchTravelers();
  Future<TravelerModel?> getTravelerById(String id);
  Future<void> createTraveler(TravelerModel traveler);
  Future<void> updateTraveler(TravelerModel traveler);
  Future<void> archiveTraveler(String id);
}
