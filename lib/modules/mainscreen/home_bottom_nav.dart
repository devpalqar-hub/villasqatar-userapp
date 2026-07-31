import 'package:flutter/cupertino.dart';
import 'package:flutter/material.dart';
import 'package:flutter_screenutil/flutter_screenutil.dart';
import 'package:get/get_utils/src/extensions/internacionalization.dart';

import 'package:villas_qatar/Core/constants/app_colors.dart';

class HomeBottomNav extends StatelessWidget {
  final int currentIndex;
  final ValueChanged<int> onChanged;

  const HomeBottomNav({
    super.key,
    required this.currentIndex,
    required this.onChanged,
  });

  @override
  Widget build(BuildContext context) {
    return SafeArea(
      top: false,
      child: Container(
        height: 65.h,
        margin: EdgeInsets.only(left: 8.w, right: 8.w, bottom: 10.h),
        decoration: BoxDecoration(
          color: AppColors.primary,
          borderRadius: BorderRadius.all(Radius.circular(40.r)),
        ),
        child: Row(
          children: [
            _navItem(icon: CupertinoIcons.home, label: "Home".tr, index: 0),
            _navItem(icon: CupertinoIcons.search, label: "Search".tr, index: 1),
            _navItem(
              icon: CupertinoIcons.add_circled,
              label: "Add".tr,
              index: 2,
            ),
            _navItem(
              icon: CupertinoIcons.chat_bubble,
              label: "Chats".tr,
              index: 3,
              showBadge: true,
            ),
            _navItem(
              icon: CupertinoIcons.profile_circled,
              label: "Profile".tr,
              index: 4,
            ),
          ],
        ),
      ),
    );
  }

  Widget _navItem({
    required IconData icon,
    required String label,
    required int index,
    bool showBadge = false,
  }) {
    final selected = currentIndex == index;

    return Expanded(
      child: InkWell(
        borderRadius: BorderRadius.circular(40.r),
        onTap: () => onChanged(index),
        child: Column(
          mainAxisAlignment: MainAxisAlignment.center,
          children: [
            Stack(
              clipBehavior: Clip.none,
              alignment: Alignment.center,
              children: [
                Container(
                  width: 38.w,
                  height: 38.w,
                  decoration: BoxDecoration(
                    color: selected
                        ? const Color(0xffA71A46)
                        : Colors.transparent,
                    shape: BoxShape.circle,
                  ),
                  child: Icon(icon, color: Colors.white, size: 22.sp),
                ),
                if (showBadge)
                  Positioned(
                    top: -2.h,
                    right: 4.w,
                    child: Container(
                      width: 8.w,
                      height: 8.w,
                      decoration: const BoxDecoration(
                        color: Colors.redAccent,
                        shape: BoxShape.circle,
                      ),
                    ),
                  ),
              ],
            ),
            SizedBox(height: 2.h),
            Text(
              label,
              style: TextStyle(
                color: Colors.white,
                fontSize: 10.sp,
                fontWeight: FontWeight.w500,
              ),
            ),
          ],
        ),
      ),
    );
  }
}
