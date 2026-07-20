import 'package:flutter/material.dart';
import 'package:flutter_screenutil/flutter_screenutil.dart';
import 'package:villas_qatar/Core/constants/app_colors.dart';

class PriceEstimatorScreen extends StatefulWidget {
  const PriceEstimatorScreen({super.key});

  @override
  State<PriceEstimatorScreen> createState() => _PriceEstimatorScreenState();
}

class _PriceEstimatorScreenState extends State<PriceEstimatorScreen> {
  int _selectedType = 0;
  bool _advancedOpen = false;
  final TextEditingController _highlightsController = TextEditingController();

  final List<_PropertyType> _types = const [
    _PropertyType('Apartment', Icons.apartment),
    _PropertyType('Villa / House', Icons.villa),
    _PropertyType('Plot', Icons.crop_square),
    _PropertyType('Commercial', Icons.store_mall_directory_outlined),
  ];

  final List<_QuickDetail> _details = const [
    _QuickDetail('BHK', 'Select'),
    _QuickDetail('Bathrooms', 'Select'),
    _QuickDetail('Furnishing', 'Select'),
    _QuickDetail('Floor', 'Any'),
    _QuickDetail('Total Floors', 'Any'),
    _QuickDetail('Age of Property', 'Any'),
    _QuickDetail('Parking', 'Any'),
  ];

  @override
  void dispose() {
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
                                        "Location",
                                        style: TextStyle(
                                          fontSize: 13,
                                          fontWeight: FontWeight.w600,
                                        ),
                                      ),
                                      SizedBox(height: 4.h),
                                      TextField(
                                        maxLines: 2,
                                        minLines: 1,
                                        decoration: InputDecoration(
                                          hintText:
                                              "Enter city, locality or area",
                                          hintMaxLines: 2,
                                          border: InputBorder.none,
                                          isDense: true,
                                          contentPadding: EdgeInsets.zero,
                                          hintStyle: TextStyle(
                                            color: const Color(0xFF8A8A99),
                                            fontSize: 10.sp,
                                            height: 1.3,
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
                                      const Text(
                                        "Area (sqft)",
                                        style: TextStyle(
                                          fontSize: 13,
                                          fontWeight: FontWeight.w600,
                                        ),
                                      ),
                                      const SizedBox(height: 8),
                                      TextField(
                                        keyboardType: TextInputType.number,
                                        decoration: InputDecoration(
                                          hintText: "e.g. 1200",
                                          suffixText: "sqft",
                                          border: InputBorder.none,
                                          isDense: true,
                                          contentPadding: EdgeInsets.zero,
                                          hintStyle: TextStyle(
                                            color: Color(0xFF8A8A99),
                                            fontSize: 12.sp,
                                          ),
                                          suffixStyle: TextStyle(
                                            color: Color.fromARGB(
                                              255,
                                              44,
                                              44,
                                              150,
                                            ),
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
                    _sectionLabel('Property Type'),
                    const SizedBox(height: 8),
                    _buildTypeGrid(),
                    const SizedBox(height: 20),
                    Row(
                      children: const [
                        Text(
                          'Quick Details',
                          style: TextStyle(
                            fontSize: 14,
                            fontWeight: FontWeight.w700,
                            color: AppColors.textPrimary,
                          ),
                        ),
                        SizedBox(width: 6),
                        Text(
                          '(Optional)',
                          style: TextStyle(
                            fontSize: 12.5,
                            color: AppColors.textSecondary,
                          ),
                        ),
                      ],
                    ),
                    const SizedBox(height: 10),
                    _buildDetailGrid(),
                    const SizedBox(height: 18),
                    _sectionLabel('Share some highlights (Optional)'),
                    _buildHighlightsField(),
                    const SizedBox(height: 16),
                    _buildAdvancedOptions(),
                    const SizedBox(height: 24),
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
          const Text(
            'AI Price Estimator',
            style: TextStyle(
              color: AppColors.textPrimary,
              fontSize: 15,
              fontWeight: FontWeight.w600,
            ),
          ),
        ],
      ),
      actions: [
        IconButton(
          icon: const Icon(Icons.info_outline, color: AppColors.textPrimary),
          onPressed: () {},
        ),
      ],
    );
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

                    const Text(
                      'Estimate Smarter',
                      style: TextStyle(
                        color: Colors.black,
                        fontSize: 21,
                        fontWeight: FontWeight.w700,
                      ),
                    ),

                    const Text(
                      'Price Better.',
                      style: TextStyle(
                        color: AppColors.primary,
                        fontSize: 21,
                        fontWeight: FontWeight.w700,
                      ),
                    ),

                    const SizedBox(height: 8),
                    Text(
                      'Get an AI-powered estimate of your\n property value in seconds.',
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

  Widget _buildEstimateCard() {
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
            style: TextStyle(fontSize: 10.5, color: AppColors.textSecondary),
          ),
          const SizedBox(height: 2),
          const Text(
            'QAR 1,250,000',
            style: TextStyle(
              fontSize: 15,
              fontWeight: FontWeight.w700,
              color: AppColors.primary,
            ),
          ),
          const SizedBox(height: 2),
          const Text(
            'Price Range 1.15M - 1.35M',
            style: TextStyle(fontSize: 10, color: AppColors.textSecondary),
          ),
        ],
      ),
    );
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
    return Column(
      spacing: 10.h,
      children: [
        /// Row 1
        Row(
          children: [
            Expanded(
              child: _detailCard(
                icon: Icons.bed_outlined,
                title: "BHK",
                value: "Select",
              ),
            ),
            const SizedBox(width: 12),
            Expanded(
              child: _detailCard(
                icon: Icons.bathtub_outlined,
                title: "Bathrooms",
                value: "Select",
              ),
            ),
          ],
        ),

        /// Row 2
        Row(
          children: [
            Expanded(
              child: _detailCard(
                icon: Icons.chair_outlined,
                title: "Furnishing",
                value: "Select",
              ),
            ),
            const SizedBox(width: 12),
            Expanded(
              child: _detailCard(
                icon: Icons.layers_outlined,
                title: "Floor",
                value: "Any",
              ),
            ),
          ],
        ),

        /// Row 3
        Row(
          children: [
            Expanded(
              child: _detailCard(
                icon: Icons.apartment_outlined,
                title: "Total Floors",
                value: "Any",
              ),
            ),
            const SizedBox(width: 12),
            Expanded(
              child: _detailCard(
                icon: Icons.calendar_today_outlined,
                title: "Age of Property",
                value: "Any",
              ),
            ),
          ],
        ),

        /// Row 4
        _detailCard(
          icon: Icons.directions_car_outlined,
          title: "Parking",
          value: "Any",
          fullWidth: true,
        ),
      ],
    );
  }

