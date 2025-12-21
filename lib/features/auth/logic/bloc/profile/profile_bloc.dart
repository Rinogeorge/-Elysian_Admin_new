import 'package:elysian_admin/core/usecases/usecase.dart';
import 'package:elysian_admin/features/auth/domain/usecases/get_current_user_usecase.dart';
import 'package:elysian_admin/features/auth/domain/usecases/logout_usecase.dart';
import 'package:flutter_bloc/flutter_bloc.dart';
import 'profile_event.dart';
import 'profile_state.dart';

class ProfileBloc extends Bloc<ProfileEvent, ProfileState> {
  final GetCurrentUserUseCase getCurrentUserUseCase;
  final LogoutUseCase logoutUseCase;

  ProfileBloc({
    required this.getCurrentUserUseCase,
    required this.logoutUseCase,
  }) : super(ProfileInitial()) {
    on<LoadProfile>(_onLoadProfile);
    on<LogoutRequested>(_onLogoutRequested);
  }

  Future<void> _onLoadProfile(
    LoadProfile event,
    Emitter<ProfileState> emit,
  ) async {
    emit(ProfileLoading());
    final result = await getCurrentUserUseCase(NoParams());
    result.fold(
      (failure) => emit(ProfileError(failure.message)),
      (user) => emit(ProfileLoaded(user)),
    );
  }

  Future<void> _onLogoutRequested(
    LogoutRequested event,
    Emitter<ProfileState> emit,
  ) async {
    emit(ProfileLoggingOut());
    final result = await logoutUseCase(NoParams());
    result.fold(
      (failure) => emit(ProfileError(failure.message)),
      (_) => emit(ProfileLogoutSuccess()),
    );
  }
}
