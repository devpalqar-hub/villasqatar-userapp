import 'package:flutter/material.dart';
import 'package:flutter_screenutil/flutter_screenutil.dart';
import 'package:fluttertoast/fluttertoast.dart';
import 'package:get/get.dart';

import 'package:villas_qatar/Core/constants/app_colors.dart';
import 'package:villas_qatar/Core/services/storage_service.dart';

import 'package:villas_qatar/modules/PlansandFeatures/model/featured_property_model.dart';
import 'package:villas_qatar/modules/PlansandFeatures/services/featured_properties_controller.dart';

import 'package:villas_qatar/modules/home/widgets/property_card.dart';

import 'package:villas_qatar/modules/propertydetailscreen/widget/agent_conatct_card.dart';
import 'package:villas_qatar/modules/propertydetailscreen/widget/boost_plan_bottomsheet.dart';
import 'package:villas_qatar/modules/propertydetailscreen/widget/bottom_actioncard.dart';
import 'package:villas_qatar/modules/propertydetailscreen/widget/herocard.dart';
import 'package:villas_qatar/modules/propertydetailscreen/widget/property_details_card.dart';
import 'package:villas_qatar/modules/propertydetailscreen/widget/property_info_card.dart';
import 'package:villas_qatar/modules/propertydetailscreen/widget/property_location_card.dart';
import 'package:villas_qatar/modules/propertydetailscreen/widget/overview_card.dart';
import 'package:villas_qatar/modules/propertylist/model/myproperty_model.dart';
import 'package:villas_qatar/modules/propertylist/service/myproperties_listcontroller.dart';

import 'package:villas_qatar/modules/searchscreen/service/searchlist_screen.dart';
import 'package:villas_qatar/modules/support/service/support_ticket_controller.dart';

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

            body:  Center(child: Text("Property not found".tr)),
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
                        onReport: () {
                          _showReportListingSheet(property);
                        },
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
                                    "Boost Property".tr,
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
                                            "Unable to load featured properties".tr,

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

                                            child:  Text("Retry".tr),
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
                                      "Featured Properties".tr,

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
                                                  "FEATURED PROPERTY ID IS EMPTY".tr,
                                                );
                                                return;
                                              }

                                             

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
        property.status?.toString().trim().toUpperCase() == "SOLD".tr;

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
                    isSold ? "Sold".tr : "Mark as Sold".tr,
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
        "Unable to Update".tr,
        "Property ID is missing..".tr,
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
                "Mark as Sold".tr,
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
                "Are you sure you want to mark this property as sold?".tr,
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
                        "This property will be updated as sold and will no longer be available as an active listing.".tr,
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
                          "Cancel".tr,
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
                              msg: "Property marked as sold successfully".tr,
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
                                  : "Unable to mark property as sold".tr,
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
                              "Mark as Sold".tr,
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
        "Unable to Boost".tr,
        "Property ID is missing.".tr,
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

