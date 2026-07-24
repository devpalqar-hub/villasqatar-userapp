import 'package:flutter/material.dart';
import 'package:flutter_screenutil/flutter_screenutil.dart';
import 'package:get/get.dart';
import 'package:get/get_core/src/get_main.dart';
import 'package:get/get_instance/src/extension_instance.dart';
import 'package:get/get_navigation/src/extension_navigation.dart';
import 'package:get/get_navigation/src/routes/transitions_type.dart';
import 'package:get/get_state_manager/src/simple/get_state.dart';
import 'package:villas_qatar/Core/constants/app_colors.dart';
import 'package:villas_qatar/modules/propertydetailscreen/propertydetailscreen.dart';
import 'package:villas_qatar/modules/propertylist/model/myproperty_model.dart';
import 'package:villas_qatar/modules/propertylist/service/myproperties_listcontroller.dart';
import 'package:villas_qatar/modules/propertylist/widgets/filter_bottomsheet.dart';
import 'package:villas_qatar/modules/searchscreen/service/searchlist_screen.dart';

import 'add_listproperty.dart';

class MyPropertiesScreen extends StatefulWidget {
  const MyPropertiesScreen({super.key});

  @override
  State<MyPropertiesScreen> createState() => _MyPropertiesScreenState();
}

class _MyPropertiesScreenState extends State<MyPropertiesScreen> {
  final MyPropertyController controller =
      Get.isRegistered<MyPropertyController>()
      ? Get.find<MyPropertyController>()
      : Get.put(MyPropertyController());
  final ScrollController scrollController = ScrollController();

  String activeFilter = "All";

  final searchCtrl = TextEditingController();

 

  @override
  void initState() {
    super.initState();

    controller.fetchProperties();

    scrollController.addListener(() {
      if (scrollController.position.pixels >=
              scrollController.position.maxScrollExtent - 200 &&
          !controller.isLoadingMore &&
          controller.hasMore) {
        controller.fetchProperties(loadMore: true);
      }
    });

    searchCtrl.addListener(() {
      setState(() {});
    });
  }

