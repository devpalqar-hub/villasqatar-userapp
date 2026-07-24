import 'dart:io';

import 'package:flutter/material.dart';
import 'package:flutter/services.dart';
import 'package:flutter_screenutil/flutter_screenutil.dart';
import 'package:get/get_core/get_core.dart';
import 'package:get/get_instance/src/extension_instance.dart';
import 'package:get/get_navigation/src/extension_navigation.dart';
import 'package:get/get_state_manager/src/simple/get_state.dart';
import 'package:get/get_utils/src/extensions/internacionalization.dart';
import 'package:image_picker/image_picker.dart';
import 'package:villas_qatar/Core/constants/app_colors.dart';
import 'package:villas_qatar/Core/widgets/primary_button.dart';
import 'package:villas_qatar/modules/mainscreen/mainscreen.dart';
import 'package:villas_qatar/modules/propertylist/service/listproperty_controller.dart';

class ListYourPropertyScreen extends StatefulWidget {
  const ListYourPropertyScreen({super.key});

  @override
  State<ListYourPropertyScreen> createState() => _ListYourPropertyScreenState();
}

class _ListYourPropertyScreenState extends State<ListYourPropertyScreen> {
  final ListPropertyController controller = Get.put(ListPropertyController());
  final ImagePicker _picker = ImagePicker();

  final descriptionCtrl = TextEditingController();
  String currency = 'QAR';



  String? zoneArea;
  String city = 'Doha';
  String country = 'Qatar';
  String propertyPosition = 'Residential'; // 'Residential' | 'Commercial'

  final List<String> stepLabels =  [
    'Basic Info'.tr,
    'Details'.tr,
    'Features'.tr,
    'Location'.tr,
    'Media'.tr,
  ];

  @override
  void _goNext() {
    controller.nextStep();
  }

  void _goBack() {
    controller.previousStep();
  }

  @override
  Widget build(BuildContext context) {
    return GetBuilder<ListPropertyController>(
      builder: (controller) {
        return Scaffold(
          bottomNavigationBar: SafeArea(
            top: false,
            child: Container(
              padding: const EdgeInsets.fromLTRB(20, 12, 20, 20),
              decoration: BoxDecoration(
                color: Colors.white,
                borderRadius: const BorderRadius.vertical(
                  top: Radius.circular(20),
                ),
                boxShadow: [
                  BoxShadow(
                    color: Colors.black.withOpacity(.08),
                    blurRadius: 16,
                    offset: const Offset(0, -4),
                  ),
                ],
              ),
              child: _buildBottomButton(),
            ),
          ),
          body: Stack(
            children: [
              /// Full screen background
              Positioned.fill(
                child: Image.asset("assets/bg2.png", fit: BoxFit.cover),
              ),

              /// Screen Content
              SafeArea(
                child: Column(
                  children: [
                    _buildTopBar(),
                    _buildStepper(),
                    Expanded(
                      child: SingleChildScrollView(
                        padding: EdgeInsets.fromLTRB(20, 16, 20, 100),
                        child: Column(
                          children: [_buildCard(), const SizedBox(height: 20)],
                        ),
                      ),
                    ),
                  ],
                ),
              ),
            ],
          ),
        );
      },
    );
  }

  Widget _buildTopBar() {
    return Padding(
      padding: const EdgeInsets.fromLTRB(12, 8, 16, 8),
      child: Row(
        children: [
          IconButton(
            icon: const Icon(Icons.arrow_back, color: AppColors.primary),
            onPressed: controller.currentStep > 0
                ? _goBack
                : () {
                    Get.offAll(() => const MainScreen(initialIndex: 2));
                  },
          ),
          Expanded(
            child: Text(
              'List Your Property'.tr,
              textAlign: TextAlign.center,
              style: TextStyle(
                fontSize: 18,
                fontWeight: FontWeight.w700,
                color: Colors.black87,
              ),
            ),
          ),
          // TextButton.icon(
          //   onPressed: () {},
          //   style: TextButton.styleFrom(
          //     foregroundColor: AppColors.primary,
          //     padding: EdgeInsets.zero,
          //   ),
          //   icon: const Icon(Icons.description_outlined, size: 18),
          //   label: const Text(
          //     'Save Draft',
          //     style: TextStyle(fontWeight: FontWeight.w600, fontSize: 13),
          //   ),
          // ),
        ],
      ),
    );
  }

  // ---------------------------------------------------------
  // STEPPER (1 - 5) with connecting lines
  // ---------------------------------------------------------
  Widget _buildStepper() {
    return Padding(
      padding: const EdgeInsets.symmetric(horizontal: 16, vertical: 8),
      child: Row(
        children: List.generate(stepLabels.length * 2 - 1, (index) {
          if (index.isOdd) {
            final leftStep = (index ~/ 2) + 1;
            final isCompleted = leftStep < controller.currentStep + 1;
            return Expanded(
              child: Container(
                height: 2,
                margin: const EdgeInsets.only(bottom: 20),
                color: isCompleted ? AppColors.primary : (Color(0xFFE3E1E6)),
              ),
            );
          }
          final stepNumber = (index ~/ 2) + 1;
          return _StepCircle(
            number: stepNumber,
            label: stepLabels[stepNumber - 1],
            state: stepNumber < controller.currentStep + 1
                ? _StepState.completed
                : stepNumber == controller.currentStep + 1
                ? _StepState.active
                : _StepState.inactive,
          );
        }),
      ),
    );
  }

  Widget _buildCard() {
    return Container(
      width: double.infinity,
      padding: const EdgeInsets.all(20),
      decoration: BoxDecoration(
        color: AppColors.cardBg,
        borderRadius: BorderRadius.circular(16),
        border: Border.all(color: AppColors.fieldBorder),
      ),
      child: AnimatedSwitcher(
        duration: const Duration(milliseconds: 250),
        child: _stepContent(),
      ),
    );
  }

  Widget _stepContent() {
    switch (controller.currentStep + 1) {
      case 1:
        return _buildStep1(key: const ValueKey('step1'));
      case 2:
        return _buildStep2(key: const ValueKey('step2'));
      case 3:
        return _buildStep3(key: const ValueKey('step3'));
      case 4:
        return _buildStep4(key: const ValueKey('step4'));
      case 5:
        return _buildStep5(key: const ValueKey('step5'));
      default:
        return const SizedBox.shrink();
    }
  }

  // ---------------------------------------------------------
  // STEP 1 — BASIC INFO
  // ---------------------------------------------------------
  Widget _buildStep1({Key? key}) {
    return Column(
      key: key,
      crossAxisAlignment: CrossAxisAlignment.start,
      children: [
        _sectionHeader(
          icon: Icons.person_outline,
          title: 'Property Owner Details'.tr,
          subtitle: 'Enter your details to get started'.tr,
        ),

        const SizedBox(height: 20),

        _fieldLabel('Full Name'.tr, required: true),
        const SizedBox(height: 8),

        _AppTextField(
          controller: controller.fullNameController,
          hint: 'Enter your full name'.tr,
          prefixIcon: Icons.person_outline,
        ),

        const SizedBox(height: 18),
        _fieldLabel('Contact Number'.tr, required: true),
        const SizedBox(height: 8),

        Row(
          children: [
            _CountryCodeDropdown(
              value: controller.countryCode,
              onChanged: controller.setCountryCode,
            ),
          SizedBox(width: 10),
            Expanded(
              child: _AppTextField(
                controller: controller.phoneController,
                hint: 'Enter mobile number'.tr,
                keyboardType: TextInputType.phone,
                enabled: !controller.whatsappVerified,
              ),
            ),

            if (controller.whatsappVerified) ...[
              const SizedBox(width: 10),
              const Icon(Icons.verified, color: Colors.green, size: 22),
            ],
          ],
        ),
        if (!controller.whatsappVerified && !controller.showOtpField) ...[
          const SizedBox(height: 12),

          SizedBox(
            width: double.infinity,
            child: PrimaryButton(title: "Send OTP".tr, onTap: controller.sendOtp),
          ),
        ],
        if (controller.showOtpField && !controller.whatsappVerified) ...[
          const SizedBox(height: 18),

          _fieldLabel("Verification Code".tr, required: true),

          const SizedBox(height: 8),

          _AppTextField(
            controller: controller.otpController,
            hint: "Enter 6-digit OTP".tr,
            keyboardType: TextInputType.number,
            prefixIcon: Icons.lock_outline,
          ),

          const SizedBox(height: 12),

          SizedBox(
            width: double.infinity,
            child: PrimaryButton(
              title: "Verify OTP".tr,
              onTap: controller.verifyOtp,
            ),
          ),

          Align(
            alignment: Alignment.centerRight,
            child: TextButton(
              onPressed: controller.sendOtp,
              child:  Text("Resend OTP".tr),
            ),
          ),
        ],

        const SizedBox(height: 18),

        _fieldLabel('Email Address'.tr),
        const SizedBox(height: 8),

        _AppTextField(
          controller: controller.emailController,
          hint: 'Enter your email address'.tr,
          prefixIcon: Icons.email_outlined,
          keyboardType: TextInputType.emailAddress,
        ),

        const SizedBox(height: 18),

        _fieldLabel('Short Description'.tr, required: true),
        const SizedBox(height: 8),

        _AppTextField(
          controller: controller.descriptionController,
          hint: 'Write a short description about your property'.tr,
          prefixIcon: Icons.description_outlined,
          maxLines: 4,
          maxLength: 250,
          showCounter: true,
        ),
      ],
    );
  }

