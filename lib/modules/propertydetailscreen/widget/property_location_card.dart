import 'package:flutter/material.dart';
import 'package:flutter_screenutil/flutter_screenutil.dart';
import 'package:get/get_utils/src/extensions/internacionalization.dart';
import 'package:url_launcher/url_launcher.dart';
import 'package:villas_qatar/modules/propertylist/model/myproperty_model.dart';

class PropertyLocationCard extends StatelessWidget {
  final Property property;

  const PropertyLocationCard({
    super.key,
    required this.property,
  });

  static const Color primary = Color(0xFFA60F46);

  @override
  Widget build(BuildContext context) {
    return Container(
      width: double.infinity,
      padding: EdgeInsets.fromLTRB(
        14.w,
        15.h,
        14.w,
        13.h,
      ),
      decoration: BoxDecoration(
        color: Colors.white,
        borderRadius: BorderRadius.circular(12.r),
        border: Border.all(
          color: const Color(0xFFE7E7E7),
          width: 1,
        ),
      ),
      child: Column(
        crossAxisAlignment: CrossAxisAlignment.start,
        children: [
          // =========================================================
          // LOCATION TITLE
          // =========================================================
          Text(
            "Location".tr,
            style: TextStyle(
              fontSize: 16.sp,
              fontWeight: FontWeight.w700,
              color: const Color(0xFF1F2937),
            ),
          ),

          SizedBox(height: 11.h),

          // =========================================================
          // ADDRESS LEFT + MAP RIGHT
          // =========================================================
          Row(
            crossAxisAlignment: CrossAxisAlignment.start,
            children: [
              // ADDRESS PILL
              Expanded(
                child: Align(
                  alignment: Alignment.centerLeft,
                  child: Container(
                    constraints: BoxConstraints(
                      maxWidth: 155.w,
                    ),
                    padding: EdgeInsets.symmetric(
                      horizontal: 11.w,
                      vertical: 6.h,
                    ),
                    decoration: BoxDecoration(
                      color: Colors.white,
                      borderRadius: BorderRadius.circular(30.r),
                      boxShadow: [
                        BoxShadow(
                          color: Colors.black.withOpacity(.08),
                          blurRadius: 14,
                          offset: const Offset(0, 5),
                        ),
                      ],
                    ),
                    child: Row(
                      mainAxisSize: MainAxisSize.min,
                      children: [
                        Icon(
                          Icons.location_on_rounded,
                          size: 15.sp,
                          color: primary,
                        ),

                        SizedBox(width: 7.w),

                        Flexible(
                          child: Text(
                            "${property.areaName}, ${property.municipality}",
                            maxLines: 1,
                            overflow: TextOverflow.ellipsis,
                            style: TextStyle(
                              fontSize: 10.5.sp,
                              fontWeight: FontWeight.w500,
                              color: const Color(0xFF252525),
                            ),
                          ),
                        ),
                      ],
                    ),
                  ),
                ),
              ),

              SizedBox(width: 12.w),

              // =====================================================
              // MAP PREVIEW
              // =====================================================
              Container(
                width: 180.w,
                height: 90.h,
                decoration: BoxDecoration(
                  borderRadius: BorderRadius.circular(10.r),
                  color: const Color(0xFFF3F3F3),
                ),
                clipBehavior: Clip.antiAlias,
                child: Stack(
                  fit: StackFit.expand,
                  children: [
                    // -------------------------------------------------
                    // Replace this Container with GoogleMap or your
                    // static map image if available.
                    // -------------------------------------------------
                    Container(
                      decoration: const BoxDecoration(
                        color: Color(0xFFF4F3EF),
                      ),
                      child: CustomPaint(
                        painter: _SimpleMapPainter(),
                      ),
                    ),

                    Center(
                      child: Icon(
                        Icons.location_on_rounded,
                        size: 30.sp,
                        color: primary,
                      ),
                    ),
                  ],
                ),
              ),
            ],
          ),

          SizedBox(height: 14.h),

          // =========================================================
          // VIEW ON MAPS BUTTON
          // =========================================================
          SizedBox(
            width: double.infinity,
            height: 43.h,
            child: OutlinedButton(
              onPressed: () async {
                final Uri uri = Uri.parse(
                  "https://www.google.com/maps/search/?api=1&query="
                  "${property.latitude},${property.longitude}",
                );

                if (await canLaunchUrl(uri)) {
                  await launchUrl(
                    uri,
                    mode: LaunchMode.externalApplication,
                  );
                }
              },
              style: OutlinedButton.styleFrom(
                padding: EdgeInsets.symmetric(horizontal: 15.w),
                foregroundColor: primary,
                side: const BorderSide(
                  color: primary,
                  width: 1,
                ),
                shape: RoundedRectangleBorder(
                  borderRadius: BorderRadius.circular(9.r),
                ),
              ),
              child: Row(
                children: [
                  const Spacer(),

                  Icon(
                    Icons.map_outlined,
                    size: 20.sp,
                    color: primary,
                  ),

                  SizedBox(width: 9.w),

                  Text(
                    "View on Maps".tr,
                    style: TextStyle(
                      fontSize: 12.sp,
                      fontWeight: FontWeight.w600,
                      color: primary,
                    ),
                  ),

                  const Spacer(),

                  Icon(
                    Icons.chevron_right_rounded,
                    size: 22.sp,
                    color: primary,
                  ),
                ],
              ),
            ),
          ),
        ],
      ),
    );
  }
}

// ===================================================================
// SIMPLE MAP BACKGROUND
// Remove this if you use GoogleMap/static map image.
// ===================================================================

class _SimpleMapPainter extends CustomPainter {
  @override
  void paint(Canvas canvas, Size size) {
    final Paint roadPaint = Paint()
      ..color = Colors.white
      ..strokeWidth = 5
      ..style = PaintingStyle.stroke;

    final Paint smallRoadPaint = Paint()
      ..color = Colors.white.withOpacity(.85)
      ..strokeWidth = 2
      ..style = PaintingStyle.stroke;

    canvas.drawLine(
      Offset(0, size.height * .25),
      Offset(size.width, size.height * .75),
      roadPaint,
    );

    canvas.drawLine(
      Offset(size.width * .2, 0),
      Offset(size.width * .55, size.height),
      roadPaint,
    );

    canvas.drawLine(
      Offset(0, size.height * .75),
      Offset(size.width, size.height * .35),
      smallRoadPaint,
    );

    canvas.drawLine(
      Offset(size.width * .72, 0),
      Offset(size.width * .85, size.height),
      smallRoadPaint,
    );
  }

  @override
  bool shouldRepaint(covariant CustomPainter oldDelegate) => false;
}