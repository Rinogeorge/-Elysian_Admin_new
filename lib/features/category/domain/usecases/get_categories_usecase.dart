import 'package:dartz/dartz.dart';
import 'package:elysian_admin/core/error/failures.dart';
import 'package:elysian_admin/core/usecases/usecase.dart';
import 'package:elysian_admin/features/category/domain/entities/category_entity.dart';
import 'package:elysian_admin/features/category/domain/repositories/category_repository.dart';
import 'package:equatable/equatable.dart';

class GetCategoriesUseCase
    implements UseCase<List<CategoryEntity>, GetCategoriesParams> {
  final CategoryRepository repository;

  GetCategoriesUseCase(this.repository);

  @override
  Future<Either<Failure, List<CategoryEntity>>> call(
    GetCategoriesParams params,
  ) async {
    return repository.getCategories(params);
  }
}

class GetCategoriesParams extends Equatable {
  final TravelType travelType;

  const GetCategoriesParams({required this.travelType});

  @override
  List<Object> get props => [travelType];
}
