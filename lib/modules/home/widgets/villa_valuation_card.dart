import 'package:flutter/material.dart';
import 'package:flutter_screenutil/flutter_screenutil.dart';
import 'package:get/get_utils/src/extensions/internacionalization.dart';
import 'package:villas_qatar/Core/constants/app_colors.dart';
import 'package:villas_qatar/Core/theme/app_textstyles.dart';
import 'package:villas_qatar/Core/widgets/motion/pressable_scale.dart';

/// Compact "AI Price Estimator" promo banner: eyebrow + headline + CTA on
/// the left, a photo thumbnail with a floating estimate badge on the right.
class VillaValuationCard extends StatelessWidget {
  const VillaValuationCard({super.key, required this.onGetEstimate});

  final VoidCallback onGetEstimate;

  @override
  Widget build(BuildContext context) {
    return Container(
      width: double.infinity,
      padding: EdgeInsets.fromLTRB(16.w, 16.h, 12.w, 16.h),
      decoration: BoxDecoration(
        color: AppColors.cream,
        borderRadius: BorderRadius.circular(20.r),
        border: Border.all(color: AppColors.warmBorder),
      ),
      child: Row(
        crossAxisAlignment: CrossAxisAlignment.center,
        children: [
          Expanded(
            child: Column(
              crossAxisAlignment: CrossAxisAlignment.start,
              children: [
                Row(
                  mainAxisSize: MainAxisSize.min,
                  children: [
                    Icon(Icons.auto_awesome, size: 12.sp, color: AppColors.gold),
                    SizedBox(width: 6.w),
                    Text(
                      "AI PRICE ESTIMATOR".tr,
                      style: AppTextStyles.bold12.copyWith(
                        fontSize: 9.5.sp,
                        fontWeight: FontWeight.w700,
                        letterSpacing: 0.6,
                        color: AppColors.gold,
                      ),
                    ),
                  ],
                ),

                SizedBox(height: 10.h),

                Text(
                  "Know Your Property's True Value".tr,
                  style: AppTextStyles.title18.copyWith(
                    fontSize: 16.5.sp,
                    fontWeight: FontWeight.w700,
                    color: AppColors.ink,
                    height: 1.25,
                    letterSpacing: -0.2,
                  ),
                ),

                SizedBox(height: 6.h),

                Text(
                  "Get AI-powered accurate price estimates in seconds.".tr,
                  style: AppTextStyles.body13.copyWith(
                    fontSize: 11.sp,
                    color: AppColors.inkMuted,
                    height: 1.45,
                  ),
                ),

                SizedBox(height: 14.h),

                _EstimateCta(onPressed: onGetEstimate),
              ],
            ),
          ),

          SizedBox(width: 14.w),

          _ThumbnailWithBadge(),
        ],
      ),
    );
  }
}

/// Rounded property photo with a floating "AI Estimate" value chip.
class _ThumbnailWithBadge extends StatelessWidget {
  const _ThumbnailWithBadge();

  @override
  Widget build(BuildContext context) {
    return Stack(
      clipBehavior: Clip.none,
      children: [
        ClipRRect(
          borderRadius: BorderRadius.circular(16.r),
          child: Image.asset(
            "assets/hero-bg.jpg",
            width: 96.w,
            height: 110.h,
            fit: BoxFit.cover,
            errorBuilder: (_, __, ___) => Container(
              width: 96.w,
              height: 110.h,
              color: AppColors.sand,
              child: Icon(
                Icons.villa_outlined,
                color: AppColors.gold,
                size: 28.sp,
              ),
            ),
          ),
        ),

        Positioned(
          top: -14.h,
          right: -6.w,
          child: Container(
            padding: EdgeInsets.symmetric(horizontal: 8.w, vertical: 6.h),
            decoration: BoxDecoration(
              color: Colors.white,
              borderRadius: BorderRadius.circular(10.r),
              boxShadow: [
                BoxShadow(
                  color: Colors.black.withOpacity(.12),
                  blurRadius: 10,
                  offset: const Offset(0, 4),
                ),
              ],
            ),
            child: Column(
              crossAxisAlignment: CrossAxisAlignment.start,
              children: [
                Text(
                  "AI Estimate".tr,
                  style: AppTextStyles.body13.copyWith(
                    fontSize: 7.5.sp,
                    fontWeight: FontWeight.w600,
                    color: AppColors.inkFaint,
                  ),
                ),
                SizedBox(height: 2.h),
                Row(
                  mainAxisSize: MainAxisSize.min,
                  children: [
                    Text(
                      "QAR 2.4M",
                      style: AppTextStyles.bold12.copyWith(
                        fontSize: 10.5.sp,
                        fontWeight: FontWeight.w700,
                        color: AppColors.trendText,
                      ),
                    ),
                    SizedBox(width: 2.w),
                    Icon(
                      Icons.trending_up_rounded,
                      size: 11.sp,
                      color: AppColors.trendText,
                    ),
                  ],
                ),
              ],
            ),
          ),
        ),
      ],
    );
  }
}

/// Maroon gradient "Estimate Now" button.
class _EstimateCta extends StatelessWidget {
  const _EstimateCta({required this.onPressed});

  final VoidCallback onPressed;

  @override
  Widget build(BuildContext context) {
    return PressableScale(
      child: InkWell(
        borderRadius: BorderRadius.circular(999.r),
        onTap: onPressed,
        child: Container(
          padding: EdgeInsets.symmetric(horizontal: 16.w, vertical: 10.h),
          decoration: BoxDecoration(
            gradient: AppColors.ctaGradient,
            borderRadius: BorderRadius.circular(999.r),
            boxShadow: [
              BoxShadow(
                color: AppColors.primary.withOpacity(.22),
                blurRadius: 14,
                offset: const Offset(0, 6),
              ),
            ],
          ),
          child: Row(
            mainAxisSize: MainAxisSize.min,
            children: [
              Text(
                "Estimate Now".tr,
                style: AppTextStyles.bold14.copyWith(
                  fontSize: 12.sp,
                  fontWeight: FontWeight.w600,
                  color: AppColors.white,
                ),
              ),
              SizedBox(width: 8.w),
              Icon(
                Icons.arrow_forward_rounded,
                size: 14.sp,
                color: AppColors.white,
              ),
            ],
          ),
        ),
      ),
    );
  }
}
