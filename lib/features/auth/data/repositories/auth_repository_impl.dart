import 'package:dartz/dartz.dart';
import 'package:elysian_admin/core/error/failures.dart';
import 'package:elysian_admin/features/auth/data/datasources/auth_remote_datasource.dart';
import 'package:elysian_admin/features/auth/domain/entities/user_entity.dart';
import 'package:elysian_admin/features/auth/domain/repositories/auth_repository.dart';
import 'package:firebase_auth/firebase_auth.dart';

class AuthRepositoryImpl implements AuthRepository {
  final AuthRemoteDataSource remoteDataSource;

  AuthRepositoryImpl({required this.remoteDataSource});

  @override
  Future<Either<Failure, UserEntity>> login(
    String email,
    String password,
  ) async {
    try {
      final user = await remoteDataSource.login(email, password);
      return Right(user);
    } on FirebaseAuthException catch (e) {
      String errorMessage = 'Authentication failed';
      switch (e.code) {
        case 'user-not-found':
          errorMessage = 'No account found with this email address.';
          break;
        case 'wrong-password':
          errorMessage = 'Incorrect password. Please try again.';
          break;
        case 'invalid-email':
          errorMessage = 'Invalid email address.';
          break;
        case 'user-disabled':
          errorMessage = 'This account has been disabled.';
          break;
        case 'too-many-requests':
          errorMessage = 'Too many failed attempts. Please try again later.';
          break;
        case 'invalid-credential':
          errorMessage =
              'Invalid email or password. Please check your credentials.';
          break;
        default:
          errorMessage =
              e.message ?? 'Authentication failed. Please try again.';
      }
      return Left(ServerFailure(errorMessage));
    } catch (e) {
      return Left(ServerFailure(e.toString()));
    }
  }

  @override
  Future<Either<Failure, UserEntity>> signup(
    String name,
    String email,
    String password,
  ) async {
    try {
      final user = await remoteDataSource.signup(name, email, password);
      return Right(user);
    } on FirebaseAuthException catch (e) {
      String errorMessage = 'Signup failed';
      switch (e.code) {
        case 'email-already-in-use':
          errorMessage = 'An account already exists with this email address.';
          break;
        case 'invalid-email':
          errorMessage = 'Invalid email address.';
          break;
        case 'weak-password':
          errorMessage =
              'Password is too weak. Please use a stronger password.';
          break;
        case 'operation-not-allowed':
          errorMessage = 'Email/password accounts are not enabled.';
          break;
        default:
          errorMessage = e.message ?? 'Signup failed. Please try again.';
      }
      return Left(ServerFailure(errorMessage));
    } catch (e) {
      return Left(ServerFailure(e.toString()));
    }
  }

  @override
  Future<Either<Failure, UserEntity>> getCurrentUser() async {
    try {
      final user = await remoteDataSource.getCurrentUser();
      return Right(user);
    } on Exception catch (e) {
      return Left(ServerFailure(e.toString()));
    } catch (e) {
      return Left(ServerFailure(e.toString()));
    }
  }

  @override
  Future<Either<Failure, void>> logout() async {
    try {
      await remoteDataSource.logout();
      return const Right(null);
    } catch (e) {
      return Left(ServerFailure(e.toString()));
    }
  }

  @override
  Future<Either<Failure, void>> forgotPassword(String email) async {
    try {
      await remoteDataSource.forgotPassword(email);
      return const Right(null);
    } on FirebaseAuthException catch (e) {
      String errorMessage = 'Password reset failed';
      switch (e.code) {
        case 'user-not-found':
          errorMessage = 'No account found with this email address.';
          break;
        case 'invalid-email':
          errorMessage = 'Invalid email address.';
          break;
        case 'user-disabled':
          errorMessage = 'This account has been disabled.';
          break;
        default:
          errorMessage =
              e.message ?? 'Password reset failed. Please try again.';
      }
      return Left(ServerFailure(errorMessage));
    } catch (e) {
      return Left(ServerFailure(e.toString()));
    }
  }
}
