import 'package:bloc/bloc.dart';
import 'package:meta/meta.dart';

part 'navigation_state.dart';

class NavigationCubit extends Cubit<NavigationState> {
  // Initialize with the initial state (index 0)
  NavigationCubit() : super(NavigationState.initial());

  // Method to update the state
  void updateIndex(int newIndex) {
    // Only emit a new state if the index has actually changed
    if (newIndex != state.currentIndex) {
      emit(NavigationState(newIndex));
    }
  }
}
