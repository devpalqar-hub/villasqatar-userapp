import 'dart:ui';

import 'package:flutter/material.dart';
import 'package:flutter_screenutil/flutter_screenutil.dart';
import 'package:get/get.dart';
import 'package:get/get_core/src/get_main.dart';
import 'package:intl/intl.dart';
import 'package:villas_qatar/Core/constants/app_colors.dart';
import 'package:villas_qatar/Core/utils/auth_guard.dart';
import 'package:villas_qatar/modules/offerscreen/view/make_offerscreen.dart';
import 'package:villas_qatar/modules/visits/service/visit_controller.dart';
import 'package:villas_qatar/modules/propertydetailscreen/widget/make_offer_Dailogue.dart';
import 'package:villas_qatar/modules/propertylist/model/myproperty_model.dart';

class BottomActionCard extends StatelessWidget {
  final Property property;
  const BottomActionCard({super.key, required this.property});

  @override
  Widget build(BuildContext context) {
    return SafeArea(
      top: false,
      child: ClipRRect(
        child: BackdropFilter(
          filter: ImageFilter.blur(sigmaX: 18, sigmaY: 18),
          child: Container(
            padding: EdgeInsets.fromLTRB(20.w, 18.h, 20.w, 5.h),
            decoration: BoxDecoration(
              color: Colors.white.withOpacity(.96),
              borderRadius: BorderRadius.only(
                topLeft: Radius.circular(10.r),
                topRight: Radius.circular(10.r),
              ),
              boxShadow: [
                BoxShadow(
                  color: Colors.black.withOpacity(.08),
                  blurRadius: 25,
                  offset: const Offset(0, -8),
                ),
              ],
            ),
            child: Row(
              children: [
                // /// Price
                // Expanded(
                //   flex: 4,
                //   child: Column(
                //     crossAxisAlignment: CrossAxisAlignment.start,
                //     mainAxisSize: MainAxisSize.min,
                //     children: [
                //       Text(
                //         "Starting From",
                //         style: TextStyle(
                //           fontSize: 10.sp,
                //           color: Colors.grey.shade600,
                //         ),
                //       ),

                //       SizedBox(height: 4.h),

                //       Text(
                //         "QAR 12.5M",
                //         style: TextStyle(
                //           fontSize: 14.sp,
                //           fontWeight: FontWeight.bold,
                //           color: AppColors.primary,
                //         ),
                //       ),
                //     ],
                //   ),
                // ),

                /// Contact
                Expanded(
                  flex: 6,
                  child: SizedBox(
                    height: 40.h,
                    child: OutlinedButton.icon(
                      style: OutlinedButton.styleFrom(
                        foregroundColor: const Color(0xff8E123E),
                        side: const BorderSide(color: Color(0xff8E123E)),
                        shape: RoundedRectangleBorder(
                          borderRadius: BorderRadius.circular(10.r),
                        ),
                      ),
                      onPressed: () {
                        if (!AuthGuard.requireLogin(
                          message: "Login is required to make an offer.".tr,
                        )) {
                          return;
                        }
                        showMakeOfferBottomSheet(context, property);
                      },
                      label: Text(
                        "Make an Offer".tr,
                        maxLines: 1,
                        overflow: TextOverflow.ellipsis,
                        softWrap: false,
                        style: TextStyle(
                          fontSize: 11.sp,
                          fontWeight: FontWeight.w800,
                        ),
                      ),
                    ),
                  ),
                ),

                SizedBox(width: 10.w),

                /// Schedule
                Expanded(
                  flex: 6,
                  child: SizedBox(
                    height: 40.h,
                    child: ElevatedButton.icon(
                      style: ElevatedButton.styleFrom(
                        elevation: 0,
                        backgroundColor: const Color(0xff8E123E),
                        shape: RoundedRectangleBorder(
                          borderRadius: BorderRadius.circular(10.r),
                        ),
                      ),
                      onPressed: () {
                        if (!AuthGuard.requireLogin(
                          message:
                              "Login is required to schedule a property visit."
                                  .tr,
                        )) {
                          return;
                        }

                        _showScheduleVisitSheet(context, property: property);
                      },
                      label: Text(
                        "Schedule".tr,
                        style: TextStyle(
                          fontSize: 10.sp,
                          color: Colors.white,
                          fontWeight: FontWeight.w700,
                        ),
                      ),
                    ),
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

void _showScheduleVisitSheet(
  BuildContext context, {
  required Property property,
}) {
  final VisitController visitController = Get.isRegistered<VisitController>()
      ? Get.find<VisitController>()
      : Get.put(VisitController());

  final TextEditingController noteController = TextEditingController();

  final slots = [
    "09:00 AM",
    "10:30 AM",
    "12:00 PM",
    "02:00 PM",
    "04:00 PM",
    "06:00 PM",
  ];

  DateTime selectedDate = DateTime.now();
  int selectedSlot = 0;
  bool isLoading = false;

  showModalBottomSheet(
    context: context,
    isScrollControlled: true,
    backgroundColor: Colors.transparent,
    builder: (_) {
      return StatefulBuilder(
        builder: (context, setState) {
          return Padding(
            padding: EdgeInsets.only(
              bottom: MediaQuery.of(context).viewInsets.bottom,
            ),
            child: Container(
              padding: EdgeInsets.fromLTRB(
                20.w,
                18.h,
                20.w,
                MediaQuery.of(context).padding.bottom + 20.h,
              ),
              decoration: BoxDecoration(
                color: Colors.white,
                borderRadius: BorderRadius.vertical(top: Radius.circular(24.r)),
              ),
              child: SingleChildScrollView(
                child: Column(
                  mainAxisSize: MainAxisSize.min,
                  crossAxisAlignment: CrossAxisAlignment.start,
                  children: [
                    Center(
                      child: Container(
                        width: 45.w,
                        height: 5.h,
                        decoration: BoxDecoration(
                          color: Colors.grey.shade300,
                          borderRadius: BorderRadius.circular(20),
                        ),
                      ),
                    ),

                    SizedBox(height: 18.h),

                    Text(
                      "Schedule a Visit".tr,
                      style: TextStyle(
                        fontSize: 18.sp,
                        fontWeight: FontWeight.w700,
                      ),
                    ),

                    SizedBox(height: 18.h),

                    Text(
                      "Select Visit Date".tr,
                      style: TextStyle(
                        fontSize: 13.sp,
                        fontWeight: FontWeight.w600,
                      ),
                    ),

                    SizedBox(height: 12.h),

                    /// DATE PICKER
                    InkWell(
                      borderRadius: BorderRadius.circular(12.r),
                      onTap: isLoading
                          ? null
                          : () async {
                              final picked = await showDatePicker(
                                context: context,
                                initialDate: selectedDate,
                                firstDate: DateTime.now(),
                                lastDate: DateTime.now().add(
                                  const Duration(days: 90),
                                ),
                                builder: (context, child) {
                                  return Theme(
                                    data: Theme.of(context).copyWith(
                                      colorScheme: const ColorScheme.light(
                                        primary: AppColors.primary,
                                        onPrimary: Colors.white,
                                        surface: Colors.white,
                                        onSurface: Colors.black,
                                      ),
                                      datePickerTheme: DatePickerThemeData(
                                        shape: RoundedRectangleBorder(
                                          borderRadius: BorderRadius.circular(
                                            18,
                                          ),
                                        ),
                                      ),
                                    ),
                                    child: child!,
                                  );
                                },
                              );

                              if (picked != null) {
                                setState(() {
                                  selectedDate = picked;
                                });
                              }
                            },
                      child: Container(
                        padding: EdgeInsets.symmetric(
                          horizontal: 16.w,
                          vertical: 14.h,
                        ),
                        decoration: BoxDecoration(
                          color: Colors.white,
                          borderRadius: BorderRadius.circular(12.r),
                          border: Border.all(color: AppColors.fieldBorder),
                        ),
                        child: Row(
                          children: [
                            const Icon(
                              Icons.calendar_month_outlined,
                              color: AppColors.primary,
                            ),

                            SizedBox(width: 12.w),

                            Expanded(
                              child: Text(
                                DateFormat(
                                  'EEE, dd MMM yyyy',
                                ).format(selectedDate),
                                style: TextStyle(
                                  fontSize: 14.sp,
                                  fontWeight: FontWeight.w600,
                                ),
                              ),
                            ),

                            const Icon(
                              Icons.keyboard_arrow_down,
                              color: Colors.grey,
                            ),
                          ],
                        ),
                      ),
                    ),

                    SizedBox(height: 22.h),

                    Text(
                      "Available Time".tr,
                      style: TextStyle(
                        fontSize: 13.sp,
                        fontWeight: FontWeight.w600,
                      ),
                    ),

                    SizedBox(height: 12.h),

                    /// TIME SLOTS
                    Wrap(
                      spacing: 10,
                      runSpacing: 10,
                      children: List.generate(slots.length, (i) {
                        final selected = selectedSlot == i;

                        return GestureDetector(
                          onTap: isLoading
                              ? null
                              : () {
                                  setState(() {
                                    selectedSlot = i;
                                  });
                                },
                          child: Container(
                            padding: EdgeInsets.symmetric(
                              horizontal: 16.w,
                              vertical: 10.h,
                            ),
                            decoration: BoxDecoration(
                              color: selected
                                  ? AppColors.primary.withOpacity(.08)
                                  : Colors.white,
                              borderRadius: BorderRadius.circular(12.r),
                              border: Border.all(
                                color: selected
                                    ? AppColors.primary
                                    : AppColors.fieldBorder,
                              ),
                            ),
                            child: Text(
                              slots[i],
                              style: TextStyle(
                                color: selected
                                    ? AppColors.primary
                                    : Colors.black87,
                                fontWeight: FontWeight.w600,
                              ),
                            ),
                          ),
                        );
                      }),
                    ),

                    SizedBox(height: 20.h),

                    /// NOTES
                    TextField(
                      controller: noteController,
                      maxLines: 3,
                      enabled: !isLoading,
                      decoration: InputDecoration(
                        hintText: "Add a note (Optional)".tr,
                        border: OutlineInputBorder(
                          borderRadius: BorderRadius.circular(12.r),
                        ),
                      ),
                    ),

                    SizedBox(height: 24.h),

                    /// BOOK VISIT
                    SizedBox(
                      width: double.infinity,
                      height: 50.h,
                      child: ElevatedButton(
                        style: ElevatedButton.styleFrom(
                          backgroundColor: AppColors.primary,
                          disabledBackgroundColor: AppColors.primary
                              .withOpacity(.6),
                          shape: RoundedRectangleBorder(
                            borderRadius: BorderRadius.circular(12.r),
                          ),
                        ),
                        onPressed: isLoading
                            ? null
                            : () async {
                                // Selected time string
                                // Example: "10:30 AM"
                                final String selectedTimeString =
                                    slots[selectedSlot];

                                // Convert "10:30 AM" to DateTime to get hour/minute
                                final DateTime parsedTime = DateFormat(
                                  "hh:mm a",
                                ).parse(selectedTimeString);

                                // Combine selected DATE + selected TIME
                                final DateTime scheduledAt = DateTime(
                                  selectedDate.year,
                                  selectedDate.month,
                                  selectedDate.day,
                                  parsedTime.hour,
                                  parsedTime.minute,
                                );

                                debugPrint("========== VISIT DATA ==========");
                                debugPrint("Property ID: ${property.id}");
                                debugPrint(
                                  "Selected Date: "
                                  "${DateFormat('yyyy-MM-dd').format(selectedDate)}",
                                );
                                debugPrint(
                                  "Selected Time: $selectedTimeString",
                                );
                                debugPrint("Scheduled Local: $scheduledAt");
                                debugPrint(
                                  "Scheduled UTC: "
                                  "${scheduledAt.toUtc().toIso8601String()}",
                                );
                                debugPrint(
                                  "Notes: ${noteController.text.trim()}",
                                );
                                debugPrint("===============================");

                                setState(() {
                                  isLoading = true;
                                });

                                final bool success = await visitController
                                    .scheduleVisit(
                                      propertyId: property.id,

                                      // DATE + TIME passed here
                                      scheduledAt: scheduledAt,

                                      notes: noteController.text.trim(),
                                    );

                                if (!context.mounted) return;

                                if (success) {
                                  Navigator.pop(context);
                                  return;
                                }

                                setState(() {
                                  isLoading = false;
                                });
                              },
                        child: isLoading
                            ? SizedBox(
                                width: 22.w,
                                height: 22.w,
                                child: const CircularProgressIndicator(
                                  strokeWidth: 2,
                                  valueColor: AlwaysStoppedAnimation<Color>(
                                    Colors.white,
                                  ),
                                ),
                              )
                            : Text(
                                "Book Visit".tr,
                                style: TextStyle(
                                  fontSize: 15.sp,
                                  fontWeight: FontWeight.w700,
                                  color: Colors.white,
                                ),
                              ),
                      ),
                    ),
                  ],
                ),
              ),
            ),
          );
        },
      );
    },
  );
}

void showMakeOfferBottomSheet(BuildContext context, Property property) {
  showModalBottomSheet(
    context: context,
    isScrollControlled: true,
    useSafeArea: true,
    backgroundColor: Colors.transparent,
    barrierColor: Colors.black.withOpacity(.35),
    builder: (_) {
      return Padding(
        padding: EdgeInsets.only(
          bottom: MediaQuery.of(context).viewInsets.bottom,
        ),
        child: MakeOfferBottomSheet(property: property),
      );
    },
  );
}
