import 'package:dartz/dartz.dart';
import 'package:elysian_admin/core/error/failures.dart';
import 'package:elysian_admin/core/usecases/usecase.dart';
import 'package:elysian_admin/features/auth/domain/entities/user_entity.dart';
import 'package:elysian_admin/features/auth/domain/repositories/auth_repository.dart';
import 'package:equatable/equatable.dart';

class SignupUseCase implements UseCase<UserEntity, SignupParams> {
  final AuthRepository repository;

  SignupUseCase(this.repository);

  @override
  Future<Either<Failure, UserEntity>> call(SignupParams params) async {
    return await repository.signup(params.name, params.email, params.password);
  }
}

class SignupParams extends Equatable {
  final String name;
  final String email;
  final String password;

  const SignupParams({
    required this.name,
    required this.email,
    required this.password,
  });

  @override
  List<Object> get props => [name, email, password];
}
