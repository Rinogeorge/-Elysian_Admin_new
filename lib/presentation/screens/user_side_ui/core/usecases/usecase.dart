import 'package:dartz/dartz.dart';
import 'package:elysian_admin/presentation/screens/user_side_ui/core/error/failures.dart';

abstract class UseCase<Type, Params> {
  Future<Either<Failure, Type>> call(Params params);
}

class NoParams {}
