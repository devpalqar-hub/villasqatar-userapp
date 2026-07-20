import 'package:flutter/material.dart';
import 'package:flutter_screenutil/flutter_screenutil.dart';
import 'package:get/get.dart';
import 'package:get/get_utils/src/extensions/internacionalization.dart';
import 'package:villas_qatar/modules/Plans/model/featured_property_model.dart';
import 'package:villas_qatar/modules/Plans/services/featured_properties_controller.dart';
import 'package:villas_qatar/modules/home/widgets/agent_card.dart';
import 'package:villas_qatar/modules/home/widgets/boost_property_banner.dart';
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

class HomeScreen extends StatefulWidget {
  final void Function(String propertyName) onSearch;
  final void Function(String type) onCategorySelected;

  const HomeScreen({
    super.key,
    required this.onSearch,
    required this.onCategorySelected,
  });

  @override
  State<HomeScreen> createState() => _HomeScreenState();
}

class _HomeScreenState extends State<HomeScreen> {
  late final FeaturedPropertiesController featuredController;

  final ScrollController featuredScrollController = ScrollController();

  @override
  void initState() {
    super.initState();

    featuredController = Get.isRegistered<FeaturedPropertiesController>()
        ? Get.find<FeaturedPropertiesController>()
        : Get.put(FeaturedPropertiesController(), permanent: true);

    /// Fetch HOME_PAGE featured properties.
    WidgetsBinding.instance.addPostFrameCallback((_) {
      featuredController.fetchFeaturedProperties(
        location: FeaturedLocation.homePage,
        limit: 5,
      );
    });

    /// Listen for horizontal pagination.
    featuredScrollController.addListener(_onFeaturedScroll);
  }

  void _onFeaturedScroll() {
    if (!featuredScrollController.hasClients) {
      return;
    }

    final position = featuredScrollController.position;

    /// Fetch next page when user gets close
    /// to the end of horizontal list.
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
              BoostPropertyBanner(),
              SectionHeader(title: "Explore Qatar".tr),
              ExploreQatarSection(),

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
              height: 225.h,

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
