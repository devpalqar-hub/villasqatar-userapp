import 'package:flutter/material.dart';
import 'package:flutter_screenutil/flutter_screenutil.dart';
import 'package:get/get.dart';

import 'package:villas_qatar/Core/constants/app_colors.dart';
import 'package:villas_qatar/Core/services/storage_service.dart';

import 'package:villas_qatar/modules/Plans/model/featured_property_model.dart';
import 'package:villas_qatar/modules/Plans/services/featured_properties_controller.dart';

import 'package:villas_qatar/modules/home/widgets/property_card.dart';

import 'package:villas_qatar/modules/propertydetailscreen/widget/agent_conatct_card.dart';
import 'package:villas_qatar/modules/propertydetailscreen/widget/boost_plan_bottomsheet.dart';
import 'package:villas_qatar/modules/propertydetailscreen/widget/bottom_actioncard.dart';
import 'package:villas_qatar/modules/propertydetailscreen/widget/herocard.dart';
import 'package:villas_qatar/modules/propertydetailscreen/widget/property_details_card.dart';
import 'package:villas_qatar/modules/propertydetailscreen/widget/property_info_card.dart';
import 'package:villas_qatar/modules/propertydetailscreen/widget/property_location_card.dart';
import 'package:villas_qatar/modules/propertydetailscreen/widget/overview_card.dart';

import 'package:villas_qatar/modules/searchscreen/service/searchlist_screen.dart';

class PropertyDetailsScreen extends StatefulWidget {
  const PropertyDetailsScreen({super.key});

  @override
  State<PropertyDetailsScreen> createState() => _PropertyDetailsScreenState();
}

class _PropertyDetailsScreenState extends State<PropertyDetailsScreen> {
  late final PropertySearchController controller;

  late final FeaturedPropertiesController featuredController;

  final ScrollController featuredScrollController = ScrollController();

  String? propertyId;

  @override
  void initState() {
    super.initState();

    controller = Get.find<PropertySearchController>();
    featuredController = Get.isRegistered<FeaturedPropertiesController>()
        ? Get.find<FeaturedPropertiesController>()
        : Get.put(FeaturedPropertiesController());

    final arguments = Get.arguments;

    if (arguments is Map) {
      propertyId = arguments["propertyId"]?.toString();
    }

    debugPrint("DETAIL SCREEN PROPERTY ID: $propertyId");

    featuredScrollController.addListener(_onFeaturedScroll);

    WidgetsBinding.instance.addPostFrameCallback((_) {
      final String? id = propertyId?.trim();

      if (id == null || id.isEmpty) {
        debugPrint("ERROR: Property ID is empty");
      } else {
        controller.fetchPropertyDetails(id);
      }

      featuredController.fetchFeaturedProperties(
        location: FeaturedLocation.propertyDetailPage,
        limit: 5,
      );
    });
  }

  @override
  void dispose() {
    featuredScrollController.removeListener(_onFeaturedScroll);

    featuredScrollController.dispose();

    super.dispose();
  }

