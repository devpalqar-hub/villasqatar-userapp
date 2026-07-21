import 'package:flutter/material.dart';
import 'package:flutter_screenutil/flutter_screenutil.dart';
import 'package:fluttertoast/fluttertoast.dart';
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
import 'package:villas_qatar/modules/propertylist/service/myproperties_listcontroller.dart';

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

          bottomNavigationBar: _buildBottomSection(
            property: property,
            isMyProperty: isMyProperty,
          ),

          body: SafeArea(
            child: Stack(
              children: [
                SingleChildScrollView(
                  physics: const BouncingScrollPhysics(),

                  child: Column(
                    crossAxisAlignment: CrossAxisAlignment.start,

                    children: [
                      HeroImageCard(
                        property: property,
                        isMyProperty: isMyProperty,
                      ),
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

                                          return GestureDetector(
                                            behavior: HitTestBehavior.opaque,

                                            onTap: () async {
                                              final String selectedPropertyId =
                                                  listing.id.toString().trim();

                                              if (selectedPropertyId.isEmpty) {
                                                debugPrint(
                                                  "FEATURED PROPERTY ID IS EMPTY",
                                                );
                                                return;
                                              }

                                              debugPrint(
                                                "FEATURED PROPERTY CLICKED: "
                                                "$selectedPropertyId",
                                              );

                                              /// Update current property ID
                                              propertyId = selectedPropertyId;

                                              /// Fetch corresponding property details
                                              await controller
                                                  .fetchPropertyDetails(
                                                    selectedPropertyId,
                                                  );

                                              /// Refresh featured list so currently opened
                                              /// property is removed from featured section
                                              await featuredController
                                                  .refreshFeatured(
                                                    location: FeaturedLocation
                                                        .propertyDetailPage,
                                                    limit: 5,
                                                  );
                                            },

                                            child: PropertyCard(
                                              propertyId: listing.id,
                                              slug: listing.slug,
                                              image: listing.imageUrl,
                                              title: listing.propertyName,
                                              location:
                                                  listing.formattedLocation,
                                              distance: '',
                                              price: listing.formattedPrice,
                                              sqm: listing.area.toString(),
                                              area: listing.area,
                                              beds: listing.bedrooms.toString(),
                                              bathrooms: listing.bathrooms,
                                              verified: listing.contactVerified,
                                              isFeatured: listing.isFeatured,
                                            ),
                                          );
                                        },
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
    /// OTHER USER'S PROPERTY
    if (!isMyProperty) {
      return BottomActionCard(property: property);
    }

    /// Check whether property is already sold
    final bool isSold =
        property.status?.toString().trim().toUpperCase() == "SOLD";

    return Material(
      color: Colors.white,
      elevation: 12,
      child: SafeArea(
        top: false,
        child: Padding(
          padding: EdgeInsets.fromLTRB(16.w, 12.h, 16.w, 12.h),
          child: SizedBox(
            width: double.infinity,
            height: 48.h,
            child: ElevatedButton(
              /// Disable button after SOLD
              onPressed: isSold
                  ? null
                  : () {
                      _onMarkAsSold(property);
                    },

              style: ElevatedButton.styleFrom(
                /// Normal = primary
                /// Sold = red
                backgroundColor: isSold
                    ? const Color(0xFFD32F2F)
                    : AppColors.primary,

                /// Required because onPressed:null
                /// otherwise Flutter makes it grey
                disabledBackgroundColor: const Color(0xFFD32F2F),

                foregroundColor: Colors.white,
                disabledForegroundColor: Colors.white,

                elevation: 0,

                shape: RoundedRectangleBorder(
                  borderRadius: BorderRadius.circular(10.r),
                ),
              ),

              child: Row(
                mainAxisAlignment: MainAxisAlignment.center,
                children: [
                  Icon(
                    isSold ? Icons.check_circle_rounded : Icons.sell_outlined,
                    size: 19.sp,
                  ),

                  SizedBox(width: 8.w),

                  Text(
                    isSold ? "Sold" : "Mark as Sold",
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
      ),
    );
  }

  void _onMarkAsSold(dynamic property) {
    final String propertyId = property.id?.toString().trim() ?? "";

    if (propertyId.isEmpty) {
      Get.snackbar(
        "Unable to Update",
        "Property ID is missing.",
        snackPosition: SnackPosition.BOTTOM,
      );
      return;
    }

    Get.dialog(
      Dialog(
        backgroundColor: Colors.transparent,
        insetPadding: EdgeInsets.symmetric(horizontal: 28.w),
        child: Container(
          width: double.infinity,
          padding: EdgeInsets.fromLTRB(22.w, 24.h, 22.w, 20.h),
          decoration: BoxDecoration(
            color: Colors.white,
            borderRadius: BorderRadius.circular(20.r),
            boxShadow: [
              BoxShadow(
                color: Colors.black.withOpacity(0.10),
                blurRadius: 24,
                offset: const Offset(0, 10),
              ),
            ],
          ),
          child: Column(
            mainAxisSize: MainAxisSize.min,
            children: [
              /// ICON
              Container(
                width: 58.w,
                height: 58.w,
                decoration: BoxDecoration(
                  color: AppColors.primary.withOpacity(0.08),
                  shape: BoxShape.circle,
                ),
                child: Center(
                  child: Icon(
                    Icons.sell_outlined,
                    color: AppColors.primary,
                    size: 27.sp,
                  ),
                ),
              ),

              SizedBox(height: 18.h),

              /// TITLE
              Text(
                "Mark as Sold",
                textAlign: TextAlign.center,
                style: TextStyle(
                  fontSize: 18.sp,
                  fontWeight: FontWeight.w700,
                  color: const Color(0xFF1F1F1F),
                ),
              ),

              SizedBox(height: 9.h),

              /// DESCRIPTION
              Text(
                "Are you sure you want to mark this property as sold?",
                textAlign: TextAlign.center,
                style: TextStyle(
                  fontSize: 12.sp,
                  fontWeight: FontWeight.w400,
                  color: const Color(0xFF777777),
                  height: 1.5,
                ),
              ),

              SizedBox(height: 6.h),

              /// INFO MESSAGE
              Container(
                width: double.infinity,
                margin: EdgeInsets.only(top: 10.h),
                padding: EdgeInsets.symmetric(horizontal: 12.w, vertical: 10.h),
                decoration: BoxDecoration(
                  color: const Color(0xFFF8F8F8),
                  borderRadius: BorderRadius.circular(10.r),
                ),
                child: Row(
                  crossAxisAlignment: CrossAxisAlignment.start,
                  children: [
                    Icon(
                      Icons.info_outline_rounded,
                      size: 17.sp,
                      color: const Color(0xFF777777),
                    ),

                    SizedBox(width: 8.w),

                    Expanded(
                      child: Text(
                        "This property will be updated as sold and will no longer be available as an active listing.",
                        style: TextStyle(
                          fontSize: 10.sp,
                          color: const Color(0xFF666666),
                          height: 1.45,
                        ),
                      ),
                    ),
                  ],
                ),
              ),

              SizedBox(height: 22.h),

              /// ACTION BUTTONS
              Row(
                children: [
                  /// CANCEL
                  Expanded(
                    child: SizedBox(
                      height: 46.h,
                      child: OutlinedButton(
                        onPressed: () {
                          Get.back();
                        },
                        style: OutlinedButton.styleFrom(
                          foregroundColor: const Color(0xFF444444),
                          side: const BorderSide(color: Color(0xFFE2E2E2)),
                          elevation: 0,
                          shape: RoundedRectangleBorder(
                            borderRadius: BorderRadius.circular(10.r),
                          ),
                        ),
                        child: Text(
                          "Cancel",
                          style: TextStyle(
                            fontSize: 12.sp,
                            fontWeight: FontWeight.w600,
                          ),
                        ),
                      ),
                    ),
                  ),

                  SizedBox(width: 10.w),

                  /// MARK AS SOLD
                  Expanded(
                    flex: 2,
                    child: SizedBox(
                      height: 46.h,
                      child: ElevatedButton(
                        onPressed: () async {
                          /// Close confirmation dialog
                          Get.back();

                          final MyPropertyController myPropertyController =
                              Get.isRegistered<MyPropertyController>()
                              ? Get.find<MyPropertyController>()
                              : Get.put(MyPropertyController());
                          final bool success = await myPropertyController
                              .markAsSold(propertyId);

                          if (success) {
                            /// IMPORTANT:
                            /// Fetch updated property from API.
                            /// Now response should contain:
                            /// status: "SOLD"
                            await controller.fetchPropertyDetails(propertyId);

                            Fluttertoast.showToast(
                              msg: "Property marked as sold successfully",
                              toastLength: Toast.LENGTH_SHORT,
                              gravity: ToastGravity.BOTTOM,
                              backgroundColor: Colors.green.shade700,
                              textColor: Colors.white,
                              fontSize: 14.sp,
                            );

                            /// DO NOT call Get.back() here
                          } else {
                            Fluttertoast.showToast(
                              msg:
                                  myPropertyController
                                      .markAsSoldError
                                      .isNotEmpty
                                  ? myPropertyController.markAsSoldError
                                  : "Unable to mark property as sold",
                              toastLength: Toast.LENGTH_LONG,
                              gravity: ToastGravity.BOTTOM,
                              backgroundColor: Colors.red.shade700,
                              textColor: Colors.white,
                              fontSize: 14.sp,
                            );
                          }
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
                              Icons.check_circle_outline_rounded,
                              size: 17.sp,
                            ),

                            SizedBox(width: 6.w),

                            Text(
                              "Mark as Sold",
                              style: TextStyle(
                                fontSize: 12.sp,
                                fontWeight: FontWeight.w600,
                              ),
                            ),
                          ],
                        ),
                      ),
                    ),
                  ),
                ],
              ),
            ],
          ),
        ),
      ),
      barrierDismissible: false,
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