  Widget _buildWhatsAppVerifiedBanner() {
    return Container(
      width: double.infinity,
      padding: const EdgeInsets.symmetric(horizontal: 14, vertical: 12),
      decoration: BoxDecoration(
        color: AppColors.greenBg,
        borderRadius: BorderRadius.circular(12),
      ),
      child: Row(
        children: [
          const Icon(Icons.chat, color: Color(0xFF25D366), size: 26),

          const SizedBox(width: 10),

          Expanded(
            child: Column(
              crossAxisAlignment: CrossAxisAlignment.start,
              children: [
                 Text(
                  "WhatsApp Verification".tr,
                  style: TextStyle(
                    color: AppColors.greenText,
                    fontWeight: FontWeight.w700,
                    fontSize: 13,
                  ),
                ),

                const SizedBox(height: 2),

                Text(
                  controller.whatsappVerified
                      ? "Your contact number is verified".tr
                      : "Your contact number is not verified".tr,
                  style: const TextStyle(
                    color: AppColors.greenText,
                    fontSize: 12,
                  ),
                ),
              ],
            ),
          ),

          Switch(
            value: controller.whatsappVerified,
            activeColor: const Color(0xFF25D366),
            onChanged: controller.setWhatsappVerified,
          ),
        ],
      ),
    );
  }

  // ---------------------------------------------------------
  // STEP 2 — PROPERTY DETAILS
  // ---------------------------------------------------------
  Widget _buildStep2({Key? key}) {
    return Column(
      key: key,
      crossAxisAlignment: CrossAxisAlignment.start,
      children: [
        _sectionHeader(
          icon: Icons.home_outlined,
          title: 'Property Details'.tr,
          subtitle: 'Tell us about your property'.tr,
        ),

        const SizedBox(height: 20),

        _fieldLabel('Property Name'.tr, required: true),
        const SizedBox(height: 8),

        _AppTextField(
          controller: controller.propertyNameController,
          hint: 'Enter property name'.tr,
        ),

        const SizedBox(height: 18),

        _fieldLabel('Property Type'.tr, required: true),
        const SizedBox(height: 8),

        _AppDropdownField(
          value: controller.propertyType.isEmpty
              ? null
              : controller.propertyType,
          hint: 'Select property type'.tr,
          icon: Icons.apartment_outlined,
          items:  ["Apartment".tr, "Villa".tr, "Townhouse".tr, "Studio".tr, "Office".tr],
          onChanged: (v) {
            if (v != null) {
              controller.setPropertyType(v);
            }
          },
        ),

        const SizedBox(height: 18),

        Row(
          children: [
            Expanded(
              child: Column(
                crossAxisAlignment: CrossAxisAlignment.start,
                children: [
                  _fieldLabel("Bedrooms".tr, required: true),
                  const SizedBox(height: 8),

                  _AppTextField(
                    controller: controller.bedroomsController,
                    hint: "e.g. 4".tr,
                    keyboardType: TextInputType.number,
                    prefixIcon: Icons.bed_outlined,
                  ),
                ],
              ),
            ),

            const SizedBox(width: 12),

            Expanded(
              child: Column(
                crossAxisAlignment: CrossAxisAlignment.start,
                children: [
                  _fieldLabel("Bathrooms".tr, required: true),
                  const SizedBox(height: 8),

                  _AppTextField(
                    controller: controller.bathroomsController,
                    hint: "e.g. 3".tr,
                    keyboardType: TextInputType.number,
                    prefixIcon: Icons.bathtub_outlined,
                  ),
                ],
              ),
            ),
          ],
        ),

        const SizedBox(height: 18),

        Row(
          children: [
            Expanded(
              child: Column(
                crossAxisAlignment: CrossAxisAlignment.start,
                children: [
                  _fieldLabel("Living Rooms".tr),
                  const SizedBox(height: 8),

                  _AppTextField(
                    controller: controller.livingRoomsController,
                    hint: "e.g. 2".tr,
                    keyboardType: TextInputType.number,
                    prefixIcon: Icons.weekend_outlined,
                  ),
                ],
              ),
            ),

            const SizedBox(width: 12),

            Expanded(
              child: Column(
                crossAxisAlignment: CrossAxisAlignment.start,
                children: [
                  _fieldLabel("Parking Spaces".tr),
                  const SizedBox(height: 8),

                  _AppTextField(
                    controller: controller.parkingSpacesController,
                    hint: "e.g. 2".tr,
                    keyboardType: TextInputType.number,
                    prefixIcon: Icons.local_parking_outlined,
                  ),
                ],
              ),
            ),
          ],
        ),

        const SizedBox(height: 18),

        _fieldLabel("Property For".tr, required: true),
        const SizedBox(height: 8),

        _buildSaleRentToggle(),

        const SizedBox(height: 18),

        _fieldLabel("Price".tr, required: true),
        const SizedBox(height: 8),

        Row(
          children: [
            _CurrencyDropdown(
              value: currency,
              onChanged: (v) {
                setState(() {
                  currency = v;
                });
              },
            ),

            const SizedBox(width: 10),

            Expanded(
              child: _AppTextField(
                controller: controller.priceController,
                hint: "Enter price".tr,
                keyboardType: TextInputType.number,
              ),
            ),
          ],
        ),

        const SizedBox(height: 18),

        _fieldLabel("Area (sqm)".tr, required: true),
        const SizedBox(height: 8),

        _AppTextField(
          controller:  controller.areaNameController,
          hint: "Enter property area".tr,
          keyboardType: TextInputType.number,
          prefixIcon: Icons.square_foot_outlined,
        ),

        const SizedBox(height: 18),

        _fieldLabel("Year Built".tr),
        const SizedBox(height: 8),

        _AppTextField(
          controller: controller.yearBuiltController,
          hint: "e.g. 2024".tr,
          keyboardType: TextInputType.number,
          prefixIcon: Icons.calendar_today_outlined,
        ),

        const SizedBox(height: 18),

        Row(
          children: [
            Expanded(
              child: Column(
                crossAxisAlignment: CrossAxisAlignment.start,
                children: [
                  _fieldLabel("Floor Number".tr),
                  const SizedBox(height: 8),

                  _AppTextField(
                    controller: controller.floorNumberController,
                    hint: "e.g. 5".tr,
                    keyboardType: TextInputType.number,
                    prefixIcon: Icons.layers_outlined,
                  ),
                ],
              ),
            ),

            const SizedBox(width: 12),

            Expanded(
              child: Column(
                crossAxisAlignment: CrossAxisAlignment.start,
                children: [
                  _fieldLabel("Total Floors".tr),
                  const SizedBox(height: 8),

                  _AppTextField(
                    controller: controller.totalFloorsController,
                    hint: "e.g. 20".tr,
                    keyboardType: TextInputType.number,
                    prefixIcon: Icons.apartment_outlined,
                  ),
                ],
              ),
            ),
          ],
        ),
      ],
    );
  }

  Widget _buildSaleRentToggle() {
    return Row(
      children: [
        Expanded(
          child: _ToggleButton(
            label: "Sale".tr,
            icon: Icons.sell_outlined,
            selected: controller.propertyPurpose == "SALE".tr,
            onTap: () => controller.setPropertyPurpose("SALE".tr),
            radius: const BorderRadius.only(
              topLeft: Radius.circular(10),
              bottomLeft: Radius.circular(10),
            ),
          ),
        ),

        Expanded(
          child: _ToggleButton(
            label: "Rent".tr,
            icon: Icons.key_outlined,
            selected: controller.propertyPurpose == "RENT".tr,
            onTap: () => controller.setPropertyPurpose("RENT".tr),
            radius: const BorderRadius.only(
              topRight: Radius.circular(10),
              bottomRight: Radius.circular(10),
            ),
          ),
        ),
      ],
    );
  }

