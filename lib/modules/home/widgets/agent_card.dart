import 'package:flutter/material.dart';
import 'package:flutter_screenutil/flutter_screenutil.dart';
import 'package:villas_qatar/modules/agent/view/agent_detailscreen.dart';

class AgentCards extends StatelessWidget {
  final String image;
  final String name;
  final String designation;
  final String phone;

  const AgentCards({
    super.key,
    required this.image,
    required this.name,
    required this.designation,
    required this.phone,
  });

  @override
  Widget build(BuildContext context) {
    return Material(
      color: Colors.transparent,
      child: InkWell(
        borderRadius: BorderRadius.circular(14.r),
        onTap: () => _openAgentDetails(context),

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
              width: 1,
            ),
            boxShadow: [
              BoxShadow(
                color: Colors.black.withOpacity(0.04),
                blurRadius: 10,
                offset: const Offset(0, 3),
              ),
            ],
          ),

          child: Column(
            mainAxisAlignment: MainAxisAlignment.center,
            children: [
              /// PROFILE IMAGE
              Hero(
                tag: phone,
                child: CircleAvatar(
                  radius: 35.r,
                  backgroundColor: const Color(0xFFF5F5F5),
                  backgroundImage: AssetImage(image),
                ),
              ),

              SizedBox(height: 12.h),

              /// AGENT NAME
              Text(
                name,
                maxLines: 1,
                overflow: TextOverflow.ellipsis,
                textAlign: TextAlign.center,
                style: TextStyle(
                  fontSize: 13.sp,
                  fontWeight: FontWeight.w600,
                  color: const Color(0xFF222222),
                ),
              ),

              SizedBox(height: 5.h),

              /// ROLE
              Text(
                designation,
                maxLines: 2,
                overflow: TextOverflow.ellipsis,
                textAlign: TextAlign.center,
                style: TextStyle(
                  fontSize: 10.sp,
                  fontWeight: FontWeight.w400,
                  color: const Color(0xFF777777),
                  height: 1.3,
                ),
              ),
            ],
          ),
        ),
      ),
    );
  }

  void _openAgentDetails(BuildContext context) {
    Navigator.push(
      context,
      PageRouteBuilder(
        transitionDuration: const Duration(milliseconds: 400),
        reverseTransitionDuration:
            const Duration(milliseconds: 250),

        pageBuilder: (
          context,
          animation,
          secondaryAnimation,
        ) =>
            const AgentDetailScreen(),

        transitionsBuilder: (
          context,
          animation,
          secondaryAnimation,
          child,
        ) {
          final position = Tween<Offset>(
            begin: const Offset(1, 0),
            end: Offset.zero,
          ).animate(
            CurvedAnimation(
              parent: animation,
              curve: Curves.easeOutCubic,
            ),
          );

          return SlideTransition(
            position: position,
            child: child,
          );
        },
      ),
    );
  }
}