import 'package:animate_do/animate_do.dart';
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

    return InkWell(
      splashColor: Colors.transparent,
      onTap: () {
        final String id = propertyId?.trim() ?? '';

        if (id.isEmpty) {
          ScaffoldMessenger.of(context).showSnackBar(
            const SnackBar(content: Text("Property details are not available")),
          );

          return;
        }

        Get.to(
          () => const PropertyDetailsScreen(),
          arguments: {"propertyId": id},
          transition: Transition.rightToLeft,
          duration: const Duration(milliseconds: 500),
        );
      },

      child: FadeInRight(
        child: Container(
          width: 220.w,
          margin: EdgeInsets.only(right: 12.w),
          decoration: BoxDecoration(
            color: Colors.white,
            borderRadius: BorderRadius.circular(8.r),
            border: Border.all(
              color: Colors.black.withValues(alpha: .05),
              width: 1,
            ),
            boxShadow: [
              BoxShadow(
                color: Colors.black.withOpacity(.01),
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
                            fontWeight: FontWeight.w500,
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

                        return Material(
                          color: Colors.transparent,
                          child: InkWell(
                            customBorder: const CircleBorder(),

                            onTap: wishlistLoading
                                ? null
                                : () async {
                                    if (id.isEmpty) {
                                      ScaffoldMessenger.of(
                                        context,
                                      ).showSnackBar(
                                        const SnackBar(
                                          content: Text(
                                            "Property ID is not available",
                                          ),
                                        ),
                                      );

                                      return;
                                    }

                                    await controller.toggleWishlist(id);
                                  },

                            child: Container(
                              width: 25.w,
                              height: 25.w,
                              alignment: Alignment.center,
                              decoration: BoxDecoration(
                                color: Colors.white.withValues(alpha: .8),
                                shape: BoxShape.circle,
                              ),

                              /// Show loader only for the
                              /// property currently being toggled.
                              child: wishlistLoading
                                  ? SizedBox(
                                      width: 14.w,
                                      height: 14.w,
                                      child: CircularProgressIndicator(
                                        strokeWidth: 2,
                                        color: Colors.white,
                                      ),
                                    )
                                  : Icon(
                                      wishlisted
                                          ? CupertinoIcons.heart_solid
                                          : CupertinoIcons.heart,
                                      size: 15.sp,
                                      color: wishlisted
                                          ? AppColors.primary
                                          : AppColors.primary,
                                    ),
                            ),
                          ),
                        );
                      },
                    ),
                  ),
                ],
              ),

              /// ===================================================
              /// PROPERTY INFORMATION
              /// ===================================================
              Padding(
                padding: EdgeInsets.symmetric(horizontal: 10.w),
                child: Column(
                  crossAxisAlignment: CrossAxisAlignment.start,
                  children: [
                    SizedBox(height: 10.w),
                    Row(
                      children: [
                        Icon(
                          CupertinoIcons.map,
                          size: 12.sp,
                          color: AppColors.primary,
                        ),
                        SizedBox(width: 5.w),
                        Expanded(
                          child: Text(
                            location,
                            maxLines: 1,
                            overflow: TextOverflow.ellipsis,
                            style: AppTextStyles.body13.copyWith(
                              fontSize: 10.sp,
                              color: Colors.grey.shade600,
                            ),
                          ),
                        ),
                      ],
                    ),
                    SizedBox(height: 5.h),
                    Text(
                      title,
                      maxLines: 1,
                      overflow: TextOverflow.ellipsis,
                      style: AppTextStyles.title16.copyWith(
                        fontSize: 13.sp,
                        fontWeight: FontWeight.w500,
                        color: AppColors.textPrimary,
                      ),
                    ),

                    SizedBox(height: 5.h),
                    Row(
                      children: [
                        _buildStat(icon: Icons.bed_outlined, label: beds),
                        SizedBox(width: 10.w),
                        _buildStat(
                          icon: Icons.bathtub_outlined,
                          label: "$bathrooms",
                        ),
                        SizedBox(width: 10.w),
                        _buildStat(
                          icon: Icons.square_foot_outlined,
                          label: _areaText(),
                        ),
                      ],
                    ),

                    SizedBox(height: 8.h),

                    /// PRICE
                    Row(
                      crossAxisAlignment: CrossAxisAlignment.baseline,
                      textBaseline: TextBaseline.alphabetic,
                      children: [
                        Flexible(
                          child: Text(
                            "QAR " + price,
                            maxLines: 1,
                            overflow: TextOverflow.ellipsis,
                            style: AppTextStyles.bold14.copyWith(
                              fontSize: 14.sp,
                              fontWeight: FontWeight.w500,
                              color: const Color(0xFF8E123E),
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
      ),
    );
  }

  // =============================================================
  // STAT (ICON + LABEL) — used for beds / baths / area row
  // =============================================================

  Widget _buildStat({required IconData icon, required String label}) {
    return Row(
      mainAxisSize: MainAxisSize.min,
      children: [
        Icon(icon, size: 13.sp, color: Colors.grey.shade500),
        SizedBox(width: 3.w),
        Text(
          label,
          maxLines: 1,
          overflow: TextOverflow.ellipsis,
          style: TextStyle(
            color: Colors.grey.shade700,
            fontSize: 9.5.sp,
            fontWeight: FontWeight.w500,
          ),
        ),
      ],
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
    return Image.network(
      image,
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

  Widget _imagePlaceholder({bool showLoader = false}) {
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
