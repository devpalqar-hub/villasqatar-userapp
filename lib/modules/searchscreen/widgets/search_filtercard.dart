import 'package:flutter/material.dart';
import 'package:flutter_screenutil/flutter_screenutil.dart';
import 'package:get/get_core/src/get_main.dart';
import 'package:get/get_instance/src/extension_instance.dart';
import 'package:get/get_state_manager/src/simple/get_state.dart';
import 'package:get/get_utils/src/extensions/internacionalization.dart';
import 'package:villas_qatar/Core/constants/app_colors.dart';
import 'package:villas_qatar/Core/theme/app_textstyles.dart';
import 'package:villas_qatar/Core/widgets/primary_button.dart';
import 'package:villas_qatar/modules/propertylist/service/listproperty_controller.dart';
import 'package:villas_qatar/modules/searchscreen/service/searchlist_screen.dart';

class SearchFilterCard extends StatefulWidget {
  final PropertySearchController controller;

  const SearchFilterCard({super.key, required this.controller});

  @override
  State<SearchFilterCard> createState() => _SearchFilterCardState();
}

class _SearchFilterCardState extends State<SearchFilterCard> {
  final ListPropertyController controller = Get.put(ListPropertyController());

  final List<String> tabs = ["Buy".tr, "Rent".tr];

  String selectedPropertyType = "Property Type";
  String selectedPrice = "Price Range";

  final List<String> propertyTypes = [
    "Property Type",
    "VILLA",
    "APARTMENT",
    "TOWNHOUSE",
    "PENTHOUSE",
    "STUDIO",
    "COMMERCIAL",
    "LAND",
  ];
  final List<String> priceRanges = [
    "Price Range",

    "10000",
    "50000",
    "100000",
    "500000",
    "1000000",
  ];

