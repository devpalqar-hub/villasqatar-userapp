import 'package:flutter/material.dart';
import 'package:get/get_state_manager/src/simple/get_controllers.dart';

class PropertyListController extends GetxController {
  final searchController = TextEditingController();

  String selectedType = "Property Type";
  String selectedPrice = "Price Range";

  @override
  void onClose() {
    searchController.dispose();
    super.onClose();
  }
}