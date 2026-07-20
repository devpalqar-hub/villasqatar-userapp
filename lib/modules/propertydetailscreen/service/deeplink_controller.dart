import 'package:flutter/material.dart';
import 'package:get/get.dart';

import 'package:villas_qatar/Core/network/api_endpoints.dart';
import 'package:villas_qatar/Core/network/api_handler.dart';
import 'package:villas_qatar/modules/propertylist/model/myproperty_model.dart';

class DeepLinkController extends GetxController {
  bool isLoading = false;

  Property? property;

  String error = '';

  /// ============================================================
  /// FETCH PROPERTY USING SLUG
  /// GET /api/listings/slug/{slug}
  /// ============================================================
  Future<Property?> fetchPropertyBySlug({
    required String slug,
  }) async {
    try {
      isLoading = true;
      error = '';
      property = null;
      update();

      debugPrint(
        "========== FETCH PROPERTY BY SLUG ==========",
      );
      debugPrint("Slug: $slug");

      final response = await ApiHandler.get(
        ApiEndpoints.propertyBySlug(slug),
      );

      debugPrint(
        "Property By Slug Response: $response",
      );

      if (response is Map<String, dynamic>) {
        property = Property.fromJson(response);

        debugPrint(
          "Property Loaded: ${property?.propertyName}",
        );

        return property;
      }

      if (response is Map) {
        property = Property.fromJson(
          Map<String, dynamic>.from(response),
        );

        return property;
      }

      throw Exception(
        "Invalid property response",
      );
    } catch (e) {
      error = e
          .toString()
          .replaceFirst(
            "Exception: ",
            "",
          );

      debugPrint(
        "Fetch Property By Slug Error: $e",
      );

      return null;
    } finally {
      isLoading = false;
      update();
    }
  }
}