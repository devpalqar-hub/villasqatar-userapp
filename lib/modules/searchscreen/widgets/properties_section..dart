import 'package:flutter/material.dart';
import 'package:flutter_screenutil/flutter_screenutil.dart';
import 'package:get/get_core/src/get_main.dart';
import 'package:get/get_instance/src/extension_instance.dart';
import 'package:get/get_navigation/src/extension_navigation.dart';
import 'package:get/get_navigation/src/routes/transitions_type.dart';
import 'package:get/get_state_manager/src/simple/get_state.dart';
import 'package:get/get_utils/src/extensions/internacionalization.dart';
import 'package:villas_qatar/Core/constants/app_colors.dart';
import 'package:villas_qatar/Core/theme/app_motion.dart';
import 'package:villas_qatar/Core/theme/app_textstyles.dart';
import 'package:villas_qatar/Core/utils/app_transitions.dart';
import 'package:villas_qatar/Core/widgets/motion/app_shimmer.dart';
import 'package:villas_qatar/Core/widgets/motion/fade_slide_in.dart';
import 'package:villas_qatar/Core/widgets/motion/pressable_scale.dart';
import 'package:villas_qatar/modules/propertydetailscreen/propertydetailscreen.dart';
import 'package:villas_qatar/modules/propertylist/model/myproperty_model.dart';
import 'package:villas_qatar/modules/searchscreen/service/searchlist_screen.dart';
import 'package:villas_qatar/modules/wishlist/service/wishlist_controller.dart';

class PropertiesSection extends StatelessWidget {
  final PropertySearchController controller;
  const PropertiesSection({super.key, required this.controller});

  @override
  Widget build(BuildContext context) {
    if (!Get.isRegistered<WishlistController>()) {
      Get.put(WishlistController());
    }

    return GetBuilder<PropertySearchController>(
      builder: (controller) {
        final totalProps =
            controller.meta?.total ?? controller.properties.length;

        return Column(
          crossAxisAlignment: CrossAxisAlignment.start,
          children: [
            /// HEADER: Count & Subtitle + View Toggles
            Row(
              crossAxisAlignment: CrossAxisAlignment.start,
              children: [
                Expanded(
                  child: Column(
                    crossAxisAlignment: CrossAxisAlignment.start,
                    children: [
                      Text(
                        "$totalProps Properties Found".tr,
                        style: AppTextStyles.title18.copyWith(
                          fontSize: 18.sp,
                          fontWeight: FontWeight.bold,
                          color: Colors.black,
                        ),
                      ),
                      SizedBox(height: 2.h),
                      Text(
                        "Premium properties across Qatar".tr,
                        style: AppTextStyles.body13.copyWith(
                          color: Colors.grey.shade500,
                        ),
                      ),
                    ],
                  ),
                ),
                // List / Map Toggle (Visual representation from screenshot)
                Container(
                  height: 32.h,
                  decoration: BoxDecoration(
                    border: Border.all(color: Colors.grey.shade300),
                    borderRadius: BorderRadius.circular(20.r),
                  ),
                  child: Row(
                    children: [
                      Container(
                        padding: EdgeInsets.symmetric(horizontal: 12.w),
                        decoration: BoxDecoration(
                          color: AppColors.primary,
                          borderRadius: BorderRadius.circular(20.r),
                        ),
                        child: Center(
                          child: Row(
                            children: [
                              Icon(
                                Icons.format_list_bulleted,
                                color: Colors.white,
                                size: 14.sp,
                              ),
                              SizedBox(width: 4.w),
                              Text(
                                "List".tr,
                                style: TextStyle(
                                  color: Colors.white,
                                  fontSize: 11.sp,
                                  fontWeight: FontWeight.w600,
                                ),
                              ),
                            ],
                          ),
                        ),
                      ),
                      Padding(
                        padding: EdgeInsets.symmetric(horizontal: 12.w),
                        child: Row(
                          children: [
                            Icon(
                              Icons.map_outlined,
                              color: Colors.black87,
                              size: 14.sp,
                            ),
                            SizedBox(width: 4.w),
                            Text(
                              "Map".tr,
                              style: TextStyle(
                                color: Colors.black87,
                                fontSize: 11.sp,
                                fontWeight: FontWeight.w600,
                              ),
                            ),
                          ],
                        ),
                      ),
                    ],
                  ),
                ),
              ],
            ),

            SizedBox(height: 20.h),

            AnimatedSwitcher(
              duration: AppMotion.medium,
              child: ListView.builder(
                key: const ValueKey('list'),
                shrinkWrap: true,
                physics: const NeverScrollableScrollPhysics(),
                itemCount: controller.properties.length,
                itemBuilder: (_, index) {
                  return Padding(
                    padding: EdgeInsets.only(bottom: 16.h),
                    child: PropertyCard(property: controller.properties[index]),
                  );
                },
              ),
            ),
          ],
        );
      },
    );
  }

  // Keep _buildLoadingSkeleton and _buildEmptyState as they were.
}

class PropertyCard extends StatelessWidget {
  final Property property;
  const PropertyCard({super.key, required this.property});

