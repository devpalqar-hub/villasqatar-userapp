import 'package:flutter/material.dart';
import 'package:flutter_screenutil/flutter_screenutil.dart';
import 'package:villas_qatar/Core/constants/app_colors.dart';
import 'package:villas_qatar/Core/theme/app_textstyles.dart';
import 'package:villas_qatar/Core/widgets/motion/pressable_scale.dart';

/// Featured-dealer tile in the website's partner-logo style: a flat white
/// card with soft shadow (no border) showing the dealer's logo with their
/// name centered underneath — falls back to a generic icon placeholder
/// tile when there's no logo.
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
          borderRadius: BorderRadius.circular(8.r),
          onTap: onTap,
          child: Container(
            width: 120.w,
            height:80.h,
            padding: EdgeInsets.fromLTRB(10.w, 10.h, 10.w, 10.h),
            decoration: BoxDecoration(
              color: AppColors.white,
              borderRadius: BorderRadius.circular(8.r),
              border: Border.all(color: Colors.grey.withOpacity(0.2)),
              boxShadow: [
                BoxShadow(
                  color: Colors.black.withOpacity(.06),
                  blurRadius: 12,
                  offset: const Offset(0, 4),
                ),
              ],
            ),
            child: Column(
              mainAxisSize: MainAxisSize.min,
              crossAxisAlignment: CrossAxisAlignment.center,
              children: [
                SizedBox(
                  height: 32.h,
                  width: double.infinity,
                  child: _buildLogo(),
                ),

                SizedBox(height: 6.h),

                Text(
                  name,
                  maxLines: 1,
                  overflow: TextOverflow.ellipsis,
                  textAlign: TextAlign.center,
                  style: AppTextStyles.bold14.copyWith(
                    fontSize: 11.sp,
                    fontWeight: FontWeight.w700,
                    color: AppColors.ink,
                    letterSpacing: -0.1,
                  ),
                ),
              ],
            ),
          ),
        ),
      ),
    );
  }

  Widget _buildLogo() {
    if (image.trim().isEmpty) {
      return _placeholder();
    }

    return image.startsWith("http")
        ? Image.network(
            image,
            fit: BoxFit.contain,
            errorBuilder: (_, __, ___) => _placeholder(),
          )
        : Image.asset(
            image,
            fit: BoxFit.contain,
            errorBuilder: (_, __, ___) => _placeholder(),
          );
  }

  Widget _placeholder() {
    return Container(
      decoration: BoxDecoration(
        color: AppColors.sand,
        borderRadius: BorderRadius.circular(8.r),
      ),
      alignment: Alignment.center,
      child: Icon(Icons.business_rounded, size: 18.sp, color: AppColors.gold),
    );
  }
}