  @override
  void dispose() {
    searchCtrl.dispose();
    scrollController.dispose();
    super.dispose();
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      backgroundColor: AppColors.background,

      body: GetBuilder<MyPropertyController>(
        builder: (controller) {
          if (controller.isLoading) {
            return const Center(child: CircularProgressIndicator());
          }

          List<Property> listings = List.from(controller.properties);

          if (searchCtrl.text.trim().isNotEmpty) {
            final q = searchCtrl.text.trim().toLowerCase();

            listings = listings.where((e) {
              return e.propertyName.toLowerCase().contains(q) ||
                  e.areaName.toLowerCase().contains(q);
            }).toList();
          }

          /// FILTER

          if (activeFilter != "All".tr) {
            listings = listings.where((e) {
              return e.status.toLowerCase() == activeFilter.toLowerCase();
            }).toList();
          }

          return SafeArea(
            child: Column(
              children: [
                _buildTopBar(),

                _buildSearchBar(),

                const SizedBox(height: 4),

                Expanded(
                  child: listings.isEmpty
                      ? _buildEmptyState()
                      : RefreshIndicator(
                          onRefresh: controller.refreshProperties,

                          child: listings.isEmpty
                              ? ListView(
                                  physics:
                                      const AlwaysScrollableScrollPhysics(),
                                  children: const [
                                    SizedBox(height: 120),
                                    _EmptyState(),
                                  ],
                                )
                              : ListView.separated(
                                  controller: scrollController,
                                  physics:
                                      const AlwaysScrollableScrollPhysics(),

                                  padding: const EdgeInsets.fromLTRB(
                                    20,
                                    8,
                                    20,
                                    90,
                                  ),

                                  itemCount:
                                      listings.length +
                                      (controller.hasMore ? 1 : 0),

                                  separatorBuilder: (_, __) =>
                                      const SizedBox(height: 14),

                                  itemBuilder: (context, index) {
                                    if (index == listings.length) {
                                      return const Padding(
                                        padding: EdgeInsets.all(20),
                                        child: Center(
                                          child: CircularProgressIndicator(),
                                        ),
                                      );
                                    }

                                    return _PropertyCard(
                                      listing: listings[index],
                                      onTap: () async {
                                        final searchController = Get.put(
                                          PropertySearchController(),
                                        );

                                        await searchController
                                            .fetchPropertyDetails(
                                              listings[index].id,
                                            );

                                        Get.to(
                                          () => const PropertyDetailsScreen(),
                                          transition: Transition.rightToLeft,
                                        );
                                      },
                                    );
                                  },
                                ),
                        ),
                ),
              ],
            ),
          );
        },
      ),

      floatingActionButton: FloatingActionButton.extended(
        onPressed: () {
          Get.to(
            () => const ListYourPropertyScreen(),
            transition: Transition.rightToLeft,
            duration: const Duration(milliseconds: 850),
            curve: Curves.easeOutCubic,
          );
        },

        backgroundColor: AppColors.primary,

        icon: const Icon(Icons.add, color: Colors.white),

        label:  Text(
          "List Property".tr,
          style: TextStyle(fontWeight: FontWeight.w700, color: Colors.white),
        ),
      ),
    );
  }

  // ---------------------------------------------------------
  // TOP BAR — matches the form screens (back arrow, centered
  // title, maroon accent action on the right)
  // ---------------------------------------------------------
  Widget _buildTopBar() {
    return Padding(
      padding: const EdgeInsets.fromLTRB(12, 8, 16, 8),
      child: Row(
        children: [
          IconButton(
            icon: const Icon(Icons.arrow_back, color: AppColors.primary),
            onPressed: () {},
          ),
           Expanded(
            child: Text(
              "My Properties".tr,
              textAlign: TextAlign.center,
              style: TextStyle(
                fontSize: 18,
                fontWeight: FontWeight.w700,
                color: Colors.black87,
              ),
            ),
          ),
          IconButton(
            icon: const Icon(Icons.tune, color: AppColors.primary),
            onPressed: () {
              showFilterBottomSheet(context);
            },
          ),
        ],
      ),
    );
  }

  // ---------------------------------------------------------
  // SEARCH BAR — same field styling as the form's text fields
  // ---------------------------------------------------------
  Widget _buildSearchBar() {
    return Padding(
      padding: const EdgeInsets.fromLTRB(20, 4, 20, 12),
      child: Container(
        height: 42, // Reduce height (try 40-44)
        decoration: BoxDecoration(
          color: AppColors.fieldBg,
          borderRadius: BorderRadius.circular(50.r),
          border: Border.all(color: AppColors.fieldBorder),
        ),
        child: TextField(
          controller: searchCtrl,
          onChanged: (_) => setState(() {}),
          style:  TextStyle(fontSize: 12, color: Colors.black87),
          decoration:  InputDecoration(
            hintText: 'Search by property name or location'.tr,
            hintStyle: TextStyle(color: AppColors.hintGrey, fontSize: 12),
            prefixIcon: Icon(Icons.search, color: AppColors.hintGrey, size: 18),
            border: InputBorder.none,
            isDense: true,
            contentPadding: EdgeInsets.symmetric(horizontal: 12, vertical: 10),
          ),
        ),
      ),
    );
  }

  Widget _buildEmptyState() {
    return Center(
      child: Padding(
        padding: const EdgeInsets.all(32),
        child: Column(
          mainAxisSize: MainAxisSize.min,
          children: [
            Container(
              width: 72,
              height: 72,
              decoration: const BoxDecoration(
                color: AppColors.pinkBg,
                shape: BoxShape.circle,
              ),
              child: const Icon(
                Icons.home_work_outlined,
                color: AppColors.primary,
                size: 32,
              ),
            ),
            const SizedBox(height: 16),
             Text(
              'No properties found'.tr,
              style: TextStyle(fontWeight: FontWeight.w700, fontSize: 15),
            ),
            const SizedBox(height: 6),
             Text(
              'Try a different search or filter, or list a new property'.tr,
              textAlign: TextAlign.center,
              style: TextStyle(color: AppColors.hintGrey, fontSize: 12.5),
            ),
          ],
        ),
      ),
    );
  }
}

