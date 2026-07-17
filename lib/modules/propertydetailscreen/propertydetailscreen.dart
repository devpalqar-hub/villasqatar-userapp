import 'package:flutter/material.dart';
import 'package:flutter_screenutil/flutter_screenutil.dart';
import 'package:get/get_state_manager/src/simple/get_state.dart';
import 'package:villas_qatar/modules/home/widgets/property_card.dart';
import 'package:villas_qatar/modules/propertydetailscreen/widget/agent_conatct_card.dart';
import 'package:villas_qatar/modules/propertydetailscreen/widget/bottom_actioncard.dart';
import 'package:villas_qatar/modules/propertydetailscreen/widget/herocard.dart';
import 'package:villas_qatar/modules/propertydetailscreen/widget/property_details_card.dart';
import 'package:villas_qatar/modules/propertydetailscreen/widget/property_info_card.dart';
import 'package:villas_qatar/modules/propertydetailscreen/widget/property_location_card.dart';
import 'package:villas_qatar/modules/propertydetailscreen/widget/overview_card.dart';
import 'package:villas_qatar/modules/searchscreen/service/searchlist_screen.dart';

class PropertyDetailsScreen extends StatelessWidget {
  const PropertyDetailsScreen({super.key});

  @override
  Widget build(BuildContext context) {
    return GetBuilder<PropertySearchController>(
      builder: (controller) {
        if (controller.isDetailsLoading) {
          return const Scaffold(
            body: Center(child: CircularProgressIndicator()),
          );
        }
        if (controller.selectedProperty == null) {
          return const Scaffold(
            body: Center(child: Text("Property not found")),
          );
        }
        final property = controller.selectedProperty!;
        return Scaffold(
          backgroundColor: Colors.white,

          bottomNavigationBar: BottomActionCard(property: property),

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
                      HeroImageCard(property: property),

                      /// Space for Floating Card
                      Padding(
                        padding: EdgeInsets.symmetric(horizontal: 16.w),
                        child: Column(
                          children: [
                            PropertyInfoCard(property: property),

                            SizedBox(height: 10.h),
                            OverviewCard(property: property),

                            SizedBox(height: 12.h),

                            PropertyLocationCard(property: property),
                            SizedBox(height: 12.h),

                            PropertyDetailsCard(property: property),
                            SizedBox(height: 12.h),

                            AgentContactCard(property: property),
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
                          ],
                        ),
                      ),
                    ],
                  ),
                ),

              ],
            ),
          ),
        );
      },
    );
  }
}
