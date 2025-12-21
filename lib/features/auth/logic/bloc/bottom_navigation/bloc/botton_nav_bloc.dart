import 'dart:async';

import 'package:elysian_admin/features/auth/logic/bloc/bottom_navigation/bloc/botton_nav_event.dart';
import 'package:elysian_admin/features/auth/logic/bloc/bottom_navigation/bloc/botton_nav_state.dart';

class NavigationBloc {
  final _stateController = StreamController<NavigationState>.broadcast();
  NavigationState _state = const NavigationState();

  Stream<NavigationState> get state => _stateController.stream;
  NavigationState get currentState => _state;

  void add(NavigationEvent event) {
    if (event is NavigateToPage) {
      _state = _state.copyWith(selectedIndex: event.index);
      _stateController.add(_state);
    }
  }

  void dispose() {
    _stateController.close();
  }
}