import 'package:elysian_admin/features/auth/domain/usecases/forgot_password_usecase.dart';

import 'package:flutter_bloc/flutter_bloc.dart';
import 'forgot_password_event.dart';
import 'forgot_password_state.dart';

class ForgotPasswordBloc
    extends Bloc<ForgotPasswordEvent, ForgotPasswordState> {
  final ForgotPasswordUseCase forgotPasswordUseCase;

  ForgotPasswordBloc({required this.forgotPasswordUseCase})
    : super(ForgotPasswordInitial()) {
    on<ForgotPasswordSubmitted>(_onForgotPasswordSubmitted);
  }

  Future<void> _onForgotPasswordSubmitted(
    ForgotPasswordSubmitted event,
    Emitter<ForgotPasswordState> emit,
  ) async {
    emit(ForgotPasswordLoading());
    final result = await forgotPasswordUseCase(
      ForgotPasswordParams(email: event.email),
    );
    result.fold(
      (failure) => emit(ForgotPasswordFailure(failure.message)),
      (_) => emit(
        const ForgotPasswordSuccess(
          'Password reset email has been sent. Please check your inbox.',
        ),
      ),
    );
  }
}
