class MyPropertyModel {
  final List<Property> data;
  final Meta meta;

  const MyPropertyModel({
    required this.data,
    required this.meta,
  });

  factory MyPropertyModel.fromJson(Map<String, dynamic> json) {
    return MyPropertyModel(
      data: (json["data"] as List? ?? [])
          .map((e) => Property.fromJson(e))
          .toList(),
      meta: Meta.fromJson(json["meta"] ?? {}),
    );
  }
}

class Property {
  final String id;
  final String referenceCode;
  final String slug;
  final String propertyName;
  final String description;
  final String purpose;

  final String typeId;
  final ListingType type;

  final double latitude;
  final double longitude;

  final bool isPotentialDuplicate;
  final String? duplicateOfId;

  final int bedrooms;
  final int bathrooms;
  final double area;
  final int livingRooms;
  final int parkingSpaces;
  final int floorNumber;
  final int totalFloors;
  final int? yearBuilt;

  final String furnishingId;
  final Furnishing furnishing;

  final Map<String, dynamic> extraProperties;

  final double price;
  final bool priceNegotiable;

  final String addressLine1;
  final String addressLine2;
  final String areaName;

  final String municipalityId;
  final Municipality municipality;

  final String country;

  final String contactPhone;
  final String contactWhatsapp;
  final bool contactVerified;

  final List<Amenity> amenities;
  final List<NearbyTag> nearbyTags;

  final String otherFeatures;

  final String status;
  final int submissionCount;

  final DateTime createdAt;
  final DateTime updatedAt;

  final CreatedBy createdBy;

  final List<Photo> photos;

  final List<Review> reviews;
  final Review? latestReview;

  final bool isWishlisted;
  final bool isFeatured;

  final String? rejectionReason;

  const Property({
    required this.id,
    required this.referenceCode,
    required this.slug,
    required this.propertyName,
    required this.description,
    required this.purpose,
    required this.typeId,
    required this.type,
    required this.latitude,
    required this.longitude,
    required this.isPotentialDuplicate,
    required this.duplicateOfId,
    required this.bedrooms,
    required this.bathrooms,
    required this.area,
    required this.livingRooms,
    required this.parkingSpaces,
    required this.floorNumber,
    required this.totalFloors,
    required this.yearBuilt,
    required this.furnishingId,
    required this.furnishing,
    required this.extraProperties,
    required this.price,
    required this.priceNegotiable,
    required this.addressLine1,
    required this.addressLine2,
    required this.areaName,
    required this.municipalityId,
    required this.municipality,
    required this.country,
    required this.contactPhone,
    required this.contactWhatsapp,
    required this.contactVerified,
    required this.amenities,
    required this.nearbyTags,
    required this.otherFeatures,
    required this.status,
    required this.submissionCount,
    required this.createdAt,
    required this.updatedAt,
    required this.createdBy,
    required this.photos,
    required this.reviews,
    required this.latestReview,
    required this.isWishlisted,
    required this.isFeatured,
    required this.rejectionReason,
  });