// =================================================================
// PROPERTY CARD
// =================================================================

class _PropertyCard extends StatelessWidget {
  final Property listing;
  final VoidCallback onTap;

  const _PropertyCard({required this.listing, required this.onTap});

  @override
  Widget build(BuildContext context) {
    return InkWell(
      borderRadius: BorderRadius.circular(10.r),
      onTap: onTap,
      child: Container(
        decoration: BoxDecoration(
          color: AppColors.cardBg,
          borderRadius: BorderRadius.circular(10.r),
          border: Border.all(color: AppColors.fieldBorder),
        ),
        padding: EdgeInsets.symmetric(horizontal: 14.w, vertical: 8.h),
        child: Column(
          crossAxisAlignment: CrossAxisAlignment.start,
          children: [
            Row(
              crossAxisAlignment: CrossAxisAlignment.start,
              children: [
                _buildThumbnail(),
                const SizedBox(width: 12),
                Expanded(child: _buildInfo()),
              ],
            ),
            SizedBox(height: 10.h),
            Divider(height: 1, color: AppColors.fieldBorder),
            SizedBox(height: 5.h),
            _buildFooter(),
          ],
        ),
      ),
    );
  }

  Widget _buildThumbnail() {
    return Stack(
      children: [
        ClipRRect(
          borderRadius: BorderRadius.circular(12),
          child: listing.photos.isNotEmpty
              ? Image.network(
                  listing.photos.first.url,
                  width: 80.w,
                  height: 80.h,
                  fit: BoxFit.cover,
                  errorBuilder: (_, __, ___) {
                    return _placeholder();
                  },
                )
              : _placeholder(),
        ),

        Positioned(
          left: 6,
          bottom: 6,
          child: Container(
            padding: const EdgeInsets.symmetric(horizontal: 6, vertical: 2),
            decoration: BoxDecoration(
              color: Colors.black54,
              borderRadius: BorderRadius.circular(6),
            ),
            child: Row(
              mainAxisSize: MainAxisSize.min,
              children: [
                const Icon(Icons.photo_camera, size: 10, color: Colors.white),
                const SizedBox(width: 3),
                Text(
                  "${listing.photos.length}",
                  style: TextStyle(color: Colors.white, fontSize: 8.sp),
                ),
              ],
            ),
          ),
        ),
      ],
    );
  }

  Widget _placeholder() {
    return Container(
      width: 80.w,
      height: 80.h,
      decoration: BoxDecoration(
        color: Colors.grey.shade300,
        borderRadius: BorderRadius.circular(12),
      ),
      child: const Icon(Icons.home, color: Colors.white),
    );
  }

  Widget _buildInfo() {
    return Column(
      crossAxisAlignment: CrossAxisAlignment.start,
      children: [
        Row(
          children: [
            Expanded(
              child: Text(
                listing.propertyName,
                maxLines: 1,
                overflow: TextOverflow.ellipsis,
                style: TextStyle(
                  fontWeight: FontWeight.w700,
                  fontSize: 12.sp,
                  color: Colors.black87,
                ),
              ),
            ),
            _StatusBadge(status: listing.status),
          ],
        ),

        const SizedBox(height: 4),

        Row(
          children: [
            const Icon(
              Icons.location_on_outlined,
              size: 13,
              color: AppColors.hintGrey,
            ),
            const SizedBox(width: 3),
            Expanded(
              child: Text(
                "${listing.areaName}, ${listing.municipality}",
                maxLines: 1,
                overflow: TextOverflow.ellipsis,
                style: const TextStyle(color: AppColors.hintGrey, fontSize: 10),
              ),
            ),
          ],
        ),

        const SizedBox(height: 8),

        Text(
          "QAR ${_formatPrice(listing.price)}"
          "${listing.purpose == "RENT" ? " / month" : ""}",
          style: const TextStyle(
            fontWeight: FontWeight.w800,
            fontSize: 15,
            color: AppColors.primary,
          ),
        ),
      ],
    );
  }

