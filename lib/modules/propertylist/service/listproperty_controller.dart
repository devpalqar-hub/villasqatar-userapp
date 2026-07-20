import 'dart:convert';
import 'dart:io';
import 'package:flutter/material.dart';
import 'package:get/get.dart';
import 'package:http/http.dart' as http;

import 'package:villas_qatar/Core/network/api_endpoints.dart';
import 'package:villas_qatar/Core/network/api_handler.dart';
import 'package:villas_qatar/Core/services/storage_service.dart';
import 'package:villas_qatar/modules/propertylist/model/listing_options_model.dart';
import 'package:villas_qatar/modules/propertylist/model/upload_property_model.dart';

class ListPropertyController extends GetxController {
  //--------------------------------------------------
  // STEP
  //--------------------------------------------------

  int currentStep = 0;

  final List<String> steps = [
    "Basic Info",
    "Details",
    "Features",
    "Location",
    "Media",
  ];

  //--------------------------------------------------
  // LOADING
  //--------------------------------------------------

  bool isLoading = false;
  bool isSubmitting = false;
  bool isUploadingImages = false;
  final List<UploadedPropertyPhoto> uploadedPhotos = [];

  String error = "";

  //--------------------------------------------------
  // OWNER
  //--------------------------------------------------

  final fullNameController = TextEditingController();

  final phoneController = TextEditingController();

  final emailController = TextEditingController();

  final descriptionController = TextEditingController();

  String countryCode = "+974";

  bool whatsappVerified = true;

  //--------------------------------------------------
  // PROPERTY
  //--------------------------------------------------

  String propertyType = "";

  String propertyPurpose = "";

  String propertyCategory = "";

  final bedroomsController = TextEditingController();

  final bathroomsController = TextEditingController();

  final areaController = TextEditingController();

  final priceController = TextEditingController();

  //--------------------------------------------------
  // LOCATION
  //--------------------------------------------------

  final addressController = TextEditingController();

  final cityController = TextEditingController();

  final areaNameController = TextEditingController();

  final buildingController = TextEditingController();

  final landmarkController = TextEditingController();
  final propertyNameController = TextEditingController();
  final otherFeatureController = TextEditingController();
  final streetController = TextEditingController();
  final livingRoomsController = TextEditingController();

  final parkingSpacesController = TextEditingController();

  final floorNumberController = TextEditingController();

  final totalFloorsController = TextEditingController();
  final yearBuiltController = TextEditingController();
  final latitudeController = TextEditingController();

  final longitudeController = TextEditingController();

  bool showOtpField = false;

  final otpController = TextEditingController();

  double latitude = 0;

  double longitude = 0;

  //--------------------------------------------------
  // OPTIONS FROM API
  //--------------------------------------------------

  List<String> amenities = [];

  List<String> nearbyTags = [];

  List<String> furnishingOptions = [];

  List<String> areaSuggestions = [];

  //--------------------------------------------------
  // SELECTED
  //--------------------------------------------------

  final Set<String> selectedAmenities = {};

  final Set<String> selectedNearbyTags = {};

  final Set<String> selectedFurnishing = {};

  //--------------------------------------------------
  // MEDIA
  //--------------------------------------------------

  final List<String> images = [];

  String video = "";

  //--------------------------------------------------
  // INIT
  //--------------------------------------------------
  //--------------------------------------------------
  // STEP NAVIGATION
  //--------------------------------------------------

  void nextStep() {
    if (currentStep < steps.length - 1) {
      currentStep++;
      update();
    }
  }

  void previousStep() {
    if (currentStep > 0) {
      currentStep--;
      update();
    }
  }

  void goToStep(int index) {
    currentStep = index;
    update();
  }

  //--------------------------------------------------
  // PROPERTY
  //--------------------------------------------------

  void setPropertyType(String value) {
    propertyType = value;
    update();
  }

  void setPropertyPurpose(String value) {
    propertyPurpose = value;
    update();
  }

  void setPropertyCategory(String value) {
    propertyCategory = value;
    update();
  }

  //--------------------------------------------------
  // COUNTRY CODE
  //--------------------------------------------------

  void setCountryCode(String value) {
    countryCode = value;
    update();
  }

  void setWhatsappVerified(bool value) {
    whatsappVerified = value;
    update();
  }

  //--------------------------------------------------
  // AMENITIES
  //--------------------------------------------------

