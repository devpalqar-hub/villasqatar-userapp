import 'package:flutter/material.dart';
import 'package:flutter_screenutil/flutter_screenutil.dart';
import 'package:get/get.dart';
import 'package:get/get_utils/src/extensions/internacionalization.dart';
import 'package:url_launcher/url_launcher.dart';
import 'package:villas_qatar/modules/PlansandFeatures/model/featured_property_model.dart';
import 'package:villas_qatar/modules/PlansandFeatures/services/featured_properties_controller.dart';
import 'package:villas_qatar/modules/home/service/banner_controller.dart';
import 'package:villas_qatar/modules/home/widgets/agent_card.dart';
import 'package:villas_qatar/modules/home/widgets/boost_property_banner.dart';
import 'package:villas_qatar/modules/home/widgets/category_card.dart';
import 'package:villas_qatar/modules/home/widgets/estimator_card.dart';
import 'package:villas_qatar/modules/home/widgets/hero_banner.dart';
import 'package:villas_qatar/modules/home/widgets/home_header.dart';
import 'package:villas_qatar/modules/home/widgets/location_card.dart';
import 'package:villas_qatar/modules/home/widgets/property_card.dart';
import 'package:villas_qatar/modules/home/widgets/quick_actioncard.dart';
import 'package:villas_qatar/modules/home/widgets/section_header.dart';
import 'package:villas_qatar/modules/home/widgets/sponser_banner.dart';
import 'package:villas_qatar/modules/home/widgets/why_choose_card.dart';
import 'package:villas_qatar/modules/pricestimator/views/price_estimator_screen.dart';

class HomeScreen extends StatefulWidget {
  final void Function(String propertyName) onSearch;
  final void Function(String type) onCategorySelected;
  final void Function(String purpose) onPurposeSelected;

  const HomeScreen({
    super.key,
    required this.onSearch,
    required this.onCategorySelected,
    required this.onPurposeSelected,
  });

  @override
  State<HomeScreen> createState() => _HomeScreenState();
}

class _HomeScreenState extends State<HomeScreen> {
  late final FeaturedPropertiesController featuredController;
  late final BannerController bannerController;
  final ScrollController featuredScrollController = ScrollController();

  @override
  void initState() {
    super.initState();

    featuredController = Get.isRegistered<FeaturedPropertiesController>()
        ? Get.find<FeaturedPropertiesController>()
        : Get.put(FeaturedPropertiesController(), permanent: true);

    bannerController = Get.isRegistered<BannerController>()
        ? Get.find<BannerController>()
        : Get.put(BannerController(), permanent: true);

    WidgetsBinding.instance.addPostFrameCallback((_) {
      featuredController.fetchFeaturedProperties(
        location: FeaturedLocation.homePage,
        limit: 5,
      );
    });

    featuredScrollController.addListener(_onFeaturedScroll);
  }

  void _onFeaturedScroll() {
    if (!featuredScrollController.hasClients) {
      return;
    }

    final position = featuredScrollController.position;
    if (position.pixels >= position.maxScrollExtent - 150) {
      featuredController.loadMore(
        location: FeaturedLocation.homePage,
        limit: 5,
      );
    }
  }

