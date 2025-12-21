import 'package:elysian_admin/core/usecases/usecase.dart';
import 'package:elysian_admin/features/auth/domain/usecases/get_current_user_usecase.dart';
import 'package:elysian_admin/features/auth/domain/usecases/logout_usecase.dart';
import 'package:flutter_bloc/flutter_bloc.dart';
import 'drawer_event.dart';
import 'drawer_state.dart';

class DrawerBloc extends Bloc<DrawerEvent, DrawerState> {
  final GetCurrentUserUseCase getCurrentUserUseCase;
  final LogoutUseCase logoutUseCase;

  DrawerBloc({
    required this.getCurrentUserUseCase,
    required this.logoutUseCase,
  }) : super(DrawerInitial()) {
    on<LoadDrawerUser>(_onLoadDrawerUser);
    on<DrawerLogoutRequested>(_onDrawerLogoutRequested);
    on<DrawerDeleteAccountRequested>(_onDrawerDeleteAccountRequested);
  }

  Future<void> _onLoadDrawerUser(
    LoadDrawerUser event,
    Emitter<DrawerState> emit,
  ) async {
    emit(DrawerLoading());
    final result = await getCurrentUserUseCase(NoParams());
    result.fold(
      (failure) => emit(DrawerError(failure.message)),
      (user) => emit(DrawerLoaded(user)),
    );
  }

  Future<void> _onDrawerLogoutRequested(
    DrawerLogoutRequested event,
    Emitter<DrawerState> emit,
  ) async {
    emit(DrawerLoggingOut());
    final result = await logoutUseCase(NoParams());
    result.fold(
      (failure) => emit(DrawerError(failure.message)),
      (_) => emit(DrawerLogoutSuccess()),
    );
  }

  Future<void> _onDrawerDeleteAccountRequested(
    DrawerDeleteAccountRequested event,
    Emitter<DrawerState> emit,
  ) async {
    emit(DrawerDeletingAccount());
    // TODO: Implement delete account use case
    // For now, emit error as placeholder
    emit(const DrawerError('Delete account functionality not yet implemented'));
  }
}

