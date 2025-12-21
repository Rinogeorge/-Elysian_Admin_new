import 'package:cloud_firestore/cloud_firestore.dart';
import 'package:elysian_admin/core/services/cloudinary_service.dart';
import 'package:elysian_admin/features/category/domain/entities/category_entity.dart';
import 'package:elysian_admin/features/category/domain/usecases/add_category_usecase.dart';
import 'package:elysian_admin/features/category/domain/usecases/delete_category_usecase.dart';
import 'package:elysian_admin/features/category/domain/usecases/get_categories_usecase.dart';
import 'package:elysian_admin/features/category/domain/usecases/update_category_usecase.dart';

abstract class CategoryRemoteDataSource {
  Future<CategoryEntity> addCategory(AddCategoryParams params);
  Future<List<CategoryEntity>> getCategories(GetCategoriesParams params);
  Future<void> deleteCategory(DeleteCategoryParams params);
  Future<void> updateCategory(UpdateCategoryParams params);
}

class CategoryRemoteDataSourceImpl implements CategoryRemoteDataSource {
  final FirebaseFirestore firebaseFirestore;
  final CloudinaryService cloudinaryService;

  CategoryRemoteDataSourceImpl({
    required this.firebaseFirestore,
    required this.cloudinaryService,
  });

  @override
  Future<CategoryEntity> addCategory(AddCategoryParams params) async {
    try {
      print('[CategoryRemoteDataSource] Adding category: ${params.name}');

      // Upload image to Cloudinary
      final imageUrl = await cloudinaryService.uploadImage(
        imagePath: params.imagePath,
        folder: 'categories',
      );
      print('[CategoryRemoteDataSource] Image uploaded: $imageUrl');

      final categoryId = firebaseFirestore.collection('categories').doc().id;
      final categoryData = {
        'id': categoryId,
        'name': params.name,
        'imageUrl': imageUrl,
        'travelType':
            params.travelType.name, // Store enum name (domestic/international)
        'createdAt': FieldValue.serverTimestamp(),
      };

      await firebaseFirestore
          .collection('categories')
          .doc(categoryId)
          .set(categoryData);

      print(
        '[CategoryRemoteDataSource] Category added to Firestore with ID: $categoryId',
      );

      return CategoryEntity(
        id: categoryId,
        name: params.name,
        imageUrl: imageUrl,
      );
    } catch (e) {
      print('[CategoryRemoteDataSource] Error adding category: $e');
      throw Exception(e.toString());
    }
  }

  @override
  Future<void> deleteCategory(DeleteCategoryParams params) async {
    try {
      print(
        '[CategoryRemoteDataSource] Deleting category: ${params.categoryId}',
      );
      await firebaseFirestore
          .collection('categories')
          .doc(params.categoryId)
          .delete();
      print('[CategoryRemoteDataSource] Category deleted successfully');
    } catch (e) {
      print('[CategoryRemoteDataSource] Error deleting category: $e');
      throw Exception(e.toString());
    }
  }

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

  @override
  Future<void> updateCategory(UpdateCategoryParams params) async {
    try {
      print(
        '[CategoryRemoteDataSource] Updating category: ${params.categoryId}',
      );
      final Map<String, dynamic> updates = {};

      if (params.name != null) {
        updates['name'] = params.name;
      }

      if (params.travelType != null) {
        updates['travelType'] = params.travelType!.name;
      }

      if (params.imagePath != null && params.imagePath!.isNotEmpty) {
        final imageUrl = await cloudinaryService.uploadImage(
          imagePath: params.imagePath!,
          folder: 'categories',
        );
        updates['imageUrl'] = imageUrl;
      }

      if (updates.isNotEmpty) {
        await firebaseFirestore
            .collection('categories')
            .doc(params.categoryId)
            .update(updates);
        print('[CategoryRemoteDataSource] Category updated successfully');
      }
    } catch (e) {
      print('[CategoryRemoteDataSource] Error updating category: $e');
      throw Exception(e.toString());
    }
  }
}
