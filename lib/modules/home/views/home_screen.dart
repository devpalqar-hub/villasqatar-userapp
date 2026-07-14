import 'package:flutter/material.dart';
import 'package:flutter_screenutil/flutter_screenutil.dart';
import 'package:get/get_utils/src/extensions/internacionalization.dart';
import 'package:villas_qatar/modules/home/widgets/agent_card.dart';
import 'package:villas_qatar/modules/home/widgets/category_card.dart';
import 'package:villas_qatar/modules/home/widgets/explore.dart';
import 'package:villas_qatar/modules/home/widgets/hero_banner.dart';
import 'package:villas_qatar/modules/mainscreen/home_bottom_nav.dart';
import 'package:villas_qatar/modules/home/widgets/home_header.dart';
import 'package:villas_qatar/modules/home/widgets/location_card.dart';
import 'package:villas_qatar/modules/home/widgets/property_card.dart';
import 'package:villas_qatar/modules/home/widgets/quick_actioncard.dart';
import 'package:villas_qatar/modules/home/widgets/section_header.dart';
import 'package:villas_qatar/modules/home/widgets/sponser_banner.dart';
import 'package:villas_qatar/modules/home/widgets/why_choose_card.dart';
import 'package:villas_qatar/modules/pricestimator/views/price_estimator_screen.dart';

class HomeScreen extends StatelessWidget {
  const HomeScreen({super.key});

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      body: SafeArea(
        child: SingleChildScrollView(
          padding: EdgeInsets.symmetric(horizontal: 24.w),
          child: Column(
            spacing: 12.h,
            children: [
              const HomeHeader(),
              HomeBanner(),
              QuickActionsCard(),

              SectionHeader(title: "Near You".tr),

              SizedBox(
                height: 100.h,
                child: ListView(
                  scrollDirection: Axis.horizontal,
                  children: const [
                    LocationCard(
                      title: 'The Pearl',
                      distance: '2.3 km away',
                      image: 'assets/lct1.jpeg',
                    ),
                    LocationCard(
                      title: 'Lusail City',
                      distance: '6.7 km away',
                      image: 'assets/lct.jpeg',
                    ),
                  ],
                ),
              ),

              /// AI Price Estimator Button
              Container(
                width: double.infinity,
                height: 58.h,
                decoration: BoxDecoration(
                  gradient: const LinearGradient(
                    colors: [Color(0xFF8E123E), Color(0xFFB71C4A)],
                  ),
                  borderRadius: BorderRadius.circular(16.r),
                  boxShadow: [
                    BoxShadow(
                      color: const Color(0xFF8E123E).withOpacity(0.18),
                      blurRadius: 14,
                      offset: const Offset(0, 6),
                    ),
                  ],
                ),
                child: Material(
                  color: Colors.transparent,
                  child: InkWell(
                    borderRadius: BorderRadius.circular(16.r),
                    onTap: () {
                      Navigator.push(
                        context,
                        MaterialPageRoute(
                          builder: (context) => PriceEstimatorScreen(),
                        ),
                      );
                    },
                    child: Padding(
                      padding: EdgeInsets.symmetric(horizontal: 18.w),
                      child: Row(
                        children: [
                          Container(
                            width: 42.w,
                            height: 42.h,
                            decoration: BoxDecoration(
                              color: Colors.white.withOpacity(.15),
                              shape: BoxShape.circle,
                            ),
                            child: Icon(
                              Icons.auto_awesome,
                              color: Colors.white,
                              size: 22.sp,
                            ),
                          ),
                          SizedBox(width: 14.w),
                          Expanded(
                            child: Column(
                              mainAxisAlignment: MainAxisAlignment.center,
                              crossAxisAlignment: CrossAxisAlignment.start,
                              children: [
                                Text(
                                  "AI Price Estimator".tr,
                                  style: TextStyle(
                                    color: Colors.white,
                                    fontSize: 16.sp,
                                    fontWeight: FontWeight.w700,
                                  ),
                                ),
                                SizedBox(height: 2.h),
                                Text(
                                  "Estimate your property's market value instantly"
                                      .tr,
                                  maxLines: 1,
                                  overflow: TextOverflow.ellipsis,
                                  style: TextStyle(
                                    color: Colors.white.withOpacity(.9),
                                    fontSize: 11.sp,
                                  ),
                                ),
                              ],
                            ),
                          ),
                          Icon(
                            Icons.arrow_forward_ios_rounded,
                            color: Colors.white,
                            size: 18.sp,
                          ),
                        ],
                      ),
                    ),
                  ),
                ),
              ),
              SectionHeader(title: "Property Categories".tr),

              SizedBox(
                height: 70.h,
                child: ListView(
                  scrollDirection: Axis.horizontal,
                  children: [
                    CategoryCard(title: 'Villas'.tr, icon: Icons.home_outlined),
                    SizedBox(width: 5.w),
                    CategoryCard(title: 'Apartments'.tr, icon: Icons.apartment),
                    SizedBox(width: 5.w),
                    CategoryCard(
                      title: 'Townhouses'.tr,
                      icon: Icons.house_siding,
                    ),
                    SizedBox(width: 5.w),
                    CategoryCard(title: 'Offices'.tr, icon: Icons.business),
                    SizedBox(width: 5.w),
                    CategoryCard(title: 'Commercial'.tr, icon: Icons.store),
                    SizedBox(width: 5.w),
                    CategoryCard(title: 'Land'.tr, icon: Icons.map_outlined),
                  ],
                ),
              ),

              SectionHeader(title: "Featured Properties".tr),

              SizedBox(
                height: 225.h,
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

              InvestmentBanner(),

              SectionHeader(title: "Featured Agents".tr),

              SizedBox(
                height: 240.h,
                child: ListView.separated(
                  scrollDirection: Axis.horizontal,
                  itemCount: 3,
                  separatorBuilder: (_, __) => SizedBox(width: 12.w),
                  itemBuilder: (context, index) {
                    final agents = [
                      {
                        "image": "assets/images/agent1.png",
                        "name": "Ahmed Al-Mansoori",
                        "designation": "Senior Property Consultant",
                        "rating": "4.8",
                        "reviews": "120",
                        "phone": "+974 55 123 456",
                      },
                      {
                        "image": "assets/images/agent2.png",
                        "name": "Fatima Al-Kuwari",
                        "designation": "Property Consultant",
                        "rating": "4.7",
                        "reviews": "98",
                        "phone": "+974 55 987 654",
                      },
                      {
                        "image": "assets/images/agent3.png",
                        "name": "Mohammed Khalid",
                        "designation": "Real Estate Advisor",
                        "rating": "4.9",
                        "reviews": "150",
                        "phone": "+974 55 456 789",
                      },
                    ];

                    final agent = agents[index];

                    return AgentCards(
                      image: agent["image"]!,
                      name: agent["name"]!,
                      designation: agent["designation"]!,
                      rating: agent["rating"]!,
                      reviews: agent["reviews"]!,
                      phone: agent["phone"]!,
                    );
                  },
                ),
              ),

              SectionHeader(title: "Explore Qatar".tr),
              ExploreQatarSection(),

              const WhyChooseCard(),
            ],
          ),
        ),
      ),
    );
  }
}
