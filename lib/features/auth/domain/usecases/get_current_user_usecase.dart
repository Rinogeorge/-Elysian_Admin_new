import 'package:dartz/dartz.dart';
import 'package:elysian_admin/core/error/failures.dart';
import 'package:elysian_admin/core/usecases/usecase.dart';
import 'package:elysian_admin/features/auth/domain/entities/user_entity.dart';
import 'package:elysian_admin/features/auth/domain/repositories/auth_repository.dart';

class GetCurrentUserUseCase implements UseCase<UserEntity, NoParams> {
  final AuthRepository repository;

  GetCurrentUserUseCase(this.repository);

  @override
  Future<Either<Failure, UserEntity>> call(NoParams params) async {
    return await repository.getCurrentUser();
  }
}
