import 'package:flutter/material.dart';
import 'package:geolocator/geolocator.dart';
import 'package:get/get.dart';
import 'package:villas_qatar/Core/network/api_endpoints.dart';
import 'package:villas_qatar/Core/network/api_handler.dart';
import 'package:villas_qatar/modules/home/model/location_repsone_model.dart';



class LocationController extends GetxController {
  static LocationController get to => Get.find();

  final TextEditingController searchController = TextEditingController();

  bool isLoading = false;

  LocationResponse? location;

  String get areaName => location?.data.areaName ?? "";

  String get formattedAddress =>
      location?.data.formattedAddress ?? "";

  double get latitude =>
      location?.data.latitude ?? 0.0;

  double get longitude =>
      location?.data.longitude ?? 0.0;

  LocationResponse? selectedLocation;

List<LocationResponse> results = [];

  Future<bool> searchLocation(String keyword) async {
    try {
      isLoading = true;
      update();

      final response = await ApiHandler.get(
        "${ApiEndpoints.geocode}?location=${Uri.encodeComponent(keyword)}",
      );

      location = LocationResponse.fromJson(response);

      debugPrint("========== LOCATION ==========");
      debugPrint(location!.data.areaName);
      debugPrint(location!.data.formattedAddress);
      debugPrint(location!.data.latitude.toString());
      debugPrint(location!.data.longitude.toString());

      update();

      return true;
    } catch (e) {
      debugPrint("Location Error: $e");
      return false;
    } finally {
      isLoading = false;
      update();
    }
  }


  Future<void> onSearchChanged(String value) async {

  if (value.trim().length <2) {
    results.clear();
    update();
    return;
  }

  isLoading = true;
  update();

  final response = await ApiHandler.get(
      "${ApiEndpoints.geocode}?location=${Uri.encodeComponent(value)}");

  results = [
    LocationResponse.fromJson(response)
  ];

  isLoading = false;

  update();
}


void selectLocation(LocationResponse item) {
  location = item;
  selectedLocation = item;

  searchController.clear();
  results.clear();

  update();
}

Future<void> detectCurrentLocation() async {
  try {
    isLoading = true;
    update();

    bool serviceEnabled = await Geolocator.isLocationServiceEnabled();
    if (!serviceEnabled) {
      Get.snackbar("Location", "Please enable location services.");
      return;
    }

    LocationPermission permission = await Geolocator.checkPermission();

    if (permission == LocationPermission.denied) {
      permission = await Geolocator.requestPermission();
    }

    if (permission == LocationPermission.denied ||
        permission == LocationPermission.deniedForever) {
      Get.snackbar("Permission", "Location permission denied.");
      return;
    }

    final position = await Geolocator.getCurrentPosition(
      desiredAccuracy: LocationAccuracy.high,
    );

    debugPrint("========== CURRENT GPS ==========");
    debugPrint("Latitude : ${position.latitude}");
    debugPrint("Longitude: ${position.longitude}");

    final url =
        "${ApiHandler.baseUrl}${ApiEndpoints.reverseGeocode}"
        "?latitude=${position.latitude}"
        "&longitude=${position.longitude}";

    debugPrint("========== REVERSE GEOCODE REQUEST ==========");
    debugPrint("URL: $url");

    final response = await ApiHandler.get(
      "${ApiEndpoints.reverseGeocode}"
      "?latitude=${position.latitude}"
      "&longitude=${position.longitude}",
    );

    debugPrint("========== REVERSE GEOCODE RESPONSE ==========");
    debugPrint(response.toString());

    location = LocationResponse.fromJson(response);
    selectedLocation = location;

    searchController.clear();
    results.clear();

    update();
  } catch (e, stackTrace) {
    debugPrint("========== REVERSE GEOCODE ERROR ==========");
    debugPrint(e.toString());
    debugPrint(stackTrace.toString());

    Get.snackbar("Error", "Unable to detect current location.");
  } finally {
    isLoading = false;
    update();
  }
}
  void clearLocation() {
    location = null;
    update();
  }
}