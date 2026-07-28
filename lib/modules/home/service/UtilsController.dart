import 'dart:convert';

import 'package:get/get.dart';
import 'package:villas_qatar/Core/network/api_handler.dart';
import 'package:villas_qatar/modules/home/model/ListingOptions.dart';

class Utilscontroller extends GetxController {
  /// Plain (non-Rx) state — call update() after mutating and wrap the
  /// consuming widget in a GetBuilder<Utilscontroller>.
  bool isLoading = false;
  String? errorMessage;

  List<OptionItem> amenities = [];
  List<OptionItem> nearbyTags = [];
  List<OptionItem> furnishingOptions = [];
  List<OptionItem> listingTypes = [];
  List<Municipality> municipalities = [];

  @override
  void onInit() {
    super.onInit();
    fetchPropertyType();
  }

  Future<void> fetchPropertyType() async {
    isLoading = true;
    errorMessage = null;
    update();

    final response = await ApiHandler.get("/api/listings/options");

    // ApiHandler responses commonly expose either `.body` (raw string)
    // or `.data` (already-decoded map). Handle both so this compiles
    // regardless of your ApiHandler's exact return type.
    ;

    final options = ListingOptions.fromJson(response);

    amenities = options.amenities;
    nearbyTags = options.nearbyTags;
    furnishingOptions = options.furnishingOptions;
    listingTypes = options.listingTypes;
    municipalities = options.municipalities;

    //   errorMessage = "Failed to load listing options: $e";
    // } finally {
    isLoading = false;
    update();
    // }
  }

  /// Convenience: municipalities flagged as popular.
  List<Municipality> get popularMunicipalities =>
      municipalities.where((m) => m.isPopular).toList();

  /// Convenience: look up an OptionItem title by id (e.g. selected amenity ids).
  String? amenityTitleById(String id) =>
      amenities.firstWhereOrNull((a) => a.id == id)?.title;
}