  @override
  Widget build(BuildContext context) {
    final photos = property.sortedPhotos;
    final isRent = property.purpose == "RENT";

    return PressableScale(
      child: InkWell(
        borderRadius: BorderRadius.circular(16.r),
        onTap: () =>
            Get.to(() => PropertyDetailsScreen(propertyId: property.id)),
        child: Container(
          height: 135.h,
          padding: EdgeInsets.all(8.w),
          decoration: BoxDecoration(
            color: Colors.white,
            borderRadius: BorderRadius.circular(16.r),
            boxShadow: [
              BoxShadow(
                color: Colors.black.withOpacity(0.04),
                blurRadius: 10,
                offset: const Offset(0, 4),
              ),
            ],
          ),
          child: Row(
            children: [
              /// LEFT: Image with pill overlay
              ClipRRect(
                borderRadius: BorderRadius.circular(12.r),
                child: Stack(
                  children: [
                    photos.isNotEmpty
                        ? Image.network(
                            photos.first.url,
                            width: 130.w,
                            height: double.infinity,
                            fit: BoxFit.cover,
                          )
                        : Image.asset(
                            "assets/villa.jpg",
                            width: 130.w,
                            height: double.infinity,
                            fit: BoxFit.cover,
                          ),
                    Positioned(
                      top: 8.h,
                      left: 8.w,
                      child: Container(
                        padding: EdgeInsets.symmetric(
                          horizontal: 8.w,
                          vertical: 4.h,
                        ),
                        decoration: BoxDecoration(
                          color: Colors.white.withOpacity(0.9),
                          borderRadius: BorderRadius.circular(8.r),
                        ),
                        child: Text(
                          isRent ? "For Rent".tr : "For Sale".tr,
                          style: TextStyle(
                            color: Colors.black87,
                            fontSize: 10.sp,
                            fontWeight: FontWeight.w700,
                          ),
                        ),
                      ),
                    ),
                  ],
                ),
              ),

              SizedBox(width: 14.w),

              /// RIGHT: Details
              Expanded(
                child: Padding(
                  padding: EdgeInsets.symmetric(vertical: 4.h),
                  child: Column(
                    crossAxisAlignment: CrossAxisAlignment.start,
                    mainAxisAlignment: MainAxisAlignment.spaceBetween,
                    children: [
                      // Title & Wishlist Icon
                      Row(
                        crossAxisAlignment: CrossAxisAlignment.start,
                        children: [
                          Expanded(
                            child: Text(
                              property.propertyName,
                              maxLines: 2,
                              overflow: TextOverflow.ellipsis,
                              style: AppTextStyles.title16.copyWith(
                                fontWeight: FontWeight.bold,
                                fontSize: 13.sp,
                                height: 1.2,
                              ),
                            ),
                          ),
                          // Heart Icon
                          Icon(
                            Icons.favorite_border,
                            color: AppColors.primary,
                            size: 18.sp,
                          ),
                        ],
                      ),

                      // Location
                      Row(
                        children: [
                          Icon(
                            Icons.location_on_outlined,
                            size: 14.sp,
                            color: Colors.grey.shade500,
                          ),
                          SizedBox(width: 4.w),
                          Expanded(
                            child: Text(
                              "${property.areaName}, ${property.municipality.name}",
                              maxLines: 1,
                              overflow: TextOverflow.ellipsis,
                              style: AppTextStyles.body12.copyWith(
                                color: Colors.grey.shade500,
                              ),
                            ),
                          ),
                        ],
                      ),

                      // Amenities (Beds, Baths, Area)
                      Row(
                        mainAxisAlignment: MainAxisAlignment.spaceBetween,
                        children: [
                          _buildAmenity(
                            Icons.bed_outlined,
                            "${property.bedrooms} Beds",
                          ),
                          _buildAmenity(
                            Icons.bathtub_outlined,
                            "${property.bathrooms} Baths",
                          ),
                          _buildAmenity(
                            Icons.square_foot_outlined,
                            "${property.area} m²",
                          ),
                        ],
                      ),

                      // Price
                      RichText(
                        text: TextSpan(
                          text: "QAR ${property.price.toStringAsFixed(0)}",
                          style: AppTextStyles.title16.copyWith(
                            color: AppColors.primary,
                            fontWeight: FontWeight.bold,
                            fontSize: 14.sp,
                          ),
                          children: [
                            if (isRent)
                              TextSpan(
                                text: " / month".tr,
                                style: AppTextStyles.body12.copyWith(
                                  color: Colors.grey.shade600,
                                ),
                              ),
                          ],
                        ),
                      ),
                    ],
                  ),
                ),
              ),
            ],
          ),
        ),
      ),
    );
  }

  Widget _buildAmenity(IconData icon, String text) {
    return Row(
      mainAxisSize: MainAxisSize.min,
      children: [
        Icon(icon, size: 14.sp, color: Colors.grey.shade600),
        SizedBox(width: 4.w),
        Text(
          text,
          style: AppTextStyles.body12.copyWith(
            color: Colors.grey.shade700,
            fontSize: 10.sp,
          ),
        ),
      ],
    );
  }
}
