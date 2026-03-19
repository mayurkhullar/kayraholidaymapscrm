import '../models/company_model.dart';

abstract class CompanyRepository {
  Future<List<CompanyModel>> fetchCompanies();
  Future<CompanyModel?> getCompanyById(String id);
  Future<void> createCompany(CompanyModel company);
  Future<void> updateCompany(CompanyModel company);
  Future<void> archiveCompany(String id);
}
