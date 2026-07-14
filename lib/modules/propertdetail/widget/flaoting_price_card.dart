import 'package:flutter/material.dart';
import 'package:flutter_screenutil/flutter_screenutil.dart';

class FloatingPriceCard extends StatelessWidget {
  const FloatingPriceCard({super.key});

  @override
  Widget build(BuildContext context) {
    return Material(
      color: Colors.transparent,
      elevation: 12,
      borderRadius: BorderRadius.circular(28.r),
      child: Container(
        padding: EdgeInsets.all(22.w),
        decoration: BoxDecoration(
          color: Colors.white,
          borderRadius: BorderRadius.circular(28.r),
          boxShadow: [
            BoxShadow(
              color: Colors.black.withOpacity(.08),
              blurRadius: 25,
              offset: const Offset(0, 12),
            ),
          ],
        ),
        child: Column(
          crossAxisAlignment: CrossAxisAlignment.start,
          children: [

            /// PRICE
            Row(
              crossAxisAlignment: CrossAxisAlignment.start,
              children: [

                Expanded(
                  child: Column(
                    crossAxisAlignment: CrossAxisAlignment.start,
                    children: [

                      Text(
                        "QAR 12,500,000",
                        style: TextStyle(
                          fontSize: 28.sp,
                          fontWeight: FontWeight.w800,
                          color: const Color(0xff222222),
                        ),
                      ),

                      SizedBox(height: 5.h),

                      Text(
                        "Luxury Villa",
                        style: TextStyle(
                          fontSize: 16.sp,
                          color: Colors.grey.shade700,
                        ),
                      ),

                      SizedBox(height: 12.h),

                      Row(
                        children: [

                          Icon(
                            Icons.location_on,
                            color: const Color(0xff8E123E),
                            size: 18.sp,
                          ),

                          SizedBox(width: 4.w),

                          Expanded(
                            child: Text(
                              "The Pearl, Doha",
                              style: TextStyle(
                                fontSize: 14.sp,
                                color: Colors.grey.shade700,
                              ),
                            ),
                          ),
                        ],
                      ),
                    ],
                  ),
                ),

                Container(
                  padding: EdgeInsets.symmetric(
                    horizontal: 12.w,
                    vertical: 7.h,
                  ),
                  decoration: BoxDecoration(
                    color: Colors.green.shade50,
                    borderRadius: BorderRadius.circular(30.r),
                  ),
                  child: Row(
                    children: [

                      Icon(
                        Icons.verified,
                        color: Colors.green,
                        size: 16.sp,
                      ),

                      SizedBox(width: 5.w),

                      Text(
                        "Verified",
                        style: TextStyle(
                          color: Colors.green,
                          fontWeight: FontWeight.w600,
                          fontSize: 12.sp,
                        ),
                      ),
                    ],
                  ),
                ),
              ],
            ),

            SizedBox(height: 20.h),

            Divider(color: Colors.grey.shade200),

            SizedBox(height: 18.h),

            /// EMI
            Container(
              padding: EdgeInsets.all(16.w),
              decoration: BoxDecoration(
                color: const Color(0xffF8F8F8),
                borderRadius: BorderRadius.circular(18.r),
              ),
              child: Row(
                children: [

                  Container(
                    width: 48.w,
                    height: 48.w,
                    decoration: BoxDecoration(
                      color: const Color(0xff8E123E).withOpacity(.1),
                      borderRadius: BorderRadius.circular(14.r),
                    ),
                    child: Icon(
                      Icons.account_balance_wallet_outlined,
                      color: const Color(0xff8E123E),
                      size: 24.sp,
                    ),
                  ),

                  SizedBox(width: 15.w),

                  Expanded(
                    child: Column(
                      crossAxisAlignment: CrossAxisAlignment.start,
                      children: [

                        Text(
                          "Estimated EMI",
                          style: TextStyle(
                            color: Colors.grey.shade600,
                            fontSize: 13.sp,
                          ),
                        ),

                        SizedBox(height: 3.h),

                        Text(
                          "QAR 52,786 / month",
                          style: TextStyle(
                            fontWeight: FontWeight.bold,
                            fontSize: 18.sp,
                          ),
                        ),
                      ],
                    ),
                  ),
                ],
              ),
            ),

            SizedBox(height: 22.h),

            /// Schedule Visit
            SizedBox(
              width: double.infinity,
              height: 56.h,
              child: ElevatedButton(
                style: ElevatedButton.styleFrom(
                  backgroundColor: const Color(0xff8E123E),
                  elevation: 0,
                  shape: RoundedRectangleBorder(
                    borderRadius: BorderRadius.circular(18.r),
                  ),
                ),
                onPressed: () {},
                child: Text(
                  "Schedule Visit",
                  style: TextStyle(
                    fontSize: 16.sp,
                    fontWeight: FontWeight.w700,
                    color: Colors.white,
                  ),
                ),
              ),
            ),

            SizedBox(height: 16.h),

            /// ACTIONS
            Row(
              children: [

                Expanded(
                  child: _ActionButton(
                    icon: Icons.handshake_outlined,
                    label: "Offer",
                  ),
                ),

                SizedBox(width: 12.w),

                Expanded(
                  child: _ActionButton(
                    icon: Icons.call_outlined,
                    label: "Call",
                  ),
                ),

                SizedBox(width: 12.w),

                Expanded(
                  child: _ActionButton(
                    icon: Icons.chat_bubble_outline,
                    label: "Chat",
                  ),
                ),

                SizedBox(width: 12.w),

                Expanded(
                  child: _ActionButton(
                    icon: Icons.favorite_border,
                    label: "Save",
                  ),
                ),
              ],
            ),
          ],
        ),
      ),
    );
  }
}

class _ActionButton extends StatelessWidget {
  final IconData icon;
  final String label;

  const _ActionButton({
    required this.icon,
    required this.label,
  });

  @override
  Widget build(BuildContext context) {
    return InkWell(
      borderRadius: BorderRadius.circular(16.r),
      onTap: () {},
      child: Container(
        padding: EdgeInsets.symmetric(vertical: 14.h),
        decoration: BoxDecoration(
          color: const Color(0xffF7F7F7),
          borderRadius: BorderRadius.circular(16.r),
          border: Border.all(
            color: Colors.grey.shade300,
          ),
        ),
        child: Column(
          children: [

            Icon(
              icon,
              color: const Color(0xff8E123E),
              size: 22.sp,
            ),

            SizedBox(height: 8.h),

            Text(
              label,
              style: TextStyle(
                fontSize: 12.sp,
                fontWeight: FontWeight.w600,
              ),
            ),
          ],
        ),
      ),
    );
  }
}