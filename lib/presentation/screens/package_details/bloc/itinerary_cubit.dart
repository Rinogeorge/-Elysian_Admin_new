import 'package:equatable/equatable.dart';
import 'package:flutter_bloc/flutter_bloc.dart';

class ItineraryState extends Equatable {
  final int dayIndex;
  final int imageIndex;

  const ItineraryState({this.dayIndex = 0, this.imageIndex = 0});

  ItineraryState copyWith({int? dayIndex, int? imageIndex}) {
    return ItineraryState(
      dayIndex: dayIndex ?? this.dayIndex,
      imageIndex: imageIndex ?? this.imageIndex,
    );
  }

  @override
  List<Object> get props => [dayIndex, imageIndex];
}

class ItineraryCubit extends Cubit<ItineraryState> {
  ItineraryCubit() : super(const ItineraryState());

  void selectDay(int dayIndex) {
    emit(state.copyWith(dayIndex: dayIndex, imageIndex: 0));
  }

  void changeImage(int imageIndex) {
    emit(state.copyWith(imageIndex: imageIndex));
  }
}
