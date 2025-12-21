import 'package:elysian_admin/core/usecases/usecase.dart';
import 'package:elysian_admin/features/auth/domain/usecases/signup_usecase.dart';
import 'package:flutter_bloc/flutter_bloc.dart';
import 'signup_event.dart';
import 'signup_state.dart';

class SignupBloc extends Bloc<SignupEvent, SignupState> {
  final SignupUseCase signupUseCase;

  SignupBloc({required this.signupUseCase}) : super(SignupInitial()) {
    on<SignupSubmitted>(_onSignupSubmitted);
  }

  Future<void> _onSignupSubmitted(
    SignupSubmitted event,
    Emitter<SignupState> emit,
  ) async {
    emit(SignupLoading());
    final result = await signupUseCase(
      SignupParams(
        name: event.name,
        email: event.email,
        password: event.password,
      ),
    );
    result.fold(
      (failure) => emit(SignupFailure(failure.message)),
      (user) => emit(SignupSuccess(user)),
    );
  }
}
