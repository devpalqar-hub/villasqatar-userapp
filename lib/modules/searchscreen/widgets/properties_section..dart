import 'package:flutter/material.dart';
import 'package:flutter_screenutil/flutter_screenutil.dart';
import 'package:get/get_core/src/get_main.dart';
import 'package:get/get_instance/src/extension_instance.dart';
import 'package:get/get_navigation/src/extension_navigation.dart';
import 'package:get/get_navigation/src/routes/transitions_type.dart';
import 'package:get/get_state_manager/src/simple/get_state.dart';
import 'package:get/get_utils/src/extensions/internacionalization.dart';
import 'package:villas_qatar/Core/constants/app_colors.dart';
import 'package:villas_qatar/Core/theme/app_textstyles.dart';
import 'package:villas_qatar/modules/propertydetailscreen/propertydetailscreen.dart';
import 'package:villas_qatar/modules/propertylist/model/myproperty_model.dart';
import 'package:villas_qatar/modules/searchscreen/service/searchlist_screen.dart';
import 'package:villas_qatar/modules/wishlist/service/wishlist_controller.dart';

class PropertiesSection extends StatelessWidget {
  final PropertySearchController controller;

  const PropertiesSection({super.key, required this.controller});

  @override
  Widget build(BuildContext context) {
    // Make sure WishlistController exists
    if (!Get.isRegistered<WishlistController>()) {
      Get.put(WishlistController());
    }

    return GetBuilder<PropertySearchController>(
      builder: (controller) {
        return Column(
          crossAxisAlignment: CrossAxisAlignment.start,
          children: [
            /// PROPERTIES HEADER
            /// Always visible
            Row(
              children: [
                Text(
                  "Properties".tr,
                  style: AppTextStyles.title18.copyWith(
                    fontSize: 15.sp,
                    fontWeight: FontWeight.w500,
                    color: Colors.black,
                  ),
                ),
              ],
            ),

            SizedBox(height: 14.h),

            /// LOADING
            if (controller.isLoading)
              Padding(
                padding: EdgeInsets.symmetric(vertical: 45.h),
                child: Center(
                  child: SizedBox(
                    width: 24.w,
                    height: 24.w,
                    child: CircularProgressIndicator(
                      strokeWidth: 2,
                      color: AppColors.primary,
                    ),
                  ),
                ),
              )
            /// NO PROPERTIES FOUND
            else if (controller.properties.isEmpty)
              _buildEmptyState()
            /// PROPERTY LIST
            else
              ListView.builder(
                shrinkWrap: true,
                physics: const NeverScrollableScrollPhysics(),
                itemCount: controller.properties.length,
                itemBuilder: (_, index) {
                  return PropertyCard(property: controller.properties[index]);
                },
              ),
          ],
        );
      },
    );
  }

  Widget _buildEmptyState() {
    return Container(
      width: double.infinity,
      padding: EdgeInsets.symmetric(vertical: 38.h, horizontal: 20.w),
      decoration: BoxDecoration(
        color: Colors.white,
        borderRadius: BorderRadius.circular(12.r),
        border: Border.all(color: const Color(0xffEEEEEE)),
      ),
      child: Column(
        children: [
          /// ICON
          Container(
            width: 58.w,
            height: 58.w,
            decoration: BoxDecoration(
              color: AppColors.primary.withOpacity(.08),
              shape: BoxShape.circle,
            ),
            child: Icon(
              Icons.home_work_outlined,
              color: AppColors.primary,
              size: 27.sp,
            ),
          ),

          SizedBox(height: 14.h),

          /// TITLE
          Text(
            "No Properties Found".tr,
            textAlign: TextAlign.center,
            style: AppTextStyles.title18.copyWith(
              fontSize: 14.sp,
              fontWeight: FontWeight.w600,
              color: const Color(0xff202124),
            ),
          ),

          SizedBox(height: 6.h),

          /// SUBTITLE
          Text(
            "Try changing your search or filters".tr,
            textAlign: TextAlign.center,
            style: AppTextStyles.body13.copyWith(
              fontSize: 11.sp,
              color: const Color(0xff777777),
              height: 1.4,
            ),
          ),
        ],
      ),
    );
  }
}

