import 'package:flutter/material.dart';
import 'package:get/get.dart';

class ListPropertyController extends GetxController {
  /// Current Step
  final RxInt currentStep = 0.obs;

  /// Step Titles
  final List<String> steps = [
    "Basic Info",
    "Details",
    "Features",
    "Location",
    "Media",
  ];

  //-------------------------------------------------------
  /// Owner Details
  //-------------------------------------------------------

  final fullNameController = TextEditingController();

  final phoneController = TextEditingController();

  final emailController = TextEditingController();

  final descriptionController = TextEditingController();

  final RxString countryCode = "+974".obs;

  final RxBool whatsappVerified = true.obs;

  //-------------------------------------------------------
  /// Property Details
  //-------------------------------------------------------

  final RxString propertyType = "".obs;

  final RxString propertyPurpose = "".obs;

  final RxString propertyCategory = "".obs;

  final bedroomsController = TextEditingController();

  final bathroomsController = TextEditingController();

  final areaController = TextEditingController();

  final priceController = TextEditingController();

  //-------------------------------------------------------
  /// Features
  //-------------------------------------------------------

  final amenities = <String>[
    "Parking",
    "Swimming Pool",
    "Gym",
    "Garden",
    "Security",
    "Balcony",
    "Elevator",
    "Air Conditioning",
    "Maid Room",
    "Kids Area",
    "Pet Friendly",
    "Internet",
  ];

  final RxList<String> selectedAmenities = <String>[].obs;

  //-------------------------------------------------------
  /// Location
  //-------------------------------------------------------

  final addressController = TextEditingController();

  final cityController = TextEditingController();

  final areaNameController = TextEditingController();

  final buildingController = TextEditingController();

  final landmarkController = TextEditingController();

  final RxDouble latitude = 0.0.obs;

  final RxDouble longitude = 0.0.obs;

  //-------------------------------------------------------
  /// Media
  //-------------------------------------------------------

  final RxList<String> images = <String>[].obs;

  final RxString video = "".obs;

  //-------------------------------------------------------
  /// Loading
  //-------------------------------------------------------

  final RxBool isSubmitting = false.obs;

  //-------------------------------------------------------
  /// Step Navigation
  //-------------------------------------------------------

  void nextStep() {
    if (currentStep.value < 4) {
      currentStep.value++;
    }
  }

  void previousStep() {
    if (currentStep.value > 0) {
      currentStep.value--;
    }
  }

  void goToStep(int index) {
    currentStep.value = index;
  }

  //-------------------------------------------------------
  /// Amenities
  //-------------------------------------------------------

  void toggleAmenity(String value) {
    if (selectedAmenities.contains(value)) {
      selectedAmenities.remove(value);
    } else {
      selectedAmenities.add(value);
    }
  }

  //-------------------------------------------------------
  /// Media
  //-------------------------------------------------------

  void addImage(String path) {
    images.add(path);
  }

  void removeImage(int index) {
    images.removeAt(index);
  }

  void setVideo(String path) {
    video.value = path;
  }

  //-------------------------------------------------------
  /// Save Draft
  //-------------------------------------------------------

  void saveDraft() {
    Get.snackbar(
      "Saved",
      "Draft saved successfully",
      snackPosition: SnackPosition.BOTTOM,
    );
  }

  //-------------------------------------------------------
  /// Submit
  //-------------------------------------------------------

  Future<void> submitProperty() async {
    isSubmitting.value = true;

    await Future.delayed(
      const Duration(seconds: 2),
    );

    isSubmitting.value = false;

    Get.snackbar(
      "Success",
      "Property Listed Successfully",
      snackPosition: SnackPosition.BOTTOM,
    );
  }

  //-------------------------------------------------------
  /// Dispose
  //-------------------------------------------------------

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

    super.onClose();
  }
}