  factory Property.fromJson(Map<String, dynamic> json) {
    return Property(
      id: json["id"] ?? "",
      referenceCode: json["referenceCode"] ?? "",
      slug: json["slug"] ?? "",
      propertyName: json["propertyName"] ?? "",
      description: json["description"] ?? "",
      purpose: json["purpose"] ?? "",

      typeId: json["typeId"] ?? "",
      type: ListingType.fromJson(json["type"] ?? {}),

      latitude: (json["latitude"] ?? 0).toDouble(),
      longitude: (json["longitude"] ?? 0).toDouble(),

      isPotentialDuplicate: json["isPotentialDuplicate"] ?? false,
      duplicateOfId: json["duplicateOfId"],

      bedrooms: json["bedrooms"] ?? 0,
      bathrooms: json["bathrooms"] ?? 0,
      area: (json["area"] ?? 0).toDouble(),
      livingRooms: json["livingRooms"] ?? 0,
      parkingSpaces: json["parkingSpaces"] ?? 0,
      floorNumber: json["floorNumber"] ?? 0,
      totalFloors: json["totalFloors"] ?? 0,
      yearBuilt: json["yearBuilt"],

      furnishingId: json["furnishingId"] ?? "",
      furnishing: Furnishing.fromJson(json["furnishing"] ?? {}),

      extraProperties:
          Map<String, dynamic>.from(json["extraProperties"] ?? {}),

      price: (json["price"] ?? 0).toDouble(),
      priceNegotiable: json["priceNegotiable"] ?? false,

      addressLine1: json["addressLine1"] ?? "",
      addressLine2: json["addressLine2"] ?? "",
      areaName: json["areaName"] ?? "",

      municipalityId: json["municipalityId"] ?? "",
      municipality: Municipality.fromJson(json["municipality"] ?? {}),

      country: json["country"] ?? "",

      contactPhone: json["contactPhone"] ?? "",
      contactWhatsapp: json["contactWhatsapp"] ?? "",
      contactVerified: json["contactVerified"] ?? false,

      amenities: (json["amenities"] as List? ?? [])
          .map((e) => Amenity.fromJson(e))
          .toList(),

      nearbyTags: (json["nearbyTags"] as List? ?? [])
          .map((e) => NearbyTag.fromJson(e))
          .toList(),

      otherFeatures: json["otherFeatures"] ?? "",

      status: json["status"] ?? "",
      submissionCount: json["submissionCount"] ?? 0,

      createdAt: DateTime.parse(json["createdAt"]),
      updatedAt: DateTime.parse(json["updatedAt"]),

      createdBy: CreatedBy.fromJson(json["createdBy"] ?? {}),

      photos: (json["photos"] as List? ?? [])
          .map((e) => Photo.fromJson(e))
          .toList(),

      reviews: (json["reviews"] as List? ?? [])
          .map((e) => Review.fromJson(e))
          .toList(),

      latestReview: json["latestReview"] == null
          ? null
          : Review.fromJson(json["latestReview"]),

      isWishlisted: json["isWishlisted"] ?? false,
      isFeatured: json["isFeatured"] ?? false,

      rejectionReason: json["rejectionReason"],
    );
  }

  List<Photo> get sortedPhotos {
    final list = List<Photo>.from(photos);
    list.sort((a, b) => a.sortOrder.compareTo(b.sortOrder));
    return list;
  }
}
class ListingType {
  final String id;
  final String title;

  const ListingType({
    required this.id,
    required this.title,
  });

  factory ListingType.fromJson(Map<String, dynamic> json) {
    return ListingType(
      id: json["id"] ?? "",
      title: json["title"] ?? "",
    );
  }
}

class Furnishing {
  final String id;
  final String title;

  const Furnishing({
    required this.id,
    required this.title,
  });

  factory Furnishing.fromJson(Map<String, dynamic> json) {
    return Furnishing(
      id: json["id"] ?? "",
      title: json["title"] ?? "",
    );
  }
}

class Municipality {
  final String id;
  final String name;
  final String image;
  final double latitude;
  final double longitude;

  const Municipality({
    required this.id,
    required this.name,
    required this.image,
    required this.latitude,
    required this.longitude,
  });

  factory Municipality.fromJson(Map<String, dynamic> json) {
    return Municipality(
      id: json["id"] ?? "",
      name: json["name"] ?? "",
      image: json["image"] ?? "",
      latitude: (json["latitude"] ?? 0).toDouble(),
      longitude: (json["longitude"] ?? 0).toDouble(),
    );
  }
}

class Amenity {
  final String id;
  final String title;
  final String? image;
  final DateTime? createdAt;
  final DateTime? updatedAt;

  const Amenity({
    required this.id,
    required this.title,
    this.image,
    this.createdAt,
    this.updatedAt,
  });

  factory Amenity.fromJson(Map<String, dynamic> json) {
    return Amenity(
      id: json["id"] ?? "",
      title: json["title"] ?? "",
      image: json["image"],
      createdAt: json["createdAt"] != null
          ? DateTime.parse(json["createdAt"])
          : null,
      updatedAt: json["updatedAt"] != null
          ? DateTime.parse(json["updatedAt"])
          : null,
    );
  }
}

