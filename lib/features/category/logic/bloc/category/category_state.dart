import 'package:elysian_admin/features/category/domain/entities/category_entity.dart';
import 'package:equatable/equatable.dart';

abstract class CategoryState extends Equatable {
  const CategoryState();

  @override
  List<Object?> get props => [];
}

class CategoryInitial extends CategoryState {
  final TravelType selectedTravelType;

  const CategoryInitial({this.selectedTravelType = TravelType.domestic});

  @override
  List<Object> get props => [selectedTravelType];
}

class CategoryLoading extends CategoryState {
  final TravelType selectedTravelType;

  const CategoryLoading({required this.selectedTravelType});

  @override
  List<Object> get props => [selectedTravelType];
}

class CategoryLoaded extends CategoryState {
  final List<CategoryEntity> categories;
  final TravelType selectedTravelType;
  final String? selectedImagePath;
  final String? successMessage;
  final CategoryEntity? selectedCategory;

  const CategoryLoaded({
    required this.categories,
    required this.selectedTravelType,
    this.selectedImagePath,
    this.successMessage,
    this.selectedCategory,
  });

  CategoryLoaded copyWith({
    List<CategoryEntity>? categories,
    TravelType? selectedTravelType,
    String? selectedImagePath,
    String? successMessage,
    CategoryEntity? selectedCategory,
  }) {
    return CategoryLoaded(
      categories: categories ?? this.categories,
      selectedTravelType: selectedTravelType ?? this.selectedTravelType,
      selectedImagePath: selectedImagePath ?? this.selectedImagePath,
      successMessage: successMessage,
      selectedCategory: selectedCategory ?? this.selectedCategory,
    );
  }

  @override
  List<Object?> get props => [
    categories,
    selectedTravelType,
    selectedImagePath,
    successMessage,
    selectedCategory,
  ];
}

class CategoryError extends CategoryState {
  final String message;
  final TravelType selectedTravelType;

  const CategoryError({
    required this.message,
    required this.selectedTravelType,
  });

  @override
  List<Object> get props => [message, selectedTravelType];
}

class CategorySuccess extends CategoryState {
  final String message;
  final TravelType selectedTravelType;

  const CategorySuccess({
    required this.message,
    required this.selectedTravelType,
  });

  @override
  List<Object> get props => [message, selectedTravelType];
}
