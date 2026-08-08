
import 'package:flutter/cupertino.dart';
import 'package:flutter/material.dart';
import 'package:flutter_screenutil/flutter_screenutil.dart';
import 'package:get/get.dart';

import 'package:villas_qatar/Core/constants/app_colors.dart';
import 'package:villas_qatar/Core/theme/app_textstyles.dart';
import 'package:villas_qatar/modules/propertydetailscreen/propertydetailscreen.dart';
import 'package:villas_qatar/modules/wishlist/service/wishlist_controller.dart';

class PropertyCard extends StatelessWidget {
  final String image;
  final String title;
  final String location;
  final String distance;
  final String price;
  final String sqm;
  final String beds;

  final bool verified;
  final bool isFeatured;

  final String? propertyId;
  final String? slug;

  final int bathrooms;
  final double area;

  /// Optional suffix shown after the price, e.g. "/mo" for rentals.
  final String? priceSuffix;

  const PropertyCard({
    super.key,
    required this.image,
    required this.title,
    required this.location,
    required this.distance,
    required this.price,
    required this.sqm,
    required this.beds,
    this.isFeatured = true,
    this.verified = true,
    this.propertyId,
    this.slug,
    this.bathrooms = 0,
    this.area = 0,
    this.priceSuffix,
  });

