import 'package:flutter/foundation.dart';
import 'package:get/get.dart';

import 'package:villas_qatar/Core/network/api_endpoints.dart';
import 'package:villas_qatar/Core/network/api_handler.dart';
import 'package:villas_qatar/modules/propertylist/model/myproperty_model.dart';

class MyPropertyController extends GetxController {
  bool isLoading = false;
  bool isLoadingMore = false;
  String error = "";
  

  List<Property> properties = [];
  String? purpose;
  String? type;

  double? minPrice;
  double? maxPrice;

  bool? priceNegotiable;

  int? minBedrooms;
  int? maxBedrooms;

  int? minBathrooms;
  int? maxBathrooms;

  double? minArea;
  double? maxArea;

  String? furnishingStatus;

  String? municipality;
  String? areaName;

  String? sortBy;
  String? sortOrder;

  int page = 1;
  final int limit = 12;
  bool hasMore = true;
  bool isMarkingAsSold = false;
  String markAsSoldError = "";
 
Future<void> fetchProperties({
  bool loadMore = false,
  bool showLoader = true,
}) async {
  // Prevent duplicate API calls
  if (loadMore) {
    if (isLoadingMore || !hasMore) {
      return;
    }

    isLoadingMore = true;
  } else {
    if (isLoading) {
      return;
    }

    if (showLoader) {
      isLoading = true;
    }

    error = "";

    page = 1;
    hasMore = true;

    // IMPORTANT:
    // Do not clear here.
    //
    // Keep old properties visible while refreshing.
  }

  update();

  try {
    final int requestedPage =
        loadMore ? page : 1;

    final query = <String, String>{
      "page": requestedPage.toString(),
      "limit": limit.toString(),
    };

    // ==========================================================
    // FILTERS
    // ==========================================================

    if (purpose != null &&
        purpose!.isNotEmpty) {
      query["purpose"] = purpose!;
    }

    if (type != null &&
        type!.isNotEmpty) {
      query["type"] = type!;
    }

    if (minPrice != null) {
      query["minPrice"] =
          minPrice!.toString();
    }

    if (maxPrice != null) {
      query["maxPrice"] =
          maxPrice!.toString();
    }

    if (priceNegotiable != null) {
      query["priceNegotiable"] =
          priceNegotiable.toString();
    }

    if (minBedrooms != null) {
      query["minBedrooms"] =
          minBedrooms.toString();
    }

    if (maxBedrooms != null) {
      query["maxBedrooms"] =
          maxBedrooms.toString();
    }

    if (minBathrooms != null) {
      query["minBathrooms"] =
          minBathrooms.toString();
    }

    if (maxBathrooms != null) {
      query["maxBathrooms"] =
          maxBathrooms.toString();
    }

    if (minArea != null) {
      query["minArea"] =
          minArea.toString();
    }

    if (maxArea != null) {
      query["maxArea"] =
          maxArea.toString();
    }

    if (furnishingStatus != null &&
        furnishingStatus!.isNotEmpty) {
      query["furnishingStatus"] =
          furnishingStatus!;
    }

    if (municipality != null &&
        municipality!.isNotEmpty) {
      query["municipality"] =
          municipality!;
    }

    if (areaName != null &&
        areaName!.isNotEmpty) {
      query["areaName"] =
          areaName!;
    }

    if (sortBy != null &&
        sortBy!.isNotEmpty) {
      query["sortBy"] = sortBy!;
    }

    if (sortOrder != null &&
        sortOrder!.isNotEmpty) {
      query["sortOrder"] =
          sortOrder!;
    }

    // ==========================================================
    // API
    // ==========================================================

    final uri = Uri.parse(
      ApiEndpoints.mypropertyList,
    ).replace(
      queryParameters: query,
    );

    debugPrint(
      "FETCH MY PROPERTIES: $uri",
    );

    final response =
        await ApiHandler.get(
      uri.toString(),
    );

    final model =
        MyPropertyModel.fromJson(
      response,
    );

    debugPrint(
      "MY PROPERTIES RECEIVED: ${model.data.length}",
    );

    // ==========================================================
    // UPDATE LIST
    // ==========================================================

    if (loadMore) {
      final Set<String?> existingIds =
          properties
              .map((e) => e.id)
              .toSet();

      final newProperties =
          model.data.where(
        (property) {
          return !existingIds.contains(
            property.id,
          );
        },
      ).toList();

      properties.addAll(
        newProperties,
      );
    } else {
      // Replace only AFTER API succeeds.
      properties = model.data;
    }

    // ==========================================================
    // PAGINATION
    // ==========================================================

    hasMore =
        requestedPage <
        model.meta.totalPages;

    page = requestedPage + 1;

    error = "";
  } catch (e, stackTrace) {
    error = e
        .toString()
        .replaceFirst(
          "Exception: ",
          "",
        );

    debugPrint(
      "FETCH MY PROPERTIES ERROR: $e",
    );

    debugPrint(
      stackTrace.toString(),
    );
  } finally {
    isLoading = false;
    isLoadingMore = false;

    update();
  }
}
  Future<void> refreshProperties() async {
    page = 1;
    hasMore = true;
    properties.clear();
    await fetchProperties();
  }

  void applyFilters({
    String? purpose,
    String? type,
    double? minPrice,
    double? maxPrice,
    bool? priceNegotiable,
    int? minBedrooms,
    int? maxBedrooms,
    int? minBathrooms,
    int? maxBathrooms,
    double? minArea,
    double? maxArea,
    String? furnishingStatus,
    String? municipality,
    String? areaName,
    String? sortBy,
    String? sortOrder,
  }) {
    this.purpose = purpose;
    this.type = type;

    this.minPrice = minPrice;
    this.maxPrice = maxPrice;

    this.priceNegotiable = priceNegotiable;

    this.minBedrooms = minBedrooms;
    this.maxBedrooms = maxBedrooms;

    this.minBathrooms = minBathrooms;
    this.maxBathrooms = maxBathrooms;

    this.minArea = minArea;
    this.maxArea = maxArea;

    this.furnishingStatus = furnishingStatus;

    this.municipality = municipality;
    this.areaName = areaName;

    this.sortBy = sortBy;
    this.sortOrder = sortOrder;

    fetchProperties();
  }



 

  Future<bool> markAsSold(String propertyId) async {
    final String id = propertyId.trim();

    if (id.isEmpty) {
      markAsSoldError = "Property ID is missing";
      update();
      return false;
    }

    try {
      isMarkingAsSold = true;
      markAsSoldError = "";
      update();

      debugPrint("MARK AS SOLD PROPERTY ID: $id");

      final response = await ApiHandler.post(
        ApiEndpoints.markPropertyAsSold(id),
      );

      debugPrint("MARK AS SOLD RESPONSE: $response");

      /// API returns updated property
      final Property updatedProperty = Property.fromJson(response);

      /// Find property in My Properties list
      final int index = properties.indexWhere((property) => property.id == id);

      /// Replace it with updated SOLD property
      if (index != -1) {
        properties[index] = updatedProperty;
      }

      update();

      return true;
    } catch (e) {
      markAsSoldError = e.toString().replaceFirst("Exception: ", "");

      debugPrint("MARK AS SOLD ERROR: $e");

      return false;
    } finally {
      isMarkingAsSold = false;
      update();
    }
  }
}
