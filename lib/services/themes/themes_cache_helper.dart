import 'package:shared_preferences/shared_preferences.dart';

enum ThemeType { light, dark, system }

class ThemeCacheHelper {
  late SharedPreferences sharedPreferences;

  Future<SharedPreferences> init() async {
    return await SharedPreferences.getInstance();
  }

  Future<void> cacheThemeCode(ThemeType themeType) async {
    sharedPreferences = await init();
    sharedPreferences.setString("THEME", themeType.name);
  }

  Future<ThemeType> getCachedThemeCode() async {
    sharedPreferences = await init();
    final cachedThemeType = sharedPreferences.getString("THEME");
    if (cachedThemeType != null) {
      return cachedThemeType == 'light'
          ? ThemeType.light
          : cachedThemeType == 'dark'
          ? ThemeType.dark
          : ThemeType.system;
    } else {
      return ThemeType.system;
    }
  }
}