  // ---------------------------------------------------------
  // STEP 3 — FEATURES & AMENITIES
  // ---------------------------------------------------------
  Widget _buildStep3({Key? key}) {
    return Column(
      key: key,
      crossAxisAlignment: CrossAxisAlignment.start,
      children: [
        _sectionHeader(
          icon: Icons.widgets_outlined,
          title: "Features & Amenities".tr,
          subtitle: "Select the amenities and nearby facilities".tr,
        ),

        const SizedBox(height: 20),

        _buildFurnishingSection(),

        const SizedBox(height: 22),

        _buildAmenitiesSection(),

        const SizedBox(height: 22),

        _buildNearbyTagsSection(),

        const SizedBox(height: 22),

        Row(
          children:  [
            Icon(Icons.tune_outlined, size: 18, color: AppColors.primary),
            SizedBox(width: 8),
            Expanded(
              child: Text(
                "Other Features".tr,
                style: TextStyle(fontWeight: FontWeight.w700, fontSize: 14),
              ),
            ),
          ],
        ),

        const SizedBox(height: 4),

       Padding(
          padding: EdgeInsets.only(left: 26),
          child: Text(
            "Add any additional features not listed above".tr,
            style: TextStyle(color: AppColors.hintGrey, fontSize: 12),
          ),
        ),

        const SizedBox(height: 16),

        _fieldLabel("Other (Please specify)".tr),

        const SizedBox(height: 8),

        _AppTextField(
          controller: controller.otherFeatureController,
          hint: "Enter other features".tr,
          prefixIcon: Icons.edit_note_outlined,
        ),
      ],
    );
  }

  Widget _buildFurnishingSection() {
    return Column(
      crossAxisAlignment: CrossAxisAlignment.start,
      children: [
        Row(
          children: [
            const Icon(
              Icons.chair_outlined,
              color: AppColors.primary,
              size: 18,
            ),
            const SizedBox(width: 8),
             Expanded(
              child: Text(
                "Furnishing".tr,
                style: TextStyle(fontWeight: FontWeight.w700, fontSize: 14),
              ),
            ),
            _buildAddButton(_showFurnishingBottomSheet),
          ],
        ),

        const SizedBox(height: 6),

        _buildSelectedFurnishing(),
      ],
    );
  }

  Widget _buildAmenitiesSection() {
    return Column(
      crossAxisAlignment: CrossAxisAlignment.start,
      children: [
        Row(
          children: [
            const Icon(
              Icons.widgets_outlined,
              color: AppColors.primary,
              size: 18,
            ),
            const SizedBox(width: 8),
           Expanded(
              child: Text(
                "Amenities".tr,
                style: TextStyle(fontWeight: FontWeight.w700, fontSize: 14),
              ),
            ),
            _buildAddButton(_showAmenitiesBottomSheet),
          ],
        ),

        const SizedBox(height: 6),

        _buildSelectedAmenities(),
      ],
    );
  }

  Widget _buildNearbyTagsSection() {
    return Column(
      crossAxisAlignment: CrossAxisAlignment.start,
      children: [
        Row(
          children: [
            const Icon(
              Icons.location_on_outlined,
              color: AppColors.primary,
              size: 18,
            ),
            const SizedBox(width: 8),
          Expanded(
              child: Text(
                "Nearby Tags".tr,
                style: TextStyle(fontWeight: FontWeight.w700, fontSize: 14),
              ),
            ),
            _buildAddButton(_showNearbyTagsBottomSheet),
          ],
        ),

        const SizedBox(height: 6),

        _buildSelectedNearbyTags(),
      ],
    );
  }

