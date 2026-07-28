import 'package:get/get.dart';

class AppFonts {
  static const String english = 'Rubik';
  static const String arabic = 'Cairo';

  static String get currentFont =>
      Get.locale?.languageCode == 'ar' ? arabic : english;
}
