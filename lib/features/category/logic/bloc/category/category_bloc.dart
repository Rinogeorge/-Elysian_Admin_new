import 'package:elysian_admin/features/category/domain/entities/category_entity.dart';
import 'package:elysian_admin/features/category/domain/usecases/add_category_usecase.dart';
import 'package:elysian_admin/features/category/domain/usecases/delete_category_usecase.dart';
import 'package:elysian_admin/features/category/domain/usecases/get_categories_usecase.dart';
import 'package:elysian_admin/features/category/domain/usecases/update_category_usecase.dart';
import 'package:elysian_admin/features/category/logic/bloc/category/category_event.dart';
import 'package:elysian_admin/features/category/logic/bloc/category/category_state.dart';
import 'package:flutter_bloc/flutter_bloc.dart';

class CategoryBloc extends Bloc<CategoryEvent, CategoryState> {
  final AddCategoryUseCase addCategoryUseCase;
  final GetCategoriesUseCase getCategoriesUseCase;
  final DeleteCategoryUseCase deleteCategoryUseCase;
  final UpdateCategoryUseCase updateCategoryUseCase;

  CategoryBloc({
    required this.addCategoryUseCase,
    required this.getCategoriesUseCase,
    required this.deleteCategoryUseCase,
    required this.updateCategoryUseCase,
  }) : super(const CategoryInitial(selectedTravelType: TravelType.domestic)) {
    on<LoadCategories>(_onLoadCategories);
    on<AddCategory>(_onAddCategory);
    on<DeleteCategory>(_onDeleteCategory);
    on<UpdateCategory>(_onUpdateCategory);
    on<ChangeTravelType>(_onChangeTravelType);
    on<SelectCategory>(_onSelectCategory);
    on<ClearImageSelection>(_onClearImageSelection);
    on<SetImagePath>(_onSetImagePath);
  }

  Future<void> _onLoadCategories(
    LoadCategories event,
    Emitter<CategoryState> emit,
  ) async {
    emit(CategoryLoading(selectedTravelType: event.travelType));
    final result = await getCategoriesUseCase(
      GetCategoriesParams(travelType: event.travelType),
    );
    result.fold(
      (failure) => emit(
        CategoryError(
          message: failure.message,
          selectedTravelType: event.travelType,
        ),
      ),
      (categories) => emit(
        CategoryLoaded(
          categories: categories,
          selectedTravelType: event.travelType,
        ),
      ),
    );
  }

  Future<void> _onAddCategory(
    AddCategory event,
    Emitter<CategoryState> emit,
  ) async {
    print('[CategoryBloc] Add category event received');
    print('[CategoryBloc] Category name: ${event.name}');
    print('[CategoryBloc] Image path: ${event.imagePath}');
    print('[CategoryBloc] Travel type: ${event.travelType}');

    final currentState = state;
    final travelType =
        currentState is CategoryLoaded
            ? currentState.selectedTravelType
            : TravelType.domestic;

    if (currentState is CategoryLoaded) {
      emit(
        CategoryLoading(selectedTravelType: currentState.selectedTravelType),
      );
    }

    final result = await addCategoryUseCase(
      AddCategoryParams(
        name: event.name,
        imagePath: event.imagePath,
        travelType: event.travelType,
      ),
    );

    result.fold(
      (failure) {
        final errorMessage = 'Failed to add category: ${failure.message}';
        print('[CategoryBloc] ERROR: $errorMessage');
        emit(
          CategoryError(
            message: failure.message,
            selectedTravelType: travelType,
          ),
        );
      },
      (category) async {
        print('[CategoryBloc] Category added successfully: ${event.name}');

        // Reload categories after adding
        print('[CategoryBloc] Reloading categories...');
        final loadResult = await getCategoriesUseCase(
          GetCategoriesParams(travelType: event.travelType),
        );
        loadResult.fold(
          (failure) {
            print(
              '[CategoryBloc] ERROR reloading categories: ${failure.message}',
            );
            emit(
              CategoryError(
                message: failure.message,
                selectedTravelType: event.travelType,
              ),
            );
          },
          (categories) {
            print(
              '[CategoryBloc] Categories reloaded successfully, count: ${categories.length}',
            );
            // Emit loaded state with categories and trigger success message via listener
            if (!emit.isDone) {
              emit(
                CategoryLoaded(
                  categories: categories,
                  selectedTravelType: event.travelType,
                  selectedImagePath: null,
                  successMessage:
                      'Category "${event.name}" added successfully!',
                ),
              );
            }
          },
        );
      },
    );
  }