  Widget _buildAddButton(VoidCallback onTap) {
    return GestureDetector(
      onTap: onTap,
      child: Container(
        padding: const EdgeInsets.symmetric(horizontal: 12, vertical: 6),
        decoration: BoxDecoration(
          border: Border.all(color: AppColors.primary),
          borderRadius: BorderRadius.circular(8.r),
        ),
        child:  Row(
          mainAxisSize: MainAxisSize.min,
          children: [
            Icon(Icons.add, size: 16, color: AppColors.primary),
            SizedBox(width: 4),
            Text(
              "Add".tr,
              style: TextStyle(
                color: AppColors.primary,
                fontWeight: FontWeight.w600,
                fontSize: 12,
              ),
            ),
          ],
        ),
      ),
    );
  }
Widget _buildSelectedAmenities() {
  if (controller.selectedAmenities.isEmpty) {
    return  Padding(
      padding: EdgeInsets.only(left: 26),
      child: Text(
        "No amenities selected".tr,
        style: TextStyle(
          color: AppColors.hintGrey,
          fontSize: 12,
        ),
      ),
    );
  }

  final selectedItems = controller.amenities
      .where(
        (item) => controller.selectedAmenities
            .contains(item.id),
      )
      .toList();

  return Padding(
    padding: const EdgeInsets.only(left: 26),
    child: Wrap(
      spacing: 8,
      runSpacing: 8,
      children: selectedItems.map((item) {
        return Container(
          padding: const EdgeInsets.symmetric(
            horizontal: 10,
            vertical: 6,
          ),
          decoration: BoxDecoration(
            color: AppColors.pinkChipBg,
            borderRadius: BorderRadius.circular(8),
            border: Border.all(
              color:
                  AppColors.primary.withOpacity(.2),
            ),
          ),
          child: Row(
            mainAxisSize: MainAxisSize.min,
            children: [
              if (item.image != null &&
                  item.image!.isNotEmpty) ...[
                ClipRRect(
                  borderRadius:
                      BorderRadius.circular(4),
                  child: Image.network(
                    item.image!,
                    width: 18,
                    height: 18,
                    fit: BoxFit.cover,
                    errorBuilder:
                        (_, __, ___) =>
                            const SizedBox.shrink(),
                  ),
                ),
                const SizedBox(width: 5),
              ],

              Text(
                item.title,
                style: const TextStyle(
                  color: AppColors.primary,
                  fontSize: 11,
                  fontWeight: FontWeight.w600,
                ),
              ),
            ],
          ),
        );
      }).toList(),
    ),
  );
}
  Widget _chipRow(List<String> labels, Set<String> selectedSet) {
    return Wrap(
      spacing: 10,
      runSpacing: 10,
      children: labels.map((label) {
        return _FeatureChip(
          label: label,
          selected: selectedSet.contains(label),
          onTap: () {
            setState(() {
              if (selectedSet.contains(label)) {
                selectedSet.remove(label);
              } else {
                selectedSet.add(label);
              }
            });
          },
        );
      }).toList(),
    );
  }
void _showAmenitiesBottomSheet() {
  showModalBottomSheet(
    context: context,
    isScrollControlled: true,
    backgroundColor: Colors.white,
    shape: const RoundedRectangleBorder(
      borderRadius: BorderRadius.vertical(
        top: Radius.circular(24),
      ),
    ),
    builder: (_) {
      return StatefulBuilder(
        builder: (context, sheetState) {
          return SafeArea(
            child: SizedBox(
              height:
                  MediaQuery.of(context).size.height *
                  .65,
              child: Padding(
                padding: const EdgeInsets.fromLTRB(
                  20,
                  12,
                  20,
                  20,
                ),
                child: Column(
                  children: [
                    Container(
                      width: 42,
                      height: 4,
                      decoration: BoxDecoration(
                        color: Colors.grey.shade300,
                        borderRadius:
                            BorderRadius.circular(20),
                      ),
                    ),

                    const SizedBox(height: 18),

                    Row(
                      children: [
                        Expanded(
                          child: Text(
                            "Select Amenities".tr,
                            style: TextStyle(
                              fontSize: 18,
                              fontWeight:
                                  FontWeight.w700,
                            ),
                          ),
                        ),
                        IconButton(
                          onPressed: () =>
                              Navigator.pop(context),
                          icon: const Icon(
                            Icons.close_rounded,
                          ),
                        ),
                      ],
                    ),

                    const SizedBox(height: 4),

                  Align(
                      alignment: Alignment.centerLeft,
                      child: Text(
                        "Choose the amenities available in your property.".tr,
                        style: TextStyle(
                          color: AppColors.hintGrey,
                          fontSize: 12,
                        ),
                      ),
                    ),

                    const SizedBox(height: 18),

                    Expanded(
                      child: GridView.builder(
                        itemCount:
                            controller.amenities.length,
                        gridDelegate:
                            const SliverGridDelegateWithFixedCrossAxisCount(
                          crossAxisCount: 3,
                          crossAxisSpacing: 10,
                          mainAxisSpacing: 10,
                          mainAxisExtent: 105,
                        ),
                        itemBuilder: (_, index) {
                          final amenity =
                              controller.amenities[index];

                          final selected = controller
                              .selectedAmenities
                              .contains(amenity.id);

                          return _AmenityTile(
                            label: amenity.title,
                            image: amenity.image,
                            selected: selected,
                            onTap: () {
                              sheetState(() {
                                controller.toggleAmenity(
                                  amenity.id,
                                );
                              });
                            },
                          );
                        },
                      ),
                    ),

                    const SizedBox(height: 12),

                    SizedBox(
                      width: double.infinity,
                      height: 48,
                      child: ElevatedButton(
                        style:
                            ElevatedButton.styleFrom(
                          backgroundColor:
                              AppColors.primary,
                          elevation: 0,
                          shape: RoundedRectangleBorder(
                            borderRadius:
                                BorderRadius.circular(
                                  14,
                                ),
                          ),
                        ),
                        onPressed: () {
                          controller.update();
                          Navigator.pop(context);
                        },
                        child: Text(
                          "Done".tr,
                          style: TextStyle(
                            color: Colors.white,
                            fontWeight:
                                FontWeight.w600,
                          ),
                        ),
                      ),
                    ),
                  ],
                ),
              ),
            ),
          );
        },
      );
    },
  );
}
Widget _buildSelectedNearbyTags() {
  if (controller.selectedNearbyTags.isEmpty) {
    return  Padding(
      padding: EdgeInsets.only(left: 26),
      child: Text(
        "No nearby tags selected".tr,
        style: TextStyle(
          color: AppColors.hintGrey,
          fontSize: 12,
        ),
      ),
    );
  }

  final selectedItems = controller.nearbyTags
      .where(
        (item) => controller.selectedNearbyTags
            .contains(item.id),
      )
      .toList();

  return Padding(
    padding: const EdgeInsets.only(left: 26),
    child: Wrap(
      spacing: 8,
      runSpacing: 8,
      children: selectedItems.map((item) {
        return Container(
          padding: const EdgeInsets.symmetric(
            horizontal: 10,
            vertical: 6,
          ),
          decoration: BoxDecoration(
            color: AppColors.pinkChipBg,
            borderRadius: BorderRadius.circular(8),
            border: Border.all(
              color:
                  AppColors.primary.withOpacity(.25),
            ),
          ),
          child: Row(
            mainAxisSize: MainAxisSize.min,
            children: [
              if (item.image != null &&
                  item.image!.isNotEmpty) ...[
                ClipRRect(
                  borderRadius:
                      BorderRadius.circular(4),
                  child: Image.network(
                    item.image!,
                    width: 18,
                    height: 18,
                    fit: BoxFit.cover,
                    errorBuilder:
                        (_, __, ___) =>
                            const SizedBox.shrink(),
                  ),
                ),
                const SizedBox(width: 5),
              ],

              Text(
                item.title,
                style: const TextStyle(
                  color: AppColors.primary,
                  fontSize: 11,
                  fontWeight: FontWeight.w600,
                ),
              ),
            ],
          ),
        );
      }).toList(),
    ),
  );
}

Widget _buildSelectedFurnishing() {
  if (controller.selectedFurnishing.isEmpty) {
    return  Padding(
      padding: EdgeInsets.only(left: 26),
      child: Text(
        "No furnishing option selected".tr,
        style: TextStyle(
          color: AppColors.hintGrey,
          fontSize: 12,
        ),
      ),
    );
  }

  final selectedItems = controller
      .furnishingOptions
      .where(
        (item) => controller.selectedFurnishing
            .contains(item.id),
      )
      .toList();

  return Padding(
    padding: const EdgeInsets.only(left: 26),
    child: Wrap(
      spacing: 8,
      runSpacing: 8,
      children: selectedItems.map((item) {
        return Container(
          padding: const EdgeInsets.symmetric(
            horizontal: 10,
            vertical: 6,
          ),
          decoration: BoxDecoration(
            color: AppColors.pinkChipBg,
            borderRadius: BorderRadius.circular(8),
            border: Border.all(
              color:
                  AppColors.primary.withOpacity(.25),
            ),
          ),
          child: Text(
            item.title,
            style: const TextStyle(
              color: AppColors.primary,
              fontWeight: FontWeight.w600,
              fontSize: 11,
            ),
          ),
        );
      }).toList(),
    ),
  );
}

void _showFurnishingBottomSheet() {
  showModalBottomSheet(
    context: context,
    isScrollControlled: true,
    backgroundColor: Colors.white,
    shape: const RoundedRectangleBorder(
      borderRadius: BorderRadius.vertical(
        top: Radius.circular(24),
      ),
    ),
    builder: (_) {
      return StatefulBuilder(
        builder: (context, sheetState) {
          return SafeArea(
            child: Padding(
              padding: const EdgeInsets.fromLTRB(
                20,
                16,
                20,
                20,
              ),
              child: Column(
                mainAxisSize: MainAxisSize.min,
                children: [
                  Container(
                    width: 42,
                    height: 4,
                    decoration: BoxDecoration(
                      color: Colors.grey.shade300,
                      borderRadius:
                          BorderRadius.circular(20),
                    ),
                  ),

                  const SizedBox(height: 18),

                  const Text(
                    "Furnishing",
                    style: TextStyle(
                      fontSize: 18,
                      fontWeight: FontWeight.w700,
                    ),
                  ),

                  const SizedBox(height: 10),

                  ...controller.furnishingOptions
                      .map((item) {
                    final selected = controller
                        .selectedFurnishing
                        .contains(item.id);

                    return ListTile(
                      contentPadding: EdgeInsets.zero,
                      leading: Icon(
                        selected
                            ? Icons
                                  .radio_button_checked
                            : Icons
                                  .radio_button_off,
                        color: AppColors.primary,
                      ),
                      title: Text(
                        item.title,
                        style: const TextStyle(
                          fontWeight:
                              FontWeight.w500,
                        ),
                      ),
                      onTap: () {
                        sheetState(() {
                          controller
                              .toggleFurnishing(
                            item.id,
                          );
                        });
                      },
                    );
                  }),

                  const SizedBox(height: 12),

                  PrimaryButton(
                    title: "Done",
                    onTap: () {
                      controller.update();
                      Navigator.pop(context);
                    },
                  ),
                ],
              ),
            ),
          );
        },
      );
    },
  );
}
void _showNearbyTagsBottomSheet() {
  showModalBottomSheet(
    context: context,
    isScrollControlled: true,
    backgroundColor: Colors.white,
    shape: const RoundedRectangleBorder(
      borderRadius: BorderRadius.vertical(
        top: Radius.circular(24),
      ),
    ),
    builder: (_) {
      return StatefulBuilder(
        builder: (context, sheetState) {
          return SafeArea(
            child: SizedBox(
              height:
                  MediaQuery.of(context).size.height *
                  .65,
              child: Padding(
                padding: const EdgeInsets.fromLTRB(
                  20,
                  12,
                  20,
                  20,
                ),
                child: Column(
                  children: [
                    Container(
                      width: 42,
                      height: 4,
                      decoration: BoxDecoration(
                        color: Colors.grey.shade300,
                        borderRadius:
                            BorderRadius.circular(20),
                      ),
                    ),

                    const SizedBox(height: 18),

                    Row(
                      children: [
                    Expanded(
                          child: Text(
                            "Nearby Tags".tr,
                            style: TextStyle(
                              fontSize: 18,
                              fontWeight:
                                  FontWeight.w700,
                            ),
                          ),
                        ),
                        IconButton(
                          onPressed: () =>
                              Navigator.pop(context),
                          icon:
                              const Icon(Icons.close),
                        ),
                      ],
                    ),

                    const SizedBox(height: 15),

                    Expanded(
                      child: GridView.builder(
                        itemCount:
                            controller.nearbyTags.length,
                        gridDelegate:
                            const SliverGridDelegateWithFixedCrossAxisCount(
                          crossAxisCount: 3,
                          crossAxisSpacing: 10,
                          mainAxisSpacing: 10,
                          mainAxisExtent: 105,
                        ),
                        itemBuilder: (_, index) {
                          final tag =
                              controller.nearbyTags[index];

                          final selected = controller
                              .selectedNearbyTags
                              .contains(tag.id);

                          return _AmenityTile(
                            label: tag.title,
                            image: tag.image,
                            selected: selected,
                            onTap: () {
                              sheetState(() {
                                controller
                                    .toggleNearbyTag(
                                  tag.id,
                                );
                              });
                            },
                          );
                        },
                      ),
                    ),

                    const SizedBox(height: 12),

                    SizedBox(
                      width: double.infinity,
                      height: 48,
                      child: ElevatedButton(
                        style:
                            ElevatedButton.styleFrom(
                          backgroundColor:
                              AppColors.primary,
                          shape: RoundedRectangleBorder(
                            borderRadius:
                                BorderRadius.circular(
                                  14,
                                ),
                          ),
                        ),
                        onPressed: () {
                          controller.update();
                          Navigator.pop(context);
                        },
                        child:  Text(
                          "Done".tr,
                          style: TextStyle(
                            color: Colors.white,
                          ),
                        ),
                      ),
                    ),
                  ],
                ),
              ),
            ),
          );
        },
      );
    },
  );
}

