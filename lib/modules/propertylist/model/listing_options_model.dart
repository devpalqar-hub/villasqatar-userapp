class ListingOptionsModel {
  final List<String> amenities;
  final List<String> nearbyTags;
  final List<String> furnishingOptions;
  final List<String> areaSuggestions;

  ListingOptionsModel({
    required this.amenities,
    required this.nearbyTags,
    required this.furnishingOptions,
    required this.areaSuggestions,
  });

  factory ListingOptionsModel.fromJson(Map<String, dynamic> json) {
    return ListingOptionsModel(
      amenities: List<String>.from(json["amenities"] ?? []),
      nearbyTags: List<String>.from(json["nearbyTags"] ?? []),
      furnishingOptions: List<String>.from(
        json["furnishingOptions"] ?? [],
      ),
      areaSuggestions: List<String>.from(
        json["areaSuggestions"] ?? [],
      ),
    );
  }
}