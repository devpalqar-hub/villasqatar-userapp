class PropertyModel {
  final String id;
  final String title;
  final String location;
  final String price;
  final String type;
  final String purpose;

  final double rating;
  final bool verified;

  final int bedrooms;
  final int bathrooms;
  final int parking;
  final int floors;

  final String area;
  final String plotArea;
  final String furnishing;
  final String ownership;
  final String completion;
  final String facing;
  final String builtYear;

  final String description;

  final List<String> images;
  final List<PropertyAmenity> amenities;

  final AgentModel agent;

  PropertyModel({
    required this.id,
    required this.title,
    required this.location,
    required this.price,
    required this.type,
    required this.purpose,
    required this.rating,
    required this.verified,
    required this.bedrooms,
    required this.bathrooms,
    required this.parking,
    required this.floors,
    required this.area,
    required this.plotArea,
    required this.furnishing,
    required this.ownership,
    required this.completion,
    required this.facing,
    required this.builtYear,
    required this.description,
    required this.images,
    required this.amenities,
    required this.agent,
  });
}

class PropertyAmenity {
  final String title;
  final String icon;

  PropertyAmenity({
    required this.title,
    required this.icon,
  });
}

class AgentModel {
  final String name;
  final String designation;
  final String company;
  final String image;
  final double rating;
  final int reviews;
  final String phone;
  final String whatsapp;

  AgentModel({
    required this.name,
    required this.designation,
    required this.company,
    required this.image,
    required this.rating,
    required this.reviews,
    required this.phone,
    required this.whatsapp,
  });
}




final demoProperty = PropertyModel(
  id: "QTR-10245",

  title: "Luxury Waterfront Villa",

  location: "The Pearl, Doha",

  price: "QAR 12,500,000",

  type: "Villa",

  purpose: "For Sale",

  rating: 4.9,

  verified: true,

  bedrooms: 5,

  bathrooms: 6,

  parking: 4,

  floors: 2,

  area: "450 sqm",

  plotArea: "620 sqm",

  furnishing: "Fully Furnished",

  ownership: "Freehold",

  completion: "Ready to Move",

  facing: "Sea Facing",

  builtYear: "2024",

  description:
      "Experience luxury waterfront living in one of Doha's most prestigious communities. This premium villa features modern architecture, private outdoor spaces, smart home integration, and breathtaking sea views.",

  images: [

    "assets/images/property1.jpg",

    "assets/images/property2.jpg",

    "assets/images/property3.jpg",

    "assets/images/property4.jpg",

  ],

  amenities: [

    PropertyAmenity(title: "Private Pool", icon: "pool"),

    PropertyAmenity(title: "Sea View", icon: "water"),

    PropertyAmenity(title: "Gym", icon: "fitness"),

    PropertyAmenity(title: "Garden", icon: "garden"),

    PropertyAmenity(title: "Balcony", icon: "balcony"),

    PropertyAmenity(title: "Parking", icon: "parking"),

    PropertyAmenity(title: "Security", icon: "security"),

    PropertyAmenity(title: "Elevator", icon: "elevator"),

  ],

  agent: AgentModel(

    name: "Ahmed Al Thani",

    designation: "Senior Property Consultant",

    company: "Premium Qatar Realty",

    image: "assets/images/agent.jpg",

    rating: 4.9,

    reviews: 156,

    phone: "+974 5555 5555",

    whatsapp: "+974 5555 5555",

  ),
);