  @override
  Widget build(BuildContext context) {
    final WishlistController wishlistController =
        Get.isRegistered<WishlistController>()
        ? Get.find<WishlistController>()
        : Get.put(WishlistController());
        // ? Get.find<WishlistController>()
        // : Get.put(WishlistController());

    return Container(
      width: 168.w,
      margin: EdgeInsets.only(right: 5.w),
      decoration: BoxDecoration(
        color: Colors.white,
        borderRadius: BorderRadius.circular(10.r),
        border: Border.all(color: Colors.grey.shade200, width: 1),
        boxShadow: [
          BoxShadow(
            color: Colors.black.withOpacity(.06),
            blurRadius: 12,
            offset: const Offset(0, 4),
          ),
        ],
      ),
      clipBehavior: Clip.antiAlias,
    
      child: Column(
        crossAxisAlignment: CrossAxisAlignment.start,
        children: [
          /// ===================================================
          /// IMAGE SECTION
          /// ===================================================
          Stack(
            children: [
              _buildImage(),
    
              /// =================================================
              /// FEATURED TAG
              /// =================================================
              if (isFeatured)
                Positioned(
                  top: 10.h,
                  left: 10.w,
                  child: Container(
                    padding: EdgeInsets.symmetric(
                      horizontal: 10.w,
                      vertical: 5.h,
                    ),
                    decoration: BoxDecoration(
                      color: AppColors.primary,
                      borderRadius: BorderRadius.circular(8.r),
                    ),
                    child: Text(
                      "Featured",
                      style: AppTextStyles.medium13.copyWith(
                        color: Colors.white,
                        fontSize: 10.sp,
                      ),
                    ),
                  ),
                ),
    
              /// =================================================
              /// WISHLIST BUTTON
              /// =================================================
              Positioned(
                top: 10.h,
                right: 10.w,
    
                /// GetBuilder rebuilds the heart whenever
                /// WishlistController calls update().
                child: GetBuilder<WishlistController>(
                  init: wishlistController,
                  builder: (controller) {
                    final String id = propertyId?.trim() ?? '';
    
                    final bool wishlisted =
                        id.isNotEmpty && controller.isWishlisted(id);
    
                    final bool wishlistLoading =
                        id.isNotEmpty && controller.isPropertyLoading(id);
    
                    /// Material + InkWell gives this button
                    /// its own tap target.
                    ///
                    /// Tapping here calls wishlist API.
                    /// Tapping rest of card opens details.
                    return Material(
                      color: Colors.transparent,
                      child: InkWell(
                        customBorder: const CircleBorder(),
    
                        onTap: wishlistLoading
                            ? null
                            : () async {
                                if (id.isEmpty) {
                                  ScaffoldMessenger.of(context).showSnackBar(
                                    const SnackBar(
                                      content: Text(
                                        "Property ID is not available",
                                      ),
                                    ),
                                  );
    
                                  return;
                                }
    
                                /// Calls:
                                /// WishlistController
                                ///     .toggleWishlist(id)
                                ///
                                /// which internally calls:
                                ///
                                /// POST wishlistByProperty(id)
                                await controller.toggleWishlist(id);
                              },
    
                        child: Container(
                          width: 32.w,
                          height: 32.w,
                          alignment: Alignment.center,
                          decoration: const BoxDecoration(
                            color: Colors.white,
                            shape: BoxShape.circle,
                          ),
    
                          /// Show loader only for the
                          /// property currently being toggled.
                          child: wishlistLoading
                              ? SizedBox(
                                  width: 15.w,
                                  height: 15.w,
                                  child: const CircularProgressIndicator(
                                    strokeWidth: 2,
                                    color: AppColors.primary,
                                  ),
                                )
                              : Icon(
                                  wishlisted
                                      ? Icons.favorite
                                      : Icons.favorite_border,
                                  size: 18.sp,
                                  color: wishlisted
                                      ? AppColors.primary
                                      : Colors.black87,
                                ),
                        ),
                      ),
                    );
                  },
                ),
              ),
    
              /// =================================================
              /// IMAGE BOTTOM INFO
              /// =================================================
              Positioned(
                bottom: 8.h,
                left: 10.w,
                right: 10.w,
                child: Column(
                  children: [
                    Row(
                      mainAxisAlignment: MainAxisAlignment.spaceBetween,
                      children: [
                        Row(
                          children: [
                            Icon(
                              Icons.people,
                              color: Colors.white,
                              size: 14.sp,
                            ),
                            SizedBox(width: 4.w),
                            Text(
                              beds,
                              style: AppTextStyles.medium13.copyWith(
                                color: Colors.white,
                                fontSize: 11.sp,
                              ),
                            ),
                          ],
                        ),
    
                        Row(
                          children: [
                            Icon(
                              Icons.remove_red_eye_outlined,
                              color: Colors.white,
                              size: 14.sp,
                            ),
                            SizedBox(width: 4.w),
                          ],
                        ),
                      ],
                    ),
    
                    SizedBox(height: 6.h),
    
                    /// VERIFIED
                    Row(
                      children: [
                        Icon(
                          Icons.local_offer_outlined,
                          size: 14.sp,
                          color: verified ? Colors.green : Colors.red,
                        ),
                        SizedBox(width: 4.w),
                        Text(
                          verified ? "Negotiable".tr : "Non-Negotiable".tr,
                          style: AppTextStyles.medium13.copyWith(
                            color: Colors.white,
                            fontSize: 10.sp,
                          ),
                        ),
                      ],
                    ),
                  ],
                ),
              ),
            ],
          ),
    
          /// ===================================================
          /// PROPERTY INFORMATION
          /// ===================================================
          Padding(
            padding: EdgeInsets.symmetric(horizontal: 8.w, vertical: 8.h),
            child: Column(
              crossAxisAlignment: CrossAxisAlignment.start,
              children: [
                /// TITLE
                Text(
                  title,
                  maxLines: 2,
                  overflow: TextOverflow.ellipsis,
                  style: AppTextStyles.title16.copyWith(
                    fontSize: 12.sp,
                    color: AppColors.textPrimary,
                  ),
                ),
    
                SizedBox(height: 6.h),
    
                /// LOCATION
                Row(
                  children: [
                    Icon(
                      Icons.location_on_outlined,
                      size: 12.sp,
                      color: Colors.grey,
                    ),
    
                    SizedBox(width: 4.w),
    
                    Expanded(
                      child: Text(
                        location,
                        maxLines: 1,
                        overflow: TextOverflow.ellipsis,
                        style: AppTextStyles.body13.copyWith(
                          fontSize: 8.sp,
                          color: Colors.grey,
                        ),
                      ),
                    ),
    
                    if (distance.isNotEmpty)
                      Text(
                        distance,
                        style: AppTextStyles.medium13.copyWith(
                          fontSize: 8.sp,
                          color: AppColors.primary,
                        ),
                      ),
                  ],
                ),
    
                SizedBox(height: 5.h),
    
                /// PRICE
                Text(
                  price,
                  maxLines: 1,
                  overflow: TextOverflow.ellipsis,
                  style: AppTextStyles.bold14.copyWith(
                    fontSize: 10.sp,
                    color: AppColors.textPrimary,
                  ),
                ),
    
                SizedBox(height: 5.h),
    
                /// =================================================
                /// BEDS / BATHS / AREA
                /// =================================================
                Row(
                  children: [
                    Flexible(
                      child: Text(
                        "$beds Beds",
                        maxLines: 1,
                        overflow: TextOverflow.ellipsis,
                        style: TextStyle(color: Colors.grey, fontSize: 10.sp),
                      ),
                    ),
    
                    SizedBox(width: 6.w),
    
                    // _buildDot(),
    
                    SizedBox(width: 6.w),
    
                    Flexible(
                      child: Text(
                        "$bathrooms Baths",
                        maxLines: 1,
                        overflow: TextOverflow.ellipsis,
                        style: TextStyle(color: Colors.grey, fontSize: 10.sp),
                      ),
                    ),
    
                    SizedBox(width: 6.w),
    
                    // _buildDot(),
    
                    SizedBox(width: 6.w),
    
                    Flexible(
                      child: Text(
                        _areaText(),
                        maxLines: 1,
                        overflow: TextOverflow.ellipsis,
                        style: TextStyle(color: Colors.grey, fontSize: 10.sp),
                      ),
                    ),
                  ],
                ),
              ],
            ),
          ),
        ],
      ),
    );
  }