  // ---------------------------------------------------------
  // STEP 4 — LOCATION DETAILS
  // ---------------------------------------------------------
  Widget _buildStep4({Key? key}) {
    return Column(
      key: key,
      crossAxisAlignment: CrossAxisAlignment.start,
      children: [
        _sectionHeader(
          icon: Icons.location_on_outlined,
          title: "Property Location".tr,
          subtitle: "Tell buyers where your property is located".tr,
        ),

        const SizedBox(height: 20),

        _fieldLabel("Address Line 1".tr, required: true),
        const SizedBox(height: 8),

        _AppTextField(
          controller: controller.addressController,
          hint: "Enter address".tr,
          prefixIcon: Icons.location_on_outlined,
        ),

        const SizedBox(height: 18),

        _fieldLabel("Address Line 2".tr),
        const SizedBox(height: 8),

        _AppTextField(
          controller: controller.streetController,
          hint: "Apartment / Building / Street".tr,
          prefixIcon: Icons.home_work_outlined,
        ),

        const SizedBox(height: 18),

        _fieldLabel("Area".tr, required: true),
        const SizedBox(height: 8),

        _AppTextField(
          controller: controller.areaController,
          hint: "Name of Area".tr,
          prefixIcon: Icons.map_outlined,
        
         
        ),

        const SizedBox(height: 18),

        _fieldLabel("Municipality / City".tr, required: true),
        const SizedBox(height: 8),

        _AppTextField(
          controller: controller.cityController,
          hint: "Enter municipality".tr,
          prefixIcon: Icons.location_city_outlined,
        ),

        const SizedBox(height: 18),

        _fieldLabel("Landmark".tr),
        const SizedBox(height: 8),

        _AppTextField(
          controller: controller.landmarkController,
          hint: "Nearby landmark".tr,
          prefixIcon: Icons.place_outlined,
        ),

        const SizedBox(height: 18),

        Row(
          children: [
            Expanded(
              child: Column(
                crossAxisAlignment: CrossAxisAlignment.start,
                children: [
                  _fieldLabel("Latitude".tr),

                  const SizedBox(height: 8),

                  _AppTextField(
                    controller: controller.latitudeController,
                    hint: "Latitude".tr,
                    keyboardType: const TextInputType.numberWithOptions(
                      decimal: true,
                    ),
                    prefixIcon: Icons.my_location_outlined,
                    onChanged: (value) {
                      controller.setLatitude(double.tryParse(value) ?? 0);
                    },
                  ),
                ],
              ),
            ),
            const SizedBox(width: 12),

            Expanded(
              child: Column(
                crossAxisAlignment: CrossAxisAlignment.start,
                children: [
                  _fieldLabel("Longitude".tr),

                  const SizedBox(height: 8),

                  _AppTextField(
                    controller: controller.longitudeController,
                    hint: "Longitude".tr,
                    keyboardType: const TextInputType.numberWithOptions(
                      decimal: true,
                    ),
                    prefixIcon: Icons.public_outlined,
                    onChanged: (value) {
                      controller.setLongitude(double.tryParse(value) ?? 0);
                    },
                  ),
                ],
              ),
            ),
          ],
        ),

        const SizedBox(height: 18),

        Container(
          padding: const EdgeInsets.all(14),
          decoration: BoxDecoration(
            color: AppColors.fieldBg,
            borderRadius: BorderRadius.circular(10),
            border: Border.all(color: AppColors.fieldBorder),
          ),
          child: Row(
            children:[
              Icon(Icons.map_outlined, color: AppColors.primary),
              SizedBox(width: 10),
              Expanded(
                child: Text(
                  "Google Map integration can be added here for selecting the exact location.".tr,
                  style: TextStyle(fontSize: 12, color: AppColors.labelGrey),
                ),
              ),
            ],
          ),
        ),
      ],
    );
  }

  // ---------------------------------------------------------
  // STEP 5 — PHOTOS & VIDEOS (MEDIA)
  // ---------------------------------------------------------
  // ---------------------------------------------------------
  // STEP 5
  // ---------------------------------------------------------

  Widget _buildStep5({Key? key}) {
    return Column(
      key: key,
      crossAxisAlignment: CrossAxisAlignment.start,
      children: [
        _sectionHeader(
          icon: Icons.camera_alt_outlined,
          title: "Photos & Videos".tr,
          subtitle: "Add high quality photos and videos to attract more buyers".tr,
        ),

        const SizedBox(height: 20),

        //=========================================================
        // PHOTOS
        //=========================================================
        _fieldLabel("Property Photos".tr, required: true),

      Padding(
          padding: EdgeInsets.only(top: 2, bottom: 12),
          child: Text(
            "Upload clear and attractive photos (Max 20 photos)".tr,
            style: TextStyle(color: AppColors.hintGrey, fontSize: 12),
          ),
        ),

        SizedBox(
          height: 82,
          child: ListView.separated(
            scrollDirection: Axis.horizontal,
            itemCount: controller.images.isEmpty ? 4 : controller.images.length,
            separatorBuilder: (_, __) => const SizedBox(width: 8),
            itemBuilder: (_, index) {
              if (controller.images.isEmpty) {
                const colors = [
                  Color(0xFFEFE3D8),
                  Color(0xFFE7DED6),
                  Color(0xFFEDEAE4),
                  Color(0xFFDCE4E8),
                ];

                return _PhotoThumbnail(color: colors[index]);
              }

              return _PhotoThumbnail(
                imagePath: controller.images[index],
                onRemove: () {
                  controller.removeImage(index);
                },
              );
            },
          ),
        ),

        const SizedBox(height: 14),

        GestureDetector(
          onTap: _pickImages,
          child: _DashedUploadBox(
            icon: Icons.add_photo_alternate_outlined,
            title: "Add Photos".tr,
            subtitle: "JPG, PNG up to 10MB each".tr,
            filled: true,
          ),
        ),

        const SizedBox(height: 22),

        //=========================================================
        // VIDEOS
        //=========================================================
        _fieldLabel("Property Videos"),

        const Padding(
          padding: EdgeInsets.only(top: 2, bottom: 4),
          child: Text(
            "(Optional)",
            style: TextStyle(color: AppColors.hintGrey, fontSize: 11),
          ),
        ),

        const Padding(
          padding: EdgeInsets.only(bottom: 12),
          child: Text(
            "Upload video tour of your property (Max 3 videos)",
            style: TextStyle(color: AppColors.hintGrey, fontSize: 12),
          ),
        ),

        GestureDetector(
          onTap: _pickVideo,
          child: _DashedUploadBox(
            icon: Icons.videocam_outlined,
            title: controller.video.isEmpty ? "Add Video" : "Video Selected",
            subtitle: controller.video.isEmpty
                ? "MP4, MOV up to 50MB each"
                : controller.video.split('/').last,
          ),
        ),

        const SizedBox(height: 16),

        _buildVideoGuidelines(),

        const SizedBox(height: 22),

        //=========================================================
        // DOCUMENTS
        //=========================================================
        // _fieldLabel("Additional Documents"),

        // const Padding(
        //   padding: EdgeInsets.only(top: 2, bottom: 4),
        //   child: Text(
        //     "(Optional)",
        //     style: TextStyle(color: AppColors.hintGrey, fontSize: 11),
        //   ),
        // ),

        // const Padding(
        //   padding: EdgeInsets.only(bottom: 12),
        //   child: Text(
        //     "Upload floor plans, brochures or other documents",
        //     style: TextStyle(color: AppColors.hintGrey, fontSize: 12),
        //   ),
        // ),

        // GestureDetector(
        //   onTap: _pickDocument,
        //   child: const _DashedUploadBox(
        //     icon: Icons.upload_file_outlined,
        //     title: "Upload Documents",
        //     subtitle: "PDF, JPG, PNG up to 10MB each",
        //   ),
        // ),
        const SizedBox(height: 18),

        _buildTipBox(),
      ],
    );
  }

