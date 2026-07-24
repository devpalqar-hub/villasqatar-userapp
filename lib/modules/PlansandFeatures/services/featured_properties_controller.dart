import 'package:flutter/material.dart';
import 'package:get/get.dart';

import 'package:villas_qatar/Core/network/api_endpoints.dart';
import 'package:villas_qatar/Core/network/api_handler.dart';
import 'package:villas_qatar/modules/PlansandFeatures/model/featured_property_model.dart';
import 'package:villas_qatar/modules/PlansandFeatures/model/myfeatured_property.dart';




enum FeaturedLocation {
  homePage('HOME_PAGE'),
  listingPage('LISTING_PAGE'),
  propertyDetailPage('PROPERTY_DETAIL_PAGE');

  final String apiValue;

  const FeaturedLocation(this.apiValue);
}

class FeaturedPropertiesController extends GetxController {
  // ============================================================
  // FEATURED PROPERTIES
  // ============================================================

  final Map<String, List<FeaturedProperty>> _properties = {};
  final Map<String, bool> _loading = {};
  final Map<String, bool> _loadingMore = {};
  final Map<String, String> _errors = {};
  final Map<String, int> _pages = {};
  final Map<String, int> _totals = {};
  final Map<String, bool> _hasMore = {};

  // ============================================================
  // MY FEATURED PLANS
  // GET /api/featured-plans
  // ============================================================

List<FeaturedProperty> featuredProperties = [];

List<MyFeaturedProperty> MyfeaturedProperties = [];

  bool isFeaturedPlansLoading = false;

  String featuredPlansError = '';

  String featuredPlansSearch = '';

  // ============================================================
  // FEATURED PROPERTY GETTERS
  // ============================================================

  List<FeaturedProperty> getProperties(
    FeaturedLocation location,
  ) {
    return _properties[location.apiValue] ?? [];
  }

  bool isLoading(
    FeaturedLocation location,
  ) {
    return _loading[location.apiValue] ?? false;
  }

  bool isLoadingMore(
    FeaturedLocation location,
  ) {
    return _loadingMore[location.apiValue] ?? false;
  }

  bool hasMore(
    FeaturedLocation location,
  ) {
    return _hasMore[location.apiValue] ?? true;
  }

  String getError(
    FeaturedLocation location,
  ) {
    return _errors[location.apiValue] ?? '';
  }

  int getTotal(
    FeaturedLocation location,
  ) {
    return _totals[location.apiValue] ?? 0;
  }

  // ============================================================
  // EASY PAGE GETTERS
  // ============================================================

  List<FeaturedProperty> get homeProperties =>
      getProperties(
        FeaturedLocation.homePage,
      );

  List<FeaturedProperty> get listingProperties =>
      getProperties(
        FeaturedLocation.listingPage,
      );

  List<FeaturedProperty> get propertyDetailProperties =>
      getProperties(
        FeaturedLocation.propertyDetailPage,
      );

  // ============================================================
  // FETCH FEATURED PROPERTIES
  // ============================================================

