import '../../domain/models/traveler_model.dart';
import '../../domain/repositories/traveler_repository.dart';
import '../datasources/traveler_remote_data_source.dart';

class TravelerRepositoryImpl implements TravelerRepository {
  TravelerRepositoryImpl({required TravelerRemoteDataSource remoteDataSource})
    : _remoteDataSource = remoteDataSource;

  final TravelerRemoteDataSource _remoteDataSource;

  @override
  Future<List<TravelerModel>> fetchTravelers() {
    return _remoteDataSource.fetchTravelers();
  }

  @override
  Future<TravelerModel?> getTravelerById(String id) {
    return _remoteDataSource.getTravelerById(id);
  }

  @override
  Future<void> createTraveler(TravelerModel traveler) {
    return _remoteDataSource.createTraveler(traveler);
  }

  @override
  Future<void> updateTraveler(TravelerModel traveler) {
    return _remoteDataSource.updateTraveler(traveler);
  }

  @override
  Future<void> archiveTraveler(String id) {
    return _remoteDataSource.archiveTraveler(id);
  }
}
