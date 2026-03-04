part of 'themes_cubit.dart';

@immutable
sealed class ThemesState {}

// final class ThemesInitial extends ThemesState {}


final class ThemesChanged extends ThemesState {
  final ThemeType? currentTheme;
  ThemesChanged({required this.currentTheme});
}
