import '../../domain/models/company_model.dart';
import '../../domain/repositories/company_repository.dart';
import '../datasources/company_remote_data_source.dart';

class CompanyRepositoryImpl implements CompanyRepository {
  CompanyRepositoryImpl({required CompanyRemoteDataSource remoteDataSource})
    : _remoteDataSource = remoteDataSource;

  final CompanyRemoteDataSource _remoteDataSource;

  @override
  Future<List<CompanyModel>> fetchCompanies() {
    return _remoteDataSource.fetchCompanies();
  }

  @override
  Future<CompanyModel?> getCompanyById(String id) {
    return _remoteDataSource.getCompanyById(id);
  }

  @override
  Future<void> createCompany(CompanyModel company) {
    return _remoteDataSource.createCompany(company);
  }

  @override
  Future<void> updateCompany(CompanyModel company) {
    return _remoteDataSource.updateCompany(company);
  }

  @override
  Future<void> archiveCompany(String id) {
    return _remoteDataSource.archiveCompany(id);
  }
}
