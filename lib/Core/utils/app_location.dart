class AppLocation {
  AppLocation._();

  static String keyword = "";

  static String title = "";

  static String areaName = "";

  static String formattedAddress = "";

  static String municipalityId = "";

  static String municipalityName = "";

  static double? latitude;

  static double? longitude;

  static bool get hasLocation =>
      latitude != null && longitude != null;

  static void clear() {
    keyword = "";
    title = "";
    areaName = "";
    formattedAddress = "";
    municipalityId = "";
    municipalityName = "";
    latitude = null;
    longitude = null;
  }
}