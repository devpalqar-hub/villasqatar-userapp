import 'package:flutter/material.dart';
import 'package:flutter/services.dart';
import 'package:flutter_screenutil/flutter_screenutil.dart';
import 'package:get/get_core/get_core.dart';
import 'package:get/get_navigation/src/extension_navigation.dart';
import 'package:villas_qatar/Core/constants/app_colors.dart';
import 'package:villas_qatar/modules/mainscreen/mainscreen.dart';
import 'package:villas_qatar/modules/propertylist/views/Mypropertiesscreen.dart';

class ListYourPropertyScreen extends StatefulWidget {
  const ListYourPropertyScreen({super.key});

  @override
  State<ListYourPropertyScreen> createState() => _ListYourPropertyScreenState();
}

class _ListYourPropertyScreenState extends State<ListYourPropertyScreen> {
  int currentStep = 1; // 1..5, drives which form is shown — no navigation

  // ---- Step 1 controllers ----
  final fullNameCtrl = TextEditingController();
  final phoneCtrl = TextEditingController();
  final emailCtrl = TextEditingController();
  final descriptionCtrl = TextEditingController();
  String countryCode = '+974';

  // ---- Step 2 controllers ----
  final propertyNameCtrl = TextEditingController();
  final roomsCtrl = TextEditingController();
  final bathroomsCtrl = TextEditingController();
  final priceCtrl = TextEditingController();
  final areaCtrl = TextEditingController();
  String? propertyType;
  String propertyFor = 'Sale'; // 'Sale' | 'Rent'
  String currency = 'QAR';

  // ---- Step 3 state (Features & Amenities) ----
  final List<_AmenityData> amenities = [
    _AmenityData('Swimming Pool', Icons.pool_outlined),
    _AmenityData('Gym', Icons.fitness_center, selected: true),
    _AmenityData('Parking', Icons.local_parking_outlined, selected: true),
    _AmenityData('Elevator', Icons.elevator_outlined),
    _AmenityData('Security', Icons.shield_outlined, selected: true),
    _AmenityData('Balcony', Icons.balcony_outlined, selected: true),
    _AmenityData('Built in Wardrobe', Icons.checkroom_outlined),
    _AmenityData('Central AC', Icons.ac_unit_outlined),
    _AmenityData('Kids Play Area', Icons.child_friendly_outlined),
    _AmenityData('Garden', Icons.local_florist_outlined),
    _AmenityData('Pet Friendly', Icons.pets_outlined),
    _AmenityData('Generator', Icons.power_outlined),
  ];

  final Set<String> furnishingSelected = {
    'Furnished',
    'Semi Furnished',
    'Ready to Move',
  };
  final Set<String> constructionSelected = {'New Property'};
  final Set<String> extraRoomsSelected = {};
  final otherFeatureCtrl = TextEditingController();

  // ---- Step 4 state (Location) ----
  final addressCtrl = TextEditingController();
  final streetCtrl = TextEditingController();
  final pincodeCtrl = TextEditingController();
  final landmarkCtrl = TextEditingController();
  String? zoneArea;
  String city = 'Doha';
  String country = 'Qatar';
  String propertyPosition = 'Residential'; // 'Residential' | 'Commercial'

  final List<String> stepLabels = const [
    'Basic Info',
    'Details',
    'Features',
    'Location',
    'Media',
  ];

  @override
  void dispose() {
    fullNameCtrl.dispose();
    phoneCtrl.dispose();
    emailCtrl.dispose();
    descriptionCtrl.dispose();
    propertyNameCtrl.dispose();
    roomsCtrl.dispose();
    bathroomsCtrl.dispose();
    priceCtrl.dispose();
    areaCtrl.dispose();
    otherFeatureCtrl.dispose();
    addressCtrl.dispose();
    streetCtrl.dispose();
    pincodeCtrl.dispose();
    landmarkCtrl.dispose();
    super.dispose();
  }

