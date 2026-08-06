import 'package:flutter/material.dart';
import 'package:flutter_screenutil/flutter_screenutil.dart';
import 'package:villas_qatar/Core/theme/app_textstyles.dart';
import 'package:villas_qatar/modules/home/model/nearBypropertyResponse.dart';



class LocationCard extends StatelessWidget {
  final NearByListingModel property;

  const LocationCard({
    super.key,
    required this.property,
  });

  @override
  Widget build(BuildContext context) {
    final image = property.photos.isNotEmpty
        ? property.photos.first.url
        : "";

    return Container(
      width: 130.w,
      margin: EdgeInsets.only(right: 10.w),
      decoration: BoxDecoration(
        borderRadius: BorderRadius.circular(14.r),
        image: DecorationImage(
          image: image.isNotEmpty
              ? NetworkImage(image)
              : const AssetImage("assets/images/location_placeholder.jpg")
                  as ImageProvider,
          fit: BoxFit.cover,
        ),
      ),
      child: Container(
        padding: EdgeInsets.all(10.w),
        decoration: BoxDecoration(
          borderRadius: BorderRadius.circular(14.r),
          gradient: LinearGradient(
            begin: Alignment.bottomCenter,
            end: Alignment.topCenter,
            colors: [
              Colors.black.withOpacity(.75),
              Colors.transparent,
            ],
          ),
        ),
        child: Column(
          mainAxisAlignment: MainAxisAlignment.end,
          crossAxisAlignment: CrossAxisAlignment.start,
          children: [
            Text(
              property.areaName,
              maxLines: 1,
              overflow: TextOverflow.ellipsis,
              style: AppTextStyles.medium13.copyWith(
                color: Colors.white,
                fontSize: 13.sp,
                fontWeight: FontWeight.w600,
              ),
            ),

            SizedBox(height: 4.h),

            Row(
              children: [
                Icon(
                  Icons.home_work_outlined,
                  color: Colors.white,
                  size: 13.sp,
                ),

                SizedBox(width: 4.w),

                Expanded(
                  child: Text(
                    "1 Property",
                    style: AppTextStyles.body13.copyWith(
                      color: Colors.white70,
                      fontSize: 10.sp,
                    ),
                  ),
                ),
              ],
            ),
          ],
        ),
      ),
    );
  }
}