import 'package:flutter_bloc/flutter_bloc.dart';
import 'package:equatable/equatable.dart';
import '../domain/entities/category_entity.dart';
import '../domain/usecases/get_categories_usecase.dart';

part 'user_category_event.dart';
part 'user_category_state.dart';

class UserCategoryBloc extends Bloc<UserCategoryEvent, UserCategoryState> {
  final GetCategoriesUseCase getCategoriesUseCase;

  UserCategoryBloc({required this.getCategoriesUseCase})
    : super(UserCategoryInitial()) {
    on<LoadUserCategories>(_onLoadUserCategories);
  }

  Future<void> _onLoadUserCategories(
    LoadUserCategories event,
    Emitter<UserCategoryState> emit,
  ) async {
    emit(UserCategoryLoading());

    // Fetch Domestic
    final domesticResult = await getCategoriesUseCase(
      const GetCategoriesParams(travelType: TravelType.domestic),
    );

    // Fetch International
    final internationalResult = await getCategoriesUseCase(
      const GetCategoriesParams(travelType: TravelType.international),
    );

    List<CategoryEntity> allCategories = [];
    String? errorMessage;

    domesticResult.fold(
      (failure) => errorMessage = failure.message,
      (categories) => allCategories.addAll(categories),
    );

    if (errorMessage != null) {
      emit(UserCategoryError(message: errorMessage!));
      return;
    }

    internationalResult.fold(
      (failure) => errorMessage = failure.message,
      (categories) => allCategories.addAll(categories),
    );

    if (errorMessage != null) {
      emit(UserCategoryError(message: errorMessage!));
      return;
    }

    emit(UserCategoryLoaded(categories: allCategories));
  }
}
