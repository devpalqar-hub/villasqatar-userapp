import 'package:flutter/material.dart';
import 'package:flutter_screenutil/flutter_screenutil.dart';
import 'package:fluttertoast/fluttertoast.dart';
import 'package:get/get.dart';
import 'package:villas_qatar/Core/constants/app_colors.dart';
import 'package:villas_qatar/modules/pricestimator/service/ai_price_estimator_controller.dart';
import 'package:villas_qatar/modules/propertylist/model/listing_options_model.dart';

import '../../propertylist/service/listproperty_controller.dart';

class PriceEstimatorScreen extends StatefulWidget {
  const PriceEstimatorScreen({super.key});

  @override
  State<PriceEstimatorScreen> createState() => _PriceEstimatorScreenState();
}

class _PriceEstimatorScreenState extends State<PriceEstimatorScreen> {
  int _selectedType = 0;
  bool _advancedOpen = false;

  final TextEditingController _locationController = TextEditingController();

  final TextEditingController _areaController = TextEditingController();

  final TextEditingController _highlightsController = TextEditingController();

  // ============================================================
  // SELECTED QUICK DETAILS
  // ============================================================

  int? _selectedBhk;
  int? _selectedBathrooms;

  FurnishingOption? _selectedFurnishing;

  int? _selectedFloor;
  int? _selectedTotalFloors;

  bool? _parkingAvailable;

  // UI-only because current estimate API does not accept property age
  String? _selectedPropertyAge;
  final Set<String> _selectedAmenityIds = {};

  // ============================================================
  // PROPERTY TYPES
  // ============================================================

  final List<_PropertyType> _types = const [
    _PropertyType('Apartment', Icons.apartment, apiValue: 'Apartment'),
    _PropertyType('Villa / House', Icons.villa, apiValue: 'Villa'),
    _PropertyType('Plot', Icons.crop_square, apiValue: 'Plot'),
    _PropertyType(
      'Commercial',
      Icons.store_mall_directory_outlined,
      apiValue: 'Commercial',
    ),
  ];

  @override
  void initState() {
    super.initState();

    /// Listing options controller
    if (!Get.isRegistered<ListPropertyController>()) {
      Get.put(ListPropertyController());
    }

    /// AI estimator controller
    if (!Get.isRegistered<AiPriceEstimatorController>()) {
      Get.put(AiPriceEstimatorController());
    }
  }

