/// Models for the `GET /api/listings/options` response.
///
/// Response shape:
/// {
///   "amenities": [...],
///   "nearbyTags": [...],
///   "furnishingOptions": [...],
///   "listingTypes": [...],
///   "municipalities": [...]
/// }

class ListingOptions {
  final List<OptionItem> amenities;
  final List<OptionItem> nearbyTags;
  final List<OptionItem> furnishingOptions;
  final List<OptionItem> listingTypes;
  final List<Municipality> municipalities;

  ListingOptions({
    required this.amenities,
    required this.nearbyTags,
    required this.furnishingOptions,
    required this.listingTypes,
    required this.municipalities,
  });

  factory ListingOptions.fromJson(Map<String, dynamic> json) {
    return ListingOptions(
      amenities: (json['amenities'] as List<dynamic>? ?? [])
          .map((e) => OptionItem.fromJson(e as Map<String, dynamic>))
          .toList(),
      nearbyTags: (json['nearbyTags'] as List<dynamic>? ?? [])
          .map((e) => OptionItem.fromJson(e as Map<String, dynamic>))
          .toList(),
      furnishingOptions: (json['furnishingOptions'] as List<dynamic>? ?? [])
          .map((e) => OptionItem.fromJson(e as Map<String, dynamic>))
          .toList(),
      listingTypes: (json['listingTypes'] as List<dynamic>? ?? [])
          .map((e) => OptionItem.fromJson(e as Map<String, dynamic>))
          .toList(),
      municipalities: (json['municipalities'] as List<dynamic>? ?? [])
          .map((e) => Municipality.fromJson(e as Map<String, dynamic>))
          .toList(),
    );
  }

  factory ListingOptions.empty() => ListingOptions(
    amenities: [],
    nearbyTags: [],
    furnishingOptions: [],
    listingTypes: [],
    municipalities: [],
  );
}

/// Shared shape for amenities / nearbyTags / furnishingOptions / listingTypes.
class OptionItem {
  final String id;
  final String title;
  final String? image;
  final String? propertyCount;

  OptionItem({
    required this.id,
    required this.title,
    this.image,
    this.propertyCount,
  });

  factory OptionItem.fromJson(Map<String, dynamic> json) {
    return OptionItem(
      id: json['id']?.toString() ?? '',
      title: json['title']?.toString() ?? '',
      image: json['image']?.toString(),
      propertyCount: json["propertyCount"] ?? "1",
    );
  }
}

class Municipality {
  final String id;
  final String name;
  final String? image;
  final double? latitude;
  final double? longitude;
  final bool isPopular;

  Municipality({
    required this.id,
    required this.name,
    this.image,
    this.latitude,
    this.longitude,
    this.isPopular = false,
  });

  factory Municipality.fromJson(Map<String, dynamic> json) {
    return Municipality(
      id: json['id']?.toString() ?? '',
      name: json['name']?.toString() ?? '',
      image: json['image']?.toString(),
      latitude: (json['latitude'] as num?)?.toDouble(),
      longitude: (json['longitude'] as num?)?.toDouble(),
      isPopular: json['isPopular'] == true,
    );
  }
}
