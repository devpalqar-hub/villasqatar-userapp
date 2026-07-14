import 'package:flutter/material.dart';
import 'package:flutter_screenutil/flutter_screenutil.dart';

class SimilarPropertiesCard extends StatelessWidget {
  const SimilarPropertiesCard({super.key});

  @override
  Widget build(BuildContext context) {
    final properties = [
      {
        "image":
            "https://images.unsplash.com/photo-1600585154340-be6161a56a0c",
        "price": "QAR 8.2M",
        "title": "Modern Beach Villa",
        "location": "Lusail, Doha",
        "bed": "4",
        "bath": "5",
        "area": "390 sqm",
      },
      {
        "image":
            "https://images.unsplash.com/photo-1600607687939-ce8a6c25118c",
        "price": "QAR 11.8M",
        "title": "Luxury Penthouse",
        "location": "West Bay",
        "bed": "5",
        "bath": "6",
        "area": "510 sqm",
      },
      {
        "image":
            "https://images.unsplash.com/photo-1600047509807-ba8f99d2cdde",
        "price": "QAR 9.4M",
        "title": "Elegant Family Villa",
        "location": "The Pearl",
        "bed": "5",
        "bath": "5",
        "area": "430 sqm",
      },
    ];

    return Column(
      crossAxisAlignment: CrossAxisAlignment.start,
      children: [
        Text(
          "Similar Properties",
          style: TextStyle(
            fontSize: 16.sp,
            fontWeight: FontWeight.bold,
          ),
        ),

        SizedBox(height: 18.h),

        SizedBox(
          height: 285.h,
          child: ListView.separated(
            scrollDirection: Axis.horizontal,
            itemCount: properties.length,
            separatorBuilder: (_, __) => SizedBox(width: 16.w),
            itemBuilder: (_, index) {
              final property = properties[index];

              return _PropertyCard(
                image: property["image"]!,
                title: property["title"]!,
                location: property["location"]!,
                price: property["price"]!,
                bed: property["bed"]!,
                bath: property["bath"]!,
                area: property["area"]!,
              );
            },
          ),
        ),
      ],
    );
  }
}

class _PropertyCard extends StatelessWidget {
  final String image;
  final String title;
  final String location;
  final String price;
  final String bed;
  final String bath;
  final String area;

  const _PropertyCard({
    required this.image,
    required this.title,
    required this.location,
    required this.price,
    required this.bed,
    required this.bath,
    required this.area,
  });

  @override
  Widget build(BuildContext context) {
    return Container(
      width: 250.w,
      decoration: BoxDecoration(
        color: Colors.white,
        borderRadius: BorderRadius.circular(24.r),
        boxShadow: [
          BoxShadow(
            color: Colors.black.withOpacity(.06),
            blurRadius: 20,
            offset: const Offset(0, 8),
          ),
        ],
      ),
      child: Column(
        crossAxisAlignment: CrossAxisAlignment.start,
        children: [

          /// IMAGE
          Stack(
            children: [
              ClipRRect(
                borderRadius: BorderRadius.vertical(
                  top: Radius.circular(24.r),
                ),
                child: Image.network(
                  image,
                  height: 150.h,
                  width: double.infinity,
                  fit: BoxFit.cover,
                ),
              ),

              Positioned(
                top: 12,
                right: 12,
                child: Container(
                  width: 40.w,
                  height: 40.w,
                  decoration: BoxDecoration(
                    color: Colors.white,
                    shape: BoxShape.circle,
                  ),
                  child: Icon(
                    Icons.favorite_border,
                    color: const Color(0xff8E123E),
                    size: 22.sp,
                  ),
                ),
              ),
            ],
          ),

          Padding(
            padding: EdgeInsets.all(16.w),
            child: Column(
              crossAxisAlignment: CrossAxisAlignment.start,
              children: [

                Text(
                  price,
                  style: TextStyle(
                    fontSize: 18.sp,
                    color: const Color(0xff8E123E),
                    fontWeight: FontWeight.bold,
                  ),
                ),

                SizedBox(height: 6.h),

                Text(
                  title,
                  maxLines: 2,
                  overflow: TextOverflow.ellipsis,
                  style: TextStyle(
                    fontWeight: FontWeight.bold,
                    fontSize: 16.sp,
                  ),
                ),

                SizedBox(height: 8.h),

                Row(
                  children: [
                    Icon(
                      Icons.location_on,
                      color: Colors.grey,
                      size: 16.sp,
                    ),
                    SizedBox(width: 4.w),
                    Expanded(
                      child: Text(
                        location,
                        style: TextStyle(
                          color: Colors.grey.shade600,
                          fontSize: 13.sp,
                        ),
                      ),
                    ),
                  ],
                ),

                SizedBox(height: 16.h),

                Row(
                  mainAxisAlignment:
                      MainAxisAlignment.spaceBetween,
                  children: [

                    _Feature(Icons.bed, bed),

                    _Feature(Icons.bathtub, bath),

                    _Feature(Icons.square_foot, area),
                  ],
                ),
              ],
            ),
          ),
        ],
      ),
    );
  }
}

class _Feature extends StatelessWidget {
  final IconData icon;
  final String value;

  const _Feature(this.icon, this.value);

  @override
  Widget build(BuildContext context) {
    return Row(
      children: [
        Icon(
          icon,
          color: const Color(0xff8E123E),
          size: 17.sp,
        ),
        SizedBox(width: 4.w),
        Text(
          value,
          style: TextStyle(
            fontWeight: FontWeight.w600,
            fontSize: 12.sp,
          ),
        ),
      ],
    );
  }
}