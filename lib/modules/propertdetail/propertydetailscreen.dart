import 'package:flutter/material.dart';
import 'package:flutter_screenutil/flutter_screenutil.dart';
import 'package:villas_qatar/modules/home/widgets/property_card.dart';
import 'package:villas_qatar/modules/propertdetail/widget/agent_conatct_card.dart';
import 'package:villas_qatar/modules/propertdetail/widget/bottom_actioncard.dart';
import 'package:villas_qatar/modules/propertdetail/widget/herocard.dart';
import 'package:villas_qatar/modules/propertdetail/widget/property_details_card.dart';
import 'package:villas_qatar/modules/propertdetail/widget/property_info_card.dart';
import 'package:villas_qatar/modules/propertdetail/widget/property_location_card.dart';
import 'package:villas_qatar/modules/propertdetail/widget/property_states_card.dart';


class PropertyDetailsScreen extends StatelessWidget {
  const PropertyDetailsScreen({super.key});

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      backgroundColor:Colors.white,

      bottomNavigationBar: const BottomActionCard(),

      body: SafeArea(
        child: Stack(
          children: [
            /// Scrollable Content
            SingleChildScrollView(
              physics: const BouncingScrollPhysics(),
              child: Column(
                crossAxisAlignment: CrossAxisAlignment.start,
                children: [
                  /// Hero Image
                  const HeroImageCard(),

                  /// Space for Floating Card
                  Padding(
                    padding: EdgeInsets.symmetric(horizontal: 20.w),
                    child: Column(
                      children: [
                        PropertyInfoCard(),

                        SizedBox(height: 10.h),
                        OverviewCard(),

                        SizedBox(height: 12.h),

                        PropertyLocationCard(),
                        SizedBox(height: 12.h),

                        PropertyDetailsCard(),
                        SizedBox(height: 12.h),

                        AgentContactCard(),
                        SizedBox(height: 12.h),

                        SizedBox(
                          height: 250.h,
                          child: ListView(
                            scrollDirection: Axis.horizontal,
                            children: const [
                              PropertyCard(
                                image: 'assets/villa.jpg',
                                title: 'Luxury Villa in Al Waab',
                                location: 'Al Waab, Doha',
                                distance: '2.3 km away',
                                price: 'QAR 3,250,000',
                                sqm: '220 SQM',
                                // timeAgo: '2 hours ago',
                                // views: '412',
                                beds: '25',
                              ),
                              PropertyCard(
                                image: 'assets/villa3.jpeg',
                                title: 'Luxury Villa in Al Waab',
                                location: 'Al Waab, Doha',
                                distance: '2.3 km away',
                                price: 'QAR 3,250,000',
                                sqm: '220 SQM',
                                // timeAgo: '2 hours ago',
                                // views: '412',
                                beds: '25',
                              ),
                              PropertyCard(
                                image: 'assets/villa1.webp',
                                title: 'Luxury Villa in Al Waab',
                                location: 'Al Waab, Doha',
                                distance: '2.3 km away',
                                price: 'QAR 3,250,000',
                                sqm: '220 SQM',
                                // timeAgo: '2 hours ago',
                                // views: '412',
                                beds: '25',
                              ),
                            ],
                          ),
                        ),

                        SizedBox(height: 120),
                      ],
                    ),
                  ),
                ],
              ),
            ),

            /// Floating Price Card
            // Positioned(
            //   left: 20.w,
            //   right: 20.w,
            //   top: 315.h,
            //   child: const FloatingPriceCard(),
            // ),
          ],
        ),
      ),
    );
  }
}
