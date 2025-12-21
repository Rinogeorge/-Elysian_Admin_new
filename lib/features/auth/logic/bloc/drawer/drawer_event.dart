import 'package:equatable/equatable.dart';

abstract class DrawerEvent extends Equatable {
  const DrawerEvent();

  @override
  List<Object> get props => [];
}

class LoadDrawerUser extends DrawerEvent {
  const LoadDrawerUser();
}

class DrawerLogoutRequested extends DrawerEvent {
  const DrawerLogoutRequested();
}

class DrawerDeleteAccountRequested extends DrawerEvent {
  const DrawerDeleteAccountRequested();
}