Future<void> _showReportListingSheet(
  Property property,
) async {
  final String listingId =
      property.id?.toString().trim() ?? '';

  /// CURRENT LOGGED-IN USER ID
  final String reportedUserId =
      StorageService.getUserId().trim();

  debugPrint("========== REPORT LISTING ==========");
  debugPrint("LISTING ID: $listingId");
  debugPrint("REPORTED USER ID: $reportedUserId");

  if (listingId.isEmpty) {
    Get.snackbar(
      "Unable to report",
      "Property information is not available.",
      snackPosition: SnackPosition.BOTTOM,
    );
    return;
  }

  if (reportedUserId.isEmpty) {
    Get.snackbar(
      "Unable to report".tr,
      "Logged-in user information is not available.".tr,
      snackPosition: SnackPosition.BOTTOM,
    );
    return;
  }

  // Continue existing code...
  final SupportTicketController supportController =
      Get.isRegistered<SupportTicketController>()
          ? Get.find<SupportTicketController>()
          : Get.put(
              SupportTicketController(),
              permanent: false,
            );

  final TextEditingController detailsController =
      TextEditingController();

  String? selectedReason;
  bool isSubmitting = false;

  final List<String> reasons = [
    "Incorrect listing information".tr,
    "Misleading or fake listing".tr,
    "Property is no longer available".tr,
    "Inappropriate content".tr,
    "Suspected scam or fraud".tr,
    "Other".tr,
  ];

  bool reportSubmitted = false;
  String? submitError;

  await showModalBottomSheet<void>(
    context: context,
    isScrollControlled: true,
    useSafeArea: true,
    backgroundColor: Colors.transparent,
    barrierColor: Colors.black.withOpacity(.45),

    builder: (BuildContext sheetContext) {
      return StatefulBuilder(
        builder: (
          BuildContext context,
          StateSetter setSheetState,
        ) {
          final double keyboardHeight =
              MediaQuery.viewInsetsOf(context).bottom;

          return AnimatedPadding(
            duration:
                const Duration(milliseconds: 200),
            curve: Curves.easeOut,
            padding: EdgeInsets.only(
              bottom: keyboardHeight,
            ),
            child: Container(
              constraints: BoxConstraints(
                maxHeight:
                    MediaQuery.sizeOf(context)
                            .height *
                        .88,
              ),
              decoration: BoxDecoration(
                color: Colors.white,
                borderRadius:
                    BorderRadius.vertical(
                  top: Radius.circular(22.r),
                ),
              ),

              child: Column(
                mainAxisSize: MainAxisSize.min,
                children: [
                  // ============================================
                  // HANDLE
                  // ============================================

                  SizedBox(height: 10.h),

                  Container(
                    width: 38.w,
                    height: 4.h,
                    decoration: BoxDecoration(
                      color:
                          const Color(0xFFD8D8D8),
                      borderRadius:
                          BorderRadius.circular(
                        20.r,
                      ),
                    ),
                  ),

                  // ============================================
                  // HEADER
                  // ============================================

                  Padding(
                    padding:
                        EdgeInsets.fromLTRB(
                      18.w,
                      12.h,
                      8.w,
                      10.h,
                    ),
                    child: Row(
                      children: [
                        Container(
                          width: 38.w,
                          height: 38.w,
                          decoration:
                              BoxDecoration(
                            color:
                                const Color(
                              0xFFFFF1F1,
                            ),
                            borderRadius:
                                BorderRadius
                                    .circular(
                              10.r,
                            ),
                          ),
                          child: Icon(
                            Icons.flag_outlined,
                            size: 20.sp,
                            color:
                                const Color(
                              0xFFD64545,
                            ),
                          ),
                        ),

                        SizedBox(width: 11.w),

                        Expanded(
                          child: Column(
                            crossAxisAlignment:
                                CrossAxisAlignment
                                    .start,
                            children: [
                              Text(
                                "Report listing".tr,
                                style: TextStyle(
                                  fontSize: 17.sp,
                                  fontWeight:
                                      FontWeight
                                          .w700,
                                  color:
                                      const Color(
                                    0xFF222222,
                                  ),
                                ),
                              ),

                              SizedBox(
                                height: 2.h,
                              ),

                              Text(
                                "Tell us what's wrong with this property.".tr,
                                style:
                                    TextStyle(
                                  fontSize:
                                      10.5.sp,
                                  color:
                                      const Color(
                                    0xFF777777,
                                  ),
                                ),
                              ),
                            ],
                          ),
                        ),

                        IconButton(
                          onPressed:
                              isSubmitting
                                  ? null
                                  : () {
                                      FocusManager
                                          .instance
                                          .primaryFocus
                                          ?.unfocus();

                                      Navigator.of(
                                        sheetContext,
                                      ).pop();
                                    },
                          icon: Icon(
                            Icons.close_rounded,
                            size: 22.sp,
                            color:
                                const Color(
                              0xFF555555,
                            ),
                          ),
                        ),
                      ],
                    ),
                  ),

                  Divider(
                    height: 1,
                    color:
                        Colors.grey.shade200,
                  ),

                  // ============================================
                  // CONTENT
                  // ============================================

                  Flexible(
                    child:
                        SingleChildScrollView(
                      keyboardDismissBehavior:
                          ScrollViewKeyboardDismissBehavior
                              .onDrag,

                      padding:
                          EdgeInsets.fromLTRB(
                        18.w,
                        16.h,
                        18.w,
                        16.h,
                      ),

                      child: Column(
                        crossAxisAlignment:
                            CrossAxisAlignment
                                .start,
                        children: [
                          Text(
                            "Why are you reporting this listing?".tr,
                            style: TextStyle(
                              fontSize: 13.sp,
                              fontWeight:
                                  FontWeight.w600,
                              color:
                                  const Color(
                                0xFF292929,
                              ),
                            ),
                          ),

                          SizedBox(height: 4.h),

                          Text(
                            "Choose the reason that best describes the issue.".tr,
                            style: TextStyle(
                              fontSize: 10.5.sp,
                              color:
                                  const Color(
                                0xFF888888,
                              ),
                            ),
                          ),

                          SizedBox(height: 14.h),

                          // ====================================
                          // REASONS
                          // ====================================

                          ...reasons.map(
                            (String reason) {
                              final bool
                                  isSelected =
                                  selectedReason ==
                                      reason;

                              return Padding(
                                padding:
                                    EdgeInsets.only(
                                  bottom: 8.h,
                                ),
                                child: InkWell(
                                  onTap:
                                      isSubmitting
                                          ? null
                                          : () {
                                              setSheetState(
                                                () {
                                                  selectedReason =
                                                      reason;
                                                },
                                              );
                                            },
                                  borderRadius:
                                      BorderRadius
                                          .circular(
                                    10.r,
                                  ),
                                  child:
                                      AnimatedContainer(
                                    duration:
                                        const Duration(
                                      milliseconds:
                                          150,
                                    ),
                                    width:
                                        double.infinity,
                                    padding:
                                        EdgeInsets
                                            .symmetric(
                                      horizontal:
                                          13.w,
                                      vertical:
                                          11.h,
                                    ),
                                    decoration:
                                        BoxDecoration(
                                      color:
                                          isSelected
                                              ? AppColors
                                                  .primary
                                                  .withOpacity(
                                                    .05,
                                                  )
                                              : Colors
                                                  .white,
                                      borderRadius:
                                          BorderRadius
                                              .circular(
                                        10.r,
                                      ),
                                      border:
                                          Border.all(
                                        color:
                                            isSelected
                                                ? AppColors
                                                    .primary
                                                : const Color(
                                                    0xFFE5E5E5,
                                                  ),
                                        width:
                                            isSelected
                                                ? 1.2
                                                : 1,
                                      ),
                                    ),
                                    child: Row(
                                      children: [
                                        Expanded(
                                          child: Text(
                                            reason,
                                            style:
                                                TextStyle(
                                              fontSize:
                                                  11.5.sp,
                                              fontWeight:
                                                  isSelected
                                                      ? FontWeight.w600
                                                      : FontWeight.w500,
                                              color:
                                                  const Color(
                                                0xFF333333,
                                              ),
                                            ),
                                          ),
                                        ),

                                        SizedBox(
                                          width: 10.w,
                                        ),

                                        Icon(
                                          isSelected
                                              ? Icons
                                                  .radio_button_checked
                                              : Icons
                                                  .radio_button_off,
                                          size: 20.sp,
                                          color:
                                              isSelected
                                                  ? AppColors.primary
                                                  : Colors.grey.shade400,
                                        ),
                                      ],
                                    ),
                                  ),
                                ),
                              );
                            },
                          ),

                          SizedBox(height: 10.h),

                          // ====================================
                          // ADDITIONAL DETAILS
                          // ====================================

                          Row(
                            children: [
                              Text(
                                "Additional details".tr,
                                style:
                                    TextStyle(
                                  fontSize: 13.sp,
                                  fontWeight:
                                      FontWeight
                                          .w600,
                                  color:
                                      const Color(
                                    0xFF292929,
                                  ),
                                ),
                              ),

                              SizedBox(width: 5.w),

                              Text(
                                "(Optional)".tr,
                                style:
                                    TextStyle(
                                  fontSize: 10.sp,
                                  color: Colors
                                      .grey
                                      .shade500,
                                ),
                              ),
                            ],
                          ),

                          SizedBox(height: 8.h),

                          // ====================================
                          // TEXT FIELD
                          //
                          // NO CUSTOM FOCUS NODE
                          // ====================================

                          TextField(
                            controller:
                                detailsController,

                            enabled:
                                !isSubmitting,

                            minLines: 3,
                            maxLines: 5,
                            maxLength: 500,

                            textCapitalization:
                                TextCapitalization
                                    .sentences,

                            keyboardType:
                                TextInputType
                                    .multiline,

                            textInputAction:
                                TextInputAction
                                    .newline,

                            decoration:
                                InputDecoration(
                              hintText:
                                  "Provide additional information that may help us review this listing.".tr,

                              hintStyle:
                                  TextStyle(
                                fontSize:
                                    10.5.sp,
                                height: 1.4,
                                color: Colors
                                    .grey
                                    .shade500,
                              ),

                              filled: true,

                              fillColor:
                                  const Color(
                                0xFFFAFAFA,
                              ),

                              counterStyle:
                                  TextStyle(
                                fontSize: 9.sp,
                                color: Colors
                                    .grey
                                    .shade500,
                              ),

                              contentPadding:
                                  EdgeInsets.all(
                                13.w,
                              ),

                              enabledBorder:
                                  OutlineInputBorder(
                                borderRadius:
                                    BorderRadius
                                        .circular(
                                  10.r,
                                ),
                                borderSide:
                                    const BorderSide(
                                  color: Color(
                                    0xFFE5E5E5,
                                  ),
                                ),
                              ),

                              focusedBorder:
                                  OutlineInputBorder(
                                borderRadius:
                                    BorderRadius
                                        .circular(
                                  10.r,
                                ),
                                borderSide:
                                    BorderSide(
                                  color: AppColors
                                      .primary,
                                  width: 1.2,
                                ),
                              ),

                              disabledBorder:
                                  OutlineInputBorder(
                                borderRadius:
                                    BorderRadius
                                        .circular(
                                  10.r,
                                ),
                                borderSide:
                                    const BorderSide(
                                  color: Color(
                                    0xFFE5E5E5,
                                  ),
                                ),
                              ),
                            ),
                          ),

                          SizedBox(height: 8.h),

                          // ====================================
                          // INFO
                          // ====================================

                          Container(
                            width:
                                double.infinity,
                            padding:
                                EdgeInsets.all(
                              11.w,
                            ),
                            decoration:
                                BoxDecoration(
                              color:
                                  const Color(
                                0xFFF7F7F7,
                              ),
                              borderRadius:
                                  BorderRadius
                                      .circular(
                                9.r,
                              ),
                            ),
                            child: Row(
                              crossAxisAlignment:
                                  CrossAxisAlignment
                                      .start,
                              children: [
                                Icon(
                                  Icons
                                      .info_outline_rounded,
                                  size: 16.sp,
                                  color:
                                      const Color(
                                    0xFF777777,
                                  ),
                                ),

                                SizedBox(
                                  width: 8.w,
                                ),

                                Expanded(
                                  child: Text(
                                    "Reports are reviewed by our support team.".tr,
                                    style:
                                        TextStyle(
                                      fontSize:
                                          9.5.sp,
                                      height: 1.45,
                                      color:
                                          const Color(
                                        0xFF777777,
                                      ),
                                    ),
                                  ),
                                ),
                              ],
                            ),
                          ),
                        ],
                      ),
                    ),
                  ),

                  // ============================================
                  // SUBMIT BUTTON
                  // ============================================

                  Container(
                    width: double.infinity,
                    padding:
                        EdgeInsets.fromLTRB(
                      18.w,
                      11.h,
                      18.w,
                      12.h,
                    ),
                    decoration: BoxDecoration(
                      color: Colors.white,
                      border: Border(
                        top: BorderSide(
                          color: Colors
                              .grey.shade200,
                        ),
                      ),
                    ),
                    child: SizedBox(
                      width: double.infinity,
                      height: 46.h,
                      child: ElevatedButton(
                        onPressed:
                            selectedReason ==
                                        null ||
                                    isSubmitting
                                ? null
                                : () async {
                                    // ==========================
                                    // REMOVE KEYBOARD
                                    // ==========================

                                    FocusManager
                                        .instance
                                        .primaryFocus
                                        ?.unfocus();

                                    final String
                                        subject =
                                        selectedReason!;

                                    final String
                                        details =
                                        detailsController
                                            .text
                                            .trim();

                                    final String
                                        message =
                                        details
                                                .isNotEmpty
                                            ? details
                                            : subject;

                                    setSheetState(
                                      () {
                                        isSubmitting =
                                            true;
                                      },
                                    );

                                    try {
                                      final result =
                                          await supportController
                                              .createTicket(
                                        category:
                                            SupportCategory
                                                .reportListing,
                                        subject:
                                            subject,
                                        message:
                                            message,
                                        listingId:
                                            listingId,
                                            reportedUserId: reportedUserId,
                                      );

                                      if (!sheetContext
                                          .mounted) {
                                        return;
                                      }

                                      if (result !=
                                          null) {
                                        reportSubmitted =
                                            true;

                                        Navigator.of(
                                          sheetContext,
                                        ).pop();

                                        return;
                                      }

                                      submitError =
                                          supportController
                                                  .createError
                                                  .isNotEmpty
                                              ? supportController
                                                  .createError
                                              : "Unable to submit report".tr;

                                      if (sheetContext
                                          .mounted) {
                                        setSheetState(
                                          () {
                                            isSubmitting =
                                                false;
                                          },
                                        );
                                      }
                                    } catch (e) {
                                      submitError =
                                          e
                                              .toString()
                                              .replaceFirst(
                                                'Exception: '.tr,
                                                '',
                                              );

                                      if (sheetContext
                                          .mounted) {
                                        setSheetState(
                                          () {
                                            isSubmitting =
                                                false;
                                          },
                                        );
                                      }
                                    }
                                  },

                        style:
                            ElevatedButton
                                .styleFrom(
                          backgroundColor:
                              AppColors.primary,

                          disabledBackgroundColor:
                              AppColors.primary
                                  .withOpacity(
                                    .35,
                                  ),

                          foregroundColor:
                              Colors.white,

                          disabledForegroundColor:
                              Colors.white,

                          elevation: 0,

                          shape:
                              RoundedRectangleBorder(
                            borderRadius:
                                BorderRadius
                                    .circular(
                              10.r,
                            ),
                          ),
                        ),

                        child: isSubmitting
                            ? SizedBox(
                                width: 20.w,
                                height: 20.w,
                                child:
                                    const CircularProgressIndicator(
                                  strokeWidth:
                                      2,
                                  color:
                                      Colors.white,
                                ),
                              )
                            : Text(
                                "Submit Report".tr,
                                style:
                                    TextStyle(
                                  fontSize:
                                      12.5.sp,
                                  fontWeight:
                                      FontWeight
                                          .w600,
                                ),
                              ),
                      ),
                    ),
                  ),
                ],
              ),
            ),
          );
        },
      );
    },
  );

  // ============================================================
  // IMPORTANT:
  // At this point bottom sheet is closed.
  //
  // Do NOT manually dispose a FocusNode because there isn't one.
  // ============================================================

  if (!mounted) {
    return;
  }

  // Give Flutter one frame to completely remove
  // the bottom-sheet route / keyboard dependencies.
  await Future<void>.delayed(
    const Duration(milliseconds: 150),
  );

  if (!mounted) {
    return;
  }

  if (reportSubmitted) {
    Get.snackbar(
      "Report submitted".tr,
      "Thank you. Our support team will review this listing.".tr,
      snackPosition: SnackPosition.BOTTOM,
      backgroundColor: Colors.green.shade700,
      colorText: Colors.white,
      margin: EdgeInsets.all(12.w),
      duration: const Duration(
        seconds: 3,
      ),
    );
  } else if (submitError != null &&
      submitError!.isNotEmpty) {
    Get.snackbar(
      "Unable to submit report".tr,
      submitError!,
      snackPosition: SnackPosition.BOTTOM,
      backgroundColor: Colors.red.shade700,
      colorText: Colors.white,
      margin: EdgeInsets.all(12.w),
    );
  }

  // Do not manually dispose the TextEditingController here.
  // It is local to this short-lived modal and avoiding disposal
  // prevents pending EditableText callbacks from accessing a
  // disposed controller during route teardown.
}

