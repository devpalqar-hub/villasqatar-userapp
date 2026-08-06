import 'package:flutter/material.dart';
import 'package:flutter_screenutil/flutter_screenutil.dart';


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
    return Material(
      color: Colors.transparent,
      child: InkWell(
        borderRadius: BorderRadius.circular(14.r),
        onTap: onTap,
        child: Container(
          width: 145.w,
          padding: EdgeInsets.symmetric(
            horizontal: 12.w,
            vertical: 14.h,
          ),
          decoration: BoxDecoration(
            color: Colors.white,
            borderRadius: BorderRadius.circular(14.r),
            border: Border.all(
              color: const Color(0xFFECECEC),
            ),
            boxShadow: [
              BoxShadow(
                color: Colors.black.withOpacity(.04),
                blurRadius: 10,
                offset: const Offset(0, 3),
              ),
            ],
          ),
          child: Column(
            mainAxisAlignment: MainAxisAlignment.center,
            children: [
              Hero(
                tag: phone,
                child: CircleAvatar(
                  radius: 35.r,
                  backgroundColor: const Color(0xFFF5F5F5),
                  backgroundImage: image.startsWith("http")
                      ? NetworkImage(image)
                      : AssetImage(image) as ImageProvider,
                ),
              ),

              SizedBox(height: 12.h),

              Text(
                name,
                maxLines: 1,
                overflow: TextOverflow.ellipsis,
                textAlign: TextAlign.center,
                style: TextStyle(
                  fontSize: 13.sp,
                  fontWeight: FontWeight.w600,
                ),
              ),

              SizedBox(height: 5.h),

              Text(
                designation,
                maxLines: 2,
                overflow: TextOverflow.ellipsis,
                textAlign: TextAlign.center,
                style: TextStyle(
                  fontSize: 10.sp,
                  color: const Color(0xFF777777),
                ),
              ),
            ],
          ),
        ),
      ),
    );
  }
}