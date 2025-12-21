import 'package:elysian_admin/features/category/domain/entities/category_entity.dart';
import 'package:equatable/equatable.dart';

abstract class CategoryEvent extends Equatable {
  const CategoryEvent();

  @override
  List<Object?> get props => [];
}

class LoadCategories extends CategoryEvent {
  final TravelType travelType;

  const LoadCategories({required this.travelType});

  @override
  List<Object> get props => [travelType];
}

class AddCategory extends CategoryEvent {
  final String name;
  final String imagePath;
  final TravelType travelType;

  const AddCategory({
    required this.name,
    required this.imagePath,
    required this.travelType,
  });

  @override
  List<Object> get props => [name, imagePath, travelType];
}

class DeleteCategory extends CategoryEvent {
  final String categoryId;

  const DeleteCategory({required this.categoryId});

  @override
  List<Object> get props => [categoryId];
}

class UpdateCategory extends CategoryEvent {
  final String categoryId;
  final String? name;
  final String? imagePath;
  final TravelType? travelType;

  const UpdateCategory({
    required this.categoryId,
    this.name,
    this.imagePath,
    this.travelType,
  });

  @override
  List<Object?> get props => [categoryId, name, imagePath, travelType];
}

class ChangeTravelType extends CategoryEvent {
  final TravelType travelType;

  const ChangeTravelType({required this.travelType});

  @override
  List<Object> get props => [travelType];
}

class ClearImageSelection extends CategoryEvent {
  const ClearImageSelection();
}

class SetImagePath extends CategoryEvent {
  final String imagePath;

  const SetImagePath({required this.imagePath});

  @override
  List<Object> get props => [imagePath];
}

class SelectCategory extends CategoryEvent {
  final CategoryEntity category;

  const SelectCategory({required this.category});

  @override
  List<Object> get props => [category];
}