  @override
  Widget build(BuildContext context) {
    final int selectedTab = widget.controller.purpose == "RENT" ? 1 : 0;
    return Container(
      width: double.infinity,
      padding: EdgeInsets.only(top: 5.h, left: 16.w, right: 16.w, bottom: 5.h),
      decoration: BoxDecoration(
        color: Colors.white,
        borderRadius: BorderRadius.circular(10.r),
        boxShadow: [
          BoxShadow(
            color: Colors.black.withOpacity(.06),
            blurRadius: 20,
            offset: const Offset(0, 10),
          ),
        ],
      ),
      child: Column(
        children: [
          /// BUY RENT PG TABS
          SizedBox(
            height: 35.h,
            child: Row(
              children: List.generate(tabs.length, (index) {
                final selected = selectedTab == index;
                return Expanded(
                  child: InkWell(
                    borderRadius: BorderRadius.circular(8.r),
                    onTap: () {
                      widget.controller.purpose = index == 0 ? "SALE" : "RENT";

                      widget.controller.update();
                    },
                    child: Column(
                      mainAxisAlignment: MainAxisAlignment.spaceBetween,
                      children: [
                        Expanded(
                          child: Center(
                            child: Text(
                              tabs[index],
                              style: AppTextStyles.title16.copyWith(
                                fontSize: 14.sp,
                                fontWeight: selected
                                    ? FontWeight.w700
                                    : FontWeight.w600,
                                color: selected
                                    ? AppColors.primary
                                    : const Color(0xff32354A),
                              ),
                            ),
                          ),
                        ),

                        AnimatedContainer(
                          duration: const Duration(milliseconds: 250),
                          height: 1.5.h,
                          width: selected ? 72.w : 0,
                          decoration: BoxDecoration(
                            color: AppColors.primary,
                            borderRadius: BorderRadius.circular(50),
                          ),
                        ),
                      ],
                    ),
                  ),
                );
              }),
            ),
          ),

          SizedBox(height: 2.h),

          Divider(color: const Color(0xffECECEC), thickness: 1, height: 1),

          SizedBox(height: 12.h),

          Row(
            children: [
              /// Search Field
              Expanded(
                child: Container(
                  height: 45.h,
                  padding: EdgeInsets.symmetric(horizontal: 16.w),
                  decoration: BoxDecoration(
                    color: const Color(0xffF8F9FB),
                    borderRadius: BorderRadius.circular(5.r),
                    border: Border.all(
                      color: const Color(0xffE6E9EF),
                      width: 1,
                    ),
                  ),
                  child: Row(
                    children: [
                      Icon(
                        Icons.search,
                        size: 18.sp,
                        color: const Color(0xff8E95A4),
                      ),

                      SizedBox(width: 12.w),
                      Expanded(
                        child: TextField(
                          controller: widget.controller.searchTextController,

                          textInputAction: TextInputAction.search,

                          // Don't update API search state while typing.
                          // Search should be applied only when submitted
                          // or Search Properties button is pressed.
                          onChanged: (_) {
                            setState(() {});
                          },

                          onSubmitted: (value) async {
                            final query = value.trim();

                            if (query.isEmpty) {
                              FocusScope.of(context).unfocus();
                              return;
                            }

                            // Close keyboard first
                            FocusScope.of(context).unfocus();

                            // Search using entered text
                            await widget.controller.applyFilters(
                              search: query,
                              type: widget.controller.type,
                              purpose: widget.controller.purpose,
                              furnishingStatus:
                                  widget.controller.furnishingStatus,
                              nearbyTag: widget.controller.nearbyTag,
                              minPrice: widget.controller.minPrice,
                              maxPrice: widget.controller.maxPrice,
                              minBedrooms: widget.controller.minBedrooms,
                              minBathrooms: widget.controller.minBathrooms,
                              minArea: widget.controller.minArea,
                              maxArea: widget.controller.maxArea,
                            );

                            if (!mounted) return;

                            FocusManager.instance.primaryFocus?.unfocus();

                            setState(() {});

                            widget.controller.update();
                          },

                          style: AppTextStyles.body14.copyWith(
                            color: const Color(0xff32354A),
                          ),

                          decoration: InputDecoration(
                            isDense: true,
                            isCollapsed: true,

                            border: InputBorder.none,
                            enabledBorder: InputBorder.none,
                            focusedBorder: InputBorder.none,

                            contentPadding: EdgeInsets.zero,

                            hintText: "Search by location or property".tr,

                            hintStyle: AppTextStyles.body13.copyWith(
                              color: const Color(0xffA5ADBA),
                            ),

                            suffixIcon:
                                widget
                                    .controller
                                    .searchTextController
                                    .text
                                    .isNotEmpty
                                ? IconButton(
                                    icon: const Icon(Icons.close, size: 18),
                                    onPressed: () async {
                                      FocusScope.of(context).unfocus();

                                      // 1. Clear text from TextField
                                      widget.controller.searchTextController
                                          .clear();

                                      // 2. Clear stored search value
                                      widget.controller.search = "";

                                      setState(() {});

                                      // 3. Call API again without search
                                      await widget.controller.applyFilters(
                                        search: "",
                                        type: widget.controller.type,
                                        purpose: widget.controller.purpose,
                                        furnishingStatus:
                                            widget.controller.furnishingStatus,
                                        nearbyTag: widget.controller.nearbyTag,
                                        minPrice: widget.controller.minPrice,
                                        maxPrice: widget.controller.maxPrice,
                                        minBedrooms:
                                            widget.controller.minBedrooms,
                                        minBathrooms:
                                            widget.controller.minBathrooms,
                                        minArea: widget.controller.minArea,
                                        maxArea: widget.controller.maxArea,
                                      );

                                      widget.controller.update();
                                    },
                                  )
                                : null,
                          ),
                        ),
                      ),
                    ],
                  ),
                ),
              ),

              /// Current Location Button
              InkWell(
                borderRadius: BorderRadius.circular(8.r),
                onTap: () {},
                child: Container(
                  width: 45.w,
                  height: 45.h,
                  decoration: BoxDecoration(
                    color: const Color(0xffF8F9FB),
                    borderRadius: BorderRadius.circular(5.r),
                    border: Border.all(
                      color: const Color(0xffE6E9EF),
                      width: 1,
                    ),
                  ),
                  child: Icon(
                    Icons.my_location_rounded,
                    color: Colors.black,
                    size: 22.sp,
                  ),
                ),
              ),
            ],
          ),

          SizedBox(height: 12.h),

          Row(
            children: [
              /// Property Type
              Expanded(
                child: Container(
                  height: 42.h,
                  padding: EdgeInsets.symmetric(horizontal: 10.w),
                  decoration: BoxDecoration(
                    color: const Color(0xffF8F9FB),
                    borderRadius: BorderRadius.circular(5.r),
                    border: Border.all(color: const Color(0xffE6E9EF)),
                  ),
                  child: DropdownButtonHideUnderline(
                    child: DropdownButton<String>(
                      value: selectedPrice,
                      underline: SizedBox(),
                      isExpanded: true,
                      items: priceRanges
                          .map(
                            (e) => DropdownMenuItem(
                              value: e,
                              child: Text(
                                e == "Price Range" ? "Price Range".tr : "$e",

                                style: TextStyle(fontSize: 10.sp),
                              ),
                            ),
                          )
                          .toList(),
                      onChanged: (value) {
                        if (value == null) return;

                        setState(() {
                          selectedPrice = value;
                        });

                        widget.controller.minPrice = value == "Price Range"
                            ? null
                            : double.parse(value);
                      },
                    ),
                  ),
                ),
              ),

              SizedBox(width: 10.w),

              /// Price Range
              Expanded(
                child: Container(
                  height: 42.h,
                  padding: EdgeInsets.symmetric(horizontal: 10.w),
                  decoration: BoxDecoration(
                    color: const Color(0xffF8F9FB),
                    borderRadius: BorderRadius.circular(5.r),
                    border: Border.all(color: const Color(0xffE6E9EF)),
                  ),
                  child: DropdownButtonHideUnderline(
                    child: DropdownButton<String>(
                      value: selectedPropertyType,
                      isExpanded: true,
                      underline: const SizedBox(),
                      items: propertyTypes
                          .map(
                            (e) => DropdownMenuItem(
                              value: e,
                              child: Text(
                                e == "Property Type" ? "Property Type".tr : e,
                                style: TextStyle(fontSize: 10.sp),
                              ),
                            ),
                          )
                          .toList(),
                      onChanged: (value) {
                        if (value == null) return;

                        setState(() {
                          selectedPropertyType = value;
                        });

                        widget.controller.type = value == "Property Type"
                            ? ""
                            : value;
                      },
                    ),
                  ),
                ),
              ),

              SizedBox(width: 10.w),

              /// Filters Button
              InkWell(
                onTap: _showFilterBottomSheet,
                borderRadius: BorderRadius.circular(8.r),
                child: Container(
                  height: 42.h,
                  padding: EdgeInsets.symmetric(horizontal: 12.w),
                  decoration: BoxDecoration(
                    color: const Color(0xffF8F9FB),
                    borderRadius: BorderRadius.circular(5.r),
                    border: Border.all(color: const Color(0xffE6E9EF)),
                  ),
                  child: Row(
                    mainAxisSize: MainAxisSize.min,
                    children: [
                      Stack(
                        clipBehavior: Clip.none,
                        children: [
                          Icon(
                            Icons.tune_rounded,
                            color: AppColors.primary,
                            size: 20.sp,
                          ),
                          Positioned(
                            right: -2,
                            top: -2,
                            child: Container(
                              width: 7.w,
                              height: 7.w,
                              decoration: const BoxDecoration(
                                color: Colors.red,
                                shape: BoxShape.circle,
                              ),
                            ),
                          ),
                        ],
                      ),

                      SizedBox(width: 6.w),

                      Text(
                        "Filters".tr,
                        style: AppTextStyles.body13.copyWith(
                          fontSize: 11.sp,
                          fontWeight: FontWeight.w600,
                          color: const Color(0xff32354A),
                        ),
                      ),
                    ],
                  ),
                ),
              ),
            ],
          ),

          SizedBox(height: 15.h),

          SizedBox(
            width: double.infinity,
            height: 50.h,
            child: ElevatedButton(
              onPressed: () async {
                widget.controller.applyFilters(
                  search: widget.controller.searchTextController.text.trim(),
                  type: widget.controller.type,
                  purpose: widget.controller.purpose,
                  furnishingStatus: widget.controller.furnishingStatus,
                  nearbyTag: widget.controller.nearbyTag,
                  minPrice: widget.controller.minPrice,
                  maxPrice: widget.controller.maxPrice,
                  minBedrooms: widget.controller.minBedrooms,
                  minBathrooms: widget.controller.minBathrooms,
                  minArea: widget.controller.minArea,
                  maxArea: widget.controller.maxArea,
                );

                setState(() {
                  selectedPropertyType = "Property Type";
                  selectedPrice = "Price Range";
                });
              },
              style: ElevatedButton.styleFrom(
                elevation: 0,
                backgroundColor: AppColors.primary,
                shape: RoundedRectangleBorder(
                  borderRadius: BorderRadius.circular(6.r),
                ),
              ),
              child: Row(
                mainAxisAlignment: MainAxisAlignment.center,
                children: [
                  Icon(Icons.search_rounded, color: Colors.white, size: 20.sp),

                  SizedBox(width: 10.w),

                  Text(
                    "Search Properties".tr,
                    style: AppTextStyles.title16.copyWith(
                      color: Colors.white,
                      fontWeight: FontWeight.w700,
                      fontSize: 15.sp,
                    ),
                  ),
                ],
              ),
            ),
          ),

          SizedBox(height: 10.h),
        ],
      ),
    );
  }