  Future<void> _onDeleteCategory(
    DeleteCategory event,
    Emitter<CategoryState> emit,
  ) async {
    print('[CategoryBloc] Delete category event received');
    print('[CategoryBloc] Category ID to delete: ${event.categoryId}');

    final currentState = state;
    if (currentState is! CategoryLoaded) {
      print(
        '[CategoryBloc] ERROR: Current state is not CategoryLoaded, state: $currentState',
      );
      return;
    }

    print(
      '[CategoryBloc] Current state is CategoryLoaded, proceeding with delete',
    );
    emit(CategoryLoading(selectedTravelType: currentState.selectedTravelType));

    final result = await deleteCategoryUseCase(
      DeleteCategoryParams(categoryId: event.categoryId),
    );

    result.fold(
      (failure) {
        print('[CategoryBloc] ERROR deleting category: ${failure.message}');
        emit(
          CategoryError(
            message: failure.message,
            selectedTravelType: currentState.selectedTravelType,
          ),
        );
      },
      (_) async {
        print('[CategoryBloc] Category deleted successfully');
        // Reload categories after deleting
        print('[CategoryBloc] Reloading categories...');
        final loadResult = await getCategoriesUseCase(
          GetCategoriesParams(travelType: currentState.selectedTravelType),
        );
        loadResult.fold(
          (failure) {
            print(
              '[CategoryBloc] ERROR reloading categories: ${failure.message}',
            );
            emit(
              CategoryError(
                message: failure.message,
                selectedTravelType: currentState.selectedTravelType,
              ),
            );
          },
          (categories) {
            print(
              '[CategoryBloc] Categories reloaded successfully, count: ${categories.length}',
            );
            // Emit loaded state with categories and success message
            if (!emit.isDone) {
              emit(
                CategoryLoaded(
                  categories: categories,
                  selectedTravelType: currentState.selectedTravelType,
                  successMessage: 'Category deleted successfully!',
                ),
              );
            }
          },
        );
      },
    );
  }

  Future<void> _onUpdateCategory(
    UpdateCategory event,
    Emitter<CategoryState> emit,
  ) async {
    final currentState = state;
    if (currentState is! CategoryLoaded) return;

    emit(CategoryLoading(selectedTravelType: currentState.selectedTravelType));

    final result = await updateCategoryUseCase(
      UpdateCategoryParams(
        categoryId: event.categoryId,
        name: event.name,
        imagePath: event.imagePath,
        travelType: event.travelType,
      ),
    );

    result.fold(
      (failure) => emit(
        CategoryError(
          message: failure.message,
          selectedTravelType: currentState.selectedTravelType,
        ),
      ),
      (_) async {
        // Reload categories after updating
        final travelType = event.travelType ?? currentState.selectedTravelType;
        final loadResult = await getCategoriesUseCase(
          GetCategoriesParams(travelType: travelType),
        );
        loadResult.fold(
          (failure) => emit(
            CategoryError(
              message: failure.message,
              selectedTravelType: travelType,
            ),
          ),
          (categories) => emit(
            CategoryLoaded(
              categories: categories,
              selectedTravelType: travelType,
              selectedImagePath: null,
            ),
          ),
        );
      },
    );
  }

  void _onSelectCategory(SelectCategory event, Emitter<CategoryState> emit) {
    if (state is CategoryLoaded) {
      emit(
        (state as CategoryLoaded).copyWith(selectedCategory: event.category),
      );
    }
  }

  void _onChangeTravelType(
    ChangeTravelType event,
    Emitter<CategoryState> emit,
  ) {
    if (state is CategoryLoaded) {
      // Clear selected category when switching travel type
      emit(
        (state as CategoryLoaded).copyWith(
          selectedTravelType: event.travelType,
          selectedCategory: null,
        ),
      );
    }
    add(LoadCategories(travelType: event.travelType));
  }

  void _onClearImageSelection(
    ClearImageSelection event,
    Emitter<CategoryState> emit,
  ) {
    final currentState = state;
    if (currentState is CategoryLoaded) {
      emit(currentState.copyWith(selectedImagePath: null));
    }
  }

  void _onSetImagePath(SetImagePath event, Emitter<CategoryState> emit) {
    final currentState = state;
    if (currentState is CategoryLoaded) {
      emit(currentState.copyWith(selectedImagePath: event.imagePath));
    } else {
      emit(
        CategoryLoaded(
          categories: [],
          selectedTravelType: TravelType.domestic,
          selectedImagePath: event.imagePath,
        ),
      );
    }
  }
}
