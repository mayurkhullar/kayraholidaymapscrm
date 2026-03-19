import 'package:cloud_firestore/cloud_firestore.dart';

import '../../../../core/constants/firestore_collections.dart';
import '../../domain/models/company_model.dart';
import 'company_remote_data_source.dart';

class FirestoreCompanyRemoteDataSource implements CompanyRemoteDataSource {
  FirestoreCompanyRemoteDataSource({required FirebaseFirestore firestore})
    : _firestore = firestore;

  final FirebaseFirestore _firestore;

  CollectionReference<Map<String, dynamic>> get _companiesCollection =>
      _firestore.collection(FirestoreCollections.companies);

  @override
  Future<List<CompanyModel>> fetchCompanies() async {
    final querySnapshot = await _companiesCollection
        .where('isArchived', isEqualTo: false)
        .get();

    return querySnapshot.docs
        .map((doc) => CompanyModel.fromMap(<String, dynamic>{
              ...doc.data(),
              'id': doc.id,
            }))
        .toList(growable: false);
  }

  @override
  Future<CompanyModel?> getCompanyById(String id) async {
    final documentSnapshot = await _companiesCollection.doc(id).get();

    if (!documentSnapshot.exists) {
      return null;
    }

    final data = documentSnapshot.data();
    if (data == null) {
      return null;
    }

    return CompanyModel.fromMap(<String, dynamic>{
      ...data,
      'id': documentSnapshot.id,
    });
  }

  @override
  Future<void> createCompany(CompanyModel company) async {
    final documentReference = company.id.isEmpty
        ? _companiesCollection.doc()
        : _companiesCollection.doc(company.id);
    final companyToCreate = company.id.isEmpty
        ? company.copyWith(id: documentReference.id)
        : company;

    await documentReference.set(companyToCreate.toMap());
  }

  @override
  Future<void> updateCompany(CompanyModel company) {
    return _companiesCollection.doc(company.id).update(company.toMap());
  }

  @override
  Future<void> archiveCompany(String id) {
    return _companiesCollection.doc(id).update(<String, dynamic>{
      'isArchived': true,
      'archivedAt': DateTime.now(),
    });
  }
}
