import 'package:equatable/equatable.dart';

abstract class PackageDetailsState extends Equatable {
  const PackageDetailsState();

  @override
  List<Object> get props => [];
}

class PackageDetailsInitial extends PackageDetailsState {}

class PackageDetailsLoading extends PackageDetailsState {}

class PackageDetailsDeleted extends PackageDetailsState {}

class PackageDetailsError extends PackageDetailsState {
  final String message;

  const PackageDetailsError(this.message);

  @override
  List<Object> get props => [message];
}
