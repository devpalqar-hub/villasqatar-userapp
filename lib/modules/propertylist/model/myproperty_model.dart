class MyPropertyModel {
  final List<Property> data;
  final Meta meta;

  MyPropertyModel({required this.data, required this.meta});

  factory MyPropertyModel.fromJson(Map<String, dynamic> json) {
    return MyPropertyModel(
      data: (json["data"] as List).map((e) => Property.fromJson(e)).toList(),
      meta: Meta.fromJson(json["meta"]),
    );
  }
}

class Property {
  final String id;
  final String slug;
  final String propertyName;
  final String description;
  final String purpose;

  final ListingType type;
  final Furnishing furnishing;
  final Municipality municipality;

  final double latitude;
  final double longitude;

  final int bedrooms;
  final int bathrooms;
  final double area;

  final int livingRooms;
  final int parkingSpaces;
  final int floorNumber;
  final int totalFloors;
  final int? yearBuilt;

  final double price;
  final bool priceNegotiable;

  final String addressLine1;
  final String addressLine2;
  final String areaName;
  final String country;

  final String contactPhone;
  final String contactWhatsapp;
  final bool contactVerified;

  final List<Amenity> amenities;
  final List<NearbyTag> nearbyTags;

  final String otherFeatures;
  final String status;

  final DateTime createdAt;
  final DateTime updatedAt;

  final CreatedBy createdBy;
  final List<Photo> photos;

  final bool isWishlisted;
  final bool isFeatured;

  Property({
    required this.id,
    required this.slug,
    required this.propertyName,
    required this.description,
    required this.purpose,
    required this.type,
    required this.furnishing,
    required this.municipality,
    required this.latitude,
    required this.longitude,
    required this.bedrooms,
    required this.bathrooms,
    required this.area,
    required this.livingRooms,
    required this.parkingSpaces,
    required this.floorNumber,
    required this.totalFloors,
    required this.yearBuilt,
    required this.price,
    required this.priceNegotiable,
    required this.addressLine1,
    required this.addressLine2,
    required this.areaName,
    required this.country,
    required this.contactPhone,
    required this.contactWhatsapp,
    required this.contactVerified,
    required this.amenities,
    required this.nearbyTags,
    required this.otherFeatures,
    required this.status,
    required this.createdAt,
    required this.updatedAt,
    required this.createdBy,
    required this.photos,
    required this.isWishlisted,
    required this.isFeatured,
  });

  factory Property.fromJson(Map<String, dynamic> json) {
    return Property(
      id: json["id"] ?? "",
      slug: json["slug"] ?? "",
      propertyName: json["propertyName"] ?? "",
      description: json["description"] ?? "",
      purpose: json["purpose"] ?? "",

      type: ListingType.fromJson(json["type"] ?? {}),
      furnishing: Furnishing.fromJson(json["furnishing"] ?? {}),
      municipality: Municipality.fromJson(json["municipality"] ?? {}),

      latitude: (json["latitude"] ?? 0).toDouble(),
      longitude: (json["longitude"] ?? 0).toDouble(),

      bedrooms: json["bedrooms"] ?? 0,
      bathrooms: json["bathrooms"] ?? 0,
      area: (json["area"] ?? 0).toDouble(),

      livingRooms: json["livingRooms"] ?? 0,
      parkingSpaces: json["parkingSpaces"] ?? 0,
      floorNumber: json["floorNumber"] ?? 0,
      totalFloors: json["totalFloors"] ?? 0,
      yearBuilt: json["yearBuilt"],

      price: (json["price"] ?? 0).toDouble(),
      priceNegotiable: json["priceNegotiable"] ?? false,

      addressLine1: json["addressLine1"] ?? "",
      addressLine2: json["addressLine2"] ?? "",
      areaName: json["areaName"] ?? "",
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

      createdAt: DateTime.parse(json["createdAt"]),
      updatedAt: DateTime.parse(json["updatedAt"]),

      createdBy: CreatedBy.fromJson(json["createdBy"] ?? {}),

      photos: (json["photos"] as List? ?? [])
          .map((e) => Photo.fromJson(e))
          .toList(),

      isWishlisted: json["isWishlisted"] ?? false,
      isFeatured: json["isFeatured"] ?? false,
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

  ListingType({
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

  Furnishing({
    required this.id,
    required this.title,
  });

  factory Furnishing.fromJson(Map<String, dynamic> json) {
    return Furnishing(
      id: json["id"] ?? "",
      title: json["title"] ?? "",
    );
  }
}class Municipality {
  final String id;
  final String name;
  final String image;
  final double latitude;
  final double longitude;

  Municipality({
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
}class Amenity {
  final String id;
  final String title;
  final String? image;

  Amenity({
    required this.id,
    required this.title,
    this.image,
  });

  factory Amenity.fromJson(Map<String, dynamic> json) {
    return Amenity(
      id: json["id"] ?? "",
      title: json["title"] ?? "",
      image: json["image"],
    );
  }
}
class NearbyTag {
  final String id;
  final String title;
  final String? image;

  NearbyTag({
    required this.id,
    required this.title,
    this.image,
  });

  factory NearbyTag.fromJson(Map<String, dynamic> json) {
    return NearbyTag(
      id: json["id"] ?? "",
      title: json["title"] ?? "",
      image: json["image"],
    );
  }
}
class CreatedBy {
  final String id;
  final String name;
  final String email;
  final String phone;
  final String role;

  CreatedBy({
    required this.id,
    required this.name,
    required this.email,
    required this.phone,
    required this.role,
  });

  factory CreatedBy.fromJson(Map<String, dynamic> json) {
    return CreatedBy(
      id: json["id"] ?? "",
      name: json["name"] ?? "",
      email: json["email"] ?? "",
      phone: json["phone"] ?? "",
      role: json["role"] ?? "",
    );
  }
}

class Photo {
  final String id;
  final String url;
  final String caption;
  final int sortOrder;

  Photo({
    required this.id,
    required this.url,
    required this.caption,
    required this.sortOrder,
  });

  factory Photo.fromJson(Map<String, dynamic> json) {
    return Photo(
      id: json["id"] ?? "",
      url: json["url"] ?? "",
      caption: json["caption"] ?? "",
      sortOrder: json["sortOrder"] ?? 0,
    );
  }

  
}


class Meta {
  final int total;
  final int page;
  final int limit;
  final int totalPages;

  Meta({
    required this.total,
    required this.page,
    required this.limit,
    required this.totalPages,
  });

  factory Meta.fromJson(Map<String, dynamic> json) {
    return Meta(
      total: json["total"] ?? 0,
      page: json["page"] ?? 0,
      limit: json["limit"] ?? 0,
      totalPages: json["totalPages"] ?? 0,
    );
  }
}
