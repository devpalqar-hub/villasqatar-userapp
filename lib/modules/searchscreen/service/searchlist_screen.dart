import 'package:flutter/material.dart';
import 'package:get/get.dart';
import 'package:villas_qatar/Core/network/api_endpoints.dart';
import 'package:villas_qatar/Core/network/api_handler.dart';
import 'package:villas_qatar/modules/propertylist/model/myproperty_model.dart';

class PropertySearchController extends GetxController {
  // ============================================================
  // LOADING
  // ============================================================

  bool isLoading = false;
  bool isLoadingMore = false;
  bool hasMore = true;

  String error = '';

  // ============================================================
  // PAGINATION
  // ============================================================

  int page = 1;
  final int limit = 12;

  List<Property> properties = [];
  Meta? meta;

  // ============================================================
  // SEARCH
  // ============================================================

  final TextEditingController searchTextController =
      TextEditingController();

  String search = '';

  // ============================================================
  // FILTERS
  // ============================================================

  String type = '';
  String purpose = '';
  String furnishingStatus = '';
  String nearbyTag = '';

  double? minPrice;
  double? maxPrice;

  int? minBedrooms;
  int? minBathrooms;

  double? minArea;
  double? maxArea;

  List<String> furnishingOptions = [];
  List<String> nearbyTags = [];

  // ============================================================
  // PROPERTY DETAILS
  // ============================================================

  bool isDetailsLoading = false;

  Property? selectedProperty;

  String detailsError = '';

  // ============================================================
  // INIT
  // ============================================================

  @override
  void onInit() {
    super.onInit();

    fetchProperties();
  }

  // ============================================================
  // FETCH PROPERTIES
  // ============================================================

