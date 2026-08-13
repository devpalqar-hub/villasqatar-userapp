import 'package:flutter/material.dart';
import 'package:get/get.dart';

import 'package:villas_qatar/Core/network/api_endpoints.dart';
import 'package:villas_qatar/Core/network/api_handler.dart';
import 'package:villas_qatar/modules/PlansandFeatures/model/featured_property_model.dart'
    hide FeaturedListing;
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
        'Invalid featured properties response'.tr,
      );
    }

    final List<MyFeaturedProperty> parsed = response
        .whereType<Map>()
        .map(
          (item) =>
              MyFeaturedProperty.fromJson(
            Map<String, dynamic>.from(item),
          ),
        )
        .toList();

    myFeaturedProperties = _dedupeMyFeaturedProperties(parsed);

    debugPrint(
      'PARSED COUNT: '
      '${parsed.length} '
      '(${myFeaturedProperties.length} after dedupe)',
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

// ============================================================
// DEDUPE MY FEATURED PROPERTIES
//
// The backend has occasionally returned two rows for the same
// checkout (e.g. a retried Stripe webhook re-inserting instead of
// updating), which showed up as the same boost purchase listed
// twice. Collapse rows that share a Stripe session - that's an
// unambiguous "same purchase attempt" key, unlike listingId/planId
// which a genuine repeat purchase would also share. Falls back to
// `id` for the (should-be-impossible) case of a row with no
// stripeSessionId at all, so at least literal duplicate entries
// still collapse.
//
// When a purchase has duplicate rows, keep the one that best
// reflects its real outcome: PAID over anything else, otherwise
// the most recently updated row.
// ============================================================

List<MyFeaturedProperty> _dedupeMyFeaturedProperties(
  List<MyFeaturedProperty> entries,
) {
  final List<MyFeaturedProperty> bySession = _collapseByKey(
    entries,
    keyOf: (entry) => entry.stripeSessionId?.isNotEmpty == true
        ? 'session:${entry.stripeSessionId}'
        : 'id:${entry.id}',
  );

  // Second pass: a retried webhook can create a *different* Stripe
  // session for the same purchase instead of reusing the first one,
  // which the pass above can't catch. Rows for the same listing+plan
  // created within a few minutes of each other are treated as the
  // same purchase attempt - a genuine renewal of the same plan
  // happens hours/days later, not seconds apart.
  const Duration sameAttemptWindow = Duration(minutes: 15);

  final List<MyFeaturedProperty> sorted = List.of(bySession)
    ..sort(
      (a, b) => (a.createdAt ?? DateTime(0))
          .compareTo(b.createdAt ?? DateTime(0)),
    );

  final List<MyFeaturedProperty> result = [];

  for (final entry in sorted) {
    final int existingIndex = result.indexWhere((kept) {
      if (kept.listingId != entry.listingId ||
          kept.planId != entry.planId) {
        return false;
      }

      final DateTime? a = kept.createdAt;
      final DateTime? b = entry.createdAt;

      if (a == null || b == null) {
        // No timestamp to compare - treat missing-timestamp rows for
        // the same listing+plan as the same attempt rather than risk
        // showing an un-collapsible duplicate.
        return true;
      }

      return b.difference(a).abs() <= sameAttemptWindow;
    });

    if (existingIndex == -1) {
      result.add(entry);
      continue;
    }

    final MyFeaturedProperty existing = result[existingIndex];

    final bool entryIsBetter = entry.isPaid && !existing.isPaid ||
        (entry.isPaid == existing.isPaid &&
            (entry.updatedAt ?? DateTime(0))
                .isAfter(existing.updatedAt ?? DateTime(0)));

    if (entryIsBetter) {
      result[existingIndex] = entry;
    }
  }

  return result;
}

List<MyFeaturedProperty> _collapseByKey(
  List<MyFeaturedProperty> entries, {
  required String Function(MyFeaturedProperty entry) keyOf,
}) {
  final Map<String, MyFeaturedProperty> byKey = {};
  final List<String> order = [];

  for (final entry in entries) {
    final String key = keyOf(entry);

    final MyFeaturedProperty? existing = byKey[key];

    if (existing == null) {
      byKey[key] = entry;
      order.add(key);
      continue;
    }

    final bool entryIsBetter = entry.isPaid && !existing.isPaid ||
        (entry.isPaid == existing.isPaid &&
            (entry.updatedAt ?? DateTime(0))
                .isAfter(existing.updatedAt ?? DateTime(0)));

    if (entryIsBetter) {
      byKey[key] = entry;
    }
  }

  return order.map((key) => byKey[key]!).toList();
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
          'Invalid featured properties response'.tr,
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
  // MY FEATURED PROPERTIES — GROUPED BY PLAN
  //
  // ONE ENTRY PER PLAN, EACH CARRYING EVERY PROPERTY THAT
  // WAS FEATURED UNDER THAT PLAN.
  // ============================================================

  List<GroupedFeaturedPlan>
      get groupedFilteredMyFeaturedProperties {
    final List<MyFeaturedProperty> source =
        filteredMyFeaturedProperties;

    final Map<String, List<MyFeaturedProperty>> byPlan = {};

    final List<String> order = [];

    for (final property in source) {
      final String key = property.plan.id.isNotEmpty
          ? property.plan.id
          : property.planId;

      if (!byPlan.containsKey(key)) {
        byPlan[key] = [];
        order.add(key);
      }

      byPlan[key]!.add(property);
    }

    return order.map((key) {
      final entries = byPlan[key]!;

      return GroupedFeaturedPlan(
        plan: entries.first.plan,
        entries: entries,
      );
    }).toList();
  }

  // ============================================================
  // SEARCHED FEATURED PLANS
  // ============================================================
}

// ============================================================
// GROUPED FEATURED PLAN
//
// ONE PLAN, WITH EVERY PROPERTY FEATURED UNDER IT.
// ============================================================

class GroupedFeaturedPlan {
  final FeaturedPlan plan;
  final List<MyFeaturedProperty> entries;

  const GroupedFeaturedPlan({
    required this.plan,
    required this.entries,
  });

  bool get hasActivePlan =>
      entries.any((entry) => entry.isCurrentlyActive);
}