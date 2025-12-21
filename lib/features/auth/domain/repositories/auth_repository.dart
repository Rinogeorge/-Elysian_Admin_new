import 'package:dartz/dartz.dart';
import 'package:elysian_admin/core/error/failures.dart';
import 'package:elysian_admin/features/auth/domain/entities/user_entity.dart';

abstract class AuthRepository {
  Future<Either<Failure, UserEntity>> login(String email, String password);
  Future<Either<Failure, UserEntity>> signup(
    String name,
    String email,
    String password,
  );
  Future<Either<Failure, UserEntity>> getCurrentUser();
  Future<Either<Failure, void>> logout();
  Future<Either<Failure, void>> forgotPassword(String email);
}