  // =============================================================
  // AREA TEXT
  // =============================================================

  String _areaText() {
    /// Prefer area if it has a valid value.
    if (area > 0) {
      return "${area.toStringAsFixed(0)} sqm";
    }

    /// Otherwise use the sqm string passed from parent.
    if (sqm.trim().isNotEmpty) {
      return "${sqm.trim()} sqm";
    }

    return "0 sqm";
  }

  // =============================================================
  // PROPERTY IMAGE
  // =============================================================

  Widget _buildImage() {
    final String cleanImage = image.trim();

    final bool validNetworkImage =
        cleanImage.startsWith('https://') || cleanImage.startsWith('http://');

    if (validNetworkImage) {
      return Image.network(
        cleanImage,
        height: 120.h,
        width: double.infinity,
        fit: BoxFit.cover,
        loadingBuilder: (context, child, loadingProgress) {
          if (loadingProgress == null) {
            return child;
          }

        return _imagePlaceholder(showLoader: true);
      },
      errorBuilder: (context, error, stackTrace) {
        return _imagePlaceholder();
      },
    );
  }

    /// LOCAL ASSET
    if (cleanImage.startsWith(
      'assets/',
    )) {
      return Image.asset(
        cleanImage,
        height: 120.h,
        width: double.infinity,
        fit: BoxFit.cover,
        errorBuilder: (
          context,
          error,
          stackTrace,
        ) {
          return _imagePlaceholder();
        },
      );
    }

    /// INVALID / EMPTY IMAGE
    return _imagePlaceholder();
  }

  // =============================================================
  // IMAGE PLACEHOLDER
  // =============================================================

  Widget _imagePlaceholder({
    bool showLoader = false,
  }) {
    return Container(
      height: 120.h,
      width: double.infinity,
      color: const Color(0xffF2F2F2),
      alignment: Alignment.center,
      child: showLoader
          ? SizedBox(
              width: 20.w,
              height: 20.w,
              child: const CircularProgressIndicator(
                strokeWidth: 2,
                color: Color(0xFF8E123E),
              ),
            )
          : Icon(
              Icons.home_work_outlined,
              size: 28.sp,
              color: Colors.grey.shade400,
            ),
    );
  }
}
