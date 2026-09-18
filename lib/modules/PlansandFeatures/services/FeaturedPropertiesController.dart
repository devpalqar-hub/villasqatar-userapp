import 'dart:developer';

import 'package:get/get.dart';
import 'package:http/http.dart';
import 'package:villas_qatar/Core/network/api_handler.dart';
import 'package:villas_qatar/modules/home/model/PropertyModel.dart';

class FeaturedPropertiesController extends GetxController {
  Future<List<PropertyModel>> fetchFeatureProperty({
    bool isHome = false,
    bool isListing = false,
    bool isPropertyPage = false,
  }) async {
    List<PropertyModel> propertyList = [];
    String loc = (isHome)
        ? "PROPERTY_DETAIL_PAGE"
        : (isListing)
        ? "LISTING_PAGE"
        : "HOME_PAGE";
    final response = await ApiHandler.get(
      "/api/featured?location=${loc}&page=1&limit=10",
    );

    if (response["data"].isNotEmpty) {
      for (var data in response["data"]) {
        propertyList.add(PropertyModel.fromJson(data["listing"]));
      }
    }
    update();
    return propertyList;
  }
}