  void _showFilterBottomSheet() {
    showModalBottomSheet(
      context: context,
      isScrollControlled: true,
      backgroundColor: Colors.white,
      shape: const RoundedRectangleBorder(
        borderRadius: BorderRadius.vertical(top: Radius.circular(22)),
      ),
      builder: (_) {
        return FilterBottomSheet(controller: widget.controller);
      },
    );
  }
}

class FilterBottomSheet extends StatefulWidget {
  final PropertySearchController controller;

  const FilterBottomSheet({super.key, required this.controller});

  @override
  State<FilterBottomSheet> createState() => _FilterBottomSheetState();
}

class _FilterBottomSheetState extends State<FilterBottomSheet> {
  late final ListPropertyController listingController;

  late final TextEditingController minPriceCtrl;
  late final TextEditingController maxPriceCtrl;
  late final TextEditingController bedCtrl;
  late final TextEditingController bathCtrl;
  late final TextEditingController areaCtrl;

  @override
  void initState() {
    super.initState();

    listingController = Get.find<ListPropertyController>();

    if (listingController.nearbyTags.isEmpty) {
      listingController.fetchListingOptions();
    }

    minPriceCtrl = TextEditingController(
      text: widget.controller.minPrice?.toString() ?? "",
    );

    maxPriceCtrl = TextEditingController(
      text: widget.controller.maxPrice?.toString() ?? "",
    );

    bedCtrl = TextEditingController(
      text: widget.controller.minBedrooms?.toString() ?? "",
    );

    bathCtrl = TextEditingController(
      text: widget.controller.minBathrooms?.toString() ?? "",
    );

    areaCtrl = TextEditingController(
      text: widget.controller.minArea?.toString() ?? "",
    );
  }

