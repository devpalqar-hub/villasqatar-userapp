import 'package:get/get.dart';
import 'package:villas_qatar/Core/network/api_endpoints.dart';
import 'package:villas_qatar/Core/network/api_handler.dart';
import 'package:villas_qatar/modules/propertylist/model/myproperty_model.dart';

class PropertySearchController extends GetxController {
  
  bool isLoading = false;
  bool isLoadingMore = false;
  bool hasMore = true;

  String error = "";

  int page = 1;
  final int limit = 12;

  List<Property> properties = [];
  Meta? meta;

  // Search & Filters
  String search = "";
  String type = "";
  String purpose = "";
  String furnishingStatus = "";
  String nearbyTag = "";

  double? minPrice;
  int? minBedrooms;
  int? minBathrooms;
  double? minArea;
  double? maxPrice;
  double? maxArea;
  List<String> furnishingOptions = [];
  List<String> nearbyTags = [];
  bool isDetailsLoading = false;
  Property? selectedProperty;
  String detailsError = "";
  @override
  void onInit() {
    super.onInit();
    fetchProperties();
  }
  

  Future<void> fetchProperties({bool loadMore = false}) async {
    if (loadMore) {
      if (isLoadingMore || !hasMore) return;
      isLoadingMore = true;
    } else {
      isLoading = true;
      page = 1;
      hasMore = true;
      error = "";
      properties.clear();
    }

    update();

    try {
      final query = <String, String>{
        "page": page.toString(),
        "limit": limit.toString(),
      };

      if (search.isNotEmpty) {
        query["search"] = search;
      }

      if (type.isNotEmpty) {
        query["type"] = type;
      }

      if (purpose.isNotEmpty) {
        query["purpose"] = purpose;
      }

      if (furnishingStatus.isNotEmpty) {
        query["furnishingStatus"] = furnishingStatus;
      }

      if (nearbyTag.isNotEmpty) {
        query["nearbyTag"] = nearbyTag;
      }

      if (minPrice != null) {
        query["minPrice"] = minPrice!.toString();
      }

      if (minBedrooms != null) {
        query["minBedrooms"] = minBedrooms.toString();
      }

      if (minBathrooms != null) {
        query["minBathrooms"] = minBathrooms.toString();
      }

      if (minArea != null) {
        query["minArea"] = minArea!.toString();
      }

      final endpoint =
          "${ApiEndpoints.propertyList}?${Uri(queryParameters: query).query}";

      final response = await ApiHandler.get(endpoint);

      final model = MyPropertyModel.fromJson(response);

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
      error = e.toString();
    } finally {
      isLoading = false;
      isLoadingMore = false;
      update();
    }
  }
  
  
  Future<void> refreshProperties() async {
    await fetchProperties();
  }

 
  
  void searchProperty(String value) {
  search = value.trim();
  fetchProperties();
}

bool _initialSearchApplied = false;

void applyInitialSearch(String? value) {
  if (_initialSearchApplied) return;

  final query = value?.trim() ?? "";

  if (query.isEmpty) return;

  _initialSearchApplied = true;

  search = query;

  fetchProperties();
}

  void applyFilters({
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
  }) {
    this.search = search ?? this.search;
    this.type = type ?? this.type;
    this.purpose = purpose ?? this.purpose;
    this.furnishingStatus = furnishingStatus ?? this.furnishingStatus;
    this.nearbyTag = nearbyTag ?? this.nearbyTag;

    this.minPrice = minPrice;
    this.maxPrice = maxPrice;
    this.minBedrooms = minBedrooms;
    this.minBathrooms = minBathrooms;
    this.minArea = minArea;
    this.maxArea = maxArea;

    fetchProperties();
  }

  void resetSearch() {
    search = "";
    type = "";
    purpose = "";
    furnishingStatus = "";
    nearbyTag = "";

    minPrice = null;
    maxPrice = null;
    minBedrooms = null;
    minBathrooms = null;
    minArea = null;
    maxArea = null;

    update();
  }

  void clearFilters() {
    search = "";
    type = "";
    purpose = "";
    furnishingStatus = "";
    nearbyTag = "";

    minPrice = null;
    minBedrooms = null;
    minBathrooms = null;
    minArea = null;

    fetchProperties();
  }

  Future<void> fetchPropertyDetails(String propertyId) async {
  try {
    isDetailsLoading = true;
    detailsError = "";
    selectedProperty = null;
    update();

    final response = await ApiHandler.get(
      "${ApiEndpoints.propertyList}/$propertyId",
    );

    selectedProperty = Property.fromJson(response);
  } catch (e) {
    detailsError = e.toString();
  } finally {
    isDetailsLoading = false;
    update();
  }
}
void clearPropertyDetails() {
  selectedProperty = null;
  detailsError = "";
  update();
}
}
