class MyFeaturedProperty {
  final String id;
  final String listingId;
  final String planId;
  final String location;

  final DateTime? startDate;
  final DateTime? endDate;

  final String paymentStatus;

  final String? stripePaymentIntentId;
  final String? stripeSessionId;

  final double? paidAmount;
  final double? discountApplied;

  final String? addedByAdminId;
  final String createdById;

  final DateTime? createdAt;
  final DateTime? updatedAt;

  final FeaturedPlan plan;
  final FeaturedListing listing;

  const MyFeaturedProperty({
    required this.id,
    required this.listingId,
    required this.planId,
    required this.location,
    this.startDate,
    this.endDate,
    required this.paymentStatus,
    this.stripePaymentIntentId,
    this.stripeSessionId,
    this.paidAmount,
    this.discountApplied,
    this.addedByAdminId,
    required this.createdById,
    this.createdAt,
    this.updatedAt,
    required this.plan,
    required this.listing,
  });

  factory MyFeaturedProperty.fromJson(
    Map<String, dynamic> json,
  ) {
    return MyFeaturedProperty(
      id: json['id']?.toString() ?? '',

      listingId:
          json['listingId']?.toString() ?? '',

      planId:
          json['planId']?.toString() ?? '',

      location:
          json['location']?.toString() ?? '',

      startDate:
          _parseDate(json['startDate']),

      endDate:
          _parseDate(json['endDate']),

      paymentStatus:
          json['paymentStatus']?.toString() ?? '',

      stripePaymentIntentId:
          json['stripePaymentIntentId']
              ?.toString(),

      stripeSessionId:
          json['stripeSessionId']?.toString(),

      paidAmount:
          _toNullableDouble(json['paidAmount']),

      discountApplied:
          _toNullableDouble(
            json['discountApplied'],
          ),

      addedByAdminId:
          json['addedByAdminId']?.toString(),

      createdById:
          json['createdById']?.toString() ?? '',

      createdAt:
          _parseDate(json['createdAt']),

      updatedAt:
          _parseDate(json['updatedAt']),

      plan: json['plan'] is Map
          ? FeaturedPlan.fromJson(
              Map<String, dynamic>.from(
                json['plan'],
              ),
            )
          : const FeaturedPlan.empty(),

      listing: json['listing'] is Map
          ? FeaturedListing.fromJson(
              Map<String, dynamic>.from(
                json['listing'],
              ),
            )
          : const FeaturedListing.empty(),
    );
  }

  // ============================================================
  // HELPERS FOR UI
  // ============================================================

  bool get isPaid =>
      paymentStatus.toUpperCase() == 'PAID';

  bool get isFailed =>
      paymentStatus.toUpperCase() == 'FAILED';

  bool get isExpired {
    if (endDate == null) {
      return false;
    }

    return DateTime.now().isAfter(endDate!);
  }

  bool get isCurrentlyActive {
    return isPaid && !isExpired;
  }

  int get remainingDays {
    if (endDate == null) {
      return 0;
    }

    final difference = endDate!.difference(
      DateTime.now(),
    );

    if (difference.isNegative) {
      return 0;
    }

    return difference.inDays;
  }

  String get locationLabel {
    return _formatEnum(location);
  }

  String get paymentStatusLabel {
    return _formatEnum(paymentStatus);
  }

  String get formattedPaidAmount {
    if (paidAmount == null) {
      return '-';
    }

    if (paidAmount ==
        paidAmount!.roundToDouble()) {
      return 'QAR ${paidAmount!.toInt()}';
    }

    return 'QAR ${paidAmount!.toStringAsFixed(2)}';
  }
}

// ============================================================
// FEATURED PLAN
// ============================================================

class FeaturedPlan {
  final String id;
  final String name;
  final List<String> locations;

  final String duration;
  final int durationDays;

  final double price;
  final bool isActive;

  final DateTime? createdAt;
  final DateTime? updatedAt;

  const FeaturedPlan({
    required this.id,
    required this.name,
    required this.locations,
    required this.duration,
    required this.durationDays,
    required this.price,
    required this.isActive,
    this.createdAt,
    this.updatedAt,
  });

  const FeaturedPlan.empty()
      : id = '',
        name = '',
        locations = const [],
        duration = '',
        durationDays = 0,
        price = 0,
        isActive = false,
        createdAt = null,
        updatedAt = null;

  factory FeaturedPlan.fromJson(
    Map<String, dynamic> json,
  ) {
    return FeaturedPlan(
      id: json['id']?.toString() ?? '',

      name: json['name']?.toString() ?? '',

      locations:
          (json['locations'] as List? ?? [])
              .map(
                (item) => item.toString(),
              )
              .toList(),

      duration:
          json['duration']?.toString() ?? '',

      durationDays:
          _toInt(json['durationDays']),

      price:
          _toDouble(json['price']),

      isActive:
          json['isActive'] == true,

      createdAt:
          _parseDate(json['createdAt']),

      updatedAt:
          _parseDate(json['updatedAt']),
    );
  }

  String get durationLabel {
    return _formatEnum(duration);
  }

  String get formattedPrice {
    if (price == price.roundToDouble()) {
      return 'QAR ${price.toInt()}';
    }

    return 'QAR ${price.toStringAsFixed(2)}';
  }
}

// ============================================================
// FEATURED LISTING
// ============================================================

class FeaturedListing {
  final String id;
  final String propertyName;

  /// API can return null
  final String? slug;

  final String status;

  const FeaturedListing({
    required this.id,
    required this.propertyName,
    this.slug,
    required this.status,
  });

  const FeaturedListing.empty()
      : id = '',
        propertyName = '',
        slug = null,
        status = '';

  factory FeaturedListing.fromJson(
    Map<String, dynamic> json,
  ) {
    return FeaturedListing(
      id: json['id']?.toString() ?? '',

      propertyName:
          json['propertyName']?.toString() ??
              'Property',

      slug: json['slug']?.toString(),

      status:
          json['status']?.toString() ?? '',
    );
  }

  String get statusLabel {
    return _formatEnum(status);
  }
}

// ============================================================
// PARSING HELPERS
// ============================================================

int _toInt(dynamic value) {
  if (value == null) {
    return 0;
  }

  if (value is int) {
    return value;
  }

  if (value is num) {
    return value.toInt();
  }

  return int.tryParse(
        value.toString(),
      ) ??
      0;
}

double _toDouble(dynamic value) {
  if (value == null) {
    return 0;
  }

  if (value is double) {
    return value;
  }

  if (value is num) {
    return value.toDouble();
  }

  return double.tryParse(
        value.toString(),
      ) ??
      0;
}

double? _toNullableDouble(
  dynamic value,
) {
  if (value == null) {
    return null;
  }

  if (value is double) {
    return value;
  }

  if (value is num) {
    return value.toDouble();
  }

  return double.tryParse(
    value.toString(),
  );
}

DateTime? _parseDate(dynamic value) {
  if (value == null) {
    return null;
  }

  final text = value.toString().trim();

  if (text.isEmpty) {
    return null;
  }

  return DateTime.tryParse(text);
}

String _formatEnum(String value) {
  if (value.trim().isEmpty) {
    return '';
  }

  return value
      .replaceAll('_', ' ')
      .trim()
      .toLowerCase()
      .split(' ')
      .where(
        (word) => word.isNotEmpty,
      )
      .map(
        (word) =>
            '${word[0].toUpperCase()}'
            '${word.substring(1)}',
      )
      .join(' ');
}