  @override
  void dispose() {
    minPriceCtrl.dispose();
    maxPriceCtrl.dispose();
    bedCtrl.dispose();
    bathCtrl.dispose();
    areaCtrl.dispose();
    super.dispose();
  }

  @override
  Widget build(BuildContext context) {
    return StatefulBuilder(
      builder: (context, setState) {
        return SafeArea(
          child: Container(
            constraints: BoxConstraints(
              maxHeight: MediaQuery.of(context).size.height * .78,
            ),
            decoration: BoxDecoration(
              color: const Color(0xffF8F9FB),
              borderRadius: BorderRadius.vertical(top: Radius.circular(24.r)),
            ),
            child: Column(
              children: [
                ///=========================================================
                /// HEADER
                ///=========================================================
                Padding(
                  padding: EdgeInsets.fromLTRB(20.w, 16.h, 20.w, 12.h),
                  child: Column(
                    children: [
                      Center(
                        child: Container(
                          width: 44.w,
                          height: 5.h,
                          decoration: BoxDecoration(
                            color: Colors.grey.shade300,
                            borderRadius: BorderRadius.circular(20),
                          ),
                        ),
                      ),

                      SizedBox(height: 18.h),

                      Row(
                        children: [
                          Container(
                            width: 46.w,
                            height: 46.w,
                            decoration: BoxDecoration(
                              color: AppColors.primary.withOpacity(.08),
                              shape: BoxShape.circle,
                            ),
                            child: Icon(
                              Icons.tune_rounded,
                              color: AppColors.primary,
                              size: 22.sp,
                            ),
                          ),

                          SizedBox(width: 14.w),

                          Expanded(
                            child: Column(
                              crossAxisAlignment: CrossAxisAlignment.start,
                              children: [
                                Text(
                                  "Filter Properties".tr,
                                  style: AppTextStyles.title18.copyWith(
                                    fontWeight: FontWeight.w700,
                                  ),
                                ),

                                SizedBox(height: 2.h),

                                Text(
                                  "Refine your search results".tr,
                                  style: AppTextStyles.body13.copyWith(
                                    color: AppColors.hintGrey,
                                  ),
                                ),
                              ],
                            ),
                          ),

                          InkWell(
                            borderRadius: BorderRadius.circular(30),
                            onTap: () => Navigator.pop(context),
                            child: Container(
                              width: 38.w,
                              height: 38.w,
                              decoration: BoxDecoration(
                                color: Colors.white,
                                shape: BoxShape.circle,
                                border: Border.all(color: Colors.grey.shade300),
                              ),
                              child: Icon(Icons.close_rounded, size: 20.sp),
                            ),
                          ),
                        ],
                      ),
                    ],
                  ),
                ),

                Divider(height: 1, color: Colors.grey.shade200),

                ///=========================================================
                /// BODY
                ///=========================================================
                Flexible(
                  child: SingleChildScrollView(
                    padding: EdgeInsets.symmetric(
                      horizontal: 16.w,
                      vertical: 10.h,
                    ),
                    child: Column(
                      crossAxisAlignment: CrossAxisAlignment.start,
                      children: [
                        ///===========================
                        /// PRICE
                        ///===========================
                        _sectionTitle("Price Range".tr),

                        _FilterCard(
                          child: Row(
                            children: [
                              Expanded(
                                child: _FilterTextField(
                                  controller: minPriceCtrl,
                                  hint: "Min Price".tr,
                                  icon: Icons.currency_exchange,
                                  keyboardType: TextInputType.number,
                                ),
                              ),

                              SizedBox(width: 12.w),

                              Expanded(
                                child: _FilterTextField(
                                  controller: maxPriceCtrl,
                                  hint: "Max Price".tr,
                                  icon: Icons.currency_exchange,
                                  keyboardType: TextInputType.number,
                                ),
                              ),
                            ],
                          ),
                        ),

                        SizedBox(height: 22.h),

                        ///===========================
                        /// PROPERTY DETAILS
                        ///===========================
                        _sectionTitle("Property Details".tr),

                        _FilterCard(
                          child: Row(
                            children: [
                              Expanded(
                                child: _FilterTextField(
                                  controller: bedCtrl,
                                  hint: "Beds".tr,
                                  icon: Icons.king_bed_outlined,
                                  keyboardType: TextInputType.number,
                                ),
                              ),

                              SizedBox(width: 10.w),

                              Expanded(
                                child: _FilterTextField(
                                  controller: bathCtrl,
                                  hint: "Baths".tr,
                                  icon: Icons.bathtub_outlined,
                                  keyboardType: TextInputType.number,
                                ),
                              ),

                              SizedBox(width: 10.w),

                              Expanded(
                                child: _FilterTextField(
                                  controller: areaCtrl,
                                  hint: "Area".tr,
                                  icon: Icons.square_foot_outlined,
                                  keyboardType: TextInputType.number,
                                ),
                              ),
                            ],
                          ),
                        ),

                        SizedBox(height: 24.h),

                        ///===========================
                        /// FURNISHING
                        ///===========================
                        _sectionTitle("Furnishing".tr),

                        _FilterCard(
                          child: LayoutBuilder(
                            builder: (context, constraints) {
                              final itemWidth = (constraints.maxWidth - 10) / 2;

                              return Wrap(
                                spacing: 10,
                                runSpacing: 10,
                                children:
                                    [
                                      "Furnished".tr,
                                      "Semi-Furnished".tr,
                                      "Unfurnished".tr,
                                    ].map((item) {
                                      final selected =
                                          widget.controller.furnishingStatus ==
                                          item;

                                      return SizedBox(
                                        width: itemWidth,
                                        child: _FilterChip(
                                          title: item,
                                          selected: selected,
                                          onTap: () {
                                            setState(() {
                                              widget
                                                  .controller
                                                  .furnishingStatus = selected
                                                  ? ""
                                                  : item;
                                            });
                                          },
                                        ),
                                      );
                                    }).toList(),
                              );
                            },
                          ),
                        ),
                        SizedBox(height: 24.h),

                        ///===========================
                        /// NEARBY
                        ///===========================
                        // _sectionTitle("Nearby"),

                        // GetBuilder<ListPropertyController>(
                        //   builder: (listing) {
                        //     if (listing.nearbyTags.isEmpty) {
                        //       return const Center(
                        //         child: Padding(
                        //           padding: EdgeInsets.all(20),
                        //           child: CircularProgressIndicator(),
                        //         ),
                        //       );
                        //     }

                        //     return _FilterCard(
                        //       child: LayoutBuilder(
                        //         builder: (context, constraints) {
                        //           final itemWidth =
                        //               (constraints.maxWidth - 10) / 2;

                        //           return Wrap(
                        //             spacing: 10,
                        //             runSpacing: 10,
                        //             children: listing.nearbyTags.map((tag) {
                        //               final selected =
                        //                   widget.controller.nearbyTag == tag;

                        //               final title = tag
                        //                   .replaceAll("_", " ")
                        //                   .split(" ")
                        //                   .map(
                        //                     (e) =>
                        //                         e[0].toUpperCase() +
                        //                         e.substring(1),
                        //                   )
                        //                   .join(" ");

                        //               return SizedBox(
                        //                 width: itemWidth,
                        //                 child: _FilterChip(
                        //                   title: title,
                        //                   selected: selected,
                        //                   onTap: () {
                        //                     setState(() {
                        //                       widget.controller.nearbyTag =
                        //                           selected ? "" : tag;
                        //                     });
                        //                   },
                        //                 ),
                        //               );
                        //             }).toList(),
                        //           );
                        //         },
                        //       ),
                        //     );
                        //   },
                        // ),
                        SizedBox(height: 40.h),
                      ],
                    ),
                  ),
                ),

                ///=========================================================
                /// BOTTOM BUTTONS
                ///=========================================================
                Container(
                  padding: EdgeInsets.fromLTRB(
                    20.w,
                    16.h,
                    20.w,
                    MediaQuery.of(context).padding.bottom + 16.h,
                  ),
                  decoration: BoxDecoration(
                    color: Colors.white,
                    border: Border(
                      top: BorderSide(color: Colors.grey.shade200),
                    ),
                  ),
                  child: Row(
                    children: [
                      Expanded(
                        child: SizedBox(
                          height: 52.h,
                          child: OutlinedButton(
                            onPressed: () {
                              widget.controller.applyFilters(
                                search: widget
                                    .controller
                                    .searchTextController
                                    .text
                                    .trim(),

                                type: widget.controller.type,

                                purpose: widget.controller.purpose,

                                furnishingStatus:
                                    widget.controller.furnishingStatus,

                                nearbyTag: widget.controller.nearbyTag,

                                minPrice: widget.controller.minPrice,

                                maxPrice: widget.controller.maxPrice,

                                minBedrooms: widget.controller.minBedrooms,

                                minBathrooms: widget.controller.minBathrooms,

                                minArea: widget.controller.minArea,

                                maxArea: widget.controller.maxArea,
                              );
                            },
                            style: OutlinedButton.styleFrom(
                              side: const BorderSide(color: AppColors.primary),
                              shape: RoundedRectangleBorder(
                                borderRadius: BorderRadius.circular(10.r),
                              ),
                            ),
                            child: Text(
                              "Reset".tr,
                              style: AppTextStyles.body14.copyWith(
                                color: AppColors.primary,
                                fontWeight: FontWeight.w700,
                              ),
                            ),
                          ),
                        ),
                      ),

                      SizedBox(width: 14.w),

                      Expanded(
                        flex: 2,
                        child: PrimaryButton(
                          title: "Apply Filters".tr,
                          onTap: () {
                            widget.controller.applyFilters(
                              furnishingStatus:
                                  widget.controller.furnishingStatus,
                              nearbyTag: widget.controller.nearbyTag,

                              minPrice: double.tryParse(minPriceCtrl.text),
                              maxPrice: double.tryParse(maxPriceCtrl.text),

                              minBedrooms: int.tryParse(bedCtrl.text),
                              minBathrooms: int.tryParse(bathCtrl.text),

                              minArea: double.tryParse(areaCtrl.text),
                            );

                            Navigator.pop(context);
                          },
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
//======================================================
// SECTION TITLE
//======================================================

Widget _sectionTitle(String title) {
  return Padding(
    padding: EdgeInsets.only(bottom: 6.h),
    child: Text(
      title,
      style: AppTextStyles.title14.copyWith(fontWeight: FontWeight.w700),
    ),
  );
}

//======================================================
// CARD
//======================================================
class _FilterCard extends StatelessWidget {
  final Widget child;

  const _FilterCard({required this.child});

  @override
  Widget build(BuildContext context) {
    return Column(children: [child]);
  }
}

class _FilterTextField extends StatelessWidget {
  final TextEditingController controller;
  final String hint;
  final IconData icon;
  final TextInputType? keyboardType;

  const _FilterTextField({
    required this.controller,
    required this.hint,
    required this.icon,
    this.keyboardType,
  });

  @override
  Widget build(BuildContext context) {
    return TextField(
      controller: controller,
      keyboardType: keyboardType,
      style: AppTextStyles.body12.copyWith(fontWeight: FontWeight.w500),
      decoration: InputDecoration(
        hintText: hint,

        prefixIcon: Icon(icon, size: 16.sp, color: AppColors.primary),

        filled: true,
        fillColor: const Color(0xffFAFAFA),

        contentPadding: EdgeInsets.symmetric(horizontal: 14.w, vertical: 6.h),

        border: OutlineInputBorder(
          borderRadius: BorderRadius.circular(10.r),
          borderSide: BorderSide(color: Colors.grey.shade300),
        ),

        enabledBorder: OutlineInputBorder(
          borderRadius: BorderRadius.circular(10.r),
          borderSide: BorderSide(color: Colors.grey.shade300),
        ),

        focusedBorder: OutlineInputBorder(
          borderRadius: BorderRadius.circular(10.r),
          borderSide: BorderSide(color: AppColors.primary, width: 1.w),
        ),
      ),
    );
  }
}

class _FilterChip extends StatelessWidget {
  final String title;
  final bool selected;
  final VoidCallback onTap;

  const _FilterChip({
    required this.title,
    required this.selected,
    required this.onTap,
  });

  @override
  Widget build(BuildContext context) {
    return Material(
      color: Colors.transparent,
      child: InkWell(
        borderRadius: BorderRadius.circular(10.r),
        onTap: onTap,
        child: AnimatedContainer(
          duration: const Duration(milliseconds: 200),
          curve: Curves.easeInOut,
          padding: EdgeInsets.symmetric(horizontal: 14.w, vertical: 10.h),
          decoration: BoxDecoration(
            color: selected ? AppColors.primary.withOpacity(.08) : Colors.white,
            borderRadius: BorderRadius.circular(10.r),
            border: Border.all(
              color: selected ? AppColors.primary : const Color(0xffE3E3E3),
              width: 1,
            ),
          ),
          child: Row(
            mainAxisSize: MainAxisSize.min,
            children: [
              AnimatedContainer(
                duration: const Duration(milliseconds: 200),
                width: 15.w,
                height: 15.w,
                decoration: BoxDecoration(
                  shape: BoxShape.circle,
                  color: selected ? AppColors.primary : Colors.transparent,
                  border: Border.all(
                    color: selected ? AppColors.primary : Colors.grey.shade400,
                  ),
                ),
                child: selected
                    ? Icon(Icons.check, color: Colors.white, size: 10.sp)
                    : null,
              ),

              SizedBox(width: 10.w),

              Flexible(
                child: Text(
                  title,
                  overflow: TextOverflow.ellipsis,
                  style: AppTextStyles.body13.copyWith(
                    fontWeight: FontWeight.w600,
                    color: selected ? AppColors.primary : Colors.black87,
                  ),
                ),
              ),
            ],
          ),
        ),
      ),
    );
  }
}
