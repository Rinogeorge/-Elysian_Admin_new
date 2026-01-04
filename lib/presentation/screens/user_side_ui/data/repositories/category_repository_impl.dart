import 'package:dartz/dartz.dart';
import 'package:elysian_admin/presentation/screens/user_side_ui/core/error/failures.dart';
import 'package:elysian_admin/presentation/screens/user_side_ui/data/datasources/category_remote_datasource.dart';
import 'package:elysian_admin/presentation/screens/user_side_ui/domain/entities/category_entity.dart';
import 'package:elysian_admin/presentation/screens/user_side_ui/domain/repositories/category_repository.dart';
import 'package:elysian_admin/presentation/screens/user_side_ui/domain/usecases/get_categories_usecase.dart';

class CategoryRepositoryImpl implements CategoryRepository {
  final CategoryRemoteDataSource remoteDataSource;

  CategoryRepositoryImpl({required this.remoteDataSource});

  @override
  Future<Either<Failure, List<CategoryEntity>>> getCategories(
    GetCategoriesParams params,
  ) async {
    try {
      final result = await remoteDataSource.getCategories(params);
      return Right(result);
    } catch (e) {
      return Left(ServerFailure(e.toString()));
    }
  }
}
