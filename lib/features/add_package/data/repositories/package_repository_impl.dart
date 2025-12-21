import 'package:cloud_firestore/cloud_firestore.dart';
import 'package:elysian_admin/features/add_package/domain/repositories/package_repository.dart';
import 'package:elysian_admin/features/add_package/data/models/package_model.dart';

class PackageRepositoryImpl implements PackageRepository {
  final FirebaseFirestore _firestore;

  PackageRepositoryImpl({FirebaseFirestore? firestore})
    : _firestore = firestore ?? FirebaseFirestore.instance;

  @override
  Future<void> addPackage(Map<String, dynamic> packageData) async {
    try {
      final collectionName =
          packageData['type'] == 'International'
              ? 'international_packages'
              : 'domestic_packages';

      await _firestore.collection(collectionName).add(packageData);
    } catch (e) {
      throw Exception('Failed to add package to Firestore: $e');
    }
  }

  @override
  Future<List<PackageModel>> getPackages({required String type}) async {
    try {
      final collectionName =
          type == 'International'
              ? 'international_packages'
              : 'domestic_packages';

      final querySnapshot = await _firestore.collection(collectionName).get();

      return querySnapshot.docs.map((doc) {
        return PackageModel.fromJson(doc.data(), doc.id);
      }).toList();
    } catch (e) {
      throw Exception('Failed to fetch packages from Firestore: $e');
    }
  }

  @override
  Future<void> deletePackage({required String id, required String type}) async {
    try {
      final collectionName =
          type == 'International'
              ? 'international_packages'
              : 'domestic_packages';

      await _firestore.collection(collectionName).doc(id).delete();
    } catch (e) {
      throw Exception('Failed to delete package from Firestore: $e');
    }
  }

  @override
  Future<void> updatePackage({
    required String id,
    required Map<String, dynamic> packageData,
  }) async {
    try {
      final collectionName =
          packageData['type'] == 'International'
              ? 'international_packages'
              : 'domestic_packages';

      await _firestore.collection(collectionName).doc(id).update(packageData);
    } catch (e) {
      throw Exception('Failed to update package in Firestore: $e');
    }
  }
}