  void toggleAmenity(String value) {
    if (selectedAmenities.contains(value)) {
      selectedAmenities.remove(value);
    } else {
      selectedAmenities.add(value);
    }

    update();
  }

  //--------------------------------------------------
  // NEARBY TAGS
  //--------------------------------------------------

  void toggleNearbyTag(String value) {
    if (selectedNearbyTags.contains(value)) {
      selectedNearbyTags.remove(value);
    } else {
      selectedNearbyTags.add(value);
    }

    update();
  }

  //--------------------------------------------------
  // FURNISHING
  //--------------------------------------------------

  void toggleFurnishing(String value) {
    if (selectedFurnishing.contains(value)) {
      selectedFurnishing.remove(value);
    } else {
      selectedFurnishing.add(value);
    }

    update();
  }

  //--------------------------------------------------
  // LOCATION
  //--------------------------------------------------
  void setLatitude(double value) {
    latitude = value;
    latitudeController.text = value == 0 ? "" : value.toString();
    update();
  }

  void setLongitude(double value) {
    longitude = value;
    longitudeController.text = value == 0 ? "" : value.toString();
    update();
  }
  //--------------------------------------------------
  // MEDIA
  //--------------------------------------------------

  void addImage(String path) {
    images.add(path);
    update();
  }

  void removeImage(int index) {
    images.removeAt(index);
    update();
  }

  void setVideo(String path) {
    video = path;
    update();
  }

  //--------------------------------------------------
  // SAVE DRAFT
  //--------------------------------------------------

  void saveDraft() {
    Get.snackbar(
      "Saved",
      "Draft saved successfully",
      snackPosition: SnackPosition.BOTTOM,
    );
  }

  //--------------------------------------------------
  // SUBMIT
  //--------------------------------------------------

  //--------------------------------------------------
  // CLEAR
  //--------------------------------------------------

  void clearForm() {
    fullNameController.clear();
    phoneController.clear();
    emailController.clear();
    descriptionController.clear();

    bedroomsController.clear();
    bathroomsController.clear();
    areaController.clear();
    priceController.clear();

    addressController.clear();
    cityController.clear();
    areaNameController.clear();
    buildingController.clear();
    landmarkController.clear();

    propertyType = "";
    propertyPurpose = "";
    propertyCategory = "";

    latitude = 0;
    longitude = 0;
    latitudeController.clear();
    longitudeController.clear();

    selectedAmenities.clear();
    selectedNearbyTags.clear();
    selectedFurnishing.clear();

    images.clear();

    video = "";

    currentStep = 0;

    update();
  }

  //--------------------------------------------------
  // DISPOSE
  //--------------------------------------------------

  @override
  void onClose() {
    fullNameController.dispose();
    phoneController.dispose();
    emailController.dispose();
    descriptionController.dispose();

    bedroomsController.dispose();
    bathroomsController.dispose();
    areaController.dispose();
    priceController.dispose();

    addressController.dispose();
    cityController.dispose();
    areaNameController.dispose();
    buildingController.dispose();
    landmarkController.dispose();
    otherFeatureController.dispose();
    streetController.dispose();
    livingRoomsController.dispose();
    parkingSpacesController.dispose();
    floorNumberController.dispose();
    totalFloorsController.dispose();
    yearBuiltController.dispose();
    latitudeController.dispose();
    longitudeController.dispose();

    super.onClose();
  }

  @override
  void onInit() {
    super.onInit();

    fetchListingOptions();
  }

  //--------------------------------------------------
  // API
  //--------------------------------------------------
  Future<void> fetchListingOptions() async {
    try {
      isLoading = true;
      error = "";
      update();

      final response = await ApiHandler.get(ApiEndpoints.listingOptions);

      final model = ListingOptionsModel.fromJson(response);

      amenities = model.amenities;
      nearbyTags = model.nearbyTags;
      furnishingOptions = model.furnishingOptions;
      areaSuggestions = model.areaSuggestions;
    } catch (e) {
      error = e.toString();
    } finally {
      isLoading = false;
      update();
    }
  }