  // ============================================================
// MY FEATURED PROPERTIES
// ============================================================



bool isFeaturedPropertiesLoading = false;

String featuredPropertiesError = '';

String featuredPropertiesSearch = '';
// ============================================================
// MY FEATURED PROPERTIES STATE
// ============================================================

List<MyFeaturedProperty> myFeaturedProperties = [];

bool isMyFeaturedPropertiesLoading = false;

String myFeaturedPropertiesError = '';

String myFeaturedPropertiesSearch = '';




Future<void> getMyFeaturedProperties({
  bool forceRefresh = false,
}) async {
  if (isMyFeaturedPropertiesLoading) {
    return;
  }

  if (!forceRefresh &&
      myFeaturedProperties.isNotEmpty) {
    return;
  }

  try {
    isMyFeaturedPropertiesLoading = true;
    myFeaturedPropertiesError = '';

    update();

    debugPrint(
      '========== GET MY FEATURED PROPERTIES ==========',
    );

    final dynamic response =
        await ApiHandler.get(
      ApiEndpoints.myfeaturedProperties,
    );

    debugPrint(
      'MY FEATURED PROPERTIES RESPONSE: $response',
    );

    if (response is! List) {
      throw Exception(
        'Invalid featured properties response',
      );
    }

    myFeaturedProperties = response
        .whereType<Map>()
        .map(
          (item) =>
              MyFeaturedProperty.fromJson(
            Map<String, dynamic>.from(item),
          ),
        )
        .toList();

    debugPrint(
      'PARSED COUNT: '
      '${myFeaturedProperties.length}',
    );
  } catch (e, stackTrace) {
    myFeaturedPropertiesError = e
        .toString()
        .replaceFirst(
          'Exception: ',
          '',
        );

    debugPrint(
      'GET MY FEATURED PROPERTIES ERROR: '
      '$myFeaturedPropertiesError',
    );

    debugPrintStack(
      stackTrace: stackTrace,
    );
  } finally {
    isMyFeaturedPropertiesLoading = false;

    update();
  }
}
  Future<void> fetchFeaturedProperties({
    required FeaturedLocation location,
    int limit = 5,
    bool loadMore = false,
    bool forceRefresh = false,
  }) async {
    final String key = location.apiValue;

    if (loadMore) {
      if (_loadingMore[key] ?? false) {
        return;
      }

      if (!(_hasMore[key] ?? true)) {
        return;
      }

      _loadingMore[key] = true;
    } else {
      if (_loading[key] ?? false) {
        return;
      }

      if (!forceRefresh &&
          (_properties[key]?.isNotEmpty ?? false)) {
        return;
      }

      _loading[key] = true;
      _pages[key] = 1;
      _hasMore[key] = true;

      if (forceRefresh) {
        _properties[key] = [];
      }
    }

    _errors[key] = '';

    update();

    try {
      final int currentPage =
          _pages[key] ?? 1;

      final query = <String, String>{
        'location': key,
        'page': currentPage.toString(),
        'limit': limit.toString(),
      };

      final uri = Uri.parse(
        ApiEndpoints.featuredProperties,
      ).replace(
        queryParameters: query,
      );

      final response =
          await ApiHandler.get(
        uri.toString(),
      );

      if (response
          is! Map<String, dynamic>) {
        throw Exception(
          'Invalid featured properties response',
        );
      }

      final model =
          FeaturedPropertiesResponse.fromJson(
        response,
      );

      final List<FeaturedProperty>
          newItems = model.data;

      if (loadMore) {
        final List<FeaturedProperty>
            existing =
            _properties[key] ?? [];

        final Set<String> existingIds =
            existing
                .map(
                  (e) => e.listing.id,
                )
                .toSet();

        final uniqueNewItems =
            newItems.where(
          (item) {
            return !existingIds.contains(
              item.listing.id,
            );
          },
        ).toList();

        _properties[key] = [
          ...existing,
          ...uniqueNewItems,
        ];
      } else {
        _properties[key] = newItems;
      }

      _totals[key] = model.total;

      final int loadedCount =
          _properties[key]?.length ?? 0;

      _hasMore[key] =
          loadedCount < model.total &&
              newItems.isNotEmpty;

      if (_hasMore[key] == true) {
        _pages[key] =
            currentPage + 1;
      }
    } catch (e) {
      _errors[key] = e
          .toString()
          .replaceFirst(
            'Exception: ',
            '',
          );
    } finally {
      if (loadMore) {
        _loadingMore[key] = false;
      } else {
        _loading[key] = false;
      }

      update();
    }
  }

  // ============================================================
  // LOAD MORE FEATURED PROPERTIES
  // ============================================================

  Future<void> loadMore({
    required FeaturedLocation location,
    int limit = 5,
  }) async {
    await fetchFeaturedProperties(
      location: location,
      limit: limit,
      loadMore: true,
    );
  }

  // ============================================================
  // REFRESH FEATURED PROPERTIES
  // ============================================================

  Future<void> refreshFeatured({
    required FeaturedLocation location,
    int limit = 5,
  }) async {
    await fetchFeaturedProperties(
      location: location,
      limit: limit,
      forceRefresh: true,
    );
  }

  // ============================================================
  // MY FEATURED PLANS
  //
  // NO LOCATION
  // NO PAGINATION
  // NO FILTER
  //
  // GET /api/featured-plans
  // ============================================================

  
  // ============================================================
  // MY FEATURED PLANS SEARCH
  // LOCAL SEARCH - NO API FILTER
  // ============================================================

  void searchMyFeaturedPlans(
    String value,
  ) {
    featuredPlansSearch =
        value.trim();

    update();
  }

  void clearMyFeaturedPlansSearch() {
    featuredPlansSearch = '';

    update();
  }

void clearMyFeaturedPropertiesSearch() {
  if (myFeaturedPropertiesSearch.isEmpty) {
    return;
  }

  myFeaturedPropertiesSearch = '';

  update();
}


void searchMyFeaturedProperties(
  String value,
) {
  myFeaturedPropertiesSearch =
      value.trim();

  update();
}

Future<void>
    refreshMyFeaturedProperties() async {
  await getMyFeaturedProperties(
    forceRefresh: true,
  );
}

// ============================================================
// FILTERED MY FEATURED PROPERTIES
// ============================================================

List<MyFeaturedProperty> get filteredMyFeaturedProperties {
  final String query =
      myFeaturedPropertiesSearch.trim().toLowerCase();

  if (query.isEmpty) {
    return myFeaturedProperties;
  }

  return myFeaturedProperties.where((property) {
    final listing = property.listing;
    final plan = property.plan;

    return listing.propertyName
            .toLowerCase()
            .contains(query) ||
        listing.status
            .toLowerCase()
            .contains(query) ||
        (listing.slug ?? '')
            .toLowerCase()
            .contains(query) ||
        plan.name
            .toLowerCase()
            .contains(query) ||
        plan.duration
            .toLowerCase()
            .contains(query) ||
        property.location
            .toLowerCase()
            .contains(query) ||
        property.paymentStatus
            .toLowerCase()
            .contains(query);
  }).toList();
}

  // ============================================================
  // SEARCHED FEATURED PLANS
  // ============================================================
}