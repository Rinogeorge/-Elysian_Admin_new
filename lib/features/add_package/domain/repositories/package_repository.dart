import 'package:elysian_admin/features/add_package/data/models/package_model.dart';

abstract class PackageRepository {
  Future<void> addPackage(Map<String, dynamic> packageData);
  Future<List<PackageModel>> getPackages({required String type});
  Future<void> deletePackage({required String id, required String type});
  Future<void> updatePackage({
    required String id,
    required Map<String, dynamic> packageData,
  });
}
