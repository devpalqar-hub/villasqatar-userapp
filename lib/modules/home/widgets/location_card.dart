import 'package:flutter/material.dart';
import 'package:flutter_screenutil/flutter_screenutil.dart';
import 'package:get/get.dart';
import 'package:villas_qatar/Core/theme/app_textstyles.dart';
import 'package:villas_qatar/modules/home/model/nearBypropertyResponse.dart';
import 'package:villas_qatar/modules/propertydetailscreen/propertydetailscreen.dart';

class LocationCard extends StatelessWidget {
  final NearByListingModel property;

  const LocationCard({super.key, required this.property});

  @override
  Widget build(BuildContext context) {
    final image = property.photos.isNotEmpty ? property.photos.first.url : "";

    return GestureDetector(
      onTap: () {
        Get.to(
          () => PropertyDetailsScreen(propertyId: property.id),
          transition: Transition.rightToLeft,
          duration: const Duration(milliseconds: 600),
        );
      },
      child: Container(
        width: 180.w,
        height: 120.h,
        margin: EdgeInsets.only(right: 2.w),
        decoration: BoxDecoration(
          borderRadius: BorderRadius.circular(10.r),
          image: DecorationImage(
            image: image.isNotEmpty
                ? NetworkImage(image)
                : const AssetImage("assets/images/location_placeholder.jpg")
                      as ImageProvider,
            fit: BoxFit.cover,
          ),
        ),
        child: Container(
          decoration: BoxDecoration(
            borderRadius: BorderRadius.circular(10.r),
            gradient: LinearGradient(
              begin: Alignment.topCenter,
              end: Alignment.bottomCenter,
              colors: [
                Colors.black.withOpacity(.15),
                Colors.black.withOpacity(.75),
              ],
            ),
          ),
          child: Padding(
            padding: EdgeInsets.all(10.w),
            child: Column(
              crossAxisAlignment: CrossAxisAlignment.start,
              children: [
                /// Distance Badge
                Align(
                  alignment: Alignment.topRight,
                  child: Container(
                    padding: EdgeInsets.symmetric(
                      horizontal: 10.w,
                      vertical: 2.h,
                    ),
                    decoration: BoxDecoration(
                      color: const Color(0xff8C1437),
                      borderRadius: BorderRadius.circular(5.r),
                    ),
                    child: Row(
                      mainAxisSize: MainAxisSize.min,
                      children: [
                        Icon(
                          Icons.near_me_rounded,
                          color: Colors.white,
                          size: 11.sp,
                        ),
                        SizedBox(width: 4.w),
                        Text(
                          "${property.distanceMetres} m",
                          style: TextStyle(
                            color: Colors.white,
                            fontWeight: FontWeight.w500,
                            fontSize: 10.sp,
                          ),
                        ),
                      ],
                    ),
                  ),
                ),

                SizedBox(height: 20.h),

                /// Property Name
                Text(
                  property.propertyName,
                  maxLines: 2,
                  overflow: TextOverflow.ellipsis,
                  style: AppTextStyles.medium13.copyWith(
                    color: Colors.white,
                    fontWeight: FontWeight.w500,
                    fontSize: 10.sp,
                    height: 1.25,
                  ),
                ),

                /// Area
                Row(
                  children: [
                    Icon(
                      Icons.location_on_outlined,
                      color: Colors.white70,
                      size: 13.sp,
                    ),
                    SizedBox(width: 4.w),
                    Expanded(
                      child: Text(
                        property.areaName,
                        maxLines: 1,
                        overflow: TextOverflow.ellipsis,
                        style: AppTextStyles.body13.copyWith(
                          color: Colors.white,
                          fontWeight: FontWeight.w500,
                          fontSize: 11.sp,
                        ),
                      ),
                    ),
                  ],
                ),
              ],
            ),
          ),
        ),
      ),
    );
  }
}
