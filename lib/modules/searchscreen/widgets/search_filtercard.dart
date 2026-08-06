import 'package:flutter/material.dart';
import 'package:flutter_screenutil/flutter_screenutil.dart';
import 'package:get/get_core/src/get_main.dart';
import 'package:get/get_instance/src/extension_instance.dart';
import 'package:get/get_state_manager/src/simple/get_state.dart';
import 'package:get/get_utils/src/extensions/internacionalization.dart';
import 'package:villas_qatar/Core/constants/app_colors.dart';
import 'package:villas_qatar/Core/theme/app_textstyles.dart';
import 'package:villas_qatar/Core/widgets/primary_button.dart';
import 'package:villas_qatar/modules/home/service/UtilsController.dart';
import 'package:villas_qatar/modules/home/service/loaction_controller.dart';
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


  final List<String> sortOptions = [
  "Sort".tr,
  "Newest".tr,
  "Oldest".tr,
  "Price: Low to High".tr,
  "Price: High to Low".tr,
  "Area: Low to High".tr,
  "Area: High to Low".tr,
];

String selectedSort = "Sort".tr;
  

  @override
  Widget build(BuildContext context) {
    final int selectedTab = widget.controller.filter.purpose == "RENT" ? 1 : 0;
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
                      widget.controller.filter.purpose = index == 0
                          ? "SALE"
                          : "RENT";

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
                          textAlignVertical: TextAlignVertical.center,
                          style: AppTextStyles.body14.copyWith(
                            color: const Color(0xff32354A),
                            fontSize: 14.sp,
                          ),
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
                              type: widget.controller.filter.type,
                              purpose: widget.controller.filter.purpose,
                              furnishingId:
                                  widget.controller.filter.furnishingId,
                              nearbyTags: widget.controller.filter.nearbyTags,
                              minPrice: widget.controller.filter.minPrice,
                              maxPrice: widget.controller.filter.maxPrice,
                              minBedrooms: widget.controller.filter.minBedrooms,
                              minBathrooms:
                                  widget.controller.filter.minBathrooms,
                              minArea: widget.controller.filter.minArea,
                              maxArea: widget.controller.filter.maxArea,
                            );

                            if (!mounted) return;

                            FocusManager.instance.primaryFocus?.unfocus();

                            setState(() {});

                            widget.controller.update();
                          },

                          decoration: InputDecoration(
                            border: InputBorder.none,
                            enabledBorder: InputBorder.none,
                            focusedBorder: InputBorder.none,

                            // Remove isCollapsed
                            isDense: true,

                            // Give proper vertical padding
                            contentPadding: EdgeInsets.symmetric(
                              vertical: 12.h,
                            ),

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

                                      widget.controller.searchTextController
                                          .clear();
                                      widget.controller.filter.search = "";

                                      setState(() {});
                                      await widget.controller.applyFilters(
                                        search: "",
                                        type: widget.controller.filter.type,
                                        purpose:
                                            widget.controller.filter.purpose,
                                        furnishingId: widget
                                            .controller
                                            .filter
                                            .furnishingId,
                                        nearbyTags:
                                            widget.controller.filter.nearbyTags,
                                        minPrice:
                                            widget.controller.filter.minPrice,
                                        maxPrice:
                                            widget.controller.filter.maxPrice,
                                        minBedrooms: widget
                                            .controller
                                            .filter
                                            .minBedrooms,
                                        minBathrooms: widget
                                            .controller
                                            .filter
                                            .minBathrooms,
                                        minArea:
                                            widget.controller.filter.minArea,
                                        maxArea:
                                            widget.controller.filter.maxArea,
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

              InkWell(
                borderRadius: BorderRadius.circular(8.r),
                onTap: () async {
                  final locationController = Get.find<LocationController>();

                  await locationController.detectCurrentLocation();

                  if (locationController.location != null) {
                    final locationName =
                        locationController.location!.data.areaName.isNotEmpty
                        ? locationController.location!.data.areaName
                        : locationController.location!.data.formattedAddress;

                    widget.controller.searchTextController.value =
                        TextEditingValue(
                          text: locationName,
                          selection: TextSelection.collapsed(
                            offset: locationName.length,
                          ),
                        );

                    setState(() {});

                    await widget.controller.applyFilters(
                      search: locationName,
                      type: widget.controller.filter.type,
                      purpose: widget.controller.filter.purpose,
                      furnishingId: widget.controller.filter.furnishingId,
                      nearbyTags: widget.controller.filter.nearbyTags,
                      minPrice: widget.controller.filter.minPrice,
                      maxPrice: widget.controller.filter.maxPrice,
                      minBedrooms: widget.controller.filter.minBedrooms,
                      minBathrooms: widget.controller.filter.minBathrooms,
                      minArea: widget.controller.filter.minArea,
                      maxArea: widget.controller.filter.maxArea,
                    );

                    widget.controller.update();
                  }
                },
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
            value: selectedPropertyType,
            isExpanded: true,
            underline: const SizedBox(),
            items: propertyTypes
                .map(
                  (e) => DropdownMenuItem(
                    value: e,
                    child: Text(
                      e == "Property Type"
                          ? "Property Type".tr
                          : e,
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

              widget.controller.filter.type =
                  value == "Property Type" ? "" : value;

              widget.controller.fetchProperties();
            },
          ),
        ),
      ),
    ),

    SizedBox(width: 10.w),

    /// Sort
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
            value: selectedSort,
            isExpanded: true,
            underline: const SizedBox(),
            items: sortOptions.map((e) {
              return DropdownMenuItem(
                value: e,
                child: Text(
                  e,
                  style: TextStyle(fontSize: 10.sp),
                ),
              );
            }).toList(),
            onChanged: (value) {
              if (value == null) return;

              setState(() {
                selectedSort = value;
              });

              switch (value) {
                case "Newest":
                  widget.controller.filter.sortBy = "createdAt";
                  widget.controller.filter.sortOrder = "desc";
                  break;

                case "Oldest":
                  widget.controller.filter.sortBy = "createdAt";
                  widget.controller.filter.sortOrder = "asc";
                  break;

                case "Price: Low to High":
                  widget.controller.filter.sortBy = "price";
                  widget.controller.filter.sortOrder = "asc";
                  break;

                case "Price: High to Low":
                  widget.controller.filter.sortBy = "price";
                  widget.controller.filter.sortOrder = "desc";
                  break;

                case "Area: Low to High":
                  widget.controller.filter.sortBy = "area";
                  widget.controller.filter.sortOrder = "asc";
                  break;

                case "Area: High to Low":
                  widget.controller.filter.sortBy = "area";
                  widget.controller.filter.sortOrder = "desc";
                  break;

                default:
                  widget.controller.filter.sortBy = "";
                  widget.controller.filter.sortOrder = "";
              }

              widget.controller.fetchProperties();
            },
          ),
        ),
      ),
    ),

    SizedBox(width: 10.w),

    /// Filters
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
            Icon(
              Icons.tune_rounded,
              color: AppColors.primary,
              size: 20.sp,
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
                  type: widget.controller.filter.type,
                  purpose: widget.controller.filter.purpose,
                  furnishingId: widget.controller.filter.furnishingId,
                  nearbyTags: widget.controller.filter.nearbyTags,
                  minPrice: widget.controller.filter.minPrice,
                  maxPrice: widget.controller.filter.maxPrice,
                  minBedrooms: widget.controller.filter.minBedrooms,
                  minBathrooms: widget.controller.filter.minBathrooms,
                  minArea: widget.controller.filter.minArea,
                  maxArea: widget.controller.filter.maxArea,
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
  late final TextEditingController minAreaCtrl;
  late final TextEditingController maxAreaCtrl;

  @override
  void initState() {
    super.initState();

    listingController = Get.find<ListPropertyController>();
    if (listingController.nearbyTags.isEmpty) {
      listingController.fetchListingOptions();
    }
    minPriceCtrl = TextEditingController(
      text: widget.controller.filter.minPrice?.toString() ?? "",
    );
    maxPriceCtrl = TextEditingController(
      text: widget.controller.filter.maxPrice?.toString() ?? "",
    );
    bedCtrl = TextEditingController(
      text: widget.controller.filter.minBedrooms?.toString() ?? "",
    );
    bathCtrl = TextEditingController(
      text: widget.controller.filter.minBathrooms?.toString() ?? "",
    );
    areaCtrl = TextEditingController(
      text: widget.controller.filter.minArea?.toString() ?? "",
    );
    minAreaCtrl = TextEditingController(
      text: widget.controller.filter.minArea?.toString() ?? "",
    );
    maxAreaCtrl = TextEditingController(
      text: widget.controller.filter.maxArea?.toString() ?? "",
    );
  }

  @override
  void dispose() {
    minPriceCtrl.dispose();
    maxPriceCtrl.dispose();
    bedCtrl.dispose();
    bathCtrl.dispose();
    areaCtrl.dispose();
    minAreaCtrl.dispose();
    maxAreaCtrl.dispose();
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
                                  style: AppTextStyles.title16.copyWith(
                                    fontWeight: FontWeight.w500,
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
                Flexible(
                  child: SingleChildScrollView(
                    padding: EdgeInsets.symmetric(
                      horizontal: 16.w,
                      vertical: 10.h,
                    ),
                    child: Column(
                      crossAxisAlignment: CrossAxisAlignment.start,
                      children: [
                        _sectionTitle("Location".tr),

                        SizedBox(height: 8),

                        GetBuilder<Utilscontroller>(
                          builder: (utils) {
                            return SizedBox(
                              height: 42.h,
                              child: DropdownButtonFormField<String>(
                                isDense: true,
                                isExpanded: true,
                                value: widget.controller.filter.locationId,
                                decoration: InputDecoration(
                                  hintText: "All Locations".tr,
                                  filled: true,
                                  fillColor: Colors.white,
                                  contentPadding: EdgeInsets.symmetric(
                                    horizontal: 14.w,
                                    vertical: 10.h,
                                  ),
                                  border: OutlineInputBorder(
                                    borderRadius: BorderRadius.circular(10.r),
                                  ),
                                  enabledBorder: OutlineInputBorder(
                                    borderRadius: BorderRadius.circular(10.r),
                                    borderSide: BorderSide(
                                      color: Colors.grey.shade300,
                                    ),
                                  ),
                                  focusedBorder: OutlineInputBorder(
                                    borderRadius: BorderRadius.circular(10.r),
                                    borderSide: const BorderSide(
                                      color: AppColors.primary,
                                    ),
                                  ),
                                ),
                                items: [
                                  DropdownMenuItem<String>(
                                    value: null,
                                    child: Text(
                                      "All Locations".tr,
                                      style: TextStyle(fontSize: 13.sp),
                                    ),
                                  ),
                                  ...utils.municipalities.map(
                                    (m) => DropdownMenuItem<String>(
                                      value: m.id,
                                      child: Text(
                                        m.name,
                                        style: TextStyle(fontSize: 13.sp),
                                      ),
                                    ),
                                  ),
                                ],
                                onChanged: (v) {
                                  setState(() {
                                    widget.controller.filter.locationId = v;
                                  });
                                },
                              ),
                            );
                          },
                        ),
                        SizedBox(height: 20),
                        _sectionTitle("Price Range".tr),
                        _FilterCard(
                          child: Row(
                            children: [
                              Expanded(
                                child: NumberSpinnerField(
                                  hint: "Min Price",
                                  value:
                                      widget.controller.filter.minPrice
                                          ?.toInt() ??
                                      0,
                                  onChanged: (v) {
                                    setState(() {
                                      widget.controller.filter.minPrice = v
                                          .toDouble();
                                    });
                                  },
                                ),
                              ),
                              SizedBox(width: 12),
                              const Text("-", style: TextStyle(fontSize: 22)),
                              SizedBox(width: 12),
                              Expanded(
                                child: NumberSpinnerField(
                                  hint: "Max Price",
                                  value:
                                      widget.controller.filter.maxPrice
                                          ?.toInt() ??
                                      0,
                                  onChanged: (v) {
                                    setState(() {
                                      widget.controller.filter.maxPrice = v
                                          .toDouble();
                                    });
                                  },
                                ),
                              ),
                            ],
                          ),
                        ),
                        SizedBox(height: 12.h),
                        _sectionTitle("Bedrooms".tr),
                        SizedBox(height: 5.h),
                        Wrap(
                          spacing: 7.w,
                          runSpacing: 12.h,
                          children: [
                            _NumberChip(
                              title: "All".tr,
                              selected:
                                  widget.controller.filter.minBedrooms == null,
                              onTap: () => setState(() {
                                widget.controller.filter.minBedrooms = null;
                              }),
                            ),

                            ...List.generate(5, (i) {
                              final value = i + 1;

                              return _NumberChip(
                                title: "$value",
                                selected:
                                    widget.controller.filter.minBedrooms ==
                                    value,
                                onTap: () => setState(() {
                                  widget.controller.filter.minBedrooms = value;
                                }),
                              );
                            }),
                            _NumberChip(
                              title: "6+",
                              selected:
                                  widget.controller.filter.minBedrooms == 6,
                              onTap: () => setState(() {
                                widget.controller.filter.minBedrooms = 6;
                              }),
                            ),
                          ],
                        ),
                        SizedBox(height: 12.h),
                        _sectionTitle("Bathrooms".tr),
                        SizedBox(height: 5.h),
                        Wrap(
                          spacing: 6.w,
                          runSpacing: 12.h,
                          children: [
                            _NumberChip(
                              title: "All".tr,
                              selected:
                                  widget.controller.filter.minBathrooms == null,
                              onTap: () => setState(() {
                                widget.controller.filter.minBathrooms = null;
                              }),
                            ),
                            ...List.generate(5, (i) {
                              final value = i + 1;
                              return _NumberChip(
                                title: "$value",
                                selected:
                                    widget.controller.filter.minBathrooms ==
                                    value,
                                onTap: () => setState(() {
                                  widget.controller.filter.minBathrooms = value;
                                }),
                              );
                            }),
                            _NumberChip(
                              title: "6+",
                              selected:
                                  widget.controller.filter.minBathrooms == 5,
                              onTap: () => setState(() {
                                widget.controller.filter.minBathrooms = 5;
                              }),
                            ),
                          ],
                        ),
                        SizedBox(height: 15.h),
                        _sectionTitle("Furnishing".tr),
                        GetBuilder<Utilscontroller>(
                          builder: (utils) {
                            return SizedBox(
                              height: 42.h,
                              child: DropdownButtonFormField<String>(
                                isDense: true,
                                value:
                                    widget
                                        .controller
                                        .filter
                                        .furnishingId
                                        .isEmpty
                                    ? null
                                    : widget.controller.filter.furnishingId,
                                decoration: InputDecoration(
                                  hintText: "Any".tr,
                                  filled: true,
                                  fillColor: Colors.white,
                                  isDense: true,
                                  contentPadding: EdgeInsets.symmetric(
                                    horizontal: 14.w,
                                    vertical: 12.h,
                                  ),
                                  border: OutlineInputBorder(
                                    borderRadius: BorderRadius.circular(10.r),
                                  ),
                                  enabledBorder: OutlineInputBorder(
                                    borderRadius: BorderRadius.circular(10.r),
                                    borderSide: BorderSide(
                                      color: Colors.grey.shade300,
                                    ),
                                  ),
                                  focusedBorder: OutlineInputBorder(
                                    borderRadius: BorderRadius.circular(10.r),
                                    borderSide: const BorderSide(
                                      color: AppColors.primary,
                                    ),
                                  ),
                                ),
                                items: utils.furnishingOptions.map((item) {
                                  return DropdownMenuItem<String>(
                                    value: item.id,
                                    child: Text(
                                      item.title,
                                      style: TextStyle(fontSize: 13.sp),
                                    ),
                                  );
                                }).toList(),
                                onChanged: (v) {
                                  setState(() {
                                    widget.controller.filter.furnishingId =
                                        v ?? "";
                                  });
                                },
                              ),
                            );
                          },
                        ),
                        SizedBox(height: 15.h),
                        _sectionTitle("Nearby".tr),
                        GetBuilder<Utilscontroller>(
                          builder: (utils) {
                            return Wrap(
                              spacing: 10.w,
                              runSpacing: 10.h,
                              children: utils.nearbyTags.map((item) {
                                final selected = widget
                                    .controller
                                    .filter
                                    .nearbyTags
                                    .contains(item.id);

                                return CustomFilterChip(
                                  title: item.title,
                                  selected: selected,
                                  onTap: () {
                                    setState(() {
                                      if (selected) {
                                        widget.controller.filter.nearbyTags
                                            .remove(item.id);
                                      } else {
                                        widget.controller.filter.nearbyTags.add(
                                          item.id,
                                        );
                                      }
                                    });
                                  },
                                );
                              }).toList(),
                            );
                          },
                        ),
                        SizedBox(height: 15.h),
                        _sectionTitle("Amenities".tr),
                        GetBuilder<Utilscontroller>(
                          builder: (utils) {
                            return Wrap(
                              spacing: 10.w,
                              runSpacing: 10.h,
                              children: utils.amenities.map((item) {
                                final selected = widget
                                    .controller
                                    .filter
                                    .amenities
                                    .contains(item.id);

                                return CustomFilterChip(
                                  title: item.title,
                                  selected: selected,
                                  onTap: () {
                                    setState(() {
                                      if (selected) {
                                        widget.controller.filter.amenities
                                            .remove(item.id);
                                      } else {
                                        widget.controller.filter.amenities.add(
                                          item.id,
                                        );
                                      }
                                    });
                                  },
                                );
                              }).toList(),
                            );
                          },
                        ),
                        SizedBox(height: 15.h),
                        _sectionTitle("Area (SQM)".tr),
                        Row(
                          children: [
                            Expanded(
                              child: NumberSpinnerField(
                                hint: "Min Area",
                                value:
                                    widget.controller.filter.minArea?.toInt() ??
                                    0,
                                onChanged: (v) {
                                  setState(() {
                                    widget.controller.filter.minArea = v
                                        .toDouble();
                                  });
                                },
                              ),
                            ),
                            SizedBox(width: 12),
                            Expanded(
                              child: NumberSpinnerField(
                                hint: "Max Area",
                                value:
                                    widget.controller.filter.maxArea?.toInt() ??
                                    0,
                                onChanged: (v) {
                                  setState(() {
                                    widget.controller.filter.maxArea = v
                                        .toDouble();
                                  });
                                },
                              ),
                            ),
                          ],
                        ),
                      ],
                    ),
                  ),
                ),
                Container(
                  padding: EdgeInsets.fromLTRB(20.w, 16.h, 20.w, 16.h),
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
                          height: 42.h,
                          child: OutlinedButton(
                            onPressed: () async {
                              await widget.controller.clearFilters();

                              setState(() {
                                minPriceCtrl.clear();
                                maxPriceCtrl.clear();
                                bedCtrl.clear();
                                bathCtrl.clear();
                                areaCtrl.clear();
                                maxAreaCtrl.clear();
                              });
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
                        child: SizedBox(
                          height: 42.h,
                          child: PrimaryButton(
                            title: "Apply Filters".tr,
                            onTap: () {
                              widget.controller.applyFilters(
                                search:
                                    widget.controller.searchTextController.text,
                                purpose: widget.controller.filter.purpose,
                                type: widget.controller.filter.type,
                                locationId: widget.controller.filter.locationId,
                                furnishingId:
                                    widget.controller.filter.furnishingId,
                                amenities: widget.controller.filter.amenities,
                                nearbyTags: widget.controller.filter.nearbyTags,
                                minPrice: widget.controller.filter.minPrice,
                                maxPrice: widget.controller.filter.maxPrice,
                                minBedrooms:
                                    widget.controller.filter.minBedrooms,
                                minBathrooms:
                                    widget.controller.filter.minBathrooms,
                                minArea: widget.controller.filter.minArea,
                                maxArea: widget.controller.filter.maxArea,
                              );

                              widget.controller.resetFilterUi();

                              minPriceCtrl.clear();
                              maxPriceCtrl.clear();
                              bedCtrl.clear();
                              bathCtrl.clear();
                              minAreaCtrl.clear();
                              maxAreaCtrl.clear();

                              Navigator.pop(context);
                            },
                          ),
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
      style: AppTextStyles.title14.copyWith(fontWeight: FontWeight.w500),
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

class CustomFilterChip extends StatelessWidget {
  final String title;
  final bool selected;
  final VoidCallback onTap;

  const CustomFilterChip({
    super.key,
    required this.title,
    required this.selected,
    required this.onTap,
  });

  @override
  Widget build(BuildContext context) {
    return InkWell(
      borderRadius: BorderRadius.circular(10.r),
      onTap: onTap,
      child: AnimatedContainer(
        duration: const Duration(milliseconds: 200),
        padding: EdgeInsets.symmetric(horizontal: 16.w, vertical: 10.h),
        decoration: BoxDecoration(
          color: selected ? AppColors.primary.withOpacity(.08) : Colors.white,
          borderRadius: BorderRadius.circular(10.r),
          border: Border.all(
            color: selected ? AppColors.primary : const Color(0xffD8DCE5),
            width: 1.4,
          ),
        ),
        child: Text(
          title,
          style: TextStyle(
            fontSize: 13.sp,
            fontWeight: FontWeight.w500,
            color: selected ? AppColors.primary : const Color(0xff555555),
          ),
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
          padding: EdgeInsets.symmetric(horizontal: 12.w, vertical: 10.h),
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

class _NumberChip extends StatelessWidget {
  final String title;
  final bool selected;
  final VoidCallback onTap;

  const _NumberChip({
    required this.title,
    required this.selected,
    required this.onTap,
  });

  @override
  Widget build(BuildContext context) {
    return InkWell(
      borderRadius: BorderRadius.circular(5.r),
      onTap: onTap,
      child: AnimatedContainer(
        duration: const Duration(milliseconds: 200),
        width: 45.w,
        height: 35.h,
        alignment: Alignment.center,
        decoration: BoxDecoration(
          color: selected ? AppColors.primary.withOpacity(.08) : Colors.white,
          borderRadius: BorderRadius.circular(8.r),
          border: Border.all(
            color: selected ? AppColors.primary : const Color(0xffD8DCE5),
            width: 1.w,
          ),
        ),
        child: Text(
          title,
          style: TextStyle(
            fontSize: 12.sp,
            fontWeight: FontWeight.w500,
            color: selected ? AppColors.primary : Colors.black87,
          ),
        ),
      ),
    );
  }
}

class NumberSpinnerField extends StatefulWidget {
  final String hint;
  final int value;
  final ValueChanged<int> onChanged;

  const NumberSpinnerField({
    super.key,
    required this.hint,
    required this.value,
    required this.onChanged,
  });

  @override
  State<NumberSpinnerField> createState() => _NumberSpinnerFieldState();
}

class _NumberSpinnerFieldState extends State<NumberSpinnerField> {
  late TextEditingController controller;

  @override
  void initState() {
    super.initState();
    controller = TextEditingController(
      text: widget.value == 0 ? "" : widget.value.toString(),
    );
  }

  @override
  void didUpdateWidget(covariant NumberSpinnerField oldWidget) {
    super.didUpdateWidget(oldWidget);

    if (oldWidget.value != widget.value) {
      controller.text = widget.value == 0 ? "" : widget.value.toString();
    }
  }

  @override
  Widget build(BuildContext context) {
    return Container(
      height: 42.h,
      decoration: BoxDecoration(
        border: Border.all(color: Colors.grey.shade200),
        borderRadius: BorderRadius.circular(10.r),
        color: Colors.white,
      ),
      child: Row(
        children: [
          Expanded(
            child: TextField(
              controller: controller,
              keyboardType: TextInputType.number,
              decoration: InputDecoration(
                hintText: widget.hint,

                isDense: true,
                border: InputBorder.none,
                contentPadding: EdgeInsets.symmetric(horizontal: 16.w),
              ),
              onChanged: (v) {
                widget.onChanged(int.tryParse(v) ?? 0);
              },
            ),
          ),

          Container(
            width: 50,

            child: Column(
              children: [
                Expanded(
                  child: InkWell(
                    onTap: () {
                      final value = (int.tryParse(controller.text) ?? 0) + 1;
                      controller.text = value.toString();
                      widget.onChanged(value);
                    },
                    child: Icon(Icons.keyboard_arrow_up, size: 16.sp),
                  ),
                ),

                Expanded(
                  child: InkWell(
                    onTap: () {
                      int value = (int.tryParse(controller.text) ?? 0) - 1;

                      if (value < 0) value = 0;

                      controller.text = value.toString();
                      widget.onChanged(value);
                    },
                    child: Icon(Icons.keyboard_arrow_down, size: 16.sp),
                  ),
                ),
              ],
            ),
          ),
        ],
      ),
    );
  }

  @override
  void dispose() {
    controller.dispose();
    super.dispose();
  }
}