  Widget _detailCard({
    required IconData icon,
    required String title,
    required String value,
    bool fullWidth = false,
  }) {
    return Container(
      width: fullWidth ? double.infinity : null,
      height: 74,
      padding: const EdgeInsets.symmetric(horizontal: 16),
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
                  softWrap: false,
                  overflow: TextOverflow.ellipsis,
                  style: const TextStyle(
                    fontSize: 10,
                    fontWeight: FontWeight.w700,
                    color: Color(0xff1E2344),
                  ),
                ),
                const SizedBox(height: 4),
                Text(
                  value,
                  style: const TextStyle(
                    fontSize: 12,
                    color: Color(0xff8C91A6),
                    fontWeight: FontWeight.w500,
                  ),
                ),
              ],
            ),
          ),

          const Icon(
            Icons.keyboard_arrow_down_rounded,
            size: 24,
            color: Color(0xff1E2344),
          ),
        ],
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
            decoration: const InputDecoration(
              hintText: 'e.g. Sea view, Near metro, Gated community...',
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
              style:  TextStyle(
                fontSize: 10.5.sp,
                color: AppColors.textSecondary,
              ),
            ),
          ),
        ],
      ),
    );
  }

  Widget _buildAdvancedOptions() {
    return Container(
      decoration: BoxDecoration(
        color: AppColors.surface,
        borderRadius: BorderRadius.circular(12.r),
        border: Border.all(color: AppColors.divider),
      ),
      child: Theme(
        data: Theme.of(context).copyWith(dividerColor: Colors.transparent),
        child: ExpansionTile(
          onExpansionChanged: (v) => setState(() => _advancedOpen = v),
          tilePadding:  EdgeInsets.symmetric(horizontal: 14.w),
          title:  Text(
            'Advanced Options',
            style: TextStyle(
              fontSize: 13.sp,
              fontWeight: FontWeight.w600,
              color: AppColors.textPrimary,
            ),
          ),
          subtitle:  Text(
            'Add more details for a more accurate estimate',
            style: TextStyle(fontSize: 11.sp, color: AppColors.textSecondary),
          ),
          trailing: Icon(
            _advancedOpen ? Icons.keyboard_arrow_up : Icons.keyboard_arrow_down,
            color: AppColors.primary,
          ),
          children: [
            Padding(
              padding: const EdgeInsets.fromLTRB(14, 0, 14, 14),
              child: Column(
                children: [
                  _textField(
                    hint: 'View (e.g. Sea, City, Garden)',
                    icon: Icons.visibility_outlined,
                  ),
                 SizedBox(height: 10.h),
                  _textField(
                    hint: 'Amenities (e.g. Pool, Gym)',
                    icon: Icons.pool_outlined,
                  ),
                ],
              ),
            ),
          ],
        ),
      ),
    );
  }

  Widget _buildCta() {
    return InkWell(
      onTap: () {},
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
        child: Row(
          mainAxisAlignment: MainAxisAlignment.center,
          children: [
             Icon(Icons.auto_awesome, color: Colors.white, size: 18.sp),
            SizedBox(width: 8.w),
            Column(
              mainAxisSize: MainAxisSize.min,
              crossAxisAlignment: CrossAxisAlignment.start,
              children: [
                Text(
                  'Get AI Estimate',
                  style: TextStyle(
                    color: Colors.white,
                    fontWeight: FontWeight.w700,
                    fontSize: 14.5.sp,
                  ),
                ),
                Text(
                  'View estimated price & range',
                  style: TextStyle(color: Colors.white70, fontSize: 10.5.sp),
                ),
              ],
            ),
            SizedBox(width: 10.w),
            const Icon(Icons.arrow_forward, color: Colors.white, size: 18),
          ],
        ),
      ),
    );
  }

  Widget _buildFooterNote() {
    return Row(
      mainAxisAlignment: MainAxisAlignment.center,
      children: [
        Icon(Icons.lock_outline, size: 13.sp, color: AppColors.textSecondary),
        SizedBox(width: 6.w),
        Text(
          'Your information is secure and private',
          style: TextStyle(fontSize: 11.sp, color: AppColors.textSecondary),
        ),
      ],
    );
  }
}

class _PropertyType {
  final String label;
  final IconData icon;
  const _PropertyType(this.label, this.icon);
}

class _QuickDetail {
  final String label;
  final String value;
  const _QuickDetail(this.label, this.value);
}