// ============================================================
// REPORT REASON TILE
// ============================================================

Widget _buildReportReason({
  required String title,
  required bool selected,
  required bool enabled,
  required VoidCallback onTap,
}) {
  return Material(
    color: Colors.transparent,
    child: InkWell(
      onTap: enabled ? onTap : null,
      borderRadius: BorderRadius.circular(10.r),
      child: AnimatedContainer(
        duration:
            const Duration(milliseconds: 150),
        width: double.infinity,
        padding: EdgeInsets.symmetric(
          horizontal: 13.w,
          vertical: 11.h,
        ),
        decoration: BoxDecoration(
          color: selected
              ? AppColors.primary.withOpacity(0.05)
              : Colors.white,
          borderRadius:
              BorderRadius.circular(10.r),
          border: Border.all(
            color: selected
                ? AppColors.primary
                : const Color(0xFFE5E5E5),
            width: selected ? 1.2 : 1,
          ),
        ),
        child: Row(
          children: [
            Expanded(
              child: Text(
                title,
                style: TextStyle(
                  fontSize: 11.5.sp,
                  fontWeight: selected
                      ? FontWeight.w600
                      : FontWeight.w500,
                  color:
                      const Color(0xFF333333),
                ),
              ),
            ),

            SizedBox(width: 10.w),

            Icon(
              selected
                  ? Icons.radio_button_checked
                  : Icons.radio_button_off,
              size: 20.sp,
              color: selected
                  ? AppColors.primary
                  : Colors.grey.shade400,
            ),
          ],
        ),
      ),
    ),
  );
}

// THIS closes _PropertyDetailsScreenState
}