  Future<void> _pickImages() async {
    final files = await _picker.pickMultiImage(imageQuality: 80);

    if (files.isEmpty) return;

    final remaining = 20 - controller.images.length;

    for (final image in files.take(remaining)) {
      controller.addImage(image.path);
    }
  }

  Future<void> _pickVideo() async {
    final file = await _picker.pickVideo(source: ImageSource.gallery);

    if (file == null) return;

    controller.setVideo(file.path);
  }

  Widget _buildVideoGuidelines() {
    return Container(
      width: double.infinity,
      padding: const EdgeInsets.all(10),
      decoration: BoxDecoration(
        color: AppColors.pinkChipBg,
        borderRadius: BorderRadius.circular(8),
      ),
      child: Column(
        crossAxisAlignment: CrossAxisAlignment.start,
        children: [
          Row(
            children: const [
              Icon(Icons.info_outline, size: 16, color: AppColors.primary),
              SizedBox(width: 8),
              Text(
                'Video Guidelines',
                style: TextStyle(
                  fontWeight: FontWeight.w700,
                  fontSize: 12.5,
                  color: AppColors.primary,
                ),
              ),
            ],
          ),
          const SizedBox(height: 8),
          ..._videoGuidelineItems.map(
            (t) => Padding(
              padding: const EdgeInsets.only(bottom: 4, left: 24),
              child: Row(
                crossAxisAlignment: CrossAxisAlignment.start,
                children: [
                  const Icon(Icons.check, size: 14, color: AppColors.primary),
                  const SizedBox(width: 6),
                  Expanded(
                    child: Text(
                      t,
                      style: const TextStyle(
                        fontSize: 12,
                        color: AppColors.labelGrey,
                      ),
                    ),
                  ),
                ],
              ),
            ),
          ),
        ],
      ),
    );
  }

  static const _videoGuidelineItems = [
    'Maximum video duration: 2 minutes',
    'Show all major areas of the property',
    'Ensure good lighting and clear audio',
  ];

  Widget _buildTipBox() {
    return Container(
      width: double.infinity,
      padding: EdgeInsets.symmetric(horizontal: 10.w, vertical: 14.h),
      decoration: BoxDecoration(
        color: AppColors.greenBg,
        borderRadius: BorderRadius.circular(8),
      ),
      child: Row(
        crossAxisAlignment: CrossAxisAlignment.start,
        children: [
          const Icon(
            Icons.verified_user_outlined,
            size: 18,
            color: AppColors.greenText,
          ),
          const SizedBox(width: 10),
          Expanded(
            child: Column(
              crossAxisAlignment: CrossAxisAlignment.start,
              children: [
                Text(
                  'Tip: Properties with photos get 10x more interest!'.tr,
                  style: TextStyle(
                    fontWeight: FontWeight.w600,
                    fontSize: 10.5,
                    color: AppColors.greenText,
                  ),
                ),
                SizedBox(height: 2.h),
                Text(
                  'Make sure to add high quality photos and videos'.tr,
                  style: TextStyle(fontSize: 10.sp, color: Colors.black),
                ),
              ],
            ),
          ),
          const Icon(Icons.auto_awesome, size: 16, color: AppColors.greenText),
        ],
      ),
    );
  }

  // ---------------------------------------------------------
  // SHARED PIECES
  // ---------------------------------------------------------
  Widget _sectionHeader({
    required IconData icon,
    required String title,
    required String subtitle,
  }) {
    return Row(
      children: [
        Container(
          width: 44,
          height: 44,
          decoration: const BoxDecoration(
            color: AppColors.pinkBg,
            shape: BoxShape.circle,
          ),
          child: Icon(icon, color: AppColors.primary, size: 22),
        ),
        const SizedBox(width: 12),
        Expanded(
          child: Column(
            crossAxisAlignment: CrossAxisAlignment.start,
            children: [
              Text(
                title,
                style: const TextStyle(
                  fontSize: 15,
                  fontWeight: FontWeight.w700,
                  color: Colors.black87,
                ),
              ),
              const SizedBox(height: 2),
              Text(
                subtitle,
                style: const TextStyle(
                  fontSize: 12.5,
                  color: AppColors.hintGrey,
                ),
              ),
            ],
          ),
        ),
      ],
    );
  }

  Widget _fieldLabel(String text, {bool required = false}) {
    return RichText(
      text: TextSpan(
        text: text,
        style: const TextStyle(
          color: AppColors.labelGrey,
          fontSize: 13.5,
          fontWeight: FontWeight.w600,
        ),
        children: required
            ? const [
                TextSpan(
                  text: ' *',
                  style: TextStyle(color: AppColors.primary),
                ),
              ]
            : [],
      ),
    );
  }
Widget _buildBottomButton() {
  final bool isLastStep =
      controller.currentStep ==
      controller.steps.length - 1;

  return SizedBox(
    width: double.infinity,
    height: 54,
    child: ElevatedButton(
      // Prevent multiple submissions
      onPressed: controller.isSubmitting
          ? null
          : () async {
              // ==========================================
              // NORMAL NEXT STEP
              // ==========================================

              if (!isLastStep) {
                controller.nextStep();
                return;
              }

              // ==========================================
              // FINAL STEP - ADD PROPERTY
              // ==========================================

              final bool success =
                  await controller.addProperty();

              if (!success) {
                return;
              }

              // ==========================================
              // CLOSE ADD PROPERTY SCREEN
              //
              // true tells My Properties:
              // "A new property was added"
              // ==========================================

              Get.back(result: true);
            },

      style: ElevatedButton.styleFrom(
        backgroundColor: AppColors.primary,
        disabledBackgroundColor:
            AppColors.primary.withOpacity(.7),
        shape: RoundedRectangleBorder(
          borderRadius:
              BorderRadius.circular(14),
        ),
        elevation: 0,
      ),

      child: controller.isSubmitting
          ? const SizedBox(
              width: 22,
              height: 22,
              child:
                  CircularProgressIndicator(
                color: Colors.white,
                strokeWidth: 2,
              ),
            )
          : Row(
              mainAxisAlignment:
                  MainAxisAlignment.center,
              children: [
                Text(
                  isLastStep
                      ? 'Review & Publish'.tr
                      : 'Save & Continue'.tr,
                  style: const TextStyle(
                    fontSize: 16,
                    fontWeight:
                        FontWeight.w700,
                    color: Colors.white,
                  ),
                ),

                const SizedBox(width: 8),

                const Icon(
                  Icons.arrow_forward,
                  size: 18,
                  color: Colors.white,
                ),
              ],
            ),
    ),
  );
}
}

// =================================================================
// AMENITY DATA MODEL
// =================================================================
class _AmenityData {
  final String label;
  final IconData icon;
  bool selected;
  _AmenityData(this.label, this.icon, {this.selected = false});
}

// =================================================================
// STEP CIRCLE WIDGET
// =================================================================
enum _StepState { completed, active, inactive }

class _StepCircle extends StatelessWidget {
  final int number;
  final String label;
  final _StepState state;

  const _StepCircle({
    required this.number,
    required this.label,
    required this.state,
  });

  @override
  Widget build(BuildContext context) {
    final bool isActive = state == _StepState.active;
    final bool isCompleted = state == _StepState.completed;
    final Color circleColor = (isActive || isCompleted)
        ? AppColors.primary
        : Colors.white;
    final Color borderColor = (isActive || isCompleted)
        ? AppColors.primary
        : Color(0xFFE3E1E6);
    final Color textColor = (isActive || isCompleted)
        ? Colors.white
        : AppColors.hintGrey;

    return Column(
      mainAxisSize: MainAxisSize.min,
      children: [
        Container(
          width: 34,
          height: 34,
          decoration: BoxDecoration(
            color: circleColor,
            shape: BoxShape.circle,
            border: Border.all(color: borderColor, width: 1.5),
          ),
          alignment: Alignment.center,
          child: isCompleted
              ? const Icon(Icons.check, color: Colors.white, size: 18)
              : Text(
                  '$number',
                  style: TextStyle(
                    color: textColor,
                    fontWeight: FontWeight.w700,
                    fontSize: 14,
                  ),
                ),
        ),
        const SizedBox(height: 6),
        Text(
          label,
          style: TextStyle(
            fontSize: 10.5,
            fontWeight: isActive ? FontWeight.w700 : FontWeight.w500,
            color: isActive ? AppColors.primary : AppColors.hintGrey,
          ),
        ),
      ],
    );
  }
}

