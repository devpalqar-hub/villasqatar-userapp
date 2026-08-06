import 'package:flutter/material.dart';
import 'package:get/get.dart';
import 'package:villas_qatar/Core/network/api_endpoints.dart';
import 'package:villas_qatar/Core/network/api_handler.dart';
import 'package:villas_qatar/Core/utils/app_location.dart';
import 'package:villas_qatar/modules/propertylist/model/myproperty_model.dart';
import 'package:villas_qatar/modules/propertylist/model/property_filter.dart';

class PropertySearchController extends GetxController {
  bool isLoading = false;
  bool isLoadingMore = false;
  bool hasMore = true;
  String error = '';
  int page = 1;
  final int limit = 12;
  List<Property> properties = [];
  Meta? meta;
  final PropertyFilter filter = PropertyFilter();
  final TextEditingController searchTextController = TextEditingController();
  bool isDetailsLoading = false;

  Property? selectedProperty;

  String detailsError = '';
  @override
  void onInit() {
    super.onInit();

    fetchProperties();
  }

  // ============================================================
  // FETCH PROPERTIES
  // ============================================================

  Future<void> fetchProperties({bool loadMore = false}) async {
    if (loadMore) {
      if (isLoadingMore || !hasMore) {
        return;
      }
      isLoadingMore = true;
    } else {
      if (isLoading) {
        return;
      }
      isLoading = true;
      page = 1;
      hasMore = true;
      error = '';
      properties.clear();
    }

    update();

    try {
      final Map<String, String> query = {
        'page': page.toString(),
        'limit': limit.toString(),
      };
      if (filter.search.isNotEmpty) {
        query['search'] = filter.search;
      }
      if (filter.createdById.isNotEmpty) {
        query['createdById'] = filter.createdById;
      }
      if (filter.type.isNotEmpty) {
        query['type'] = filter.type;
      }
      if (filter.purpose.isNotEmpty) {
        query['purpose'] = filter.purpose;
      }
      // Municipality Filter
      if (filter.locationId != null && filter.locationId!.isNotEmpty) {
        query['municipalityId'] = filter.locationId!;
      }
      if (filter.sortBy.isNotEmpty) {
        query["sortBy"] = filter.sortBy;
      }

      if (filter.sortOrder.isNotEmpty) {
        query["sortOrder"] = filter.sortOrder;
      }

      // // User Current Location
      // if (AppLocation.latitude != null) {
      //   query['latitude'] = AppLocation.latitude!.toString();
      // }

      // if (AppLocation.longitude != null) {
      //   query['longitude'] = AppLocation.longitude!.toString();
      // }
      if (filter.furnishingId.isNotEmpty) {
        query['furnishingId'] = filter.furnishingId;
      }

      // // Amenities
      // if (selectedAmenities.isNotEmpty) {
      //   query['amenityIds'] = selectedAmenities.join(',');
      // }

      // // Nearby Tags
      // if (selectedNearbyTags.isNotEmpty) {
      //   query['nearbyTagIds'] = selectedNearbyTags.join(',');
      // }

      if (filter.nearbyTagId.isNotEmpty) {
        query['nearbyTagId'] = filter.nearbyTagId;
      }
      // Price
      if (filter.minPrice != null) {
        query['minPrice'] = filter.minPrice!.toString();
      }

      if (filter.maxPrice != null) {
        query['maxPrice'] = filter.maxPrice!.toString();
      }

      // Bedrooms
      if (filter.minBedrooms != null) {
        query['minBedrooms'] = filter.minBedrooms!.toString();
      }

      // Bathrooms
      if (filter.minBathrooms != null) {
        query['minBathrooms'] = filter.minBathrooms!.toString();
      }

      // Area
      if (filter.minArea != null) {
        query['minArea'] = filter.minArea!.toString();
      }

      if (filter.maxArea != null) {
        query['maxArea'] = filter.maxArea!.toString();
      }

      final String endpoint =
          '${ApiEndpoints.propertyList}?${Uri(queryParameters: query).query}';

      debugPrint('========== PROPERTY SEARCH ==========');
      debugPrint('ENDPOINT: $endpoint');

      final response = await ApiHandler.get(endpoint);

      final MyPropertyModel model = MyPropertyModel.fromJson(response);

      if (loadMore) {
        properties.addAll(model.data);
      } else {
        properties = model.data;
      }

      meta = model.meta;

      hasMore = page < model.meta.totalPages;

      if (hasMore) {
        page++;
      }
    } catch (e) {
      error = e.toString().replaceFirst('Exception: ', '');
      debugPrint('PROPERTY SEARCH ERROR: $error');
    } finally {
      isLoading = false;
      isLoadingMore = false;
      update();
    }
  }
  //======================================================
  // SEARCH PROPERTY
  //======================================================