  @override
  void dispose() {
    featuredScrollController.removeListener(_onFeaturedScroll);

    featuredScrollController.dispose();

    super.dispose();
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      body: SafeArea(
        child: SingleChildScrollView(
          padding: EdgeInsets.symmetric(horizontal: 24.w),
          child: Column(
            spacing: 12.h,
            children: [
              HomeHeader(),
              HomeBanner(onSearch: widget.onSearch),
              // QuickActionsCard(onPurposeSelected: widget.onPurposeSelected),
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

              // /// AI PRICE ESTIMATOR - PREMIUM CARD
              // Container(
              //   width: double.infinity,
              //   padding: EdgeInsets.symmetric(horizontal: 16.w, vertical: 14.h),
              //   decoration: BoxDecoration(
              //     color: Colors.white,
              //     borderRadius: BorderRadius.circular(16.r),
              //     border: Border.all(
              //       color: const Color(0xFF8E123E).withOpacity(0.12),
              //     ),
              //     boxShadow: [
              //       BoxShadow(
              //         color: Colors.black.withOpacity(0.05),
              //         blurRadius: 16,
              //         offset: const Offset(0, 5),
              //       ),
              //     ],
              //   ),
              //   child: InkWell(
              //     borderRadius: BorderRadius.circular(16.r),
              //     onTap: () {
              //       Navigator.push(
              //         context,
              //         MaterialPageRoute(builder: (_) => PriceEstimatorScreen()),
              //       );
              //     },
              //     child: Row(
              //       children: [
              //         /// ICON
              //         Container(
              //           width: 48.w,
              //           height: 48.w,
              //           decoration: BoxDecoration(
              //             color: const Color(0xFF8E123E).withOpacity(0.08),
              //             borderRadius: BorderRadius.circular(14.r),
              //           ),
              //           child: Stack(
              //             alignment: Alignment.center,
              //             children: [
              //               Icon(
              //                 Icons.home_work_outlined,
              //                 color: const Color(0xFF8E123E),
              //                 size: 25.sp,
              //               ),

              //               Positioned(
              //                 top: 7.h,
              //                 right: 7.w,
              //                 child: Icon(
              //                   Icons.auto_awesome,
              //                   size: 11.sp,
              //                   color: const Color(0xFF8E123E),
              //                 ),
              //               ),
              //             ],
              //           ),
              //         ),

              //         SizedBox(width: 14.w),

              //         /// TEXT
              //         Expanded(
              //           child: Column(
              //             crossAxisAlignment: CrossAxisAlignment.start,
              //             children: [
              //               Row(
              //                 children: [
              //                   Flexible(
              //                     child: Text(
              //                       "AI Price Estimator".tr,
              //                       style: TextStyle(
              //                         fontSize: 15.sp,
              //                         fontWeight: FontWeight.w700,
              //                         color: const Color(0xFF222222),
              //                       ),
              //                     ),
              //                   ),

              //                   SizedBox(width: 7.w),
              //                 ],
              //               ),

              //               SizedBox(height: 5.h),

              //               Text(
              //                 "Get an instant estimate of your property's market value"
              //                     .tr,
              //                 maxLines: 2,
              //                 overflow: TextOverflow.ellipsis,
              //                 style: TextStyle(
              //                   fontSize: 11.sp,
              //                   height: 1.35,
              //                   color: Colors.grey.shade600,
              //                 ),
              //               ),
              //             ],
              //           ),
              //         ),

              //         SizedBox(width: 10.w),

              //         /// ARROW
              //         Container(
              //           width: 32.w,
              //           height: 32.w,
              //           decoration: BoxDecoration(
              //             color: const Color(0xFF8E123E),
              //             borderRadius: BorderRadius.circular(10.r),
              //           ),
              //           child: Icon(
              //             Icons.arrow_forward_rounded,
              //             color: Colors.white,
              //             size: 17.sp,
              //           ),
              //         ),
              //       ],
              //     ),
              //   ),
              // ),
              EstimatorCard(),
              SectionHeader(title: "Property Categories".tr, showSeeAll: false),

              SizedBox(
                height: 70.h,
                child: ListView(
                  scrollDirection: Axis.horizontal,
                  children: [
                    CategoryCard(
                      title: 'Villas'.tr,
                      icon: Icons.home_outlined,
                      onTap: () => widget.onCategorySelected("VILLA"),
                    ),

                    SizedBox(width: 5.w),

                    CategoryCard(
                      title: 'Apartments'.tr,
                      icon: Icons.apartment,
                      onTap: () => widget.onCategorySelected("APARTMENT"),
                    ),

                    SizedBox(width: 5.w),

                    CategoryCard(
                      title: 'Townhouses'.tr,
                      icon: Icons.house_siding,
                      onTap: () => widget.onCategorySelected("TOWNHOUSE"),
                    ),

                    SizedBox(width: 5.w),

                    CategoryCard(
                      title: 'Offices'.tr,
                      icon: Icons.business,
                      onTap: () => widget.onCategorySelected("OFFICE"),
                    ),

                    SizedBox(width: 5.w),

                    CategoryCard(
                      title: 'Commercial'.tr,
                      icon: Icons.store,
                      onTap: () => widget.onCategorySelected("COMMERCIAL"),
                    ),

                    SizedBox(width: 5.w),

                    CategoryCard(
                      title: 'Land'.tr,
                      icon: Icons.map_outlined,
                      onTap: () => widget.onCategorySelected("LAND"),
                    ),
                  ],
                ),
              ),

              _buildFeaturedPropertiesSection(),

              _buildBannersSection(),
              SectionHeader(title: "Featured Dealers".tr),

              SizedBox(
                height: 165.h,
                child: ListView.separated(
                  scrollDirection: Axis.horizontal,
                  physics: const BouncingScrollPhysics(),
                  clipBehavior: Clip.none,
                  itemCount: 3,
                  separatorBuilder: (_, __) => SizedBox(width: 12.w),
                  itemBuilder: (context, index) {
                    final agents = [
                      {
                        "image": "assets/images/agent1.png",
                        "name": "Ahmed Al-Mansoori",
                        "designation": "Senior Property Consultant",
                        "phone": "+974 55 123 456",
                      },
                      {
                        "image": "assets/images/agent2.png",
                        "name": "Fatima Al-Kuwari",
                        "designation": "Property Consultant",
                        "phone": "+974 55 987 654",
                      },
                      {
                        "image": "assets/images/agent3.png",
                        "name": "Mohammed Khalid",
                        "designation": "Real Estate Advisor",
                        "phone": "+974 55 456 789",
                      },
                    ];

                    final agent = agents[index];

                    return AgentCards(
                      image: agent["image"]!,
                      name: agent["name"]!,
                      designation: agent["designation"]!,
                      phone: agent["phone"]!,
                    );
                  },
                ),
              ),

              const WhyChooseCard(),
            ],
          ),
        ),
      ),
    );
  }

  Widget _buildFeaturedPropertiesSection() {
    return GetBuilder<FeaturedPropertiesController>(
      builder: (controller) {
        final List<FeaturedProperty> properties = controller.homeProperties;

        final bool loading = controller.isLoading(FeaturedLocation.homePage);

        final bool loadingMore = controller.isLoadingMore(
          FeaturedLocation.homePage,
        );

        final String error = controller.getError(FeaturedLocation.homePage);

        final bool canLoadMore = controller.hasMore(FeaturedLocation.homePage);

        /// --------------------------------------------
        /// INITIAL LOADING
        /// --------------------------------------------

        if (loading && properties.isEmpty) {
          return Column(
            crossAxisAlignment: CrossAxisAlignment.start,
            children: [
              SectionHeader(title: "Featured Properties".tr),

              SizedBox(
                height: 225.h,
                child: const Center(
                  child: CircularProgressIndicator(color: Color(0xFF8E123E)),
                ),
              ),
            ],
          );
        }

        /// --------------------------------------------
        /// ERROR
        /// --------------------------------------------

        if (error.isNotEmpty && properties.isEmpty) {
          return Column(
            crossAxisAlignment: CrossAxisAlignment.start,
            children: [
              SectionHeader(title: "Featured Properties".tr),

              Container(
                width: double.infinity,
                height: 130.h,

                alignment: Alignment.center,

                child: Column(
                  mainAxisAlignment: MainAxisAlignment.center,
                  children: [
                    Icon(
                      Icons.error_outline_rounded,
                      color: Colors.grey,
                      size: 25.sp,
                    ),

                    SizedBox(height: 6.h),

                    Text(
                      "Unable to load featured properties",
                      style: TextStyle(fontSize: 10.sp, color: Colors.grey),
                    ),

                    SizedBox(height: 3.h),

                    TextButton(
                      onPressed: () {
                        controller.refreshFeatured(
                          location: FeaturedLocation.homePage,
                          limit: 5,
                        );
                      },
                      child: const Text("Try Again"),
                    ),
                  ],
                ),
              ),
            ],
          );
        }

        if (properties.isEmpty) {
          return const SizedBox.shrink();
        }

        return Column(
          crossAxisAlignment: CrossAxisAlignment.start,
          children: [
            SectionHeader(title: "Featured Properties".tr),
            SizedBox(height: 10.h),
            SizedBox(
              height: 250.h,

              child: ListView.separated(
                controller: featuredScrollController,

                scrollDirection: Axis.horizontal,

                physics: const BouncingScrollPhysics(),

                padding: EdgeInsets.zero,

                itemCount: properties.length + (canLoadMore ? 1 : 0),

                separatorBuilder: (context, index) {
                  return SizedBox(width: 10.w);
                },

                itemBuilder: (context, index) {
                  /// PAGINATION LOADER AT END
                  if (index == properties.length) {
                    return SizedBox(
                      width: 55.w,

                      child: Center(
                        child: loadingMore
                            ? SizedBox(
                                width: 22.w,
                                height: 22.w,

                                child: const CircularProgressIndicator(
                                  strokeWidth: 2,
                                  color: Color(0xFF8E123E),
                                ),
                              )
                            : const SizedBox.shrink(),
                      ),
                    );
                  }

                  final FeaturedProperty featured = properties[index];

                  final property = featured.listing;

                  return PropertyCard(
                    image: property.imageUrl,

                    title: property.propertyName,

                    location: property.formattedLocation,

                    distance: '',

                    price: property.price.toString(),

                    sqm: '${property.area.toStringAsFixed(0)} SQM',

                    beds: property.bedrooms.toString(),

                    verified: property.contactVerified,

                    isFeatured: property.isFeatured,

                    propertyId: property.id,

                    slug: property.slug,

                    bathrooms: property.bathrooms,

                    area: property.area,
                  );
                },
              ),
            ),
          ],
        );
      },
    );
  }
}

