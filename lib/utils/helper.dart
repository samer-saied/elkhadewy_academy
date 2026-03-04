import 'dart:ui';

import 'colors.dart';

class Helper {
  static Color getCourseColor(String? colorString) {
    if (colorString == null) return AppColors.jonquil;

    int? colorValue = int.tryParse(colorString);
    return (colorValue == null) ? AppColors.jonquil : Color(colorValue);
  }

  static String? extractYoutubeId(String url) {
    // This Regex covers: standard, shortened, embed, and mobile youtube links
    final RegExp regExp = RegExp(
      r'.*(?:(?:youtu\.be\/|v\/|vi\/|u\/\w\/|embed\/|shorts\/)|(?:(?:watch)?\?v?=|&v?=))([^#&?]*).*',
      caseSensitive: false,
      multiLine: false,
    );

    final Match? match = regExp.firstMatch(url);

    if (match != null && match.groupCount >= 1) {
      return match.group(1);
    }

    return null; // Returns null if the URL is invalid or ID not found
  }
}
