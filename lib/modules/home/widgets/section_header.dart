import 'package:flutter/material.dart';
import 'package:flutter_screenutil/flutter_screenutil.dart';
import 'package:get/get_utils/src/extensions/internacionalization.dart';
import 'package:villas_qatar/Core/theme/app_textstyles.dart';

import '../../../Core/constants/app_colors.dart';

class SectionHeader extends StatelessWidget {
  final String title;
  final bool showSeeAll;
  final VoidCallback? onSeeAllTap;

  const SectionHeader({
    super.key,
    required this.title,
    this.showSeeAll = true,
    this.onSeeAllTap,
  });

  @override
  Widget build(BuildContext context) {
    return Row(
      children: [
        Text(
          title,
          style: AppTextStyles.bold14.copyWith(
            color: AppColors.textPrimary,
          ),
        ),

        const Spacer(),

        if (showSeeAll)
          InkWell(
            onTap: onSeeAllTap,
            child: Row(
              children: [
                Text(
                  'See all'.tr,
                  style: AppTextStyles.medium13.copyWith(
                    color: AppColors.primary,
                    fontSize: 11.sp,
                  ),
                ),
                SizedBox(width: 4.w),
                Icon(
                  Icons.arrow_forward,
                  color: AppColors.primary,
                  size: 16.sp,
                ),
              ],
            ),
          ),
      ],
    );
  }
}