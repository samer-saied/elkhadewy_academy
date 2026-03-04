import 'package:shared_preferences/shared_preferences.dart';

class LanguageCacheHelper {
   late SharedPreferences sharedPreferences;

  Future<SharedPreferences> init() async {
   return    await SharedPreferences.getInstance();
  }

  Future<void> cacheLanguageCode(String languageCode) async {
    sharedPreferences = await init();
    sharedPreferences.setString("LOCALE", languageCode);
  }

  Future<String> getCachedLanguageCode() async {
    sharedPreferences = await init();
    final cachedLanguageCode = sharedPreferences.getString("LOCALE");
    if (cachedLanguageCode != null) {
      return cachedLanguageCode;
    } else {
      return "en";
    }
  }
}
