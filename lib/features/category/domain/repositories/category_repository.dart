import 'package:dartz/dartz.dart';
import 'package:elysian_admin/core/error/failures.dart';
import 'package:elysian_admin/features/category/domain/entities/category_entity.dart';
import 'package:elysian_admin/features/category/domain/usecases/add_category_usecase.dart';
import 'package:elysian_admin/features/category/domain/usecases/delete_category_usecase.dart';
import 'package:elysian_admin/features/category/domain/usecases/get_categories_usecase.dart';
import 'package:elysian_admin/features/category/domain/usecases/update_category_usecase.dart';

abstract class CategoryRepository {
  Future<Either<Failure, CategoryEntity>> addCategory(AddCategoryParams params);
  Future<Either<Failure, List<CategoryEntity>>> getCategories(
    GetCategoriesParams params,
  );
  Future<Either<Failure, void>> deleteCategory(DeleteCategoryParams params);
  Future<Either<Failure, void>> updateCategory(UpdateCategoryParams params);
}
