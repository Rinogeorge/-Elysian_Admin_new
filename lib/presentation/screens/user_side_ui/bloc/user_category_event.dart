part of 'user_category_bloc.dart';

abstract class UserCategoryEvent extends Equatable {
  const UserCategoryEvent();

  @override
  List<Object> get props => [];
}

class LoadUserCategories extends UserCategoryEvent {}
