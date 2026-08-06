import 'package:flutter/material.dart';
import 'package:get/get_core/src/get_main.dart';
import 'package:get/get_navigation/src/extension_navigation.dart';
import 'package:get/get_state_manager/src/simple/get_controllers.dart';

import 'package:villas_qatar/Core/network/api_endpoints.dart';
import 'package:villas_qatar/Core/network/api_handler.dart';
import 'package:villas_qatar/Core/services/storage_service.dart';
import 'package:villas_qatar/modules/settings/model/profile_model.dart';

class ProfileController extends GetxController {
  final nameController = TextEditingController();
  final emailController = TextEditingController();
  final phoneController = TextEditingController();
  final passwordController = TextEditingController();

  ProfileModel? profile;

  bool isLoading = false;
  bool isSaving = false;

  @override
  void onInit() {
    super.onInit();
    fetchProfile();
  }

  Future<void> fetchProfile() async {
    try {
      isLoading = true;
      update();
      final userId = StorageService.getUserId();

      final response = await ApiHandler.get(ApiEndpoints.userById(userId));

      profile = ProfileModel.fromJson(response);

      nameController.text = profile!.name;
      emailController.text = profile!.email;
      phoneController.text = profile!.phone;

      await StorageService.saveProfile(response);
    } catch (e) {
      Get.snackbar("Error", e.toString());
    } finally {
      isLoading = false;
      update();
    }
  }

  Future<void> updateProfile() async {
    try {
      isSaving = true;
      update();

      final body = {
        "name": nameController.text.trim(),
        "email": emailController.text.trim(),
        "phone": phoneController.text.trim(),
      };

      if (passwordController.text.trim().isNotEmpty) {
        body["password"] = passwordController.text.trim();
      }

      final response = await ApiHandler.patch(ApiEndpoints.myProfile, body: body);

      profile = ProfileModel.fromJson(response);

      await StorageService.saveProfile(response);

      Get.snackbar("Success", "Profile updated successfully");
    } catch (e) {
      Get.snackbar("Error", e.toString());
    } finally {
      isSaving = false;
      update();
    }
  }

  @override
  void onClose() {
    nameController.dispose();
    emailController.dispose();
    phoneController.dispose();
    passwordController.dispose();
    super.onClose();
  }
}
