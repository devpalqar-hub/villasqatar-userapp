import 'package:flutter/material.dart';
import 'package:flutter_screenutil/flutter_screenutil.dart';
import 'package:villas_qatar/Core/constants/app_colors.dart';

class AgentReviewCard extends StatelessWidget {
  const AgentReviewCard({super.key});

  @override
  Widget build(BuildContext context) {
    return Container(
      padding: EdgeInsets.all(16.w),
      decoration: BoxDecoration(
        color: Colors.white,
        borderRadius: BorderRadius.circular(16.r),
        border: Border.all(color: AppColors.fieldBorder),
        boxShadow: [
          BoxShadow(
            color: Colors.black.withOpacity(.03),
            blurRadius: 10,
            offset: const Offset(0, 3),
          ),
        ],
      ),
      child: Column(
        children: [
          Row(
            children: [
              CircleAvatar(
                radius: 22.r,
                backgroundColor: AppColors.primary.withOpacity(.1),
                child: Icon(
                  Icons.person,
                  color: AppColors.primary,
                  size: 22.sp,
                ),
              ),

              SizedBox(width: 12.w),

              Expanded(
                child: Column(
                  crossAxisAlignment: CrossAxisAlignment.start,
                  children: [
                    Text(
                      "John Smith",
                      style: TextStyle(
                        fontSize: 13.sp,
                        fontWeight: FontWeight.w700,
                      ),
                    ),

                    SizedBox(height: 3.h),

                    Row(
                      children: List.generate(
                        5,
                        (index) =>
                            Icon(Icons.star, size: 15.sp, color: Colors.amber),
                      ),
                    ),
                  ],
                ),
              ),

              Text(
                "2 days ago",
                style: TextStyle(color: Colors.grey, fontSize: 11.sp),
              ),
            ],
          ),

          SizedBox(height: 14.h),

          Text(
            "Ahmed was extremely professional and helped us find the perfect villa. He explained every detail clearly and made the buying process very smooth. Highly recommended.",
            style: TextStyle(
              fontSize: 12.sp,
              color: Colors.grey.shade700,
              height: 1.6,
            ),
          ),
        ],
      ),
    );
  }
}
