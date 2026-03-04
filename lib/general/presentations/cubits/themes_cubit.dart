import 'package:bloc/bloc.dart';
import 'package:flutter/material.dart';

import '../../../../services/themes/themes_cache_helper.dart';

part 'themes_state.dart';

class ThemesCubit extends Cubit<ThemesState> {
  ThemesCubit() : super(ThemesChanged(currentTheme: ThemeType.system));

  Future<void> getSavedTheme() async {
    final ThemeType cachedThemeName = await ThemeCacheHelper()
        .getCachedThemeCode();

    emit(ThemesChanged(currentTheme: cachedThemeName));
  }

  Future<void> changeTheme() async {
    final ThemeType cachedThemeName = await ThemeCacheHelper()
        .getCachedThemeCode();
    if (cachedThemeName == ThemeType.light) {
      await ThemeCacheHelper().cacheThemeCode(ThemeType.dark);
      emit(ThemesChanged(currentTheme: ThemeType.dark));
    } else {
      await ThemeCacheHelper().cacheThemeCode(ThemeType.light);
      emit(ThemesChanged(currentTheme: ThemeType.light));
    }
  }
}
