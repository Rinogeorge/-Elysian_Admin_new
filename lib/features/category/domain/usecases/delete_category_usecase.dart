import 'package:dartz/dartz.dart';
import 'package:elysian_admin/core/error/failures.dart';
import 'package:elysian_admin/core/usecases/usecase.dart';
import 'package:elysian_admin/features/category/domain/repositories/category_repository.dart';
import 'package:equatable/equatable.dart';

class DeleteCategoryUseCase implements UseCase<void, DeleteCategoryParams> {
  final CategoryRepository repository;

  DeleteCategoryUseCase(this.repository);

  @override
  Future<Either<Failure, void>> call(DeleteCategoryParams params) async {
    return repository.deleteCategory(params);
  }
}

class DeleteCategoryParams extends Equatable {
  final String categoryId;

  const DeleteCategoryParams({required this.categoryId});

  @override
  List<Object> get props => [categoryId];
}
