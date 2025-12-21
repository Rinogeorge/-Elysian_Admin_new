import 'package:elysian_admin/features/auth/domain/entities/user_entity.dart'
    show UserEntity;

import 'package:equatable/equatable.dart';

abstract class ProfileState extends Equatable {
  const ProfileState();

  @override
  List<Object> get props => [];
}

class ProfileInitial extends ProfileState {}

class ProfileLoading extends ProfileState {}

class ProfileLoaded extends ProfileState {
  final UserEntity user;

  const ProfileLoaded(this.user);

  @override
  List<Object> get props => [user];
}

class ProfileError extends ProfileState {
  final String message;

  const ProfileError(this.message);

  @override
  List<Object> get props => [message];
}

class ProfileLoggingOut extends ProfileState {}

class ProfileLogoutSuccess extends ProfileState {}
