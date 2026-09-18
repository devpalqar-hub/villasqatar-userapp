import 'package:flutter/material.dart';
import 'package:flutter_screenutil/flutter_screenutil.dart';
import 'package:villas_qatar/Core/constants/app_colors.dart';
import 'package:villas_qatar/Core/theme/app_textstyles.dart';
import 'package:villas_qatar/Core/widgets/motion/pressable_scale.dart';

/// Featured-dealer card in the website's card style: white tile, neutral
/// hairline border, 16px corners, with the dealer's avatar ringed in the brand
/// tint and the tagline in muted ink.
class AgentCards extends StatelessWidget {
  final String image;
  final String name;
  final String designation;
  final String phone;
  final VoidCallback? onTap;

  const AgentCards({
    super.key,
    required this.image,
    required this.name,
    required this.designation,
    required this.phone,
    this.onTap,
  });

  @override
  Widget build(BuildContext context) {
    return PressableScale(
      child: Material(
        color: Colors.transparent,
        child: InkWell(
          borderRadius: BorderRadius.circular(16.r),
          onTap: onTap,
          child: Container(
            width: 145.w,
            padding: EdgeInsets.symmetric(horizontal: 12.w, vertical: 16.h),
            decoration: BoxDecoration(
              color: AppColors.white,
              borderRadius: BorderRadius.circular(16.r),
              border: Border.all(color: AppColors.coolBorder),
            ),
            child: Column(
              mainAxisAlignment: MainAxisAlignment.center,
              children: [
                /// Avatar with a soft gold ring, echoing the site's dealer
                /// cards, which frame the logo in a warm border.
                Container(
                  padding: EdgeInsets.all(2.5.r),
                  decoration: BoxDecoration(
                    shape: BoxShape.circle,
                    border: Border.all(color: AppColors.goldBorder),
                  ),
                  child: Hero(
                    tag: phone,
                    child: CircleAvatar(
                      radius: 32.r,
                      backgroundColor: AppColors.sand,
                      backgroundImage: image.startsWith("http")
                          ? NetworkImage(image)
                          : AssetImage(image) as ImageProvider,
                    ),
                  ),
                ),

                SizedBox(height: 12.h),

                Text(
                  name,
                  maxLines: 1,
                  overflow: TextOverflow.ellipsis,
                  textAlign: TextAlign.center,
                  style: AppTextStyles.bold14.copyWith(
                    fontSize: 12.5.sp,
                    fontWeight: FontWeight.w700,
                    color: AppColors.ink,
                    letterSpacing: -0.1,
                  ),
                ),

                SizedBox(height: 5.h),

                Text(
                  designation,
                  maxLines: 2,
                  overflow: TextOverflow.ellipsis,
                  textAlign: TextAlign.center,
                  style: AppTextStyles.body13.copyWith(
                    fontSize: 10.sp,
                    color: AppColors.inkMuted,
                    height: 1.4,
                  ),
                ),
              ],
            ),
          ),
        ),
      ),
    );
  }
}
