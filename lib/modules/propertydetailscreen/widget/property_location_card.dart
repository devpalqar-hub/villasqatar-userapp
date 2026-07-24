import 'package:flutter/material.dart';
import 'package:flutter_screenutil/flutter_screenutil.dart';
import 'package:get/get_utils/src/extensions/internacionalization.dart';
// import 'package:google_maps_flutter/google_maps_flutter.dart';
import 'package:url_launcher/url_launcher.dart';
import 'package:villas_qatar/Core/constants/app_colors.dart';
import 'package:villas_qatar/modules/propertylist/model/myproperty_model.dart';

class PropertyLocationCard extends StatelessWidget {
  final Property property;

  const PropertyLocationCard({super.key, required this.property});

  @override
  Widget build(BuildContext context) {
    return Container(
      width: double.infinity,
      padding: EdgeInsets.symmetric(vertical: 10.h, horizontal: 14.w),
      decoration: BoxDecoration(
        color: Colors.white,
        borderRadius: BorderRadius.circular(10.r),
        border: Border.all(color: const Color(0xffECECEC)),
      ),
      child: Column(
        crossAxisAlignment: CrossAxisAlignment.start,
        children: [
          /// Heading
          Text(
            "Location".tr,
            style: TextStyle(
              fontSize: 16.sp,
              fontWeight: FontWeight.w700,
              color: const Color(0xff1F2937),
            ),
          ),

          SizedBox(height: 12.h),

          ClipRRect(
            borderRadius: BorderRadius.circular(14.r),
            child: Stack(
              children: [
                SizedBox(
                  height: 180.h,
                  width: double.infinity,
                  // child: GoogleMap(
                  //   initialCameraPosition: const CameraPosition(
                  //     target: LatLng(0, 0),
                  //     zoom: 2,
                  //   ),
                  //   onMapCreated: (GoogleMapController controller) {
                  //     controller.animateCamera(
                  //       CameraUpdate.newLatLngZoom(
                  //         LatLng(
                  //           property.latitude.toDouble(),
                  //           property.longitude.toDouble(),
                  //         ),
                  //         16,
                  //       ),
                  //     );
                  //   },
                  //   markers: {
                  //     Marker(
                  //       markerId: const MarkerId("property"),
                  //       position: LatLng(
                  //         property.latitude.toDouble(),
                  //         property.longitude.toDouble(),
                  //       ),
                  //     ),
                  //   },
                  // ),
                ),
                Positioned(
                  left: 12.w,
                  top: 12.h,
                  child: Container(
                    padding: EdgeInsets.symmetric(
                      horizontal: 12.w,
                      vertical: 6.h,
                    ),
                    decoration: BoxDecoration(
                      color: Colors.white,
                      borderRadius: BorderRadius.circular(30.r),
                      boxShadow: [
                        BoxShadow(color: Colors.black12, blurRadius: 8),
                      ],
                    ),
                    child: Row(
                      mainAxisSize: MainAxisSize.min,
                      children: [
                        Icon(
                          Icons.location_on,
                          size: 16.sp,
                          color: AppColors.primary,
                        ),
                        SizedBox(width: 6.w),
                        Text(
                          "${property.areaName}, ${property.municipality}",
                          style: TextStyle(
                            fontWeight: FontWeight.w600,
                            fontSize: 12.sp,
                          ),
                        ),
                      ],
                    ),
                  ),
                ),
              ],
            ),
          ),

          SizedBox(height: 6.h),
          Wrap(
            spacing: 10.w,
            runSpacing: 10.h,
            children: property.nearbyTags.map((tag) {
              return Container(
                padding: EdgeInsets.symmetric(horizontal: 12.w, vertical: 10.h),
                decoration: BoxDecoration(
                  color: const Color(0xffF8F8F8),
                  borderRadius: BorderRadius.circular(12.r),
                  border: Border.all(color: const Color(0xffECECEC)),
                ),
                child: Row(
                  mainAxisSize: MainAxisSize.min,
                  children: [
                    Icon(
                      _getNearbyIcon(tag),
                      size: 18.sp,
                      color: AppColors.primary,
                    ),
                    SizedBox(width: 8.w),
                    Text(
                      tag
                          .replaceAll("_", " ")
                          .split(" ")
                          .map((e) => e[0].toUpperCase() + e.substring(1))
                          .join(" "),
                      style: TextStyle(
                        fontSize: 12.sp,
                        fontWeight: FontWeight.w600,
                        color: const Color(0xff444444),
                      ),
                    ),
                  ],
                ),
              );
            }).toList(),
          ),
          SizedBox(height: 14.h),

          SizedBox(
            width: double.infinity,
            height: 45.h,
            child: OutlinedButton.icon(
              style: OutlinedButton.styleFrom(
                side:  BorderSide(color: Color(0xffA61E3D)),
                shape: RoundedRectangleBorder(
                  borderRadius: BorderRadius.circular(14.r),
                ),
              ),
              onPressed: () async {
                final uri = Uri.parse(
                  "https://www.google.com/maps/search/?api=1&query="
                  "${property.latitude},${property.longitude}",
                );

                if (await canLaunchUrl(uri)) {
                  await launchUrl(uri, mode: LaunchMode.externalApplication);
                }
              },
              icon: Icon(
                Icons.map_outlined,
                color:  Color(0xffA61E3D),
                size: 22.sp,
              ),
              label: Text(
                "View on Maps".tr,
                style: TextStyle(
                  color: Color(0xffA61E3D),
                  fontWeight: FontWeight.w700,
                  fontSize: 14.sp,
                ),
              ),
            ),
          ),
        ],
      ),
    );
  }

  Widget _locationItem(IconData icon, String value, String subtitle) {
    return Row(
      children: [
        Icon(icon, size: 18.sp, color: const Color(0xff444444)),
        SizedBox(width: 14.w),
        RichText(
          text: TextSpan(
            style: TextStyle(fontSize: 12.sp, color: const Color(0xff666666)),
            children: [
              TextSpan(
                text: "$value ",
                style: const TextStyle(
                  fontWeight: FontWeight.w700,
                  color: Colors.black,
                ),
              ),
              TextSpan(text: subtitle),
            ],
          ),
        ),
      ],
    );
  }
}

IconData _getNearbyIcon(String tag) {
  switch (tag.toLowerCase()) {
    case "school":
      return Icons.school_outlined;

    case "metro":
      return Icons.train_outlined;

    case "hospital":
      return Icons.local_hospital_outlined;

    case "clinic":
      return Icons.medical_services_outlined;

    case "mall":
      return Icons.shopping_bag_outlined;

    case "airport":
      return Icons.flight_takeoff_outlined;

    case "beach":
      return Icons.beach_access_outlined;

    case "pharmacy":
      return Icons.local_pharmacy_outlined;

    case "mosque":
      return Icons.mosque_outlined;

    case "church":
      return Icons.church_outlined;

    default:
      return Icons.location_on_outlined;
  }
}