Widget _buildBannersSection() {
  return GetBuilder<BannerController>(
    builder: (controller) {
      /// INITIAL LOADING
      if (controller.isLoading && controller.banners.isEmpty) {
        return Container(
          width: double.infinity,
          height: 250.h,
          decoration: BoxDecoration(
            color: Colors.grey.shade100,
            borderRadius: BorderRadius.circular(10.r),
          ),
          alignment: Alignment.center,
          child: SizedBox(
            width: 22.w,
            height: 22.w,
            child: const CircularProgressIndicator(
              strokeWidth: 2,
              color: Color(0xff8C1437),
            ),
          ),
        );
      }

      /// NO BANNERS / ERROR
      if (controller.banners.isEmpty) {
        return const SizedBox.shrink();
      }

      final now = DateTime.now();

      /// Only banners that are:
      /// 1. Active
      /// 2. Started
      /// 3. Not expired
      final banners = controller.banners.where((banner) {
        if (!banner.isActive) {
          return false;
        }

        if (banner.startDate != null && now.isBefore(banner.startDate!)) {
          return false;
        }

        if (banner.endDate != null && now.isAfter(banner.endDate!)) {
          return false;
        }

        return true;
      }).toList();

      /// Sort according to API position.
      banners.sort((a, b) => a.position.compareTo(b.position));

      if (banners.isEmpty) {
        return const SizedBox.shrink();
      }

      /// ONE BANNER
      if (banners.length == 1) {
        final banner = banners.first;

        return InvestmentBanner(
          banner: banner,
          onTap: () {
            _handleBannerTap(banner.linkUrl);
          },
        );
      }

      /// MULTIPLE BANNERS
      return SizedBox(
        height: 150.h,
        child: PageView.builder(
          itemCount: banners.length,
          itemBuilder: (context, index) {
            final banner = banners[index];

            return Padding(
              padding: EdgeInsets.only(
                right: index == banners.length - 1 ? 0 : 8.w,
              ),
              child: InvestmentBanner(
                banner: banner,
                onTap: () {
                  _handleBannerTap(banner.linkUrl);
                },
              ),
            );
          },
        ),
      );
    },
  );
}

Future<void> _handleBannerTap(String linkUrl) async {
  if (linkUrl.trim().isEmpty) {
    return;
  }

  final Uri? uri = Uri.tryParse(linkUrl.trim());

  if (uri == null) {
    debugPrint("Invalid banner URL: $linkUrl");
    return;
  }

  try {
    final bool launched = await launchUrl(
      uri,
      mode: LaunchMode.externalApplication,
    );

    if (!launched) {
      debugPrint("Unable to open banner URL: $linkUrl");
    }
  } catch (e) {
    debugPrint("Banner URL error: $e");
  }
}
