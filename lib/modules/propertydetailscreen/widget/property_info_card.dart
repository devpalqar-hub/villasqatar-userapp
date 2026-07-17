import 'package:flutter/material.dart';
import 'package:flutter_screenutil/flutter_screenutil.dart';
import 'package:villas_qatar/modules/propertylist/model/myproperty_model.dart';

class PropertyInfoCard extends StatefulWidget {
  final Property property;

  const PropertyInfoCard({super.key, required this.property});

  @override
  State<PropertyInfoCard> createState() => _PropertyInfoCardState();
}

class _PropertyInfoCardState extends State<PropertyInfoCard> {
  int selectedChip = 0;
  @override
  Widget build(BuildContext context) {
    final property = widget.property;
    return Container(
      width: double.infinity,

      child: Column(
        crossAxisAlignment: CrossAxisAlignment.start,
        children: [
          SizedBox(height: 10.h),
          Text(
            property.propertyName,
            style: TextStyle(
              fontSize: 15.sp,
              fontWeight: FontWeight.bold,
              color: const Color(0xff222222),
            ),
          ),

          SizedBox(height: 10.h),
          Row(
            children: [
              Icon(Icons.location_on_rounded, color: Colors.grey, size: 14.sp),

              SizedBox(width: 10.w),

              Text(
                "${property.areaName}, ${property.municipality}, ${property.country}",
                style: TextStyle(fontSize: 12.sp, color: Colors.grey.shade700),
              ),

              SizedBox(width: 18.w),
              Row(
                children: [
                  Icon(
                    property.contactVerified
                        ? Icons.verified
                        : Icons.verified_outlined,
                    color: property.contactVerified
                        ? Colors.green
                        : Colors.grey,
                    size: 15,
                  ),
                  SizedBox(width: 4.w),
                  Text(
                    property.contactVerified ? "Verified" : "Not Verified",
                    style: TextStyle(
                      color: property.contactVerified
                          ? Colors.green
                          : Colors.grey,
                      fontWeight: FontWeight.w600,
                      fontSize: 12.sp,
                    ),
                  ),
                ],
              ),
            ],
          ),

          SizedBox(height: 8.h),
          IntrinsicHeight(
            child: Row(
              children: [
                Text(
                  "ID #${property.id.substring(0, 8).toUpperCase()}",
                  style: TextStyle(
                    fontWeight: FontWeight.w600,
                    fontSize: 13.sp,
                    color: Colors.blue.shade800,
                  ),
                ),
                SizedBox(width: 10.w),
                VerticalDivider(
                  thickness: 1,
                  width: 1,
                  color: Colors.grey.shade400,
                ),
                SizedBox(width: 10.w),

                Text(
                  "1.2 km away",
                  style: TextStyle(
                    color: Colors.grey.shade600,
                    fontSize: 13.sp,
                  ),
                ),
                SizedBox(width: 10.w),
                _featureItem(
                  Icons.square_foot_outlined,
                  "${property.area} sqm",
                ),
              ],
            ),
          ),

          SizedBox(height: 8.h),

          Container(
            child: Row(
              children: [
                _featureItem(Icons.bed_outlined, "${property.bedrooms} Beds"),
                SizedBox(width: 6.w),
                _featureItem(
                  Icons.bathtub_outlined,
                  "${property.bathrooms} Baths",
                ),
                SizedBox(width: 6.w),

                SizedBox(width: 20.w),
                _featureItem(
                  Icons.home_work_outlined,
                  property.type
                      .replaceAll("_", " ")
                      .toLowerCase()
                      .split(" ")
                      .map((e) => e[0].toUpperCase() + e.substring(1))
                      .join(" "),
                ),
              ],
            ),
          ),

          /// Status Chips
        ],
      ),
    );
  }

  Widget _featureItem(IconData icon, String text) {
    return Expanded(
      child: Row(
        children: [
          Icon(icon, size: 18.sp, color: Colors.grey),
          SizedBox(width: 6.w),
          Text(
            text,
            style: TextStyle(
              fontSize: 13.sp,
              fontWeight: FontWeight.w600,
              color: Colors.grey,
            ),
          ),
        ],
      ),
    );
  }

  Widget _chip({required String text, required int index}) {
    final bool isSelected = selectedChip == index;

    return GestureDetector(
      onTap: () {
        setState(() {
          selectedChip = index;
        });
      },
      child: AnimatedContainer(
        duration: const Duration(milliseconds: 200),
        padding: EdgeInsets.symmetric(horizontal: 14.w, vertical: 6.h),
        decoration: BoxDecoration(
          color: Colors.white,
          borderRadius: BorderRadius.circular(8.r),
          border: Border.all(
            color: isSelected ? const Color(0xff8E123E) : Colors.grey.shade300,
            width: isSelected ? 1.5 : 1,
          ),
        ),
        child: Text(
          text,
          style: TextStyle(
            color: isSelected ? Colors.black : Colors.black,
            fontWeight: FontWeight.w500,
            fontSize: 8.sp,
          ),
        ),
      ),
    );
  }
}
