import 'package:flutter/material.dart';
import 'package:flutter_screenutil/flutter_screenutil.dart';
import 'package:font_awesome_flutter/font_awesome_flutter.dart';
import 'package:url_launcher/url_launcher.dart';
import 'package:villas_qatar/Core/constants/app_colors.dart';
import 'package:villas_qatar/modules/agent/view/agent_detailscreen.dart';

class AgentCards extends StatelessWidget {
  final String image;
  final String name;
  final String designation;
  final String rating;
  final String reviews;
  final String phone;

  const AgentCards({
    super.key,
    required this.image,
    required this.name,
    required this.designation,
    required this.rating,
    required this.reviews,
    required this.phone,
  });

  @override
  Widget build(BuildContext context) {
    return InkWell(
      borderRadius: BorderRadius.circular(14.r),
      onTap: () {
        Navigator.push(
          context,
          PageRouteBuilder(
            transitionDuration: const Duration(milliseconds: 900),
            reverseTransitionDuration: const Duration(milliseconds: 350),
            pageBuilder: (_, animation, secondaryAnimation) =>
                const AgentDetailScreen(),
            transitionsBuilder: (_, animation, secondaryAnimation, child) {
              const begin = Offset(1.0, 0.0); // Right
              const end = Offset.zero;
              const curve = Curves.easeOutCubic;

              final tween = Tween(
                begin: begin,
                end: end,
              ).chain(CurveTween(curve: curve));

              return SlideTransition(
                position: animation.drive(tween),
                child: child,
              );
            },
          ),
        );
      },
      child: Container(
        width: 170.w,
        padding: EdgeInsets.symmetric(horizontal: 14.w, vertical: 12.h),
        decoration: BoxDecoration(
          color: Colors.white,
          borderRadius: BorderRadius.circular(14.r),
          border: Border.all(color: const Color(0xffECECEC)),
          boxShadow: [
            BoxShadow(
              color: Colors.black.withOpacity(.04),
              blurRadius: 10,
              offset: const Offset(0, 3),
            ),
          ],
        ),
        child: Column(
          children: [
            /// Avatar
            Hero(
              tag: phone,
              child: CircleAvatar(
                radius: 38.r,
                backgroundColor: const Color(0xffF6F6F6),
                backgroundImage: AssetImage(image),
              ),
            ),

            SizedBox(height: 12.h),

            /// Name
            Text(
              name,
              maxLines: 2,
              textAlign: TextAlign.center,
              overflow: TextOverflow.ellipsis,
              style: TextStyle(
                fontSize: 13.sp,
                fontWeight: FontWeight.w700,
                color: const Color(0xff222222),
              ),
            ),

            SizedBox(height: 4.h),

            /// Designation
            Text(
              designation,
              maxLines: 2,
              textAlign: TextAlign.center,
              overflow: TextOverflow.ellipsis,
              style: TextStyle(
                fontSize: 10.sp,
                color: const Color(0xff7B7B7B),
                height: 1.3,
              ),
            ),

            SizedBox(height: 10.h),

            /// Rating
            Row(
              mainAxisAlignment: MainAxisAlignment.center,
              children: [
                Icon(Icons.star_rounded, color: Colors.amber, size: 16.sp),
                SizedBox(width: 4.w),
                Text(
                  rating,
                  style: TextStyle(
                    fontWeight: FontWeight.w700,
                    fontSize: 11.sp,
                  ),
                ),
                Text(
                  " ($reviews)",
                  style: TextStyle(
                    fontSize: 10.sp,
                    color: Colors.grey.shade600,
                  ),
                ),
              ],
            ),

            SizedBox(height: 6.h),

            /// Phone
            Text(
              phone,
              style: TextStyle(
                fontSize: 10.sp,
                color: Colors.grey.shade700,
                fontWeight: FontWeight.w600,
              ),
            ),

            const Spacer(),

            /// Chat & Call Buttons
            Row(
              children: [
                Expanded(
                  child: InkWell(
                    borderRadius: BorderRadius.circular(10.r),
                    onTap: _openWhatsApp,
                    child: Container(
                      height: 38.h,
                      decoration: BoxDecoration(
                        color: const Color(0xffFFF4F6),
                        borderRadius: BorderRadius.circular(10.r),
                      ),
                      child: Center(
                        child: FaIcon(
                          FontAwesomeIcons.whatsapp,
                          color: const Color(0xFF25D366),
                          size: 20.sp,
                        ),
                      ),
                    ),
                  ),
                ),

                SizedBox(width: 10.w),

                Expanded(
                  child: InkWell(
                    borderRadius: BorderRadius.circular(10.r),
                    onTap: _makeCall,
                    child: Container(
                      height: 38.h,
                      decoration: BoxDecoration(
                        color: const Color(0xffFFF4F6),
                        borderRadius: BorderRadius.circular(10.r),
                      ),
                      child: Center(
                        child: Icon(
                          Icons.call_outlined,
                          color: AppColors.primary,
                          size: 20.sp,
                        ),
                      ),
                    ),
                  ),
                ),
              ],
            ),
          ],
        ),
      ),
    );
  }

  Future<void> _openWhatsApp() async {
    // Remove spaces, +, -, etc.
    final number = phone.replaceAll(RegExp(r'[^0-9]'), '');

    final Uri uri = Uri.parse("https://wa.me/$number?text=Hello");

    if (await canLaunchUrl(uri)) {
      await launchUrl(uri, mode: LaunchMode.externalApplication);
    }
  }

  Future<void> _makeCall() async {
    final Uri uri = Uri(scheme: 'tel', path: phone);

    if (await canLaunchUrl(uri)) {
      await launchUrl(uri);
    }
  }
}
