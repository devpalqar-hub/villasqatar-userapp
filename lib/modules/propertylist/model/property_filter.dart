class PropertyFilter {
  String search = '';

  String type = '';
  String purpose = '';

  String? locationId;

  String furnishingId = '';

  // Single nearby tag (for API if needed)
  String nearbyTagId = '';

  // Multiple selections
  List<String> amenities = [];
  List<String> nearbyTags = [];

  double? minPrice;
  double? maxPrice;

  int? minBedrooms;
  int? minBathrooms;

  double? minArea;
  double? maxArea;
  String sortBy = "";
  String sortOrder = "";
  String createdById = '';

  void clear() {
    search = '';

    type = '';
    purpose = '';

    locationId = null;

    furnishingId = '';

    nearbyTagId = '';

    amenities.clear();
    nearbyTags.clear();

    minPrice = null;
    maxPrice = null;

    minBedrooms = null;
    minBathrooms = null;

    minArea = null;
    maxArea = null;
    sortBy = "";
    sortOrder = "";
    createdById = '';
  }

  /// Number of "advanced" filters currently applied (location, furnishing,
  /// amenities, nearby tags, price/area range, bedrooms, bathrooms).
  /// Used to show a count badge on the Filters button.
  int get activeFilterCount {
    int count = 0;

    if (locationId != null && locationId!.isNotEmpty) count++;
    if (furnishingId.isNotEmpty) count++;
    if (amenities.isNotEmpty) count++;
    if (nearbyTags.isNotEmpty) count++;
    if (minPrice != null || maxPrice != null) count++;
    if (minBedrooms != null) count++;
    if (minBathrooms != null) count++;
    if (minArea != null || maxArea != null) count++;

    return count;
  }

  PropertyFilter copy() {
    return PropertyFilter()
      ..search = search
      ..type = type
      ..purpose = purpose
      ..locationId = locationId
      ..furnishingId = furnishingId
      ..nearbyTagId = nearbyTagId
      ..amenities = List<String>.from(amenities)
      ..nearbyTags = List<String>.from(nearbyTags)
      ..minPrice = minPrice
      ..maxPrice = maxPrice
      ..minBedrooms = minBedrooms
      ..minBathrooms = minBathrooms
      ..minArea = minArea
      ..maxArea = maxArea
      ..createdById = createdById
      ..sortBy = sortBy
      ..sortOrder = sortOrder;
  }
}