  void _goNext() {
    if (currentStep < 5) {
      setState(() => currentStep += 1);
    } else {
      // Final step -> Review & Publish action goes here
    }
  }

  void _goBack() {
    if (currentStep > 1) {
      setState(() => currentStep -= 1);
    }
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      bottomNavigationBar: SafeArea(
        top: false,
        child: Container(
          padding: const EdgeInsets.fromLTRB(20, 12, 20, 20),
          decoration: BoxDecoration(
            color: Colors.white,
            borderRadius: const BorderRadius.vertical(top: Radius.circular(20)),
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
  }

  // ---------------------------------------------------------
  // TOP BAR
  // ---------------------------------------------------------
  Widget _buildTopBar() {
    return Padding(
      padding: const EdgeInsets.fromLTRB(12, 8, 16, 8),
      child: Row(
        children: [
          IconButton(
            icon: const Icon(Icons.arrow_back, color: AppColors.primary),
            onPressed: currentStep > 1
                ? _goBack
                : () {
                    Get.offAll(() => const MainScreen(initialIndex: 2));
                  },
          ),
          const Expanded(
            child: Text(
              'List Your Property',
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
            final isCompleted = leftStep < currentStep;
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
            state: stepNumber < currentStep
                ? _StepState.completed
                : stepNumber == currentStep
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
    switch (currentStep) {
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
          title: 'Property Owner Details',
          subtitle: 'Enter your details to get started',
        ),
        const SizedBox(height: 20),
        _fieldLabel('Full Name', required: true),
        const SizedBox(height: 8),
        _AppTextField(
          controller: fullNameCtrl,
          hint: 'Enter your full name',
          prefixIcon: Icons.person_outline,
        ),
        const SizedBox(height: 18),
        _fieldLabel('Contact Number', required: true),
        const SizedBox(height: 8),
        Row(
          children: [
            _CountryCodeDropdown(
              value: countryCode,
              onChanged: (v) => setState(() => countryCode = v),
            ),
            const SizedBox(width: 10),
            Expanded(
              child: _AppTextField(
                controller: phoneCtrl,
                hint: 'Enter mobile number',
                keyboardType: TextInputType.phone,
              ),
            ),
          ],
        ),
        const SizedBox(height: 14),
        _buildWhatsAppVerifiedBanner(),
        const SizedBox(height: 18),
        _fieldLabel('Email Address'),
        const SizedBox(height: 8),
        _AppTextField(
          controller: emailCtrl,
          hint: 'Enter your email address',
          prefixIcon: Icons.email_outlined,
          keyboardType: TextInputType.emailAddress,
        ),
        const SizedBox(height: 18),
        _fieldLabel('Short Description', required: true),
        const SizedBox(height: 8),
        _AppTextField(
          controller: descriptionCtrl,
          hint: 'Write a short description about your property',
          prefixIcon: Icons.description_outlined,
          maxLines: 4,
          maxLength: 250,
          onChanged: (_) => setState(() {}),
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
          const Expanded(
            child: Column(
              crossAxisAlignment: CrossAxisAlignment.start,
              children: [
                Text(
                  'WhatsApp Verified',
                  style: TextStyle(
                    color: AppColors.greenText,
                    fontWeight: FontWeight.w700,
                    fontSize: 13,
                  ),
                ),
                SizedBox(height: 2),
                Text(
                  'Your number is verified',
                  style: TextStyle(color: AppColors.greenText, fontSize: 12),
                ),
              ],
            ),
          ),
          const Icon(Icons.check_circle, color: Color(0xFF1E9E4B), size: 18),
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
          title: 'Property Details',
          subtitle: 'Tell us about your property',
        ),
        const SizedBox(height: 20),
        _fieldLabel('Property Name', required: true),
        const SizedBox(height: 8),
        _AppTextField(
          controller: propertyNameCtrl,
          hint: 'Enter property name',
        ),
        const SizedBox(height: 18),
        _fieldLabel('Property Type', required: true),
        const SizedBox(height: 8),
        _AppDropdownField(
          value: propertyType,
          hint: 'Select property type',
          icon: Icons.apartment_outlined,
          items: const ['Apartment', 'Villa', 'Townhouse', 'Studio', 'Office'],
          onChanged: (v) => setState(() => propertyType = v),
        ),
        const SizedBox(height: 18),
        Row(
          crossAxisAlignment: CrossAxisAlignment.start,
          children: [
            Expanded(
              child: Column(
                crossAxisAlignment: CrossAxisAlignment.start,
                children: [
                  _fieldLabel('Number of Rooms', required: true),
                  const SizedBox(height: 8),
                  _AppTextField(
                    controller: roomsCtrl,
                    hint: 'e.g. 3',
                    prefixIcon: Icons.bed_outlined,
                    keyboardType: TextInputType.number,
                  ),
                ],
              ),
            ),
            const SizedBox(width: 12),
            Expanded(
              child: Column(
                crossAxisAlignment: CrossAxisAlignment.start,
                children: [
                  _fieldLabel('Bathrooms', required: true),
                  const SizedBox(height: 8),
                  _AppTextField(
                    controller: bathroomsCtrl,
                    hint: 'e.g. 2',
                    prefixIcon: Icons.bathtub_outlined,
                    keyboardType: TextInputType.number,
                  ),
                ],
              ),
            ),
          ],
        ),
        const SizedBox(height: 18),
        _fieldLabel('Property For', required: true),
        const SizedBox(height: 8),
        _buildSaleRentToggle(),
        const SizedBox(height: 18),
        _fieldLabel('Price', required: true),
        const SizedBox(height: 8),
        Row(
          children: [
            _CurrencyDropdown(
              value: currency,
              onChanged: (v) => setState(() => currency = v),
            ),
            const SizedBox(width: 10),
            Expanded(
              child: _AppTextField(
                controller: priceCtrl,
                hint: 'Enter price',
                keyboardType: TextInputType.number,
              ),
            ),
          ],
        ),
        const SizedBox(height: 18),
        _fieldLabel('Area (sqft)', required: true),
        const SizedBox(height: 8),
        _AppTextField(
          controller: areaCtrl,
          hint: 'Enter area in sqft',
          prefixIcon: Icons.square_foot_outlined,
          keyboardType: TextInputType.number,
        ),
      ],
    );
  }

  Widget _buildSaleRentToggle() {
    return Row(
      children: [
        Expanded(
          child: _ToggleButton(
            label: 'Sale',
            icon: Icons.sell_outlined,
            selected: propertyFor == 'Sale',
            onTap: () => setState(() => propertyFor = 'Sale'),
            radius: const BorderRadius.only(
              topLeft: Radius.circular(10),
              bottomLeft: Radius.circular(10),
            ),
          ),
        ),
        Expanded(
          child: _ToggleButton(
            label: 'Rent',
            icon: Icons.vpn_key_outlined,
            selected: propertyFor == 'Rent',
            onTap: () => setState(() => propertyFor = 'Rent'),
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
    final allSelected = amenities.every((a) => a.selected);
    return Column(
      key: key,
      crossAxisAlignment: CrossAxisAlignment.start,
      children: [
        _sectionHeader(
          icon: Icons.apartment_outlined,
          title: 'Features & Amenities',
          subtitle: 'Select amenities and features of your property',
        ),
        const SizedBox(height: 20),
        Row(
          children: [
            const Icon(
              Icons.groups_outlined,
              size: 18,
              color: AppColors.primary,
            ),
            const SizedBox(width: 8),
            const Expanded(
              child: Text(
                'Amenities',
                style: TextStyle(fontWeight: FontWeight.w700, fontSize: 14),
              ),
            ),
            GestureDetector(
              onTap: () {
                setState(() {
                  for (final a in amenities) {
                    a.selected = !allSelected;
                  }
                });
              },
              child: const Text(
                'Select All',
                style: TextStyle(
                  color: AppColors.primary,
                  fontWeight: FontWeight.w600,
                  fontSize: 12.5,
                ),
              ),
            ),
          ],
        ),
        const SizedBox(height: 2),
        const Padding(
          padding: EdgeInsets.only(left: 26),
          child: Text(
            'Choose the amenities available',
            style: TextStyle(color: AppColors.hintGrey, fontSize: 12),
          ),
        ),
        const SizedBox(height: 14),
        GridView.count(
          crossAxisCount: 4,
          shrinkWrap: true,
          physics: const NeverScrollableScrollPhysics(),
          mainAxisSpacing: 10,
          crossAxisSpacing: 10,
          childAspectRatio: 0.82,
          children: amenities.map((a) {
            return _AmenityTile(
              data: a,
              onTap: () => setState(() => a.selected = !a.selected),
            );
          }).toList(),
        ),
        const SizedBox(height: 22),
        Row(
          children: const [
            Icon(Icons.tune, size: 18, color: AppColors.primary),
            SizedBox(width: 8),
            Text(
              'Other Features',
              style: TextStyle(fontWeight: FontWeight.w700, fontSize: 14),
            ),
          ],
        ),
        const Padding(
          padding: EdgeInsets.only(left: 26),
          child: Text(
            'Add other key features of your property',
            style: TextStyle(color: AppColors.hintGrey, fontSize: 12),
          ),
        ),
        const SizedBox(height: 14),
        _chipRow(const [
          'Furnished',
          'Semi Furnished',
          'Unfurnished',
          'Ready to Move',
        ], furnishingSelected),
        const SizedBox(height: 10),
        _chipRow(const [
          'Under Construction',
          'New Property',
          'Resale',
        ], constructionSelected),
        const SizedBox(height: 10),
        _chipRow(const [
          'Servant Room',
          'Study Room',
          'Store Room',
        ], extraRoomsSelected),
        const SizedBox(height: 10),
        _chipRow(const [
          'Laundry Room',
          'Private Garden',
          'Rooftop',
        ], extraRoomsSelected),
        const SizedBox(height: 10),
        _chipRow(const [
          'Sea View',
          'Maid Room',
          'Smart Home',
        ], extraRoomsSelected),
        const SizedBox(height: 18),
        _fieldLabel('Other (Please specify)'),
        const SizedBox(height: 8),
        _AppTextField(
          controller: otherFeatureCtrl,
          hint: 'Enter other features',
        ),
      ],
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
          title: 'Location Details',
          subtitle: 'Help buyers find your property easily',
        ),
        const SizedBox(height: 20),
        _fieldLabel('Select Location on Map', required: true),
        const SizedBox(height: 8),
        const _MapPreview(),
        const SizedBox(height: 10),
        Center(
          child: OutlinedButton.icon(
            onPressed: () {},
            style: OutlinedButton.styleFrom(
              foregroundColor: AppColors.primary,
              backgroundColor: AppColors.pinkChipBg,
              side: const BorderSide(color: AppColors.primary),
              padding: const EdgeInsets.symmetric(horizontal: 20, vertical: 10),
              shape: RoundedRectangleBorder(
                borderRadius: BorderRadius.circular(10),
              ),
            ),
            icon: const Icon(Icons.my_location, size: 16),
            label: const Text(
              'Select on Map',
              style: TextStyle(fontWeight: FontWeight.w700, fontSize: 13),
            ),
          ),
        ),
        SizedBox(height: 15.h),
        _fieldLabel('Property Address', required: true),
        SizedBox(height: 8.h),
        _AppTextField(controller: addressCtrl, hint: 'Enter full address'),
        SizedBox(height: 15.h),
        _fieldLabel('Zone / Area', required: true),
        SizedBox(height: 8.h),
        _AppDropdownField(
          value: zoneArea,
          hint: 'Select area',
          icon: Icons.map_outlined,
          items: ['West Bay', 'The Pearl', 'Al Sadd', 'Lusail'],
          onChanged: (v) => setState(() => zoneArea = v),
        ),
        SizedBox(height: 15.h),
        _fieldLabel('Street / Building', required: true),
        SizedBox(height: 8.h),
        _AppTextField(controller: streetCtrl, hint: 'Enter street or building'),
        SizedBox(height: 15.h),
        Row(
          crossAxisAlignment: CrossAxisAlignment.start,
          children: [
            Expanded(
              child: Column(
                crossAxisAlignment: CrossAxisAlignment.start,
                children: [
                  _fieldLabel('City', required: true),
                  SizedBox(height: 8.h),
                  _AppDropdownField(
                    value: city,
                    hint: 'Select city',
                    icon: Icons.location_city_outlined,
                    items: const ['Doha', 'Al Wakrah', 'Al Rayyan', 'Lusail'],
                    onChanged: (v) => setState(() => city = v ?? city),
                  ),
                ],
              ),
            ),
          ],
        ),
        SizedBox(height: 15.h),
        _fieldLabel('Landmark (Optional)'),
        SizedBox(height: 8.h),
        _AppTextField(controller: landmarkCtrl, hint: 'Enter nearby landmark'),
        SizedBox(height: 15.h),
        _sectionHeader(
          icon: Icons.public,
          title: 'Property Position',
          subtitle: 'Help buyers understand the exact location',
        ),
        SizedBox(height: 14),
        Row(
          children: [
            Expanded(
              child: _ToggleButton(
                label: 'Residential Area',
                icon: Icons.home_outlined,
                selected: propertyPosition == 'Residential',
                onTap: () => setState(() => propertyPosition = 'Residential'),
                radius: BorderRadius.circular(12),
              ),
            ),
            const SizedBox(width: 12),
            Expanded(
              child: _ToggleButton(
                label: 'Commercial Area',
                icon: Icons.apartment_outlined,
                selected: propertyPosition == 'Commercial',
                onTap: () => setState(() => propertyPosition = 'Commercial'),
                radius: BorderRadius.circular(12),
              ),
            ),
          ],
        ),
      ],
    );
  }

  // ---------------------------------------------------------
  // STEP 5 — PHOTOS & VIDEOS (MEDIA)
  // ---------------------------------------------------------
  Widget _buildStep5({Key? key}) {
    return Column(
      key: key,
      crossAxisAlignment: CrossAxisAlignment.start,
      children: [
        _sectionHeader(
          icon: Icons.camera_alt_outlined,
          title: 'Photos & Videos',
          subtitle: 'Add high quality photos and videos to attract more buyers',
        ),
        const SizedBox(height: 20),
        _fieldLabel('Property Photos', required: true),
        const Padding(
          padding: EdgeInsets.only(top: 2, bottom: 12),
          child: Text(
            'Upload clear and attractive photos (Max 20 photos)',
            style: TextStyle(color: AppColors.hintGrey, fontSize: 12),
          ),
        ),
        SizedBox(
          height: 78,
          child: ListView(
            scrollDirection: Axis.horizontal,
            children: const [
              _PhotoThumbnail(color: Color(0xFFEFE3D8)),
              _PhotoThumbnail(color: Color(0xFFE7DED6)),
              _PhotoThumbnail(color: Color(0xFFEDEAE4)),
              _PhotoThumbnail(color: Color(0xFFDCE4E8)),
              _PhotoThumbnail(
                color: Color(0xFF8A8A8A),
                overlayLabel: '+15\nAdd More',
                isLast: true,
              ),
            ],
          ),
        ),
        const SizedBox(height: 14),
        const _DashedUploadBox(
          icon: Icons.add_photo_alternate_outlined,
          title: 'Add Photos',
          subtitle: 'JPG, PNG up to 10MB each',
          filled: true,
        ),
        const SizedBox(height: 22),
        _fieldLabel('Property Videos'),
        const Padding(
          padding: EdgeInsets.only(top: 2, bottom: 4),
          child: Text(
            '(Optional)',
            style: TextStyle(color: AppColors.hintGrey, fontSize: 11),
          ),
        ),
        const Padding(
          padding: EdgeInsets.only(bottom: 12),
          child: Text(
            'Upload video tour of your property (Max 3 videos)',
            style: TextStyle(color: AppColors.hintGrey, fontSize: 12),
          ),
        ),
        const _DashedUploadBox(
          icon: Icons.videocam_outlined,
          title: 'Add Video',
          subtitle: 'MP4, MOV up to 50MB each',
        ),
        const SizedBox(height: 16),
        _buildVideoGuidelines(),
        const SizedBox(height: 22),
        _fieldLabel('Additional Documents'),
        const Padding(
          padding: EdgeInsets.only(top: 2, bottom: 4),
          child: Text(
            '(Optional)',
            style: TextStyle(color: AppColors.hintGrey, fontSize: 11),
          ),
        ),
        const Padding(
          padding: EdgeInsets.only(bottom: 12),
          child: Text(
            'Upload floor plans, brochures or other documents',
            style: TextStyle(color: AppColors.hintGrey, fontSize: 12),
          ),
        ),
        const _DashedUploadBox(
          icon: Icons.upload_file_outlined,
          title: 'Upload Documents',
          subtitle: 'PDF, JPG, PNG up to 10MB each',
        ),
        const SizedBox(height: 18),
        _buildTipBox(),
      ],
    );
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
                  'Tip: Properties with photos get 10x more interest!',
                  style: TextStyle(
                    fontWeight: FontWeight.w600,
                    fontSize: 10.5,
                    color: AppColors.greenText,
                  ),
                ),
                SizedBox(height: 2.h),
                Text(
                  'Make sure to add high quality photos and videos',
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
    final isLastStep = currentStep == 5;

    return SizedBox(
      width: double.infinity,
      height: 54,
      child: ElevatedButton(
        onPressed: _goNext,
        style: ElevatedButton.styleFrom(
          backgroundColor: AppColors.primary,
          shape: RoundedRectangleBorder(
            borderRadius: BorderRadius.circular(14),
          ),
          elevation: 0,
        ),
        child: Row(
          mainAxisAlignment: MainAxisAlignment.center,
          children: [
            Text(
              isLastStep ? 'Review & Publish' : 'Save & Continue',
              style: const TextStyle(
                fontSize: 16,
                fontWeight: FontWeight.w700,
                color: Colors.white,
              ),
            ),
            const SizedBox(width: 8),
            const Icon(Icons.arrow_forward, size: 18),
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
  final _AmenityData data;
  final VoidCallback onTap;

  const _AmenityTile({required this.data, required this.onTap});

  @override
  Widget build(BuildContext context) {
    return GestureDetector(
      onTap: onTap,
      child: Stack(
        children: [
          Container(
            width: 90, // Fixed width
            height: 90, // Fixed height
            decoration: BoxDecoration(
              color: data.selected ? AppColors.pinkChipBg : AppColors.fieldBg,
              borderRadius: BorderRadius.circular(10),
              border: Border.all(
                color: data.selected
                    ? AppColors.primary
                    : AppColors.fieldBorder,
              ),
            ),
            padding: const EdgeInsets.symmetric(horizontal: 6, vertical: 8),
            child: Column(
              mainAxisAlignment: MainAxisAlignment.center,
              children: [
                Icon(
                  data.icon,
                  size: 22,
                  color: data.selected
                      ? AppColors.primary
                      : AppColors.labelGrey,
                ),
                const SizedBox(height: 6),
                Text(
                  data.label,
                  textAlign: TextAlign.center,
                  maxLines: 2,
                  overflow: TextOverflow.ellipsis,
                  style: TextStyle(
                    fontSize: 10,
                    fontWeight: FontWeight.w600,
                    color: data.selected
                        ? AppColors.primary
                        : AppColors.labelGrey,
                  ),
                ),
              ],
            ),
          ),
          if (data.selected)
            Positioned(
              top: 4,
              right: 4,
              child: Container(
                width: 16,
                height: 16,
                decoration: const BoxDecoration(
                  color: AppColors.primary,
                  shape: BoxShape.circle,
                ),
                child: const Icon(Icons.check, size: 10, color: Colors.white),
              ),
            ),
        ],
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
class _PhotoThumbnail extends StatelessWidget {
  final Color color;
  final String? overlayLabel;
  final bool isLast;

  const _PhotoThumbnail({
    required this.color,
    this.overlayLabel,
    this.isLast = false,
  });

  @override
  Widget build(BuildContext context) {
    return Padding(
      padding: EdgeInsets.only(right: isLast ? 0 : 8),
      child: Stack(
        children: [
          Container(
            width: 78,
            height: 78,
            decoration: BoxDecoration(
              color: color,
              borderRadius: BorderRadius.circular(10),
            ),
            alignment: Alignment.center,
            child: overlayLabel != null
                ? Text(
                    overlayLabel!,
                    textAlign: TextAlign.center,
                    style: const TextStyle(
                      color: Colors.white,
                      fontWeight: FontWeight.w700,
                      fontSize: 11,
                    ),
                  )
                : const Icon(Icons.image_outlined, color: Colors.white70),
          ),
          if (!isLast)
            Positioned(
              top: 4,
              right: 4,
              child: Container(
                width: 16,
                height: 16,
                decoration: const BoxDecoration(
                  color: Colors.black54,
                  shape: BoxShape.circle,
                ),
                child: const Icon(Icons.close, size: 10, color: Colors.white),
              ),
            ),
        ],
      ),
    );
  }
}

// =================================================================
// DASHED UPLOAD BOX (Step 5 — photos / video / documents)
// =================================================================
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
      padding: EdgeInsets.symmetric(vertical: 10.h),
      decoration: BoxDecoration(
        color: filled ? AppColors.pinkChipBg : AppColors.fieldBg,
        borderRadius: BorderRadius.circular(8),
        border: Border.all(
          color: filled ? AppColors.primary : AppColors.fieldBorder,
          width: 1.w,
        ),
      ),
      child: Column(
        children: [
          Row(
            crossAxisAlignment: CrossAxisAlignment.center,
            mainAxisAlignment: MainAxisAlignment.center,
            children: [
              Icon(icon, color: AppColors.primary, size: 24),

              SizedBox(width: 8.w),
              Text(
                title,
                style: const TextStyle(
                  color: AppColors.primary,
                  fontWeight: FontWeight.w500,
                  fontSize: 13.5,
                ),
              ),
            ],
          ),

          const SizedBox(height: 3),
          Text(
            subtitle,
            style: const TextStyle(color: AppColors.hintGrey, fontSize: 11),
          ),
        ],
      ),
    );
  }
}

// =================================================================
// ENTRY POINT (for quick preview / testing)
// =================================================================
class ListYourPropertyApp extends StatelessWidget {
  const ListYourPropertyApp({super.key});

  @override
  Widget build(BuildContext context) {
    return MaterialApp(
      debugShowCheckedModeBanner: false,
      theme: ThemeData(
        fontFamily: 'Roboto',
        useMaterial3: true,
        colorScheme: ColorScheme.fromSeed(seedColor: AppColors.primary),
      ),
      home: const ListYourPropertyScreen(),
    );
  }
}

void main() {
  runApp(const ListYourPropertyApp());
}