  @override
  void dispose() {
    _locationController.dispose();
    _areaController.dispose();
    _highlightsController.dispose();

    super.dispose();
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      backgroundColor: AppColors.background,
      appBar: _buildAppBar(context),
      body: SafeArea(
        child: ListView(
          padding: EdgeInsets.symmetric(horizontal: 5.w, vertical: 10.h),
          children: [
            _buildHero(context),
            Padding(
              padding: const EdgeInsets.fromLTRB(16, 10, 16, 0),
              child: Container(
                padding: const EdgeInsets.symmetric(
                  horizontal: 20,
                  vertical: 18,
                ),
                decoration: BoxDecoration(
                  color: Colors.white,
                  borderRadius: BorderRadius.circular(10.r),
                  border: Border.all(color: const Color(0xFFE8E8ED), width: 1),
                  boxShadow: [
                    BoxShadow(
                      color: Colors.black.withOpacity(0.04),
                      blurRadius: 18,
                      spreadRadius: 0,
                      offset: const Offset(0, 6),
                    ),
                  ],
                ),
                child: Column(
                  crossAxisAlignment: CrossAxisAlignment.start,
                  children: [
                    Container(
                      padding: EdgeInsets.symmetric(
                        horizontal: 10.w,
                        vertical: 18.h,
                      ),
                      decoration: BoxDecoration(
                        color: Colors.white,
                        borderRadius: BorderRadius.circular(10.r),
                        border: Border.all(color: const Color(0xFFE9E9EF)),
                        boxShadow: [
                          BoxShadow(
                            color: Colors.black.withOpacity(.04),
                            blurRadius: 14,
                            offset: const Offset(0, 4),
                          ),
                        ],
                      ),
                      child: Row(
                        children: [
                          /// Location
                          Expanded(
                            child: Row(
                              crossAxisAlignment: CrossAxisAlignment.start,
                              children: [
                                Icon(
                                  Icons.location_on_outlined,
                                  color: AppColors.primary,
                                  size: 24.sp,
                                ),
                                const SizedBox(width: 14),
                                Expanded(
                                  child: Column(
                                    crossAxisAlignment:
                                        CrossAxisAlignment.start,
                                    children: [
                                      Text(
                                        "Location".tr,
                                        style: TextStyle(
                                          fontSize: 13,
                                          fontWeight: FontWeight.w600,
                                        ),
                                      ),
                                      SizedBox(height: 4.h),
                                      TextField(
                                        controller: _locationController,
                                        maxLines: 1,
                                        decoration: InputDecoration(
                                          hintText:
                                              "Enter city, locality or area".tr,
                                          border: InputBorder.none,
                                          isDense: true,
                                          contentPadding: EdgeInsets.zero,
                                          hintStyle: TextStyle(
                                            color: const Color(0xFF8A8A99),
                                            fontSize: 10.sp,
                                          ),
                                        ),
                                      ),
                                    ],
                                  ),
                                ),
                              ],
                            ),
                          ),

                          Container(
                            margin: const EdgeInsets.symmetric(horizontal: 18),
                            height: 58,
                            width: 1,
                            color: const Color(0xFFE4E4EA),
                          ),

                          /// Area
                          Expanded(
                            child: Row(
                              crossAxisAlignment: CrossAxisAlignment.start,
                              children: [
                                Icon(
                                  Icons.square_foot_outlined,
                                  color: AppColors.primary,
                                  size: 22.sp,
                                ),
                                const SizedBox(width: 14),
                                Expanded(
                                  child: Column(
                                    crossAxisAlignment:
                                        CrossAxisAlignment.start,
                                    children: [
                                      Text(
                                        "Area (sqm)".tr,
                                        style: TextStyle(
                                          fontSize: 13,
                                          fontWeight: FontWeight.w600,
                                        ),
                                      ),
                                      const SizedBox(height: 8),
                                      TextField(
                                        controller: _areaController,
                                        keyboardType:
                                            const TextInputType.numberWithOptions(
                                              decimal: true,
                                            ),
                                        decoration: InputDecoration(
                                          hintText: "e.g. 1200",
                                          suffixText: "sqm".tr,
                                          border: InputBorder.none,
                                          isDense: true,
                                          contentPadding: EdgeInsets.zero,
                                          hintStyle: TextStyle(
                                            color: const Color(0xFF8A8A99),
                                            fontSize: 12.sp,
                                          ),
                                          suffixStyle: TextStyle(
                                            color: const Color(0xff2C2C96),
                                            fontSize: 12.sp,
                                            fontWeight: FontWeight.w500,
                                          ),
                                        ),
                                      ),
                                    ],
                                  ),
                                ),
                              ],
                            ),
                          ),
                        ],
                      ),
                    ),
                    SizedBox(height: 12.h),
                    _sectionLabel('Property Type'.tr),
                    const SizedBox(height: 8),
                    _buildTypeGrid(),

                    SizedBox(height: 18.h),

                    _sectionLabel('Property Details'.tr),
                    SizedBox(height: 10.h),

                    _buildDetailGrid(),

                    SizedBox(height: 18.h),

                    Row(
                      children: [
                        Text(
                          'Amenities'.tr,
                          style: TextStyle(
                            fontSize: 14,
                            fontWeight: FontWeight.w700,
                            color: AppColors.textPrimary,
                          ),
                        ),
                        SizedBox(width: 6),
                        Text(
                          '(Optional)'.tr,
                          style: TextStyle(
                            fontSize: 12.5,
                            color: AppColors.textSecondary,
                          ),
                        ),
                      ],
                    ),

                    const SizedBox(height: 10),

                    _buildAmenities(),

                    const SizedBox(height: 18),

                    const SizedBox(height: 18),
                    _sectionLabel('Share some highlights (Optional)'.tr),
                    _buildHighlightsField(),
                    const SizedBox(height: 16),

                    _buildCta(),
                    const SizedBox(height: 14),
                    _buildFooterNote(),
                  ],
                ),
              ),
            ),
          ],
        ),
      ),
    );
  }

  PreferredSizeWidget _buildAppBar(BuildContext context) {
    return AppBar(
      backgroundColor: AppColors.background,
      elevation: 0,
      centerTitle: true,
      leading: IconButton(
        icon: const Icon(Icons.arrow_back, color: AppColors.textPrimary),
        onPressed: () => Navigator.of(context).maybePop(),
      ),
      title: Row(
        mainAxisSize: MainAxisSize.min,
        children: [
          const Icon(
            Icons.diamond_outlined,
            color: AppColors.primary,
            size: 16,
          ),
          const SizedBox(width: 6),
          Text(
            'AI Price Estimator'.tr,
            style: TextStyle(
              color: AppColors.textPrimary,
              fontSize: 15,
              fontWeight: FontWeight.w600,
            ),
          ),
        ],
      ),
      
    );
  }

  Widget _buildAmenities() {
    return GetBuilder<ListPropertyController>(
      builder: (controller) {
        if (controller.isLoading && controller.amenities.isEmpty) {
          return Container(
            height: 58.h,
            width: double.infinity,
            decoration: BoxDecoration(
              color: Colors.white,
              borderRadius: BorderRadius.circular(10.r),
              border: Border.all(color: const Color(0xFFE9EAF3)),
            ),
            child: const Center(
              child: SizedBox(
                width: 20,
                height: 20,
                child: CircularProgressIndicator(
                  strokeWidth: 2,
                  color: AppColors.primary,
                ),
              ),
            ),
          );
        }

        final selectedItems = controller.amenities
            .where((item) => _selectedAmenityIds.contains(item.id))
            .toList();

        return InkWell(
          onTap: () {
            if (controller.amenities.isEmpty) {
              Fluttertoast.showToast(
                msg: "Amenities are not available.".tr,
                gravity: ToastGravity.BOTTOM,
              );
              return;
            }

            _showAmenitiesSheet(controller.amenities);
          },
          borderRadius: BorderRadius.circular(10.r),
          child: Container(
            width: double.infinity,
            constraints: BoxConstraints(minHeight: 58.h),
            padding: EdgeInsets.symmetric(horizontal: 15.w, vertical: 12.h),
            decoration: BoxDecoration(
              color: Colors.white,
              borderRadius: BorderRadius.circular(10.r),
              border: Border.all(color: const Color(0xFFE9EAF3)),
              boxShadow: [
                BoxShadow(
                  color: Colors.black.withOpacity(.025),
                  blurRadius: 8,
                  offset: const Offset(0, 2),
                ),
              ],
            ),
            child: Row(
              children: [
                Icon(
                  Icons.home_work_outlined,
                  size: 21.sp,
                  color: AppColors.primary,
                ),

                SizedBox(width: 12.w),

                Expanded(
                  child: selectedItems.isEmpty
                      ? Text(
                          "Select amenities".tr,
                          style: TextStyle(
                            fontSize: 12.sp,
                            color: const Color(0xff8C91A6),
                          ),
                        )
                      : Text(
                          selectedItems.map((e) => e.title).join(", "),
                          maxLines: 2,
                          overflow: TextOverflow.ellipsis,
                          style: TextStyle(
                            fontSize: 11.sp,
                            color: AppColors.primary,
                            fontWeight: FontWeight.w600,
                          ),
                        ),
                ),

                if (_selectedAmenityIds.isNotEmpty) ...[
                  Container(
                    padding: EdgeInsets.symmetric(
                      horizontal: 8.w,
                      vertical: 4.h,
                    ),
                    decoration: BoxDecoration(
                      color: AppColors.primary.withOpacity(.08),
                      borderRadius: BorderRadius.circular(20.r),
                    ),
                    child: Text(
                      "${_selectedAmenityIds.length}",
                      style: TextStyle(
                        fontSize: 10.sp,
                        fontWeight: FontWeight.w700,
                        color: AppColors.primary,
                      ),
                    ),
                  ),
                  SizedBox(width: 6.w),
                ],

                Icon(
                  Icons.keyboard_arrow_down_rounded,
                  size: 24.sp,
                  color: const Color(0xff1E2344),
                ),
              ],
            ),
          ),
        );
      },
    );
  }

  IconData _amenityIcon(String amenity) {
    final String value = amenity.toLowerCase().replaceAll('_', ' ');

    if (value.contains('pool') || value.contains('swimming')) {
      return Icons.pool_outlined;
    }

    if (value.contains('gym') || value.contains('fitness')) {
      return Icons.fitness_center_outlined;
    }

    if (value.contains('parking') || value.contains('garage')) {
      return Icons.local_parking_outlined;
    }

    if (value.contains('security') || value.contains('cctv')) {
      return Icons.security_outlined;
    }

    if (value.contains('elevator') || value.contains('lift')) {
      return Icons.elevator_outlined;
    }

    if (value.contains('garden')) {
      return Icons.park_outlined;
    }

    if (value.contains('balcony')) {
      return Icons.balcony_outlined;
    }

    if (value.contains('air') || value.contains('ac')) {
      return Icons.ac_unit_outlined;
    }

    if (value.contains('wifi') || value.contains('internet')) {
      return Icons.wifi_outlined;
    }

    if (value.contains('pet')) {
      return Icons.pets_outlined;
    }

    if (value.contains('play')) {
      return Icons.child_care_outlined;
    }

    if (value.contains('concierge')) {
      return Icons.support_agent_outlined;
    }

    return Icons.check_circle_outline_rounded;
  }

  Widget _buildHero(BuildContext context) {
    return ClipRRect(
      child: SizedBox(
        height: 150,
        child: Stack(
          children: [
            /// Background Image
            Positioned.fill(
              child: Image.asset("assets/auth_bg 1.png", fit: BoxFit.cover),
            ),

            /// Left Content
            Padding(
              padding: EdgeInsets.all(20),
              child: SizedBox(
                width: 190,
                child: Column(
                  crossAxisAlignment: CrossAxisAlignment.start,
                  children: [
                    const SizedBox(height: 10),

                    Text(
                      'Estimate Smarter'.tr,
                      style: TextStyle(
                        color: Colors.black,
                        fontSize: 21,
                        fontWeight: FontWeight.w500,
                      ),
                    ),

                    Text(
                      'Price Better.'.tr,
                      style: TextStyle(
                        color: AppColors.primary,
                        fontSize: 21,
                        fontWeight: FontWeight.w500,
                      ),
                    ),
                    SizedBox(height: 8),
                    Text(
                      'Get an AI-powered estimate of your\n property value in seconds.'
                          .tr,
                      maxLines: 2,
                      style: TextStyle(
                        color: Colors.black.withOpacity(0.85),
                        fontSize: 10.5.sp,
                        height: 1.4,
                      ),
                    ),
                  ],
                ),
              ),
            ),

            /// Floating Estimate Card
            Positioned(
              right: 10.w,
              top: 45.h, // Adjust this value to move up/down
              child: SizedBox(width: 150, child: _buildEstimateCard()),
            ),
          ],
        ),
      ),
    );
  }

  Future<void> _showAmenitiesSheet(List<ListingOptionItem> amenities) async {
    final Set<String> tempSelected = {..._selectedAmenityIds};

    await Get.bottomSheet(
      StatefulBuilder(
        builder: (sheetContext, setSheetState) {
          return SafeArea(
            top: false,
            child: Container(
              constraints: BoxConstraints(maxHeight: Get.height * .70),
              decoration: BoxDecoration(
                color: Colors.white,
                borderRadius: BorderRadius.vertical(top: Radius.circular(24.r)),
              ),
              child: Column(
                mainAxisSize: MainAxisSize.min,
                children: [
                  SizedBox(height: 10.h),

                  Container(
                    width: 42.w,
                    height: 4.h,
                    decoration: BoxDecoration(
                      color: const Color(0xFFDADADA),
                      borderRadius: BorderRadius.circular(10.r),
                    ),
                  ),

                  Padding(
                    padding: EdgeInsets.fromLTRB(20.w, 16.h, 10.w, 10.h),
                    child: Row(
                      children: [
                        Expanded(
                          child: Column(
                            crossAxisAlignment: CrossAxisAlignment.start,
                            children: [
                              Text(
                                "Select Amenities".tr,
                                style: TextStyle(
                                  fontSize: 17.sp,
                                  fontWeight: FontWeight.w700,
                                  color: AppColors.textPrimary,
                                ),
                              ),
                              SizedBox(height: 3.h),
                              Text(
                                "You can select multiple amenities".tr,
                                style: TextStyle(
                                  fontSize: 11.sp,
                                  color: AppColors.textSecondary,
                                ),
                              ),
                            ],
                          ),
                        ),
                        IconButton(
                          onPressed: Get.back,
                          icon: Icon(
                            Icons.close_rounded,
                            color: Colors.grey.shade600,
                          ),
                        ),
                      ],
                    ),
                  ),

                  Divider(height: 1, color: Colors.grey.shade200),

                  Flexible(
                    child: ListView.separated(
                      shrinkWrap: true,
                      padding: EdgeInsets.symmetric(vertical: 8.h),
                      itemCount: amenities.length,
                      separatorBuilder: (_, __) => Divider(
                        height: 1,
                        indent: 20.w,
                        endIndent: 20.w,
                        color: Colors.grey.shade100,
                      ),
                      itemBuilder: (context, index) {
                        final amenity = amenities[index];

                        final bool selected = tempSelected.contains(amenity.id);

                        return InkWell(
                          onTap: () {
                            setSheetState(() {
                              if (selected) {
                                tempSelected.remove(amenity.id);
                              } else {
                                tempSelected.add(amenity.id);
                              }
                            });
                          },
                          child: Padding(
                            padding: EdgeInsets.symmetric(
                              horizontal: 20.w,
                              vertical: 14.h,
                            ),
                            child: Row(
                              children: [
                                _buildAmenityImage(amenity, selected),

                                SizedBox(width: 12.w),

                                Expanded(
                                  child: Text(
                                    amenity.title,
                                    style: TextStyle(
                                      fontSize: 13.sp,
                                      fontWeight: selected
                                          ? FontWeight.w600
                                          : FontWeight.w400,
                                      color: selected
                                          ? AppColors.primary
                                          : AppColors.textPrimary,
                                    ),
                                  ),
                                ),

                                AnimatedContainer(
                                  duration: const Duration(milliseconds: 150),
                                  width: 22.w,
                                  height: 22.w,
                                  decoration: BoxDecoration(
                                    color: selected
                                        ? AppColors.primary
                                        : Colors.white,
                                    borderRadius: BorderRadius.circular(6.r),
                                    border: Border.all(
                                      color: selected
                                          ? AppColors.primary
                                          : Colors.grey.shade400,
                                    ),
                                  ),
                                  child: selected
                                      ? Icon(
                                          Icons.check,
                                          size: 15.sp,
                                          color: Colors.white,
                                        )
                                      : null,
                                ),
                              ],
                            ),
                          ),
                        );
                      },
                    ),
                  ),

                  Divider(height: 1, color: Colors.grey.shade200),

                  Padding(
                    padding: EdgeInsets.fromLTRB(20.w, 12.h, 20.w, 16.h),
                    child: Row(
                      children: [
                        if (tempSelected.isNotEmpty)
                          TextButton(
                            onPressed: () {
                              setSheetState(tempSelected.clear);
                            },
                            child: Text(
                              "Clear All",
                              style: TextStyle(
                                color: AppColors.textSecondary,
                                fontSize: 12.sp,
                              ),
                            ),
                          ),

                        const Spacer(),

                        Text(
                          "${tempSelected.length} selected",
                          style: TextStyle(
                            fontSize: 11.sp,
                            color: AppColors.textSecondary,
                          ),
                        ),

                        SizedBox(width: 12.w),

                        ElevatedButton(
                          onPressed: () {
                            setState(() {
                              _selectedAmenityIds
                                ..clear()
                                ..addAll(tempSelected);
                            });

                            Get.back();
                          },
                          style: ElevatedButton.styleFrom(
                            backgroundColor: AppColors.primary,
                            foregroundColor: Colors.white,
                          ),
                          child: Text("Apply".tr),
                        ),
                      ],
                    ),
                  ),
                ],
              ),
            ),
          );
        },
      ),
      isScrollControlled: true,
      backgroundColor: Colors.transparent,
    );
  }

  Widget _buildAmenityImage(ListingOptionItem amenity, bool selected) {
    final String? image = amenity.image;

    return Container(
      width: 36.w,
      height: 36.w,
      decoration: BoxDecoration(
        color: selected
            ? AppColors.primary.withOpacity(.08)
            : const Color(0xFFF6F6F8),
        borderRadius: BorderRadius.circular(9.r),
      ),
      clipBehavior: Clip.antiAlias,
      child:
          image != null &&
              image.trim().isNotEmpty &&
              (image.startsWith('http://') || image.startsWith('https://'))
          ? Image.network(
              image,
              fit: BoxFit.cover,
              errorBuilder: (_, __, ___) {
                return Icon(
                  _amenityIcon(amenity.title),
                  size: 18.sp,
                  color: selected ? AppColors.primary : const Color(0xff606477),
                );
              },
            )
          : Icon(
              _amenityIcon(amenity.title),
              size: 18.sp,
              color: selected ? AppColors.primary : const Color(0xff606477),
            ),
    );
  }

  Widget _buildEstimateCard() {
    return GetBuilder<AiPriceEstimatorController>(
      builder: (controller) {
        final result = controller.estimation;

        return Container(
          width: 190,
          padding: const EdgeInsets.symmetric(horizontal: 12, vertical: 10),
          decoration: BoxDecoration(
            color: AppColors.surface,
            borderRadius: BorderRadius.circular(10.r),
            boxShadow: [
              BoxShadow(
                color: Colors.black.withOpacity(0.15),
                blurRadius: 14,
                offset: const Offset(0, 6),
              ),
            ],
          ),
          child: Column(
            crossAxisAlignment: CrossAxisAlignment.start,
            children: [
              const Text(
                'Estimated Price',
                style: TextStyle(
                  fontSize: 10.5,
                  color: AppColors.textSecondary,
                ),
              ),

              const SizedBox(height: 2),

              Text(
                result == null
                    ? 'Get an estimate'.tr
                    : _formatQar(result.averagePrice),
                maxLines: 1,
                overflow: TextOverflow.ellipsis,
                style: const TextStyle(
                  fontSize: 15,
                  fontWeight: FontWeight.w700,
                  color: AppColors.primary,
                ),
              ),

              const SizedBox(height: 2),

              Text(
                result == null
                    ? 'Enter property details below'.tr
                    : '${_formatCompactQar(result.minPrice)} - ${_formatCompactQar(result.maxPrice)}',
                maxLines: 1,
                overflow: TextOverflow.ellipsis,
                style: const TextStyle(
                  fontSize: 10,
                  color: AppColors.textSecondary,
                ),
              ),
            ],
          ),
        );
      },
    );
  }

  String _formatCompactQar(double value) {
    if (value >= 1000000) {
      final double millions = value / 1000000;

      return "QAR ${millions.toStringAsFixed(millions % 1 == 0 ? 0 : 2)}M";
    }

    if (value >= 1000) {
      final double thousands = value / 1000;

      return "QAR ${thousands.toStringAsFixed(thousands % 1 == 0 ? 0 : 1)}K";
    }

    return "QAR ${value.round()}";
  }

  Widget _sectionLabel(String text) {
    return Padding(
      padding: const EdgeInsets.only(bottom: 8),
      child: Text(
        text,
        style: const TextStyle(
          fontSize: 13,
          fontWeight: FontWeight.w600,
          color: AppColors.textPrimary,
        ),
      ),
    );
  }

  Widget _textField({required String hint, required IconData icon}) {
    return Container(
      decoration: BoxDecoration(
        color: AppColors.surface,
        borderRadius: BorderRadius.circular(12),
        border: Border.all(color: AppColors.divider),
      ),
      child: TextField(
        decoration: InputDecoration(
          hintText: hint,
          hintStyle: const TextStyle(
            color: AppColors.textSecondary,
            fontSize: 13,
          ),
          prefixIcon: Icon(icon, color: AppColors.primary, size: 20),
          border: InputBorder.none,
          contentPadding: const EdgeInsets.symmetric(vertical: 14),
        ),
      ),
    );
  }

  Widget _buildTypeGrid() {
    return SingleChildScrollView(
      scrollDirection: Axis.horizontal,
      child: Row(
        children: List.generate(_types.length, (i) {
          final selected = _selectedType == i;

          return Padding(
            padding: EdgeInsets.only(right: i == _types.length - 1 ? 0 : 10),
            child: InkWell(
              onTap: () => setState(() => _selectedType = i),
              borderRadius: BorderRadius.circular(12),
              child: Container(
                width: 75.w, // Fixed width
                height: 75.h, // Fixed height
                decoration: BoxDecoration(
                  color: selected ? AppColors.primary : AppColors.surface,
                  borderRadius: BorderRadius.circular(12),
                  border: Border.all(
                    color: selected ? AppColors.primary : AppColors.divider,
                  ),
                ),
                child: Column(
                  mainAxisAlignment: MainAxisAlignment.center,
                  children: [
                    Icon(
                      _types[i].icon,
                      size: 22,
                      color: selected ? Colors.white : AppColors.primary,
                    ),
                    SizedBox(height: 8),
                    Text(
                      _types[i].label,
                      textAlign: TextAlign.center,
                      style: TextStyle(
                        fontSize: 10.sp,
                        fontWeight: FontWeight.w600,
                        color: selected ? Colors.white : AppColors.textPrimary,
                      ),
                    ),
                  ],
                ),
              ),
            ),
          );
        }),
      ),
    );
  }

  Widget _buildDetailGrid() {
    return GetBuilder<ListPropertyController>(
      builder: (listingController) {
        if (listingController.isLoading &&
            listingController.furnishingOptions.isEmpty) {
          return const Center(
            child: Padding(
              padding: EdgeInsets.all(20),
              child: CircularProgressIndicator(color: AppColors.primary),
            ),
          );
        }

        return Column(
          children: [
            Row(
              children: [
                Expanded(
                  child: _detailCard(
                    icon: Icons.bed_outlined,
                    title: "BHK".tr,
                    value: _selectedBhk?.toString() ?? "Select".tr,
                    onTap: () {
                      _showOptionSheet<int>(
                        title: "Select BHK",
                        options: const [1, 2, 3, 4, 5, 6],
                        labelBuilder: (value) => "$value BHK",
                        selectedValue: _selectedBhk,
                        onSelected: (value) {
                          setState(() {
                            _selectedBhk = value;
                          });
                        },
                      );
                    },
                  ),
                ),
                SizedBox(width: 12.w),
                Expanded(
                  child: _detailCard(
                    icon: Icons.bathtub_outlined,
                    title: "Bathrooms".tr,
                    value: _selectedBathrooms?.toString() ?? "Select".tr,
                    onTap: () {
                      _showOptionSheet<int>(
                        title: "Select Bathrooms".tr,
                        options: const [1, 2, 3, 4, 5, 6],
                        labelBuilder: (value) =>
                            "$value Bathroom${value > 1 ? 's' : ''}",
                        selectedValue: _selectedBathrooms,
                        onSelected: (value) {
                          setState(() {
                            _selectedBathrooms = value;
                          });
                        },
                      );
                    },
                  ),
                ),
              ],
            ),

            SizedBox(height: 10.h),

            Row(
              children: [
                Expanded(
                  child: _detailCard(
                    icon: Icons.chair_outlined,
                    title: "Furnishing".tr,
                    value: _selectedFurnishing?.title ?? "Select".tr,
                    onTap: () {
                      if (listingController.furnishingOptions.isEmpty) {
                        Fluttertoast.showToast(
                          msg: "Furnishing options are not available.".tr,
                          gravity: ToastGravity.BOTTOM,
                        );
                        return;
                      }

                      _showOptionSheet<FurnishingOption>(
                        title: "Select Furnishing".tr,
                        options: listingController.furnishingOptions,
                        labelBuilder: (item) => item.title,
                        selectedValue: _selectedFurnishing,
                        onSelected: (item) {
                          setState(() {
                            _selectedFurnishing = item;
                          });
                        },
                      );
                    },
                  ),
                ),

                SizedBox(width: 12.w),

                Expanded(
                  child: _detailCard(
                    icon: Icons.layers_outlined,
                    title: "Floor".tr,
                    value: _selectedFloor?.toString() ?? "Any".tr,
                    onTap: () {
                      _showOptionSheet<int>(
                        title: "Select Floor".tr,
                        options: List.generate(50, (index) => index),
                        labelBuilder: (value) =>
                            value == 0 ? "Ground Floor".tr : "Floor $value",
                        selectedValue: _selectedFloor,
                        onSelected: (value) {
                          setState(() {
                            _selectedFloor = value;

                            if (_selectedTotalFloors != null &&
                                value > _selectedTotalFloors!) {
                              _selectedTotalFloors = value;
                            }
                          });
                        },
                      );
                    },
                  ),
                ),
              ],
            ),

            SizedBox(height: 10.h),

            Row(
              children: [
                Expanded(
                  child: _detailCard(
                    icon: Icons.apartment_outlined,
                    title: "Total Floors".tr,
                    value: _selectedTotalFloors?.toString() ?? "Any".tr,
                    onTap: () {
                      _showOptionSheet<int>(
                        title: "Select Total Floors".tr,
                        options: List.generate(50, (index) => index + 1),
                        labelBuilder: (value) =>
                            "$value Floor${value > 1 ? 's' : ''}",
                        selectedValue: _selectedTotalFloors,
                        onSelected: (value) {
                          setState(() {
                            _selectedTotalFloors = value;

                            if (_selectedFloor != null &&
                                _selectedFloor! > value) {
                              _selectedFloor = value;
                            }
                          });
                        },
                      );
                    },
                  ),
                ),

                SizedBox(width: 12.w),

                Expanded(
                  child: _detailCard(
                    icon: Icons.calendar_today_outlined,
                    title: "Age of Property".tr,
                    value: _selectedPropertyAge ?? "Any".tr,
                    onTap: () {
                      _showOptionSheet<String>(
                        title: "Select Property Age".tr,
                        options: [
                          "New / Under 1 Year".tr,
                          "1 - 5 Years".tr,
                          "5 - 10 Years".tr,
                          "10+ Years".tr,
                        ],
                        labelBuilder: (value) => value,
                        selectedValue: _selectedPropertyAge,
                        onSelected: (value) {
                          setState(() {
                            _selectedPropertyAge = value;
                          });
                        },
                      );
                    },
                  ),
                ),
              ],
            ),

            SizedBox(height: 10.h),

            _detailCard(
              icon: Icons.directions_car_outlined,
              title: "Parking".tr,
              value: _parkingAvailable == null
                  ? "Any".tr
                  : _parkingAvailable!
                  ? "Available".tr
                  : "Not Available".tr,
              fullWidth: true,
              onTap: () {
                _showOptionSheet<bool>(
                  title: "Select Parking Availability".tr,
                  options: const [true, false],
                  labelBuilder: (value) =>
                      value ? "Available".tr : "Not Available".tr,
                  selectedValue: _parkingAvailable,
                  onSelected: (value) {
                    setState(() {
                      _parkingAvailable = value;
                    });
                  },
                );
              },
            ),
          ],
        );
      },
    );
  }

  Widget _detailCard({
    required IconData icon,
    required String title,
    required String value,
    required VoidCallback onTap,
    bool fullWidth = false,
  }) {
    return Material(
      color: Colors.transparent,
      child: InkWell(
        onTap: onTap,
        borderRadius: BorderRadius.circular(10.r),
        child: Container(
          width: fullWidth ? double.infinity : null,
          height: 74.h,
          padding: EdgeInsets.symmetric(horizontal: 16.w),
          decoration: BoxDecoration(
            color: Colors.white,
            borderRadius: BorderRadius.circular(10.r),
            border: Border.all(color: const Color(0xFFE9EAF3)),
            boxShadow: [
              BoxShadow(
                color: Colors.black.withOpacity(.03),
                blurRadius: 12,
                offset: const Offset(0, 3),
              ),
            ],
          ),
          child: Row(
            children: [
              Icon(icon, size: 20.sp, color: const Color(0xff1E2344)),

              SizedBox(width: 10.w),

              Expanded(
                child: Column(
                  mainAxisAlignment: MainAxisAlignment.center,
                  crossAxisAlignment: CrossAxisAlignment.start,
                  children: [
                    Text(
                      title,
                      maxLines: 1,
                      overflow: TextOverflow.ellipsis,
                      style: TextStyle(
                        fontSize: 10.sp,
                        fontWeight: FontWeight.w700,
                        color: const Color(0xff1E2344),
                      ),
                    ),

                    SizedBox(height: 4.h),

                    Text(
                      value,
                      maxLines: 1,
                      overflow: TextOverflow.ellipsis,
                      style: TextStyle(
                        fontSize: 11.sp,
                        color: value == "Select" || value == "Any".tr
                            ? const Color(0xff8C91A6)
                            : AppColors.primary,
                        fontWeight: FontWeight.w500,
                      ),
                    ),
                  ],
                ),
              ),

              Icon(
                Icons.keyboard_arrow_down_rounded,
                size: 24.sp,
                color: const Color(0xff1E2344),
              ),
            ],
          ),
        ),
      ),
    );
  }

  Widget _buildHighlightsField() {
    return Container(
      decoration: BoxDecoration(
        color: AppColors.surface,
        borderRadius: BorderRadius.circular(12),
        border: Border.all(color: AppColors.divider),
      ),
      padding: const EdgeInsets.symmetric(horizontal: 12, vertical: 4),
      child: Column(
        crossAxisAlignment: CrossAxisAlignment.end,
        children: [
          TextField(
            controller: _highlightsController,
            maxLength: 100,
            maxLines: 2,
            onChanged: (_) => setState(() {}),
            decoration: InputDecoration(
              hintText: 'e.g. Sea view, Near metro, Gated community...'.tr,
              hintStyle: TextStyle(
                color: AppColors.textSecondary,
                fontSize: 12.5,
              ),
              border: InputBorder.none,
              counterText: '',
              contentPadding: EdgeInsets.symmetric(vertical: 10),
            ),
          ),
          Padding(
            padding: const EdgeInsets.only(bottom: 6),
            child: Text(
              '${_highlightsController.text.length}/100',
              style: TextStyle(
                fontSize: 10.5.sp,
                color: AppColors.textSecondary,
              ),
            ),
          ),
        ],
      ),
    );
  }

  Widget _buildCta() {
    return GetBuilder<AiPriceEstimatorController>(
      builder: (controller) {
        return InkWell(
          onTap: controller.isLoading ? null : () => _estimatePrice(controller),
          borderRadius: BorderRadius.circular(14.r),
          child: Container(
            width: double.infinity,
            padding: EdgeInsets.symmetric(vertical: 16.h),
            decoration: BoxDecoration(
              gradient: AppColors.buttonGradient,
              borderRadius: BorderRadius.circular(14.r),
              boxShadow: [
                BoxShadow(
                  color: AppColors.primary.withOpacity(0.35),
                  blurRadius: 14.r,
                  offset: const Offset(0, 6),
                ),
              ],
            ),
            child: controller.isLoading
                ? Center(
                    child: SizedBox(
                      width: 22.w,
                      height: 22.w,
                      child: const CircularProgressIndicator(
                        strokeWidth: 2,
                        color: Colors.white,
                      ),
                    ),
                  )
                : Row(
                    mainAxisAlignment: MainAxisAlignment.center,
                    children: [
                      Icon(
                        Icons.auto_awesome,
                        color: Colors.white,
                        size: 18.sp,
                      ),

                      SizedBox(width: 8.w),

                      Column(
                        mainAxisSize: MainAxisSize.min,
                        crossAxisAlignment: CrossAxisAlignment.start,
                        children: [
                          Text(
                            'Get AI Estimate'.tr,
                            style: TextStyle(
                              color: Colors.white,
                              fontWeight: FontWeight.w700,
                              fontSize: 14.5.sp,
                            ),
                          ),
                          Text(
                            'View estimated price & range'.tr,
                            style: TextStyle(
                              color: Colors.white70,
                              fontSize: 10.5.sp,
                            ),
                          ),
                        ],
                      ),

                      SizedBox(width: 10.w),

                      const Icon(
                        Icons.arrow_forward,
                        color: Colors.white,
                        size: 18,
                      ),
                    ],
                  ),
          ),
        );
      },
    );
  }

  Future<void> _estimatePrice(AiPriceEstimatorController controller) async {
    final String areaName = _locationController.text.trim();

    final double? areaSqft = double.tryParse(_areaController.text.trim());
    final List<String> highlightParts = [];

    final listingController = Get.find<ListPropertyController>();

    final selectedAmenityTitles = listingController.amenities
        .where((item) => _selectedAmenityIds.contains(item.id))
        .map((item) => item.title)
        .toList();

    if (selectedAmenityTitles.isNotEmpty) {
      highlightParts.add(selectedAmenityTitles.join(', '));
    }

    if (_highlightsController.text.trim().isNotEmpty) {
      highlightParts.add(_highlightsController.text.trim());
    }

    final String combinedHighlights = highlightParts.join(', ');

    // ============================================================
    // VALIDATION
    // ============================================================

    if (areaName.isEmpty) {
      Fluttertoast.showToast(
        msg: "Please enter the property location.".tr,
        gravity: ToastGravity.BOTTOM,
      );
      return;
    }

    if (areaSqft == null || areaSqft <= 0) {
      Fluttertoast.showToast(
        msg: "Please enter a valid property area.".tr,
        gravity: ToastGravity.BOTTOM,
      );
      return;
    }

    if (_selectedBhk == null) {
      Fluttertoast.showToast(
        msg: "Please select BHK.".tr,
        gravity: ToastGravity.BOTTOM,
      );
      return;
    }

    if (_selectedBathrooms == null) {
      Fluttertoast.showToast(
        msg: "Please select bathrooms.".tr,
        gravity: ToastGravity.BOTTOM,
      );
      return;
    }

    if (_selectedFurnishing == null) {
      Fluttertoast.showToast(
        msg: "Please select furnishing status.".tr,
        gravity: ToastGravity.BOTTOM,
      );
      return;
    }

    // ============================================================
    // API CALL
    // ============================================================

    final bool success = await controller.estimatePrice(
      areaName: areaName,
      areaSqft: areaSqft,

      /// API-safe value instead of UI label
      propertyType: _types[_selectedType].apiValue,

      bhk: _selectedBhk!,
      bathrooms: _selectedBathrooms!,

      furnishingStatus: _selectedFurnishing!.title,

      floorAbove: _selectedFloor ?? 0,

      totalFloors: _selectedTotalFloors ?? 0,

      parkingAvailable: _parkingAvailable ?? false,

      highlights: combinedHighlights,
    );

    if (!mounted) {
      return;
    }

    if (success) {
      _showEstimateResult(controller);
    } else {
      Fluttertoast.showToast(
        msg: controller.error.isNotEmpty
            ? controller.error
            : "Unable to estimate price.".tr,
        toastLength: Toast.LENGTH_LONG,
        gravity: ToastGravity.BOTTOM,
      );
    }
  }

  void _showEstimateResult(AiPriceEstimatorController controller) {
    final result = controller.estimation;

    if (result == null) {
      return;
    }

    Get.bottomSheet(
      SafeArea(
        top: false,
        child: Container(
          padding: EdgeInsets.fromLTRB(20.w, 12.h, 20.w, 24.h),
          decoration: BoxDecoration(
            color: Colors.white,
            borderRadius: BorderRadius.vertical(top: Radius.circular(24.r)),
          ),
          child: Column(
            mainAxisSize: MainAxisSize.min,
            children: [
              Container(
                width: 42.w,
                height: 4.h,
                decoration: BoxDecoration(
                  color: const Color(0xFFDADADA),
                  borderRadius: BorderRadius.circular(10.r),
                ),
              ),

              SizedBox(height: 20.h),

              Container(
                width: 54.w,
                height: 54.w,
                decoration: BoxDecoration(
                  color: AppColors.primary.withOpacity(.08),
                  shape: BoxShape.circle,
                ),
                child: Icon(
                  Icons.auto_awesome_rounded,
                  color: AppColors.primary,
                  size: 26.sp,
                ),
              ),

              SizedBox(height: 14.h),

              Text(
                "AI Estimated Value".tr,
                style: TextStyle(
                  fontSize: 13.sp,
                  color: AppColors.textSecondary,
                ),
              ),

              SizedBox(height: 5.h),

              Text(
                _formatQar(result.averagePrice),
                style: TextStyle(
                  fontSize: 23.sp,
                  fontWeight: FontWeight.w600,
                  color: AppColors.primary,
                ),
              ),

              SizedBox(height: 20.h),

              Container(
                padding: EdgeInsets.all(16.w),
                decoration: BoxDecoration(
                  color: AppColors.background,
                  borderRadius: BorderRadius.circular(14.r),
                  border: Border.all(color: AppColors.divider),
                ),
                child: Row(
                  children: [
                    Expanded(
                      child: _priceResultItem(
                        "Minimum".tr,
                        _formatQar(result.minPrice),
                      ),
                    ),

                    Container(width: 1, height: 40.h, color: AppColors.divider),

                    Expanded(
                      child: _priceResultItem(
                        "Maximum".tr,
                        _formatQar(result.maxPrice),
                      ),
                    ),
                  ],
                ),
              ),

              SizedBox(height: 20.h),

              SizedBox(
                width: double.infinity,
                height: 48.h,
                child: ElevatedButton(
                  onPressed: Get.back,
                  style: ElevatedButton.styleFrom(
                    backgroundColor: AppColors.primary,
                    foregroundColor: Colors.white,
                    elevation: 0,
                    shape: RoundedRectangleBorder(
                      borderRadius: BorderRadius.circular(12.r),
                    ),
                  ),
                  child: Text(
                    "Done".tr,
                    style: TextStyle(fontWeight: FontWeight.w700),
                  ),
                ),
              ),
            ],
          ),
        ),
      ),
      isScrollControlled: true,
      backgroundColor: Colors.transparent,
    );
  }

  Widget _priceResultItem(String title, String price) {
    return Column(
      children: [
        Text(
          title,
          style: TextStyle(fontSize: 11.sp, color: AppColors.textSecondary),
        ),
        SizedBox(height: 5.h),
        Text(
          price,
          textAlign: TextAlign.center,
          style: TextStyle(
            fontSize: 13.sp,
            fontWeight: FontWeight.w700,
            color: AppColors.textPrimary,
          ),
        ),
      ],
    );
  }

  String _formatQar(double value) {
    final String digits = value.round().toString();

    final String formatted = digits.replaceAllMapped(
      RegExp(r'\B(?=(\d{3})+(?!\d))'),
      (match) => ',',
    );

    return "QAR $formatted";
  }

  Widget _buildFooterNote() {
    return Row(
      mainAxisAlignment: MainAxisAlignment.center,
      children: [
        Icon(Icons.lock_outline, size: 13.sp, color: AppColors.textSecondary),
        SizedBox(width: 6.w),
        Text(
          'Your information is secure and private'.tr,
          style: TextStyle(fontSize: 11.sp, color: AppColors.textSecondary),
        ),
      ],
    );
  }
}

