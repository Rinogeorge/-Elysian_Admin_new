import 'package:elysian_admin/features/add_package/data/models/package_model.dart';
import 'package:equatable/equatable.dart';

abstract class PackageListState extends Equatable {
  const PackageListState();

  @override
  List<Object?> get props => [];
}

class PackageListInitial extends PackageListState {}

class PackageListLoading extends PackageListState {}

class PackageListLoaded extends PackageListState {
  final List<PackageModel> packages;

  const PackageListLoaded({required this.packages});

  @override
  List<Object?> get props => [packages];
}

class PackageListError extends PackageListState {
  final String message;

  const PackageListError({required this.message});

  @override
  List<Object?> get props => [message];
}
