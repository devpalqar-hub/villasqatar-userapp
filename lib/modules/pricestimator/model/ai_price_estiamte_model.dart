class AiPriceEstimatorRequest {
  final String areaName;
  final double areaSqft;
  final String propertyType;
  final int bhk;
  final int bathrooms;
  final String furnishingStatus;
  final int floorAbove;
  final int totalFloors;
  final bool parkingAvailable;
  final String highlights;

  const AiPriceEstimatorRequest({
    required this.areaName,
    required this.areaSqft,
    required this.propertyType,
    required this.bhk,
    required this.bathrooms,
    required this.furnishingStatus,
    required this.floorAbove,
    required this.totalFloors,
    required this.parkingAvailable,
    required this.highlights,
  });

  Map<String, dynamic> toJson() {
    return {
      "areaName": areaName.trim(),
      "areaSqft": areaSqft,
      "propertyType": propertyType.trim(),
      "bhk": bhk,
      "bathrooms": bathrooms,
      "furnishingStatus":
          furnishingStatus.trim(),
      "floorAbove": floorAbove,
      "totalFloors": totalFloors,
      "parkingAvailable": parkingAvailable,
      "highlights": highlights.trim(),
    };
  }
}

class AiPriceEstimatorResponse {
  final double minPrice;
  final double maxPrice;
  final double averagePrice;

  const AiPriceEstimatorResponse({
    required this.minPrice,
    required this.maxPrice,
    required this.averagePrice,
  });

  factory AiPriceEstimatorResponse.fromJson(
    Map<String, dynamic> json,
  ) {
    return AiPriceEstimatorResponse(
      minPrice: _parseDouble(
        json["minPrice"],
      ),
      maxPrice: _parseDouble(
        json["maxPrice"],
      ),
      averagePrice: _parseDouble(
        json["averagePrice"],
      ),
    );
  }

  static double _parseDouble(
    dynamic value,
  ) {
    if (value == null) {
      return 0;
    }

    if (value is num) {
      return value.toDouble();
    }

    return double.tryParse(
          value.toString(),
        ) ??
        0;
  }
}