// =================================================================
// TEXT FIELD
// =================================================================
class _AppTextField extends StatelessWidget {
  final TextEditingController controller;
  final String hint;
  final IconData? prefixIcon;
  final TextInputType? keyboardType;
  final int maxLines;
  final int? maxLength;
  final bool showCounter;
  final bool enabled;
  final ValueChanged<String>? onChanged;

  const _AppTextField({
    required this.controller,
    required this.hint,
    this.prefixIcon,
    this.keyboardType,
    this.maxLines = 1,
    this.maxLength,
    this.showCounter = false,
    this.onChanged,
    this.enabled = true,
  });

  @override
  Widget build(BuildContext context) {
    return Container(
      decoration: BoxDecoration(
        color: AppColors.fieldBg,
        borderRadius: BorderRadius.circular(12),
        border: Border.all(color: AppColors.fieldBorder),
      ),
      padding: const EdgeInsets.symmetric(horizontal: 4),
      child: Stack(
        children: [
          TextField(
            controller: controller,
            keyboardType: keyboardType,
            maxLines: maxLines,
            maxLength: maxLength,
            onChanged: onChanged,
            inputFormatters: keyboardType == TextInputType.number
                ? [FilteringTextInputFormatter.digitsOnly]
                : null,
            style: const TextStyle(fontSize: 14, color: Colors.black87),
            decoration: InputDecoration(
              hintText: hint,
              hintStyle: const TextStyle(
                color: AppColors.hintGrey,
                fontSize: 14,
              ),
              prefixIcon: prefixIcon != null
                  ? Icon(prefixIcon, color: AppColors.hintGrey, size: 20)
                  : null,
              border: InputBorder.none,
              counterText: '',
              contentPadding: const EdgeInsets.symmetric(
                horizontal: 12,
                vertical: 14,
              ),
            ),
          ),
          if (showCounter)
            Positioned(
              right: 10,
              bottom: 6,
              child: Text(
                '${controller.text.length}/${maxLength ?? 0}',
                style: const TextStyle(fontSize: 11, color: AppColors.hintGrey),
              ),
            ),
        ],
      ),
    );
  }
}

// =================================================================
// DROPDOWN FIELD
// =================================================================
class _AppDropdownField extends StatelessWidget {
  final String? value;
  final String hint;
  final IconData icon;
  final List<String> items;
  final ValueChanged<String?> onChanged;

  const _AppDropdownField({
    required this.value,
    required this.hint,
    required this.icon,
    required this.items,
    required this.onChanged,
  });

  @override
  Widget build(BuildContext context) {
    return Container(
      decoration: BoxDecoration(
        color: AppColors.fieldBg,
        borderRadius: BorderRadius.circular(12),
        border: Border.all(color: AppColors.fieldBorder),
      ),
      padding: const EdgeInsets.symmetric(horizontal: 12),
      child: DropdownButtonHideUnderline(
        child: DropdownButton<String>(
          isExpanded: true,
          value: value,
          hint: Row(
            children: [
              Icon(icon, color: AppColors.hintGrey, size: 20),
              const SizedBox(width: 10),
              Text(
                hint,
                style: const TextStyle(color: AppColors.hintGrey, fontSize: 14),
              ),
            ],
          ),
          icon: const Icon(
            Icons.keyboard_arrow_down,
            color: AppColors.hintGrey,
          ),
          items: items
              .map((e) => DropdownMenuItem(value: e, child: Text(e)))
              .toList(),
          onChanged: onChanged,
        ),
      ),
    );
  }
}

// =================================================================
// COUNTRY CODE DROPDOWN
// =================================================================
class _CountryCodeDropdown extends StatelessWidget {
  final String value;
  final ValueChanged<String> onChanged;

  const _CountryCodeDropdown({required this.value, required this.onChanged});

  static const List<String> codes = ['+974', '+971', '+91', '+1', '+44'];

  @override
  Widget build(BuildContext context) {
    return Container(
      height: 52,
      padding: const EdgeInsets.symmetric(horizontal: 10),
      decoration: BoxDecoration(
        color: AppColors.fieldBg,
        borderRadius: BorderRadius.circular(12),
        border: Border.all(color: AppColors.fieldBorder),
      ),
      child: DropdownButtonHideUnderline(
        child: DropdownButton<String>(
          value: value,
          icon: const Icon(Icons.keyboard_arrow_down, size: 18),
          items: codes
              .map(
                (c) => DropdownMenuItem(
                  value: c,
                  child: Row(
                    children: [
                      Container(
                        width: 20,
                        height: 14,
                        color: AppColors.primary,
                      ),
                      const SizedBox(width: 6),
                      Text(c, style: const TextStyle(fontSize: 13)),
                    ],
                  ),
                ),
              )
              .toList(),
          onChanged: (v) => onChanged(v ?? value),
        ),
      ),
    );
  }
}

// =================================================================
// CURRENCY DROPDOWN
// =================================================================
class _CurrencyDropdown extends StatelessWidget {
  final String value;
  final ValueChanged<String> onChanged;

  const _CurrencyDropdown({required this.value, required this.onChanged});

  static const List<String> currencies = ['QAR', 'USD', 'AED', 'SAR'];

  @override
  Widget build(BuildContext context) {
    return Container(
      height: 52,
      padding: const EdgeInsets.symmetric(horizontal: 10),
      decoration: BoxDecoration(
        color: AppColors.fieldBg,
        borderRadius: BorderRadius.circular(12),
        border: Border.all(color: AppColors.fieldBorder),
      ),
      child: DropdownButtonHideUnderline(
        child: DropdownButton<String>(
          value: value,
          icon: const Icon(Icons.keyboard_arrow_down, size: 18),
          items: currencies
              .map(
                (c) => DropdownMenuItem(
                  value: c,
                  child: Text(c, style: const TextStyle(fontSize: 13)),
                ),
              )
              .toList(),
          onChanged: (v) => onChanged(v ?? value),
        ),
      ),
    );
  }
}

// =================================================================
// TOGGLE BUTTON (Sale/Rent, Residential/Commercial)
// =================================================================
class _ToggleButton extends StatelessWidget {
  final String label;
  final IconData icon;
  final bool selected;
  final VoidCallback onTap;
  final BorderRadius radius;

  const _ToggleButton({
    required this.label,
    required this.icon,
    required this.selected,
    required this.onTap,
    required this.radius,
  });

  @override
  Widget build(BuildContext context) {
    return GestureDetector(
      onTap: onTap,
      child: Container(
        height: 50,
        decoration: BoxDecoration(
          color: selected ? AppColors.pinkBg : AppColors.fieldBg,
          borderRadius: radius,
          border: Border.all(
            color: selected ? AppColors.primary : AppColors.fieldBorder,
          ),
        ),
        alignment: Alignment.center,
        child: Row(
          mainAxisAlignment: MainAxisAlignment.center,
          children: [
            Icon(
              icon,
              size: 18,
              color: selected ? AppColors.primary : AppColors.hintGrey,
            ),
            const SizedBox(width: 6),
            Flexible(
              child: Text(
                label,
                overflow: TextOverflow.ellipsis,
                style: TextStyle(
                  fontWeight: FontWeight.w600,
                  fontSize: 13,
                  color: selected ? AppColors.primary : AppColors.hintGrey,
                ),
              ),
            ),
          ],
        ),
      ),
    );
  }
}

// =================================================================
// AMENITY TILE (Step 3 grid item)
// =================================================================
class _AmenityTile extends StatelessWidget {
  final String label;
  final String? image;
  final bool selected;
  final VoidCallback onTap;

  const _AmenityTile({
    required this.label,
    this.image,
    required this.selected,
    required this.onTap,
  });

