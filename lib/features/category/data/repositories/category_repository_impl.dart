import 'package:dartz/dartz.dart';
import 'package:elysian_admin/core/error/failures.dart';
import 'package:elysian_admin/features/category/data/datasources/category_remote_datasource.dart';
import 'package:elysian_admin/features/category/domain/entities/category_entity.dart';
import 'package:elysian_admin/features/category/domain/repositories/category_repository.dart';
import 'package:elysian_admin/features/category/domain/usecases/add_category_usecase.dart';
import 'package:elysian_admin/features/category/domain/usecases/delete_category_usecase.dart';
import 'package:elysian_admin/features/category/domain/usecases/get_categories_usecase.dart';
import 'package:elysian_admin/features/category/domain/usecases/update_category_usecase.dart';

class CategoryRepositoryImpl implements CategoryRepository {
  final CategoryRemoteDataSource remoteDataSource;

  CategoryRepositoryImpl({required this.remoteDataSource});

  @override
  Future<Either<Failure, CategoryEntity>> addCategory(
    AddCategoryParams params,
  ) async {
    try {
      final result = await remoteDataSource.addCategory(params);
      return Right(result);
    } catch (e) {
      // Return proper failure
      return Left(ServerFailure(e.toString()));
    }
  }

  @override
  Future<Either<Failure, void>> deleteCategory(
    DeleteCategoryParams params,
  ) async {
    try {
      await remoteDataSource.deleteCategory(params);
      return const Right(null);
    } catch (e) {
      return Left(ServerFailure(e.toString()));
    }
  }

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

  @override
  Future<Either<Failure, void>> updateCategory(
    UpdateCategoryParams params,
  ) async {
    try {
      await remoteDataSource.updateCategory(params);
      return const Right(null);
    } catch (e) {
      return Left(ServerFailure(e.toString()));
    }
  }
}