  Future<void> addProperty() async {
    try {
      isSubmitting = true;
      update();
      final uploadedImageUrls = await uploadAllPropertyImages();

      debugPrint("========== UPLOADED IMAGES ==========");
      debugPrint(uploadedImageUrls.toString());
      if (images.isNotEmpty && uploadedImageUrls.length != images.length) {
        throw Exception("Some images could not be uploaded.");
      }

      final body = {
        "propertyName": propertyNameController.text.trim(),
        "description": descriptionController.text.trim(),

        "purpose": propertyPurpose,
        "type": propertyType.toUpperCase(),

        "latitude": latitude,
        "longitude": longitude,

        "bedrooms": int.tryParse(bedroomsController.text.trim()) ?? 0,

        "bathrooms": int.tryParse(bathroomsController.text.trim()) ?? 0,

        "area": double.tryParse(areaController.text.trim()) ?? 0,

        "livingRooms": int.tryParse(livingRoomsController.text.trim()) ?? 0,

        "parkingSpaces": int.tryParse(parkingSpacesController.text.trim()) ?? 0,

        "floorNumber": int.tryParse(floorNumberController.text.trim()) ?? 0,

        "totalFloors": int.tryParse(totalFloorsController.text.trim()) ?? 0,

        /// Optional
        "yearBuilt": null,

        "furnishingStatus": selectedFurnishing.isEmpty
            ? null
            : selectedFurnishing.first,

        /// Optional custom properties
        "extraProperties": {},

        "price": double.tryParse(priceController.text.trim()) ?? 0,

        "priceNegotiable": false,

        "addressLine1": addressController.text.trim(),

        "addressLine2": streetController.text.trim(),

        "areaName": areaNameController.text.trim(),

        "municipality": cityController.text.trim(),

        "contactPhone": "$countryCode${phoneController.text.trim()}",

        "contactWhatsapp": "$countryCode${phoneController.text.trim()}",

        "contactVerified": whatsappVerified,

        "amenities": selectedAmenities.toList(),

        "nearbyTags": selectedNearbyTags.toList(),

        "otherFeatures": otherFeatureController.text.trim(),
        "photos": uploadedImageUrls,
      };

      debugPrint("========== ADD PROPERTY ==========");
      debugPrint("PHOTOS: ${body["photos"]}");

      await ApiHandler.post(ApiEndpoints.propertyAdd, body: body);

      Get.snackbar(
        "Success",
        "Property listed successfully.",
        snackPosition: SnackPosition.BOTTOM,
      );

      clearForm();
    } catch (e) {
      Get.snackbar("Error", e.toString(), snackPosition: SnackPosition.BOTTOM);
    } finally {
      isSubmitting = false;
      update();
    }
  }

  Future<void> sendOtp() async {
    // API call

    showOtpField = true;
    update();
  }

  Future<String?> uploadPropertyImage(File image) async {
    try {
      final token = StorageService.getToken();

      final request = http.MultipartRequest(
        "POST",
        Uri.parse("${ApiHandler.baseUrl}/api/upload"),
      );

      request.headers.addAll({
        "Authorization": "Bearer $token",
        "Accept": "application/json",
      });

      // field name from Swagger = file
      request.files.add(await http.MultipartFile.fromPath("file", image.path));

      debugPrint("========== PROPERTY IMAGE UPLOAD ==========");
      debugPrint("URL: ${request.url}");
      debugPrint("FILE: ${image.path}");

      final streamedResponse = await request.send();
      final response = await http.Response.fromStream(streamedResponse);

      debugPrint("STATUS: ${response.statusCode}");
      debugPrint("BODY: ${response.body}");

      if (response.statusCode == 200 || response.statusCode == 201) {
        final data = jsonDecode(response.body);

        return data["url"]?.toString();
      }

      final error = jsonDecode(response.body);

      throw Exception(error["message"] ?? "Image upload failed");
    } catch (e) {
      debugPrint("PROPERTY IMAGE UPLOAD ERROR: $e");
      rethrow;
    }
  }

  Future<List<Map<String, dynamic>>> uploadAllPropertyImages() async {
    final List<Map<String, dynamic>> photos = [];

    for (int i = 0; i < images.length; i++) {
      final imageFile = File(images[i]);

      final imageUrl = await uploadPropertyImage(imageFile);

      if (imageUrl == null || imageUrl.isEmpty) {
        throw Exception("Failed to upload image ${i + 1}");
      }

      photos.add({"url": imageUrl, "sortOrder": i, "caption": ""});

      debugPrint("IMAGE ${i + 1}/${images.length} UPLOADED: $imageUrl");
    }

    return photos;
  }

  Future<void> verifyOtp() async {
    // Verify OTP API

    whatsappVerified = true;
    showOtpField = false;

    update();
  }
}