class NearbyTag {
  final String id;
  final String title;
  final String? image;
  final DateTime? createdAt;
  final DateTime? updatedAt;

  const NearbyTag({
    required this.id,
    required this.title,
    this.image,
    this.createdAt,
    this.updatedAt,
  });

  factory NearbyTag.fromJson(Map<String, dynamic> json) {
    return NearbyTag(
      id: json["id"] ?? "",
      title: json["title"] ?? "",
      image: json["image"],
      createdAt: json["createdAt"] != null
          ? DateTime.parse(json["createdAt"])
          : null,
      updatedAt: json["updatedAt"] != null
          ? DateTime.parse(json["updatedAt"])
          : null,
    );
  }
}

class CreatedBy {
  final String id;
  final String name;
  final String email;
  final String phone;
  final String role;
  final DealerProfile? dealerProfile;

  const CreatedBy({
    required this.id,
    required this.name,
    required this.email,
    required this.phone,
    required this.role,
    this.dealerProfile,
  });

  factory CreatedBy.fromJson(Map<String, dynamic> json) {
    return CreatedBy(
      id: json["id"] ?? "",
      name: json["name"] ?? "",
      email: json["email"] ?? "",
      phone: json["phone"] ?? "",
      role: json["role"] ?? "",
      dealerProfile: json["dealerProfile"] == null
          ? null
          : DealerProfile.fromJson(json["dealerProfile"]),
    );
  }
}

class DealerProfile {
  const DealerProfile();

  factory DealerProfile.fromJson(Map<String, dynamic> json) {
    return const DealerProfile();
  }
}

class Photo {
  final String id;
  final String url;
  final String? minioKey;
  final String caption;
  final int sortOrder;
  final DateTime? uploadedAt;

  const Photo({
    required this.id,
    required this.url,
    this.minioKey,
    required this.caption,
    required this.sortOrder,
    this.uploadedAt,
  });

  factory Photo.fromJson(Map<String, dynamic> json) {
    return Photo(
      id: json["id"] ?? "",
      url: json["url"] ?? "",
      minioKey: json["minioKey"],
      caption: json["caption"] ?? "",
      sortOrder: json["sortOrder"] ?? 0,
      uploadedAt: json["uploadedAt"] != null
          ? DateTime.parse(json["uploadedAt"])
          : null,
    );
  }
}
class Review {
  final String id;
  final String action;
  final String message;
  final DateTime reviewedAt;
  final ReviewedBy reviewedBy;

  const Review({
    required this.id,
    required this.action,
    required this.message,
    required this.reviewedAt,
    required this.reviewedBy,
  });

  factory Review.fromJson(Map<String, dynamic> json) {
    return Review(
      id: json["id"] ?? "",
      action: json["action"] ?? "",
      message: json["message"] ?? "",
      reviewedAt: json["reviewedAt"] != null
          ? DateTime.parse(json["reviewedAt"])
          : DateTime.now(),
      reviewedBy: ReviewedBy.fromJson(
        json["reviewedBy"] ?? {},
      ),
    );
  }
}

class ReviewedBy {
  final String id;
  final String name;
  final String role;

  const ReviewedBy({
    required this.id,
    required this.name,
    required this.role,
  });

  factory ReviewedBy.fromJson(Map<String, dynamic> json) {
    return ReviewedBy(
      id: json["id"] ?? "",
      name: json["name"] ?? "",
      role: json["role"] ?? "",
    );
  }
}

class Meta {
  final int total;
  final int page;
  final int limit;
  final int totalPages;

  const Meta({
    required this.total,
    required this.page,
    required this.limit,
    required this.totalPages,
  });

  factory Meta.fromJson(Map<String, dynamic> json) {
    return Meta(
      total: json["total"] ?? 0,
      page: json["page"] ?? 1,
      limit: json["limit"] ?? 10,
      totalPages: json["totalPages"] ?? 1,
    );
  }
}