  Future<void> searchProperty(String value) async {
    filter.search = value.trim();

    _setSearchText(filter.search);

    await fetchProperties();
  }

  //======================================================
  // INITIAL SEARCH
  //======================================================

  Future<void> applyInitialSearch(String? value) async {
    final query = value?.trim() ?? "";

    if (query.isEmpty) return;

    filter.search = query;

    _setSearchText(query);

    update();

    await fetchProperties();
  }

  //======================================================
  // INITIAL PURPOSE
  //======================================================

  Future<void> applyInitialPurpose(String? value) async {
    final selectedPurpose = value?.trim().toUpperCase() ?? "";

    if (selectedPurpose != "SALE" && selectedPurpose != "RENT") {
      return;
    }

    filter.purpose = selectedPurpose;

    update();

    await fetchProperties();
  }

  //======================================================
  // APPLY FILTERS
  //======================================================

  Future<void> applyFilters({
    String? search,
    String? type,
    String? purpose,
    String? locationId,
    String? furnishingId,
    List<String>? amenities,
    List<String>? nearbyTags,
    double? minPrice,
    double? maxPrice,
    int? minBedrooms,
    int? minBathrooms,
    double? minArea,
    double? maxArea,
    String? createdById,
  }) async {
    if (search != null) {
      filter.search = search.trim();

      _setSearchText(filter.search);
    }

    if (type != null) {
      filter.type = type;
    }

    if (purpose != null) {
      filter.purpose = purpose;
    }

    if (locationId != null) {
      filter.locationId = locationId;
    }

    if (furnishingId != null) {
      filter.furnishingId = furnishingId;
    }

    if (amenities != null) {
      filter.amenities = List.from(amenities);
    }

    if (nearbyTags != null) {
      filter.nearbyTags = List.from(nearbyTags);
    }

    if (createdById != null) {
      filter.createdById = createdById;
    }

    filter.minPrice = minPrice;
    filter.maxPrice = maxPrice;

    filter.minBedrooms = minBedrooms;
    filter.minBathrooms = minBathrooms;

    filter.minArea = minArea;
    filter.maxArea = maxArea;

    page = 1;
    hasMore = true;

    await fetchProperties();
  }

  //======================================================
  // RESET SEARCH
  //======================================================

  Future<void> resetSearch() async {
    filter.clear();

    searchTextController.clear();

    page = 1;
    hasMore = true;

    update();

    await fetchProperties();
  }

  //======================================================
  // CLEAR FILTERS
  //======================================================

  Future<void> clearFilters() async {
    filter.clear();

    searchTextController.clear();

    page = 1;
    hasMore = true;

    update();

    await fetchProperties();
  }

  //======================================================
  // REFRESH
  //======================================================

  Future<void> refreshProperties() async {
    page = 1;

    hasMore = true;

    await fetchProperties();
  }

  //======================================================
  // RESET UI ONLY
  //======================================================

  void resetFilterUi() {
    filter.clear();

    searchTextController.clear();

    update();
  }

  void _setSearchText(String value) {
    searchTextController.value = TextEditingValue(
      text: value,
      selection: TextSelection.collapsed(offset: value.length),
    );
  }

  Future<void> fetchPropertyDetails(String propertyId) async {
    print("fetchPropertyDetails called");
    if (propertyId.trim().isEmpty) return;

    if (isDetailsLoading) return;

    try {
      isDetailsLoading = true;

      detailsError = '';

      selectedProperty = null;

      update();

      final response = await ApiHandler.get(
        '${ApiEndpoints.propertyList}/$propertyId',
      );

      selectedProperty = Property.fromJson(response);
       print("Property.fromJson called");
      print("==================================");
print(selectedProperty!.latestReview?.message);
print(selectedProperty!.rejectionReason);
print(selectedProperty!.reviews.length);
print("==================================");
    } catch (e) {
      detailsError = e.toString().replaceFirst('Exception: ', '');

      debugPrint('PROPERTY DETAILS ERROR: $detailsError');
    } finally {
      isDetailsLoading = false;

      update();
    }
  }

  // ============================================================
  Future<void> clearSearch() async {
    filter.search = '';

    searchTextController.clear();

    // Remove any selection/cursor position
    searchTextController.selection = const TextSelection.collapsed(offset: 0);

    update();

    await fetchProperties();
  }

  // ============================================================
  // CLOSE
  // ============================================================
  void clearPropertyDetails() {
    selectedProperty = null;
    detailsError = '';
    update();
  }

  @override
  void onClose() {
    searchTextController.dispose();
    super.onClose();
  }
}
