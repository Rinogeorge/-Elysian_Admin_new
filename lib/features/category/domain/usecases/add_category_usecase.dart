import 'package:dartz/dartz.dart';
import 'package:elysian_admin/core/error/failures.dart';
import 'package:elysian_admin/core/usecases/usecase.dart';
import 'package:elysian_admin/features/category/domain/entities/category_entity.dart';
import 'package:elysian_admin/features/category/domain/repositories/category_repository.dart';
import 'package:equatable/equatable.dart';

class AddCategoryUseCase implements UseCase<CategoryEntity, AddCategoryParams> {
  final CategoryRepository repository;

  AddCategoryUseCase(this.repository);

  @override
  Future<Either<Failure, CategoryEntity>> call(AddCategoryParams params) async {
    return repository.addCategory(params);
  }
}

class AddCategoryParams extends Equatable {
  final String name;
  final String imagePath;
  final TravelType travelType;

  const AddCategoryParams({
    required this.name,
    required this.imagePath,
    required this.travelType,
  });

  @override
  List<Object> get props => [name, imagePath, travelType];
}
