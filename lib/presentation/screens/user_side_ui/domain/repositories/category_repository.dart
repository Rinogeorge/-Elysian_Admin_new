import 'package:dartz/dartz.dart';
import 'package:elysian_admin/presentation/screens/user_side_ui/core/error/failures.dart';
import 'package:elysian_admin/presentation/screens/user_side_ui/domain/entities/category_entity.dart';
import 'package:elysian_admin/presentation/screens/user_side_ui/domain/usecases/get_categories_usecase.dart';

abstract class CategoryRepository {
  Future<Either<Failure, List<CategoryEntity>>> getCategories(
    GetCategoriesParams params,
  );
}
