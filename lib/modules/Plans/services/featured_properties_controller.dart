import 'package:flutter/material.dart';
import 'package:get/get.dart';

import 'package:villas_qatar/Core/network/api_endpoints.dart';
import 'package:villas_qatar/Core/network/api_handler.dart';
import 'package:villas_qatar/modules/Plans/model/featured_property_model.dart';


enum FeaturedLocation {
  homePage('HOME_PAGE'),
  listingPage('LISTING_PAGE'),
  propertyDetailPage('PROPERTY_DETAIL_PAGE');

  final String apiValue;

  const FeaturedLocation(this.apiValue);
}

class FeaturedPropertiesController extends GetxController {
  final Map<String, List<FeaturedProperty>> _properties = {};

  final Map<String, bool> _loading = {};

  final Map<String, bool> _loadingMore = {};

  final Map<String, String> _errors = {};

  final Map<String, int> _pages = {};

  final Map<String, int> _totals = {};

  final Map<String, bool> _hasMore = {};

  // ============================================================
  // GETTERS
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
  // FETCH
  // ============================================================
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
      debugPrint(
        '🔄 FORCE REFRESH: Clearing old $key data',
      );

      _properties[key] = [];
    }
  }

  _errors[key] = '';

  update();

  try {
    // ==========================================================
    // CURRENT PAGE
    // ==========================================================

    final int currentPage =
        _pages[key] ?? 1;

    // ==========================================================
    // QUERY PARAMETERS
    // ==========================================================

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


    if (response is! Map<String, dynamic>) {
    
      throw Exception(
        'Invalid featured properties response',
      );
    }

    // ==========================================================
    // PARSE RESPONSE
    // ==========================================================

    final model =
        FeaturedPropertiesResponse.fromJson(
      response,
    );

    final List<FeaturedProperty> newItems =
        model.data;
    for (int i = 0;
        i < newItems.length;
        i++) {
      final FeaturedProperty featured =
          newItems[i];

      final FeaturedListing listing =
          featured.listing;
    }

    // ==========================================================
    // SAVE / APPEND DATA
    // ==========================================================

    if (loadMore) {
      final List<FeaturedProperty> existing =
          _properties[key] ?? [];

      final Set<String> existingIds =
          existing
              .map(
                (e) => e.listing.id,
              )
              .toSet();

      final List<FeaturedProperty>
          uniqueNewItems =
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
      _properties[key] =
          newItems;
    }

    // ==========================================================
    // TOTAL
    // ==========================================================

    _totals[key] =
        model.total;

    final int loadedCount =
        _properties[key]?.length ?? 0;

    // ==========================================================
    // HAS MORE
    // ==========================================================

    _hasMore[key] =
        loadedCount < model.total &&
        newItems.isNotEmpty;

    // ==========================================================
    // NEXT PAGE
    // ==========================================================

    if (_hasMore[key] == true) {
      _pages[key] =
          currentPage + 1;
    }
  } catch (e, stackTrace) {
    // ==========================================================
    // ERROR
    // ==========================================================

    _errors[key] =
        e
            .toString()
            .replaceFirst(
              'Exception: ',
              '',
            );
  } finally {
  
    if (loadMore) {
      _loadingMore[key] =
          false;
    } else {
      _loading[key] =
          false;
    }

    update();
  }
}

  // ============================================================
  // LOAD NEXT PAGE
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
  // REFRESH
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
}