  @override
  Widget build(BuildContext context) {
    return InkWell(
      onTap: onTap,
      borderRadius: BorderRadius.circular(12),
      child: Container(
        padding: const EdgeInsets.all(8),
        decoration: BoxDecoration(
          color: selected
              ? AppColors.pinkChipBg
              : Colors.white,
          borderRadius: BorderRadius.circular(12),
          border: Border.all(
            color: selected
                ? AppColors.primary
                : AppColors.fieldBorder,
            width: selected ? 1.5 : 1,
          ),
        ),
        child: Column(
          mainAxisAlignment:
              MainAxisAlignment.center,
          children: [
            if (image != null &&
                image!.trim().isNotEmpty)
              ClipRRect(
                borderRadius:
                    BorderRadius.circular(8),
                child: Image.network(
                  image!,
                  width: 36,
                  height: 36,
                  fit: BoxFit.cover,

                  errorBuilder:
                      (context, error, stackTrace) {
                    return const Icon(
                      Icons.home_outlined,
                      size: 30,
                      color: AppColors.primary,
                    );
                  },
                ),
              )
            else
              const Icon(
                Icons.home_outlined,
                size: 30,
                color: AppColors.primary,
              ),

            const SizedBox(height: 7),

            Text(
              label,
              maxLines: 2,
              overflow: TextOverflow.ellipsis,
              textAlign: TextAlign.center,
              style: TextStyle(
                fontSize: 11,
                fontWeight: selected
                    ? FontWeight.w700
                    : FontWeight.w500,
                color: selected
                    ? AppColors.primary
                    : Colors.black87,
              ),
            ),
          ],
        ),
      ),
    );
  }
}
// =================================================================
// FEATURE CHIP (Step 3 "Other Features" checkbox chip)
// =================================================================
class _FeatureChip extends StatelessWidget {
  final String label;
  final bool selected;
  final VoidCallback onTap;

  const _FeatureChip({
    super.key,
    required this.label,
    required this.selected,
    required this.onTap,
  });

  @override
  Widget build(BuildContext context) {
    return InkWell(
      onTap: onTap,
      borderRadius: BorderRadius.circular(12),
      child: AnimatedContainer(
        duration: const Duration(milliseconds: 200),
        padding: const EdgeInsets.symmetric(horizontal: 14, vertical: 10),
        decoration: BoxDecoration(
          color: selected ? AppColors.primary.withOpacity(.08) : Colors.white,
          borderRadius: BorderRadius.circular(12),
          border: Border.all(
            color: selected ? AppColors.primary : AppColors.fieldBorder,
          ),
        ),
        child: Row(
          mainAxisSize: MainAxisSize.min, // 👈 Width according to content
          children: [
            Icon(
              selected ? Icons.check_circle : Icons.radio_button_unchecked,
              size: 18,
              color: selected ? AppColors.primary : AppColors.textSecondary,
            ),
            const SizedBox(width: 8),
            Text(
              label,
              style: TextStyle(
                fontSize: 12,
                fontWeight: FontWeight.w600,
                color: selected ? AppColors.primary : AppColors.textPrimary,
              ),
            ),
          ],
        ),
      ),
    );
  }
}

// =================================================================
// MAP PREVIEW (Step 4)
// =================================================================
class _MapPreview extends StatelessWidget {
  const _MapPreview();

  @override
  Widget build(BuildContext context) {
    return ClipRRect(
      borderRadius: BorderRadius.circular(12),
      child: Container(
        height: 140,
        width: double.infinity,
        color: AppColors.mapBg,
        child: Stack(
          children: [
            CustomPaint(size: Size.infinite, painter: _MapGridPainter()),
            Positioned(top: 10, right: 12, child: _mapLabel('West Bay')),
            Positioned(
              bottom: 10,
              left: 10,
              child: _mapLabel('Doha Exhibition & Convention Center'),
            ),
            const Center(
              child: Icon(
                Icons.location_on,
                color: AppColors.primary,
                size: 34,
              ),
            ),
            Positioned(
              bottom: 10,
              right: 10,
              child: Container(
                width: 30,
                height: 30,
                decoration: const BoxDecoration(
                  color: Colors.white,
                  shape: BoxShape.circle,
                  boxShadow: [BoxShadow(color: Colors.black26, blurRadius: 3)],
                ),
                child: const Icon(
                  Icons.my_location,
                  size: 16,
                  color: AppColors.primary,
                ),
              ),
            ),
          ],
        ),
      ),
    );
  }

  Widget _mapLabel(String text) {
    return Container(
      padding: const EdgeInsets.symmetric(horizontal: 8, vertical: 4),
      decoration: BoxDecoration(
        color: Colors.white,
        borderRadius: BorderRadius.circular(6),
        boxShadow: const [BoxShadow(color: Colors.black12, blurRadius: 2)],
      ),
      child: Text(
        text,
        style: const TextStyle(fontSize: 9.5, color: Colors.black87),
      ),
    );
  }
}

class _MapGridPainter extends CustomPainter {
  @override
  void paint(Canvas canvas, Size size) {
    final paint = Paint()
      ..color = Colors.white.withOpacity(0.5)
      ..strokeWidth = 1;
    for (double x = 0; x < size.width; x += 24) {
      canvas.drawLine(Offset(x, 0), Offset(x, size.height), paint);
    }
    for (double y = 0; y < size.height; y += 24) {
      canvas.drawLine(Offset(0, y), Offset(size.width, y), paint);
    }
  }

  @override
  bool shouldRepaint(covariant CustomPainter oldDelegate) => false;
}

// =================================================================
// PHOTO THUMBNAIL (Step 5)
// =================================================================

// =================================================================
// DASHED UPLOAD BOX (Step 5 — photos / video / documents)
// =================================================================

class _PhotoThumbnail extends StatelessWidget {
  final Color color;
  final String? imagePath;
  final String? overlayLabel;
  final bool isLast;
  final VoidCallback? onRemove;

  const _PhotoThumbnail({
    this.color = Colors.grey,
    this.imagePath,
    this.overlayLabel,
    this.isLast = false,
    this.onRemove,
  });

  @override
  Widget build(BuildContext context) {
    return Container(
      width: 78,
      height: 78,
      margin: const EdgeInsets.only(right: 8),
      child: Stack(
        children: [
          ClipRRect(
            borderRadius: BorderRadius.circular(10),
            child: imagePath != null
                ? Image.file(
                    File(imagePath!),
                    width: 78,
                    height: 78,
                    fit: BoxFit.cover,
                  )
                : Container(width: 78, height: 78, color: color),
          ),

          if (overlayLabel != null)
            Container(
              width: 78,
              height: 78,
              decoration: BoxDecoration(
                color: Colors.black45,
                borderRadius: BorderRadius.circular(10),
              ),
              child: Center(
                child: Text(
                  overlayLabel!,
                  textAlign: TextAlign.center,
                  style: const TextStyle(
                    color: Colors.white,
                    fontWeight: FontWeight.bold,
                  ),
                ),
              ),
            ),

          if (imagePath != null)
            Positioned(
              top: 3,
              right: 3,
              child: GestureDetector(
                onTap: onRemove,
                child: Container(
                  padding: const EdgeInsets.all(3),
                  decoration: const BoxDecoration(
                    color: Colors.red,
                    shape: BoxShape.circle,
                  ),
                  child: const Icon(Icons.close, color: Colors.white, size: 12),
                ),
              ),
            ),
        ],
      ),
    );
  }
}

class _DashedUploadBox extends StatelessWidget {
  final IconData icon;
  final String title;
  final String subtitle;
  final bool filled;

  const _DashedUploadBox({
    required this.icon,
    required this.title,
    required this.subtitle,
    this.filled = false,
  });

  @override
  Widget build(BuildContext context) {
    return Container(
      width: double.infinity,
      padding: const EdgeInsets.symmetric(horizontal: 16, vertical: 20),
      decoration: BoxDecoration(
        color: filled ? AppColors.pinkChipBg : Colors.white,
        borderRadius: BorderRadius.circular(12),
        border: Border.all(
          color: AppColors.primary.withOpacity(.4),
          width: 1.2,
        ),
      ),
      child: Column(
        children: [
          Icon(icon, color: AppColors.primary, size: 32),

          const SizedBox(height: 10),

          Text(
            title,
            style: const TextStyle(fontWeight: FontWeight.w700, fontSize: 14),
          ),

          const SizedBox(height: 4),

          Text(
            subtitle,
            textAlign: TextAlign.center,
            style: const TextStyle(color: AppColors.hintGrey, fontSize: 12),
          ),
        ],
      ),
    );
  }
}

// =================================================================
// ENTRY POINT (for quick preview / testing)
// =================================================================
