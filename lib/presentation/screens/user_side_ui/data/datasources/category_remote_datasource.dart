import 'package:cloud_firestore/cloud_firestore.dart';
// Note: Removed CloudinaryService import as it is not needed for GETTING categories.
import 'package:elysian_admin/presentation/screens/user_side_ui/domain/entities/category_entity.dart';
import 'package:elysian_admin/presentation/screens/user_side_ui/domain/usecases/get_categories_usecase.dart';

abstract class CategoryRemoteDataSource {
  Future<List<CategoryEntity>> getCategories(GetCategoriesParams params);
}

class CategoryRemoteDataSourceImpl implements CategoryRemoteDataSource {
  final FirebaseFirestore firebaseFirestore;

  // Removed CloudinaryService dependency since we only fetch here.
  CategoryRemoteDataSourceImpl({required this.firebaseFirestore});

  @override
  Future<List<CategoryEntity>> getCategories(GetCategoriesParams params) async {
    try {
      print(
        '[CategoryRemoteDataSource] Fetching categories for type: ${params.travelType.name}',
      );
      final snapshot =
          await firebaseFirestore
              .collection('categories')
              .where('travelType', isEqualTo: params.travelType.name)
              .get();

      print(
        '[CategoryRemoteDataSource] Found ${snapshot.docs.length} categories',
      );

      return snapshot.docs.map((doc) {
        final data = doc.data();
        return CategoryEntity(
          id: data['id'] ?? doc.id,
          name: data['name'] ?? '',
          imageUrl: data['imageUrl'] ?? '',
        );
      }).toList();
    } catch (e) {
      print('[CategoryRemoteDataSource] Error fetching categories: $e');
      throw Exception(e.toString());
    }
  }
}
