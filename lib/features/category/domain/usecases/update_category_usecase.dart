import 'package:dartz/dartz.dart';
import 'package:elysian_admin/core/error/failures.dart';
import 'package:elysian_admin/core/usecases/usecase.dart';
import 'package:elysian_admin/features/category/domain/entities/category_entity.dart';
import 'package:elysian_admin/features/category/domain/repositories/category_repository.dart';
import 'package:equatable/equatable.dart';

class UpdateCategoryUseCase implements UseCase<void, UpdateCategoryParams> {
  final CategoryRepository repository;

  UpdateCategoryUseCase(this.repository);

  @override
  Future<Either<Failure, void>> call(UpdateCategoryParams params) async {
    return repository.updateCategory(params);
  }
}

class UpdateCategoryParams extends Equatable {
  final String categoryId;
  final String? name;
  final String? imagePath;
  final TravelType? travelType;

  const UpdateCategoryParams({
    required this.categoryId,
    this.name,
    this.imagePath,
    this.travelType,
  });

  @override
  List<Object?> get props => [categoryId, name, imagePath, travelType];
}
