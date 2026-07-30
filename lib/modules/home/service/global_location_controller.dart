import 'package:get/get.dart';

class GlobalLocationController extends GetxController {
  static GlobalLocationController get to => Get.find();

  String keyword = "";
  String title = "";
  String areaName = "";

  double? latitude;
  double? longitude;

  String formattedAddress = "";

  bool isLoading = false;

  void setLocation(Map<String, dynamic> json) {
    keyword = json["keyword"] ?? "";

    final data = json["data"] ?? {};

    title = data["title"] ?? "";
    areaName = data["areaName"] ?? "";
    latitude = (data["latitude"] as num?)?.toDouble();
    longitude = (data["longitude"] as num?)?.toDouble();
    formattedAddress = data["formattedAddress"] ?? "";

    update();
  }

  void clear() {
    keyword = "";
    title = "";
    areaName = "";
    latitude = null;
    longitude = null;
    formattedAddress = "";

    update();
  }
}