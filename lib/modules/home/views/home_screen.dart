import 'package:flutter/cupertino.dart';
import 'package:flutter/material.dart';
import 'package:flutter_screenutil/flutter_screenutil.dart';
import 'package:get/get.dart';
import 'package:url_launcher/url_launcher.dart';
import 'package:villas_qatar/Core/constants/app_colors.dart';
import 'package:villas_qatar/Core/theme/app_textstyles.dart';
import 'package:villas_qatar/Core/utils/app_location.dart';
import 'package:villas_qatar/modules/PlansandFeatures/model/featured_property_model.dart';
import 'package:villas_qatar/modules/PlansandFeatures/services/featured_properties_controller.dart';
import 'package:villas_qatar/modules/dealers/service/dealer_controller.dart';
import 'package:villas_qatar/modules/dealers/service/view/dealer_detail_screen.dart';
import 'package:villas_qatar/modules/dealers/service/view/detail_list_screen.dart';
import 'package:villas_qatar/modules/home/service/UtilsController.dart';
import 'package:villas_qatar/modules/home/service/banner_controller.dart';
import 'package:villas_qatar/modules/home/service/loaction_controller.dart';
import 'package:villas_qatar/modules/home/widgets/agent_card.dart';
import 'package:villas_qatar/modules/home/widgets/category_card.dart';
import 'package:villas_qatar/modules/home/widgets/estimator_card.dart';
import 'package:villas_qatar/modules/home/widgets/hero_banner.dart';
import 'package:villas_qatar/modules/home/widgets/location_card.dart';
import 'package:villas_qatar/modules/home/widgets/property_card.dart';
import 'package:villas_qatar/modules/home/widgets/section_header.dart';
import 'package:villas_qatar/modules/home/widgets/sponser_banner.dart';
import 'package:villas_qatar/modules/home/widgets/why_choose_card.dart';
import 'package:villas_qatar/modules/mainscreen/home_bottom_nav.dart';
import 'package:villas_qatar/modules/mainscreen/mainscreen.dart';
import 'package:villas_qatar/modules/propertydetailscreen/propertydetailscreen.dart';
import 'package:villas_qatar/modules/searchscreen/view/search_screen.dart';

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
  late final DealerController dealerController;
  final ScrollController featuredScrollController = ScrollController();
  final Utilscontroller utilscontroller = Get.put(Utilscontroller());
  final LocationController locationcontroller = Get.put(LocationController());
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
    dealerController = Get.isRegistered<DealerController>()
        ? Get.find<DealerController>()
        : Get.put(DealerController());

    WidgetsBinding.instance.addPostFrameCallback((_) {
      dealerController.fetchDealers();
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
      appBar: AppBar(
        backgroundColor: Colors.white,
        leading: Container(),
        leadingWidth: 10.w,
        title: Image.asset(
          'assets/Logo/logo.png',
          width: 140.w,
          fit: BoxFit.contain,
        ),
        actions: [
          InkWell(
            borderRadius: BorderRadius.circular(20.r),
            onTap: () {
              showLocationBottomSheet(context);
            },
            child: Container(
              height: 30.h,
              padding: EdgeInsets.symmetric(horizontal: 8.w),
              decoration: BoxDecoration(
                color: Colors.white,
                borderRadius: BorderRadius.circular(20.r),
                border: Border.all(color: Colors.grey.shade300),
                boxShadow: [
                  BoxShadow(
                    color: Colors.black.withOpacity(0.09),
                    blurRadius: 10,
                    offset: const Offset(0, 3),
                  ),
                ],
              ),
              child: GetBuilder<LocationController>(
                builder: (_) {
                  return Row(
                    mainAxisSize: MainAxisSize.min,
                    children: [
                      Icon(
                        Icons.location_on_outlined,
                        color: AppColors.primary,
                        size: 14.sp,
                      ),

                      SizedBox(width: 6.w),

                      Flexible(
                        child: Text(
                          AppLocation.areaName.isEmpty
                              ? "Doha".tr
                              : AppLocation.areaName,
                          maxLines: 1,
                          overflow: TextOverflow.ellipsis,
                          style: AppTextStyles.body13.copyWith(
                            color: AppColors.textPrimary,
                          ),
                        ),
                      ),

                      SizedBox(width: 2.w),

                      Icon(
                        Icons.keyboard_arrow_down,
                        size: 16.sp,
                        color: AppColors.textPrimary,
                      ),
                    ],
                  );
                },
              ),
            ),
          ),
          SizedBox(width: 10.w),
          Icon(
            CupertinoIcons.bell_solid,
            color: AppColors.primary.withOpacity(.9),
          ),
          SizedBox(width: 10.w),
        ],
      ),
      body: SafeArea(
        child: SingleChildScrollView(
          //  padding: EdgeInsets.symmetric(horizontal: 24.w),
          child: Column(
            spacing: 12.h,
            children: [
              //SizedBox(height: 20),
              // HomeHeader(),
              HomeBanner(onSearch: (propertyName, type) {}),

              // QuickActionsCard(onPurposeSelected: widget.onPurposeSelected),
              Padding(
                padding: EdgeInsets.symmetric(horizontal: 16.w),
                child: SectionHeader(
                  title: "Browse by Category".tr,
                  onSeeAllTap: () {
                    Get.offAll(
                      () => const MainScreen(initialIndex: 1),
                      transition: Transition.rightToLeft,
                    );
                  },
                ),
              ),
              GetBuilder<Utilscontroller>(
                builder: (__) {
                  return SizedBox(
                    height: 110.h,
                    child: SingleChildScrollView(
                      scrollDirection: Axis.horizontal,
                      physics: const BouncingScrollPhysics(),
                      padding: EdgeInsets.symmetric(horizontal: 16.w),
                      child: Row(
                        children: [
                          for (var data in utilscontroller.listingTypes)
                            Padding(
                              padding: EdgeInsets.only(right: 8.w),
                              child: Container(
                                width: 100.w,
                                padding: EdgeInsets.all(5.w),
                                decoration: BoxDecoration(
                                  color: Colors.white,
                                  borderRadius: BorderRadius.circular(10.r),
                                  boxShadow: [
                                    BoxShadow(
                                      color: Colors.black.withOpacity(.02),
                                      spreadRadius: .1,
                                      blurRadius: 10,
                                    ),
                                  ],
                                ),
                                child: Column(
                                  mainAxisAlignment: MainAxisAlignment.center,
                                  children: [
                                    Image.network(
                                      data.image ?? "",
                                      width: 60.w,
                                      height: 60.w,
                                    ),
                                    SizedBox(height: 4.h),
                                    Text(
                                      data.title.tr,
                                      textAlign: TextAlign.center,
                                      style: TextStyle(
                                        fontFamily: "Rubik",
                                        fontSize: 12.sp,
                                        fontWeight: FontWeight.w400,
                                      ),
                                    ),
                                   
                                  ],
                                ),
                              ),
                            ),
                        ],
                      ),
                    ),
                  );
                },
              ),
            
             
              Padding(
                padding: EdgeInsets.symmetric(horizontal: 16.w),
                child: SectionHeader(title: "Near You".tr),
              ),

              Container(
                padding: EdgeInsets.symmetric(horizontal: 16.w),
                height: 100.h,
                child: GetBuilder<LocationController>(
                  builder: (controller) {
                    if (controller.isNearbyLoading) {
                      return const Center(child: CircularProgressIndicator());
                    }

                    if (controller.nearbyProperties.isEmpty) {
                      return const Center(child: Text("No nearby properties"));
                    }

                    return ListView.separated(
                      scrollDirection: Axis.horizontal,
                      itemCount: controller.nearbyProperties.length,
                      separatorBuilder: (_, __) => SizedBox(width: 10.w),
                      itemBuilder: (context, index) {
                        final property = controller.nearbyProperties[index];

                        return LocationCard(property: property);
                      },
                    );
                  },
                ),
              ),
              // EstimatorCard(),

              _buildFeaturedPropertiesSection(),

              _buildBannersSection(),
              SectionHeader(
                title: "Featured Dealers".tr,
                showSeeAll: true,
                onSeeAllTap: () {
                  Get.to(() => const DealerListScreen());
                },
              ),

              GetBuilder<DealerController>(
                builder: (controller) {
                  if (controller.isLoading && controller.dealers.isEmpty) {
                    return SizedBox(
                      height: 165.h,
                      child: const Center(child: CircularProgressIndicator()),
                    );
                  }

                  if (controller.dealers.isEmpty) {
                    return SizedBox(
                      height: 165.h,
                      child: Center(
                        child: Text(
                          "No dealers found".tr,
                          style: AppTextStyles.body14,
                        ),
                      ),
                    );
                  }

                  return SizedBox(
                    height: 165.h,
                    child: ListView.separated(
                      padding: EdgeInsets.symmetric(horizontal: 16.w),
                      scrollDirection: Axis.horizontal,
                      physics: const BouncingScrollPhysics(),
                      itemCount: controller.dealers.length,
                      separatorBuilder: (_, __) => SizedBox(width: 12.w),
                      itemBuilder: (_, index) {
                        final dealer = controller.dealers[index];

                        return AgentCards(
                          image: dealer.dealerProfile.coverImage,
                          name: dealer.dealerProfile.dealerName.isNotEmpty
                              ? dealer.dealerProfile.dealerName
                              : dealer.name,
                          designation:
                              dealer.dealerProfile.tagline ??
                              "Property Consultant",
                          phone: dealer.dealerProfile.contactPhone,
                          onTap: () {
                            Get.to(
                              () => const DealerDetailsScreen(),
                              arguments: dealer.id,
                            );
                          },
                        );
                      },
                    ),
                  );
                },
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
            SectionHeader(
              title: "Featured Properties",
              onSeeAllTap: () {
                Get.offAll(
                  () => const MainScreen(initialIndex: 1),
                  transition: Transition.rightToLeft,
                );
              },
            ),
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

                  return GestureDetector(
                    onTap: () {
                      debugPrint("Sending propertyId = ${property.id}");

                      Get.to(
                        () => PropertyDetailsScreen(
                          propertyId: property.id.toString(),
                        ),
                        transition: Transition.rightToLeft,
                      );
                    },
                    child: PropertyCard(
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
                    ),
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

void showLocationBottomSheet(BuildContext context) {
  final controller = Get.find<LocationController>();

  Get.bottomSheet(
    LocationBottomSheet(controller: controller),
    isScrollControlled: true,
    backgroundColor: Colors.white,
    shape: const RoundedRectangleBorder(
      borderRadius: BorderRadius.vertical(top: Radius.circular(24)),
    ),
  );
}

class LocationBottomSheet extends StatelessWidget {
  const LocationBottomSheet({super.key, required this.controller});

  final LocationController controller;

  @override
  Widget build(BuildContext context) {
    return GetBuilder<LocationController>(
      builder: (_) {
        return DraggableScrollableSheet(
          expand: false,
          initialChildSize: .50,
          // minChildSize: .45,
          maxChildSize: .60,
          builder: (context, scrollController) {
            return Container(
              decoration: const BoxDecoration(
                color: Colors.white,
                borderRadius: BorderRadius.vertical(top: Radius.circular(28)),
              ),
              child: Column(
                children: [
                  SizedBox(height: 12.h),

                  /// Handle
                  Container(
                    width: 55.w,
                    height: 4.h,
                    decoration: BoxDecoration(
                      color: Colors.grey.shade300,
                      borderRadius: BorderRadius.circular(100),
                    ),
                  ),

                  SizedBox(height: 18.h),

                  /// Header
                  Padding(
                    padding: EdgeInsets.symmetric(horizontal: 20.w),
                    child: Row(
                      children: [
                        Expanded(
                          child: Text(
                            "Choose Location".tr,
                            style: AppTextStyles.title18.copyWith(
                              fontWeight: FontWeight.w600,
                            ),
                          ),
                        ),
                        InkWell(
                          borderRadius: BorderRadius.circular(30),
                          onTap: Get.back,
                          child: Container(
                            padding: EdgeInsets.all(8.w),
                            decoration: BoxDecoration(
                              color: Colors.grey.shade100,
                              shape: BoxShape.circle,
                            ),
                            child: Icon(Icons.close_rounded, size: 18.sp),
                          ),
                        ),
                      ],
                    ),
                  ),

                  SizedBox(height: 20.h),

                  Padding(
                    padding: EdgeInsets.symmetric(horizontal: 16.w),
                    child: InkWell(
                      borderRadius: BorderRadius.circular(10.r),
                      onTap: () async {
                        await controller.detectCurrentLocation();
                        Get.back();
                      },
                      child: Container(
                        padding: EdgeInsets.symmetric(
                          horizontal: 16.w,
                          vertical: 10.h,
                        ),
                        decoration: BoxDecoration(
                          borderRadius: BorderRadius.circular(10.r),
                          color: AppColors.primary.withOpacity(.05),
                          border: Border.all(
                            color: AppColors.primary.withOpacity(.12),
                          ),
                          boxShadow: [
                            BoxShadow(
                              color: Colors.black.withOpacity(.04),
                              blurRadius: 15,
                              offset: const Offset(0, 6),
                            ),
                          ],
                        ),
                        child: Row(
                          children: [
                            Container(
                              height: 35.h,
                              width: 35.w,
                              decoration: BoxDecoration(
                                color: AppColors.primary,
                                borderRadius: BorderRadius.circular(10.r),
                              ),
                              child: Icon(
                                Icons.my_location_rounded,
                                color: Colors.white,
                                size: 15.sp,
                              ),
                            ),

                            SizedBox(width: 14.w),

                            Expanded(
                              child: Column(
                                crossAxisAlignment: CrossAxisAlignment.start,
                                children: [
                                  Text(
                                    "Use Current Location".tr,
                                    style: AppTextStyles.medium14.copyWith(
                                      fontWeight: FontWeight.w700,
                                    ),
                                  ),
                                  SizedBox(height: 4.h),
                                  Text(
                                    "Detect location using GPS".tr,
                                    style: AppTextStyles.body13.copyWith(
                                      color: Colors.grey.shade600,
                                    ),
                                  ),
                                ],
                              ),
                            ),

                            Container(
                              padding: EdgeInsets.all(10.w),
                              decoration: BoxDecoration(
                                color: Colors.white,
                                shape: BoxShape.circle,
                              ),
                              child: Icon(
                                Icons.arrow_forward_ios_rounded,
                                color: AppColors.primary,
                                size: 12.sp,
                              ),
                            ),
                          ],
                        ),
                      ),
                    ),
                  ),

                  SizedBox(height: 15.h),

                  /// Search Box
                  Padding(
                    padding: EdgeInsets.symmetric(horizontal: 16.w),
                    child: TextField(
                      controller: controller.searchController,
                      textInputAction: TextInputAction.search,
                      onChanged: controller.onSearchChanged,
                      decoration: InputDecoration(
                        hintText: "Search city, area or landmark".tr,

                        prefixIcon: Icon(
                          Icons.search_rounded,
                          color: Colors.grey.shade600,
                        ),

                        suffixIcon: controller.searchController.text.isNotEmpty
                            ? IconButton(
                                onPressed: () {
                                  controller.searchController.clear();
                                  controller.results.clear();
                                  controller.update();
                                },
                                icon: const Icon(Icons.close_rounded),
                              )
                            : null,

                        filled: true,
                        fillColor: Colors.grey.shade100,

                        contentPadding: EdgeInsets.symmetric(vertical: 16.h),

                        border: OutlineInputBorder(
                          borderRadius: BorderRadius.circular(10.r),
                          borderSide: BorderSide.none,
                        ),

                        enabledBorder: OutlineInputBorder(
                          borderRadius: BorderRadius.circular(10.r),
                          borderSide: BorderSide.none,
                        ),

                        focusedBorder: OutlineInputBorder(
                          borderRadius: BorderRadius.circular(10.r),
                          borderSide: BorderSide(
                            color: AppColors.primary,
                            width: 1.2,
                          ),
                        ),
                      ),
                    ),
                  ),

                  SizedBox(height: 10.h),

                  if (controller.isLoading)
                    const Expanded(
                      child: Center(child: CircularProgressIndicator()),
                    ),

                  if (!controller.isLoading)
                    Expanded(
                      child: controller.results.isEmpty
                          ? SingleChildScrollView(
                              controller: scrollController,
                              physics: const BouncingScrollPhysics(),
                              child: SizedBox(
                                height: 180.h,
                                child: Column(
                                  mainAxisAlignment: MainAxisAlignment.center,
                                  children: [
                                    Container(
                                      height: 45.w,
                                      width: 45.w,
                                      decoration: BoxDecoration(
                                        color: AppColors.primary.withOpacity(
                                          .08,
                                        ),
                                        shape: BoxShape.circle,
                                      ),
                                      child: Icon(
                                        Icons.location_searching_rounded,
                                        color: AppColors.primary,
                                        size: 20.sp,
                                      ),
                                    ),
                                    SizedBox(height: 15.h),
                                    Text(
                                      controller.searchController.text.isEmpty
                                          ? "Search for a location".tr
                                          : "No locations found".tr,
                                      style: AppTextStyles.medium14.copyWith(
                                        fontWeight: FontWeight.w600,
                                      ),
                                    ),
                                    SizedBox(height: 6.h),
                                    Padding(
                                      padding: EdgeInsets.symmetric(
                                        horizontal: 40.w,
                                      ),
                                      child: Text(
                                        controller.searchController.text.isEmpty
                                            ? "Search by city, area or landmark"
                                                  .tr
                                            : "Try another keyword".tr,
                                        textAlign: TextAlign.center,
                                        style: AppTextStyles.body13.copyWith(
                                          color: Colors.grey.shade600,
                                        ),
                                      ),
                                    ),
                                  ],
                                ),
                              ),
                            )
                          : ListView.separated(
                              controller: scrollController,
                              physics: const BouncingScrollPhysics(),
                              padding: EdgeInsets.fromLTRB(20.w, 0, 20.w, 25.h),
                              itemCount: controller.results.length,
                              separatorBuilder: (_, __) =>
                                  SizedBox(height: 12.h),
                              itemBuilder: (_, index) {
                                final item = controller.results[index];

                                return Material(
                                  color: Colors.white,
                                  borderRadius: BorderRadius.circular(18.r),
                                  elevation: .5,
                                  shadowColor: Colors.black12,
                                  child: InkWell(
                                    borderRadius: BorderRadius.circular(18.r),
                                    onTap: () {
                                      controller.selectLocation(item);
                                      Get.back();
                                    },
                                    child: Padding(
                                      padding: EdgeInsets.all(14.w),
                                      child: Row(
                                        children: [
                                          Container(
                                            width: 45.w,
                                            height: 45.w,
                                            decoration: BoxDecoration(
                                              color: AppColors.primary
                                                  .withOpacity(.08),
                                              borderRadius:
                                                  BorderRadius.circular(15.r),
                                            ),
                                            child: Icon(
                                              Icons.location_on_rounded,
                                              color: AppColors.primary,
                                              size: 20.sp,
                                            ),
                                          ),

                                          SizedBox(width: 14.w),

                                          Expanded(
                                            child: Column(
                                              crossAxisAlignment:
                                                  CrossAxisAlignment.start,
                                              children: [
                                                Text(
                                                  item.data.areaName,
                                                  maxLines: 1,
                                                  overflow:
                                                      TextOverflow.ellipsis,
                                                  style: AppTextStyles.medium14
                                                      .copyWith(
                                                        fontWeight:
                                                            FontWeight.w700,
                                                      ),
                                                ),

                                                SizedBox(height: 5.h),

                                                Text(
                                                  item.data.formattedAddress,
                                                  maxLines: 2,
                                                  overflow:
                                                      TextOverflow.ellipsis,
                                                  style: AppTextStyles.body13
                                                      .copyWith(
                                                        color: Colors
                                                            .grey
                                                            .shade600,
                                                        height: 1.4,
                                                      ),
                                                ),
                                              ],
                                            ),
                                          ),

                                          SizedBox(width: 8.w),

                                          Icon(
                                            Icons.arrow_forward_ios_rounded,
                                            color: AppColors.primary,
                                            size: 14.sp,
                                          ),
                                        ],
                                      ),
                                    ),
                                  ),
                                );
                              },
                            ),
                    ),
                ],
              ),
            );
          },
        );
      },
    );
  }
}
