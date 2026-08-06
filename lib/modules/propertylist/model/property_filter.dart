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