import 'package:equatable/equatable.dart';

abstract class ForgotPasswordState extends Equatable {
  const ForgotPasswordState();

  @override
  List<Object> get props => [];
}

class ForgotPasswordInitial extends ForgotPasswordState {}

class ForgotPasswordLoading extends ForgotPasswordState {}

class ForgotPasswordSuccess extends ForgotPasswordState {
  final String message;

  const ForgotPasswordSuccess(this.message);

  @override
  List<Object> get props => [message];
}

class ForgotPasswordFailure extends ForgotPasswordState {
  final String message;

  const ForgotPasswordFailure(this.message);

  @override
  List<Object> get props => [message];
}
