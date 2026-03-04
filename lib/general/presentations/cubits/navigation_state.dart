part of 'navigation_cubit.dart';

@immutable
class NavigationState {
  final int currentIndex;

  const NavigationState(this.currentIndex);

  // Simple factory for initial state
  factory NavigationState.initial() => const NavigationState(0);
}