  @override
  Widget build(BuildContext context) {
    return GetBuilder<PropertySearchController>(
      builder: (controller) {
        if (controller.isDetailsLoading) {
          return const Scaffold(
            backgroundColor: Colors.white,
            body: Center(child: CircularProgressIndicator()),
          );
        }

        if (controller.selectedProperty == null) {
          return Scaffold(
            backgroundColor: Colors.white,

            appBar: AppBar(
              backgroundColor: Colors.white,

              elevation: 0,

              leading: IconButton(
                icon: const Icon(Icons.arrow_back, color: Colors.black),

                onPressed: () {
                  Navigator.pop(context);
                },
              ),
            ),

            body: const Center(child: Text("Property not found")),
          );
        }

        final property = controller.selectedProperty!;

        final String loggedInUserId = StorageService.getUserId();

        final String propertyOwnerId =
            property.createdBy?.id?.toString().trim() ?? '';

        final bool isMyProperty =
            loggedInUserId.isNotEmpty &&
            propertyOwnerId.isNotEmpty &&
            loggedInUserId == propertyOwnerId;

        return Scaffold(
          backgroundColor: Colors.white,

          bottomNavigationBar: BottomActionCard(property: property),

          body: SafeArea(
            child: Stack(
              children: [
                SingleChildScrollView(
                  physics: const BouncingScrollPhysics(),

                  child: Column(
                    crossAxisAlignment: CrossAxisAlignment.start,

                    children: [
                      HeroImageCard(property: property),
                      if (isMyProperty)
                        Padding(
                          padding: EdgeInsets.fromLTRB(16.w, 12.h, 16.w, 4.h),
                          child: SizedBox(
                            width: double.infinity,
                            height: 48.h,
                            child: ElevatedButton(
                              onPressed: () {
                                _onBoostProperty(property);
                              },
                              style: ElevatedButton.styleFrom(
                                backgroundColor: AppColors.primary,
                                foregroundColor: Colors.white,
                                elevation: 0,
                                shape: RoundedRectangleBorder(
                                  borderRadius: BorderRadius.circular(10.r),
                                ),
                              ),
                              child: Row(
                                mainAxisAlignment: MainAxisAlignment.center,
                                children: [
                                  Icon(
                                    Icons.rocket_launch_outlined,
                                    size: 19.sp,
                                  ),
                                  SizedBox(width: 8.w),
                                  Text(
                                    "Boost Property",
                                    style: TextStyle(
                                      fontSize: 14.sp,
                                      fontWeight: FontWeight.w600,
                                    ),
                                  ),
                                ],
                              ),
                            ),
                          ),
                        ),
                      Padding(
                        padding: EdgeInsets.symmetric(horizontal: 16.w),

                        child: Column(
                          children: [
                            // ================================
                            // PROPERTY INFO
                            // ================================
                            PropertyInfoCard(property: property),

                            SizedBox(height: 10.h),

                            // ================================
                            // OVERVIEW
                            // ================================
                            OverviewCard(property: property),

                            SizedBox(height: 12.h),

                            // ================================
                            // LOCATION
                            // ================================
                            PropertyLocationCard(property: property),

                            SizedBox(height: 12.h),

                            // ================================
                            // PROPERTY DETAILS
                            // ================================
                            PropertyDetailsCard(property: property),

                            SizedBox(height: 12.h),
                            AgentContactCard(property: property),

                            SizedBox(height: 12.h),
                            GetBuilder<FeaturedPropertiesController>(
                              builder: (featuredController) {
                                final List<FeaturedProperty>
                                featuredProperties = featuredController
                                    .getProperties(
                                      FeaturedLocation.propertyDetailPage,
                                    );

                                final bool isLoading = featuredController
                                    .isLoading(
                                      FeaturedLocation.propertyDetailPage,
                                    );

                                final bool isLoadingMore = featuredController
                                    .isLoadingMore(
                                      FeaturedLocation.propertyDetailPage,
                                    );

                                final bool hasMore = featuredController.hasMore(
                                  FeaturedLocation.propertyDetailPage,
                                );

                                final String error = featuredController
                                    .getError(
                                      FeaturedLocation.propertyDetailPage,
                                    );

                                if (isLoading && featuredProperties.isEmpty) {
                                  return SizedBox(
                                    height: 250.h,

                                    child: const Center(
                                      child: CircularProgressIndicator(),
                                    ),
                                  );
                                }
                                if (error.isNotEmpty &&
                                    featuredProperties.isEmpty) {
                                  return SizedBox(
                                    height: 150.h,

                                    child: Center(
                                      child: Column(
                                        mainAxisSize: MainAxisSize.min,

                                        children: [
                                          Text(
                                            "Unable to load featured properties",

                                            textAlign: TextAlign.center,

                                            style: TextStyle(
                                              fontSize: 12.sp,

                                              color: Colors.grey,
                                            ),
                                          ),

                                          SizedBox(height: 8.h),

                                          TextButton(
                                            onPressed: () {
                                              featuredController
                                                  .refreshFeatured(
                                                    location: FeaturedLocation
                                                        .propertyDetailPage,

                                                    limit: 5,
                                                  );
                                            },

                                            child: const Text("Retry"),
                                          ),
                                        ],
                                      ),
                                    ),
                                  );
                                }
                                if (featuredProperties.isEmpty) {
                                  return const SizedBox.shrink();
                                }
                                final String currentPropertyId =
                                    propertyId?.trim() ?? '';

                                final List<FeaturedProperty> displayProperties =
                                    featuredProperties.where((featured) {
                                      return featured.listing.id !=
                                          currentPropertyId;
                                    }).toList();

                                if (displayProperties.isEmpty &&
                                    !isLoadingMore) {
                                  return const SizedBox.shrink();
                                }
                                return Column(
                                  crossAxisAlignment: CrossAxisAlignment.start,

                                  children: [
                                    Text(
                                      "Featured Properties",

                                      style: TextStyle(
                                        fontSize: 18.sp,

                                        fontWeight: FontWeight.w600,

                                        color: Colors.black,
                                      ),
                                    ),

                                    SizedBox(height: 12.h),

                                    SizedBox(
                                      height: 250.h,

                                      child: ListView.separated(
                                        controller: featuredScrollController,

                                        scrollDirection: Axis.horizontal,

                                        physics: const BouncingScrollPhysics(),

                                        itemCount:
                                            displayProperties.length +
                                            (isLoadingMore ? 1 : 0),

                                        separatorBuilder: (context, index) {
                                          return SizedBox(width: 8.w);
                                        },

                                        itemBuilder: (context, index) {
                                          if (index >=
                                              displayProperties.length) {
                                            return SizedBox(
                                              width: 70.w,

                                              child: const Center(
                                                child:
                                                    CircularProgressIndicator(),
                                              ),
                                            );
                                          }

                                          final FeaturedProperty featured =
                                              displayProperties[index];

                                          final FeaturedListing listing =
                                              featured.listing;

                                          // ====================
                                          // PROPERTY CARD
                                          // ====================

                                          return PropertyCard(
                                            propertyId: listing.id,

                                            slug: listing.slug,

                                            image: listing.imageUrl,

                                            title: listing.propertyName,

                                            location: listing.formattedLocation,

                                            distance: '',

                                            price: listing.formattedPrice,

                                            sqm: listing.area.toString(),

                                            area: listing.area,

                                            beds: listing.bedrooms.toString(),

                                            bathrooms: listing.bathrooms,

                                            verified: listing.contactVerified,

                                            isFeatured: listing.isFeatured,
                                          );
                                        },
                                      ),
                                    ),
                                    if (!hasMore &&
                                        displayProperties.isNotEmpty)
                                      Padding(
                                        padding: EdgeInsets.only(top: 6.h),

                                        child: Center(
                                          child: Text(
                                            "No more featured properties",

                                            style: TextStyle(
                                              fontSize: 10.sp,

                                              color: Colors.grey,
                                            ),
                                          ),
                                        ),
                                      ),
                                  ],
                                );
                              },
                            ),

                            SizedBox(height: 20.h),
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

  Widget _buildBottomSection({
    required dynamic property,
    required bool isMyProperty,
  }) {
    if (!isMyProperty) {
      return BottomActionCard(property: property);
    }

    return Material(
      color: Colors.white,
      elevation: 12,

      child: SafeArea(
        top: false,

        child: Column(
          mainAxisSize: MainAxisSize.min,

          children: [
            Padding(
              padding: EdgeInsets.fromLTRB(16.w, 12.h, 16.w, 6.h),

              child: SizedBox(
                width: double.infinity,

                height: 48.h,

                child: ElevatedButton(
                  onPressed: () {
                    _onBoostProperty(property);
                  },

                  style: ElevatedButton.styleFrom(
                    backgroundColor: AppColors.primary,

                    foregroundColor: Colors.white,

                    elevation: 0,

                    shape: RoundedRectangleBorder(
                      borderRadius: BorderRadius.circular(10.r),
                    ),
                  ),

                  child: Row(
                    mainAxisAlignment: MainAxisAlignment.center,

                    children: [
                      Icon(Icons.rocket_launch_outlined, size: 19.sp),

                      SizedBox(width: 8.w),

                      Text(
                        "Boost Property",

                        style: TextStyle(
                          fontSize: 14.sp,

                          fontWeight: FontWeight.w600,
                        ),
                      ),
                    ],
                  ),
                ),
              ),
            ),

            BottomActionCard(property: property),
          ],
        ),
      ),
    );
  }

  void _onBoostProperty(dynamic property) {
    final String id = property.id?.toString().trim() ?? '';

    debugPrint("========== OPEN BOOST SHEET ==========");
    debugPrint("PROPERTY ID: $id");

    if (id.isEmpty) {
      Get.snackbar(
        "Unable to Boost",
        "Property ID is missing.",
        snackPosition: SnackPosition.BOTTOM,
      );
      return;
    }

    Get.bottomSheet(
      BoostPlanBottomSheet(propertyId: id),
      isScrollControlled: true,
      backgroundColor: Colors.transparent,
      barrierColor: Colors.black.withOpacity(.45),
      isDismissible: true,
      enableDrag: true,
    );
  }

  void _onFeaturedScroll() {
    if (!featuredScrollController.hasClients) {
      return;
    }

    final ScrollPosition position = featuredScrollController.position;

    if (position.pixels >= position.maxScrollExtent - 200) {
      final bool hasMore = featuredController.hasMore(
        FeaturedLocation.propertyDetailPage,
      );

      final bool loadingMore = featuredController.isLoadingMore(
        FeaturedLocation.propertyDetailPage,
      );

      if (hasMore && !loadingMore) {
        debugPrint("LOAD MORE PROPERTY_DETAIL_PAGE FEATURED");

        featuredController.loadMore(
          location: FeaturedLocation.propertyDetailPage,

          limit: 5,
        );
      }
    }
  }
}
