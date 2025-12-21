import 'package:elysian_admin/features/add_package/data/models/package_model.dart';
import 'package:equatable/equatable.dart';

abstract class PackageDetailsEvent extends Equatable {
  const PackageDetailsEvent();

  @override
  List<Object> get props => [];
}

class DeletePackageEvent extends PackageDetailsEvent {
  final PackageModel package;

  const DeletePackageEvent(this.package);

  @override
  List<Object> get props => [package];
}
