import 'package:dartz/dartz.dart';
import 'package:elysian_admin/core/error/failures.dart';
import 'package:elysian_admin/core/usecases/usecase.dart';
import 'package:elysian_admin/features/auth/domain/repositories/auth_repository.dart';
import 'package:equatable/equatable.dart';

class ForgotPasswordUseCase implements UseCase<void, ForgotPasswordParams> {
  final AuthRepository repository;

  ForgotPasswordUseCase(this.repository);

  @override
  Future<Either<Failure, void>> call(ForgotPasswordParams params) async {
    return await repository.forgotPassword(params.email);
  }
}

class ForgotPasswordParams extends Equatable {
  final String email;

  const ForgotPasswordParams({required this.email});

  @override
  List<Object> get props => [email];
}
