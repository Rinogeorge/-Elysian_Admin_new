import 'package:equatable/equatable.dart';

abstract class PackageListEvent extends Equatable {
  const PackageListEvent();

  @override
  List<Object> get props => [];
}

class FetchPackages extends PackageListEvent {
  final String type;

  const FetchPackages({this.type = 'International'});

  @override
  List<Object> get props => [type];
}