class PropertyCard extends StatelessWidget {
  final Property property;
  const PropertyCard({super.key, required this.property});

  @override
  Widget build(BuildContext context) {
    final photos = property.sortedPhotos;
    return InkWell(
      borderRadius: BorderRadius.circular(10.r),
      // onTap: () async {
      //   final controller = Get.find<PropertySearchController>();

      //   await controller.fetchPropertyDetails(property.id);

      //   if (controller.selectedProperty != null) {
      //     Get.to(
      //       () => const PropertyDetailsScreen(),
      //       transition: Transition.rightToLeft,
      //       duration: const Duration(milliseconds: 250),
      //     );
      //   }
      // },
      onTap: () {
  Get.to(
    () => PropertyDetailsScreen(
      propertyId: property.id,
    ),
    transition: Transition.rightToLeft,
    duration: const Duration(milliseconds: 250),
  );
},
      child: Container(
        margin: EdgeInsets.only(bottom: 18.h),
        decoration: BoxDecoration(
          color: Colors.white,
          borderRadius: BorderRadius.circular(10.r),
          boxShadow: [
            BoxShadow(
              color: Colors.black.withOpacity(.05),
              blurRadius: 12,
              offset: const Offset(0, 6),
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
                    top: Radius.circular(8.r),
                  ),

                  child: photos.isNotEmpty
                      ? Image.network(
                          photos.first.url,
                          width: double.infinity,
                          height: 150.h,
                          fit: BoxFit.cover,
                          errorBuilder: (_, __, ___) {
                            return Image.asset(
                              "assets/villa.jpg",
                              width: double.infinity,
                              height: 150.h,
                              fit: BoxFit.cover,
                            );
                          },
                        )
                      : Image.asset(
                          "assets/villa.jpg",
                          width: double.infinity,
                          height: 150.h,
                          fit: BoxFit.cover,
                        ),
                ),

                // Positioned(
                //   left: 14.w,
                //   top: 14.h,
                //   child: Container(
                //     padding: EdgeInsets.symmetric(
                //       horizontal: 12.w,
                //       vertical: 6.h,
                //     ),
                //     decoration: BoxDecoration(
                //       color: AppColors.primary,
                //       borderRadius: BorderRadius.circular(5.r),
                //     ),
                //     child: Text(
                //       "FEATURED".tr,
                //       style: TextStyle(
                //         color: Colors.white,
                //         fontSize: 10.sp,
                //         fontWeight: FontWeight.w700,
                //       ),
                //     ),
                //   ),
                // ),
                Positioned(
                  right: 14.w,
                  top: 14.h,
                  child: Builder(
                    builder: (context) {
                      if (!Get.isRegistered<WishlistController>()) {
                        return Container(
                          width: 38.w,
                          height: 38.w,
                          decoration: const BoxDecoration(
                            color: Colors.white,
                            shape: BoxShape.circle,
                          ),
                          child: Icon(
                            Icons.favorite_border,
                            color: AppColors.primary,
                            size: 20.sp,
                          ),
                        );
                      }

                      return GetBuilder<WishlistController>(
                        builder: (wishlistController) {
                          final isWishlisted = wishlistController.isWishlisted(
                            property.id,
                          );

                          final isLoading = wishlistController
                              .isPropertyLoading(property.id);

                          return InkWell(
                            customBorder: const CircleBorder(),
                            onTap: isLoading
                                ? null
                                : () async {
                                    await wishlistController.toggleWishlist(
                                      property.id,
                                    );
                                  },
                            child: Container(
                              width: 38.w,
                              height: 38.w,
                              alignment: Alignment.center,
                              decoration: const BoxDecoration(
                                color: Colors.white,
                                shape: BoxShape.circle,
                              ),
                              child: isLoading
                                  ? SizedBox(
                                      width: 17.w,
                                      height: 17.w,
                                      child: const CircularProgressIndicator(
                                        strokeWidth: 2,
                                        color: AppColors.primary,
                                      ),
                                    )
                                  : Icon(
                                      isWishlisted
                                          ? Icons.favorite
                                          : Icons.favorite_border,
                                      color: AppColors.primary,
                                      size: 20.sp,
                                    ),
                            ),
                          );
                        },
                      );
                    },
                  ),
                ),

                Positioned(
                  bottom: 14.h,
                  right: 14.w,
                  child: Container(
                    padding: EdgeInsets.symmetric(
                      horizontal: 10.w,
                      vertical: 5.h,
                    ),
                    decoration: BoxDecoration(
                      color: Colors.black54,
                      borderRadius: BorderRadius.circular(14.r),
                    ),
                    child: Row(
                      children: [
                        Icon(
                          Icons.photo_library_outlined,
                          color: Colors.white,
                          size: 14.sp,
                        ),
                        SizedBox(width: 4.w),
                        Text(
                          property.sortedPhotos.length.toString(),
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
              ],
            ),

            Padding(
              padding: EdgeInsets.all(16.w),
              child: Column(
                crossAxisAlignment: CrossAxisAlignment.start,
                children: [
                  Text(
                    property.propertyName,
                    style: AppTextStyles.title14.copyWith(
                      fontWeight: FontWeight.w500,
                    ),
                  ),

                  SizedBox(height: 4.h),

                  Row(
                    children: [
                      Icon(
                        Icons.location_on_outlined,
                        size: 16.sp,
                        color: Colors.grey,
                      ),

                      SizedBox(width: 4.w),

                      Text(
                        "${property.areaName},  ${property.municipality.name}",
                        style: AppTextStyles.body13.copyWith(
                          color: Colors.grey,
                        ),
                      ),
                    ],
                  ),

                  SizedBox(height: 6.h),
                  Row(
                    children: [
                      PropertyFeatureChip(
                        icon: Icons.king_bed_outlined,
                        value: property.bedrooms.toString(),
                      ),

                      PropertyFeatureChip(
                        icon: Icons.bathtub_outlined,
                        value: property.bathrooms.toString(),
                      ),

                      PropertyFeatureChip(
                        icon: Icons.square_foot_outlined,
                        value: "${property.area} sqm",
                      ),
                    ],
                  ),

                  SizedBox(height: 8.h),

                  Row(
                    children: [
                      Text(
                        "QAR ${property.price.toStringAsFixed(0)}",
                        style: AppTextStyles.title16.copyWith(
                          color: AppColors.primary,
                          fontWeight: FontWeight.w500,
                        ),
                      ),

                      const Spacer(),

                      Container(
                        padding: EdgeInsets.symmetric(
                          horizontal: 10.w,
                          vertical: 6.h,
                        ),
                        decoration: BoxDecoration(
                          color: const Color(0xffFFF4F6),
                          borderRadius: BorderRadius.circular(18.r),
                        ),
                        child: Text(
                          property.purpose == "SALE"
                              ? "For Sale".tr
                              : "For Rent".tr,
                          style: TextStyle(
                            color: AppColors.primary,
                            fontWeight: FontWeight.w600,
                            fontSize: 11.sp,
                          ),
                        ),
                      ),
                    ],
                  ),
                ],
              ),
            ),
          ],
        ),
      ),
    );
  }
}

class PropertyFeatureChip extends StatelessWidget {
  final IconData icon;
  final String value;

  const PropertyFeatureChip({
    super.key,
    required this.icon,
    required this.value,
  });

  @override
  Widget build(BuildContext context) {
    return Padding(
      padding: EdgeInsets.only(right: 18.w),
      child: Row(
        children: [
          Icon(icon, size: 17.sp, color: const Color(0xff7A7A7A)),

          SizedBox(width: 5.w),

          Text(
            value,
            style: AppTextStyles.body13.copyWith(
              color: const Color(0xff555555),
              fontWeight: FontWeight.w600,
            ),
          ),
        ],
      ),
    );
  }
}