  Widget _buildFooter() {
    return Row(
      children: [
        if (listing.bedrooms > 0) ...[
          _statIcon(Icons.bed_outlined, "${listing.bedrooms} Beds"),
          const SizedBox(width: 16),
        ],

        _statIcon(Icons.bathtub_outlined, "${listing.bathrooms} Baths"),

        const SizedBox(width: 16),

        _statIcon(Icons.square_foot_outlined, "${listing.area.toInt()} sqft"),

        const Spacer(),
      ],
    );
  }

  Widget _statIcon(IconData icon, String label) {
    return Row(
      children: [
        Icon(icon, size: 15, color: AppColors.labelGrey),
        const SizedBox(width: 4),
        Text(
          label,
          style: const TextStyle(fontSize: 11.5, color: AppColors.labelGrey),
        ),
      ],
    );
  }

  String _formatPrice(num price) {
    return price
        .toStringAsFixed(0)
        .replaceAllMapped(RegExp(r'\B(?=(\d{3})+(?!\d))'), (match) => ",");
  }
}

// =================================================================
// STATUS BADGE (Active / Draft / Sold) — same pill language as
// the WhatsApp Verified banner (colored bg + colored text)
// =================================================================
class _StatusBadge extends StatelessWidget {
  final String status;

  const _StatusBadge({required this.status});

  @override
  Widget build(BuildContext context) {
    Color bg;
    Color fg;

    switch (status.toUpperCase()) {
      case "ACTIVE":
        bg = AppColors.greenBg;
        fg = AppColors.greenText;
        break;

      case "PENDING":
        bg = Colors.grey.shade100;
        fg = Colors.grey;
        break;

      case "INACTIVE":
        bg = AppColors.pinkChipBg;
        fg = AppColors.primary;
        break;

      default:
        bg = Colors.orange.shade100;
        fg = Colors.orange;
    }

    return Container(
      padding: const EdgeInsets.symmetric(horizontal: 8, vertical: 3),
      decoration: BoxDecoration(
        color: bg,
        borderRadius: BorderRadius.circular(6),
      ),
      child: Text(
        status,
        style: TextStyle(fontSize: 10, fontWeight: FontWeight.w700, color: fg),
      ),
    );
  }
}

// =================================================================
// FOR SALE / FOR RENT TAG
// =================================================================
class _ForTag extends StatelessWidget {
  final Property property;

  const _ForTag({super.key, required this.property});

  @override
  Widget build(BuildContext context) {
    final bool isSale = property.purpose.toUpperCase() == "SALE";

    return Container(
      padding: const EdgeInsets.symmetric(horizontal: 8, vertical: 3),
      decoration: BoxDecoration(
        color: AppColors.pinkBg,
        borderRadius: BorderRadius.circular(6),
      ),
      child: Row(
        mainAxisSize: MainAxisSize.min,
        children: [
          Icon(
            isSale ? Icons.sell_outlined : Icons.vpn_key_outlined,
            size: 11,
            color: AppColors.primary,
          ),
          const SizedBox(width: 3),
          Text(
            isSale ? "For Sale".tr : "For Rent".tr,
            style: const TextStyle(
              fontSize: 10.5,
              fontWeight: FontWeight.w700,
              color: AppColors.primary,
            ),
          ),
        ],
      ),
    );
  }
}

class _EmptyState extends StatelessWidget {
  const _EmptyState({super.key});

  @override
  Widget build(BuildContext context) {
    return Center(
      child: Padding(
        padding: const EdgeInsets.all(32),
        child: Column(
          mainAxisSize: MainAxisSize.min,
          children: [
            // your existing empty state UI
          ],
        ),
      ),
    );
  }
}