  Future<void> fetchProperties({
    bool loadMore = false,
  }) async {
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

      // Search
      if (search.trim().isNotEmpty) {
        query['search'] = search.trim();
      }

      // Property type
      if (type.isNotEmpty) {
        query['type'] = type;
      }

      // Purpose
      if (purpose.isNotEmpty) {
        query['purpose'] = purpose;
      }

      // Furnishing
      if (furnishingStatus.isNotEmpty) {
        query['furnishingStatus'] =
            furnishingStatus;
      }

      // Nearby
      if (nearbyTag.isNotEmpty) {
        query['nearbyTag'] = nearbyTag;
      }

      // Price
      if (minPrice != null) {
        query['minPrice'] =
            minPrice!.toString();
      }

      if (maxPrice != null) {
        query['maxPrice'] =
            maxPrice!.toString();
      }

      // Bedrooms
      if (minBedrooms != null) {
        query['minBedrooms'] =
            minBedrooms!.toString();
      }

      // Bathrooms
      if (minBathrooms != null) {
        query['minBathrooms'] =
            minBathrooms!.toString();
      }

      // Area
      if (minArea != null) {
        query['minArea'] =
            minArea!.toString();
      }

      if (maxArea != null) {
        query['maxArea'] =
            maxArea!.toString();
      }

      final String endpoint =
          '${ApiEndpoints.propertyList}'
          '?${Uri(queryParameters: query).query}';

      debugPrint(
        '========== PROPERTY SEARCH ==========',
      );

      debugPrint(
        'ENDPOINT: $endpoint',
      );

      final response =
          await ApiHandler.get(endpoint);

      final MyPropertyModel model =
          MyPropertyModel.fromJson(
        response,
      );

      if (loadMore) {
        properties.addAll(
          model.data,
        );
      } else {
        properties = model.data;
      }

      meta = model.meta;

      hasMore =
          page < model.meta.totalPages;

      if (hasMore) {
        page++;
      }
    } catch (e) {
      error = e
          .toString()
          .replaceFirst(
            'Exception: ',
            '',
          );

      debugPrint(
        'PROPERTY SEARCH ERROR: $error',
      );
    } finally {
      isLoading = false;
      isLoadingMore = false;

      update();
    }
  }

  // ============================================================
  // SEARCH PROPERTY
  // ============================================================

  Future<void> searchProperty(
    String value,
  ) async {
    final String query =
        value.trim();

    search = query;

    _setSearchText(query);

    await fetchProperties();
  }

  // ============================================================
  // INITIAL SEARCH
  // ============================================================

  Future<void> applyInitialSearch(
    String? value,
  ) async {
    final String query =
        value?.trim() ?? '';

    if (query.isEmpty) {
      return;
    }

    search = query;

    _setSearchText(query);

    update();

    await fetchProperties();
  }

  // ============================================================
  // INITIAL PURPOSE
  // ============================================================

  Future<void> applyInitialPurpose(
    String? value,
  ) async {
    final String selectedPurpose =
        value?.trim().toUpperCase() ?? '';

    if (selectedPurpose != 'SALE' &&
        selectedPurpose != 'RENT') {
      return;
    }

    purpose = selectedPurpose;

    update();

    await fetchProperties();
  }

  // ============================================================
  // APPLY FILTERS
  // ============================================================

  Future<void> applyFilters({
    String? search,
    String? type,
    String? purpose,
    String? furnishingStatus,
    String? nearbyTag,
    double? minPrice,
    double? maxPrice,
    int? minBedrooms,
    int? minBathrooms,
    double? minArea,
    double? maxArea,
  }) async {
    if (search != null) {
      this.search = search.trim();

      _setSearchText(
        this.search,
      );
    }

    if (type != null) {
      this.type = type;
    }

    if (purpose != null) {
      this.purpose = purpose;
    }

    if (furnishingStatus != null) {
      this.furnishingStatus =
          furnishingStatus;
    }

    if (nearbyTag != null) {
      this.nearbyTag = nearbyTag;
    }

    this.minPrice = minPrice;
    this.maxPrice = maxPrice;

    this.minBedrooms = minBedrooms;
    this.minBathrooms = minBathrooms;

    this.minArea = minArea;
    this.maxArea = maxArea;

    await fetchProperties();
  }

  // ============================================================
  // RESET SEARCH + FILTERS
  // ============================================================

  Future<void> resetSearch() async {
    _resetFilterValues();

    _setSearchText('');

    update();

    await fetchProperties();
  }

  // ============================================================
  // CLEAR FILTERS
  // ============================================================

  Future<void> clearFilters() async {
    _resetFilterValues();

    _setSearchText('');

    update();

    await fetchProperties();
  }

  // ============================================================
  // REFRESH
  // ============================================================

  Future<void> refreshProperties() async {
  search = '';

  searchTextController.clear();

  type = '';
  purpose = '';
  furnishingStatus = '';
  nearbyTag = '';

  minPrice = null;
  maxPrice = null;

  minBedrooms = null;
  minBathrooms = null;

  minArea = null;
  maxArea = null;

  page = 1;
  hasMore = true;

  update();

  await fetchProperties();
}

  // ============================================================
  // RESET FILTER VALUES
  // ============================================================

  void _resetFilterValues() {
    search = '';

    type = '';
    purpose = '';
    furnishingStatus = '';
    nearbyTag = '';

    minPrice = null;
    maxPrice = null;

    minBedrooms = null;
    minBathrooms = null;

    minArea = null;
    maxArea = null;
  }

  // ============================================================
  // SAFE SEARCH TEXT UPDATE
  // ============================================================

  void _setSearchText(
    String value,
  ) {
    searchTextController.value =
        TextEditingValue(
      text: value,
      selection: TextSelection.collapsed(
        offset: value.length,
      ),
    );
  }

  // ============================================================
  // PROPERTY DETAILS
  // ============================================================

  Future<void> fetchPropertyDetails(
    String propertyId,
  ) async {
    try {
      isDetailsLoading = true;

      detailsError = '';

      selectedProperty = null;

      update();

      final response =
          await ApiHandler.get(
        '${ApiEndpoints.propertyList}'
        '/$propertyId',
      );

      selectedProperty =
          Property.fromJson(
        response,
      );
    } catch (e) {
      detailsError = e
          .toString()
          .replaceFirst(
            'Exception: ',
            '',
          );
    } finally {
      isDetailsLoading = false;

      update();
    }
  }

  // ============================================================
  // CLEAR PROPERTY DETAILS
  // ============================================================
   Future<void> clearSearch() async {
  search = '';

  searchTextController.clear();

  // Remove any selection/cursor position
  searchTextController.selection =
      const TextSelection.collapsed(
    offset: 0,
  );

  update();

  await fetchProperties();
}

  void clearPropertyDetails() {
    selectedProperty = null;

    detailsError = '';

    update();
  }

  // ============================================================
  // CLOSE
  // ============================================================

  @override
  void onClose() {
    searchTextController.dispose();

    super.onClose();
  }
}