Future<void> _showOptionSheet<T>({
  required String title,
  required List<T> options,
  required String Function(T value) labelBuilder,
  required T? selectedValue,
  required ValueChanged<T> onSelected,
}) async {
  await Get.bottomSheet(
    SafeArea(
      top: false,
      child: Container(
        constraints: BoxConstraints(maxHeight: Get.height * .65),
        decoration: BoxDecoration(
          color: Colors.white,
          borderRadius: BorderRadius.vertical(top: Radius.circular(24.r)),
        ),
        child: Column(
          mainAxisSize: MainAxisSize.min,
          children: [
            SizedBox(height: 10.h),

            Container(
              width: 42.w,
              height: 4.h,
              decoration: BoxDecoration(
                color: const Color(0xFFDADADA),
                borderRadius: BorderRadius.circular(10.r),
              ),
            ),

            Padding(
              padding: EdgeInsets.fromLTRB(20.w, 18.h, 10.w, 12.h),
              child: Row(
                children: [
                  Expanded(
                    child: Text(
                      title,
                      style: TextStyle(
                        fontSize: 17.sp,
                        fontWeight: FontWeight.w700,
                        color: AppColors.textPrimary,
                      ),
                    ),
                  ),

                  IconButton(
                    onPressed: () => Get.back(),
                    icon: Icon(
                      Icons.close_rounded,
                      color: Colors.grey.shade600,
                    ),
                  ),
                ],
              ),
            ),

            Divider(height: 1, color: Colors.grey.shade200),

            Flexible(
              child: ListView.separated(
                shrinkWrap: true,
                padding: EdgeInsets.symmetric(vertical: 8.h),
                itemCount: options.length,
                separatorBuilder: (_, __) => Divider(
                  height: 1,
                  indent: 20.w,
                  endIndent: 20.w,
                  color: Colors.grey.shade100,
                ),
                itemBuilder: (itemContext, index) {
                  final T value = options[index];

                  final bool selected = value == selectedValue;

                  return InkWell(
                    onTap: () {
                      onSelected(value);

                      Get.back();
                    },
                    child: Padding(
                      padding: EdgeInsets.symmetric(
                        horizontal: 20.w,
                        vertical: 15.h,
                      ),
                      child: Row(
                        children: [
                          Expanded(
                            child: Text(
                              labelBuilder(value),
                              style: TextStyle(
                                fontSize: 13.sp,
                                fontWeight: selected
                                    ? FontWeight.w600
                                    : FontWeight.w400,
                                color: selected
                                    ? AppColors.primary
                                    : AppColors.textPrimary,
                              ),
                            ),
                          ),

                          Icon(
                            selected
                                ? Icons.radio_button_checked
                                : Icons.radio_button_off,
                            color: selected
                                ? AppColors.primary
                                : Colors.grey.shade400,
                            size: 20.sp,
                          ),
                        ],
                      ),
                    ),
                  );
                },
              ),
            ),

            SizedBox(height: 10.h),
          ],
        ),
      ),
    ),
    isScrollControlled: true,
    backgroundColor: Colors.transparent,
  );
}

String _formatOption(String value) {
  return value
      .replaceAll("_", " ")
      .split(" ")
      .map(
        (word) => word.isEmpty
            ? word
            : "${word[0].toUpperCase()}${word.substring(1).toLowerCase()}",
      )
      .join(" ");
}

class _PropertyType {
  final String label;
  final IconData icon;
  final String apiValue;

  const _PropertyType(this.label, this.icon, {required this.apiValue});
}
