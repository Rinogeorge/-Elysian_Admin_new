part of 'user_category_bloc.dart';

abstract class UserCategoryState extends Equatable {
  const UserCategoryState();

  @override
  List<Object> get props => [];
}

class UserCategoryInitial extends UserCategoryState {}

class UserCategoryLoading extends UserCategoryState {}

class UserCategoryLoaded extends UserCategoryState {
  final List<CategoryEntity> categories;

  const UserCategoryLoaded({required this.categories});

  @override
  List<Object> get props => [categories];
}

class UserCategoryError extends UserCategoryState {
  final String message;

  const UserCategoryError({required this.message});

  @override
  List<Object> get props => [message];
}
