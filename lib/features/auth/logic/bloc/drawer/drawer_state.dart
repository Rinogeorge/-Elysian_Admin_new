import 'package:elysian_admin/features/auth/domain/entities/user_entity.dart';
import 'package:equatable/equatable.dart';

abstract class DrawerState extends Equatable {
  const DrawerState();

  @override
  List<Object> get props => [];
}

class DrawerInitial extends DrawerState {}

class DrawerLoading extends DrawerState {}

class DrawerLoaded extends DrawerState {
  final UserEntity user;

  const DrawerLoaded(this.user);

  @override
  List<Object> get props => [user];
}

class DrawerError extends DrawerState {
  final String message;

  const DrawerError(this.message);

  @override
  List<Object> get props => [message];
}

class DrawerLoggingOut extends DrawerState {}

class DrawerLogoutSuccess extends DrawerState {}

class DrawerDeletingAccount extends DrawerState {}

class DrawerDeleteAccountSuccess extends DrawerState {}

