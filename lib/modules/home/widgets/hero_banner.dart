import 'package:flutter/material.dart';
import 'package:flutter_screenutil/flutter_screenutil.dart';
import 'package:get/get.dart';
import 'package:villas_qatar/core/constants/app_colors.dart';
import 'package:villas_qatar/modules/searchscreen/view/search_screen.dart';

/// Search intent selected alongside the query.
enum PropertySearchType { rent, sale }

class HomeBanner extends StatefulWidget {
  /// Now passes back both the query text and which mode (rent/sale) was active.
  final void Function(String propertyName, PropertySearchType type) onSearch;
  const HomeBanner({super.key, required this.onSearch});

  @override
  State<HomeBanner> createState() => _HomeBannerState();
}

class _HomeBannerState extends State<HomeBanner> {
  final TextEditingController searchController = TextEditingController();
  final FocusNode _focusNode = FocusNode();

  PropertySearchType _selectedType = PropertySearchType.rent;
  bool _isFocused = false;

  @override
  void initState() {
    super.initState();
    _focusNode.addListener(() {
      setState(() => _isFocused = _focusNode.hasFocus);
    });
  }

  void _searchProperty() {
    final propertyName = searchController.text.trim();

    if (propertyName.isEmpty) return;

    FocusScope.of(context).unfocus();

    // Pass search value + selected type
    widget.onSearch(propertyName, _selectedType);

    // Then clear TextField
    searchController.clear();
  }

  @override
  void dispose() {
    searchController.dispose();
    _focusNode.dispose();
    super.dispose();
  }

  @override
  Widget build(BuildContext context) {
    return Container(
      height: 240.h,

      child: ClipRRect(
        borderRadius: BorderRadiusGeometry.only(
          bottomLeft: Radius.circular(40),
          bottomRight: Radius.circular(40),
        ),
        child: Stack(
          children: [
            /// Background Image
            Positioned.fill(
              child: Opacity(
                opacity: .3,
                child: ClipRRect(
                  borderRadius: BorderRadiusGeometry.only(
                    bottomLeft: Radius.circular(40),
                    bottomRight: Radius.circular(40),
                  ),
                  child: Image.asset("assets/auth_bg1.png", fit: BoxFit.cover),
                ),
              ),
            ),

            /// Content
            Padding(
              padding: EdgeInsets.symmetric(horizontal: 20.w, vertical: 15.h),
              child: Column(
                crossAxisAlignment: CrossAxisAlignment.start,
                children: [
                  Row(
                    children: [
                      Text(
                        "Find your".tr + " dream villas".tr,
                        style: TextStyle(
                          fontFamily: "Rubik",
                          fontSize: 20.sp,
                          fontWeight: FontWeight.w400,
                          color: Colors.black,
                        ),
                      ),
                    ],
                  ),

                  Text(
                    "in Qatar".tr,
                    style: TextStyle(
                      fontSize: 25.sp,
                      fontWeight: FontWeight.w500,
                      color: AppColors.primary,
                    ),
                  ),

                  //  SizedBox(height: 6.h),
                  SizedBox(
                    width: 240.w,
                    child: Text(
                      "Discover premium villas and properties in the best locations across Qatar"
                          .tr,
                      style: TextStyle(
                        fontSize: 11.sp,
                        color: Colors.black.withOpacity(.9),
                      ),
                    ),
                  ),
                  const Spacer(),

                  /// ---- Rent / Sale toggle ----
                  Padding(
                    padding: EdgeInsets.only(right: 14.w, bottom: 10.h),
                    child: _SearchTypeToggle(
                      selected: _selectedType,
                      onChanged: (type) {
                        setState(() => _selectedType = type);
                      },
                    ),
                  ),

                  /// ---- AI-style search bar ----
                  Padding(
                    padding: EdgeInsets.only(right: 14.w),
                    child: _AiSearchField(
                      controller: searchController,
                      focusNode: _focusNode,
                      isFocused: _isFocused,
                      onSubmit: _searchProperty,
                    ),
                  ),
                ],
              ),
            ),
          ],
        ),
      ),
    );
  }
}

/// Pill-shaped Rent / Sale segmented toggle.
class _SearchTypeToggle extends StatelessWidget {
  final PropertySearchType selected;
  final ValueChanged<PropertySearchType> onChanged;

  const _SearchTypeToggle({required this.selected, required this.onChanged});

  @override
  Widget build(BuildContext context) {
    return Container(
      height: 34.h,
      padding: EdgeInsets.all(3.r),
      decoration: BoxDecoration(
        color: Colors.white.withOpacity(.85),
        borderRadius: BorderRadius.circular(20.r),
        boxShadow: const [
          BoxShadow(color: Colors.black12, blurRadius: 8, offset: Offset(0, 2)),
        ],
      ),
      child: Row(
        mainAxisSize: MainAxisSize.min,
        children: [
          _buildOption(context, "Rent".tr, PropertySearchType.rent),
          _buildOption(context, "Sale".tr, PropertySearchType.sale),
        ],
      ),
    );
  }

  Widget _buildOption(
    BuildContext context,
    String label,
    PropertySearchType type,
  ) {
    final bool isActive = selected == type;

    return GestureDetector(
      onTap: () => onChanged(type),
      child: AnimatedContainer(
        duration: const Duration(milliseconds: 200),
        curve: Curves.easeOut,
        padding: EdgeInsets.symmetric(horizontal: 18.w, vertical: 6.h),
        decoration: BoxDecoration(
          borderRadius: BorderRadius.circular(18.r),
          gradient: isActive
              ? const LinearGradient(
                  colors: [Color(0xffA61E3D), Color(0xff7A1630)],
                )
              : null,
        ),
        child: Text(
          label,
          style: TextStyle(
            fontSize: 11.sp,
            fontWeight: FontWeight.w600,
            color: isActive ? Colors.white : Colors.black54,
          ),
        ),
      ),
    );
  }
}

/// A search field styled like a modern AI-assistant search box:
/// gradient border that lights up on focus, a sparkle/AI icon, and
/// a rounded send button.
class _AiSearchField extends StatelessWidget {
  final TextEditingController controller;
  final FocusNode focusNode;
  final bool isFocused;
  final VoidCallback onSubmit;

  const _AiSearchField({
    required this.controller,
    required this.focusNode,
    required this.isFocused,
    required this.onSubmit,
  });

  @override
  Widget build(BuildContext context) {
    return AnimatedContainer(
      duration: const Duration(milliseconds: 250),
      curve: Curves.easeOut,
      padding: EdgeInsets.all(isFocused ? 1.6 : 0),
      decoration: BoxDecoration(
        borderRadius: BorderRadius.circular(16.r),
        gradient: isFocused
            ? const LinearGradient(
                colors: [
                  Color(0xffA61E3D),
                  Color(0xffFFB199),
                  Color(0xffA61E3D),
                ],
              )
            : null,
        boxShadow: [
          BoxShadow(
            color: isFocused
                ? const Color(0xffA61E3D).withOpacity(.25)
                : Colors.black12,
            blurRadius: isFocused ? 20 : 15,
            offset: const Offset(0, 4),
          ),
        ],
      ),
      child: Container(
        height: 48.h,
        decoration: BoxDecoration(
          color: Colors.white,
          borderRadius: BorderRadius.circular(15.r),
        ),
        child: Row(
          children: [
            SizedBox(width: 14.w),

            /// AI sparkle icon instead of plain magnifier
            ShaderMask(
              shaderCallback: (bounds) => const LinearGradient(
                colors: [Color(0xffA61E3D), Color(0xffFF8A65)],
              ).createShader(bounds),
              child: Icon(Icons.auto_awesome, color: Colors.white, size: 18.sp),
            ),

            SizedBox(width: 10.w),

            Expanded(
              child: TextField(
                controller: controller,
                focusNode: focusNode,
                textInputAction: TextInputAction.search,
                onSubmitted: (_) => onSubmit(),
                style: TextStyle(fontSize: 12.sp, color: Colors.black87),
                decoration: InputDecoration(
                  border: InputBorder.none,
                  hintText: "Ask AI to find your villa...".tr,
                  isDense: true,
                  isCollapsed: true,
                  hintStyle: TextStyle(fontSize: 11.sp, color: Colors.grey),
                ),
              ),
            ),

            /// Send / Arrow button
            Padding(
              padding: EdgeInsets.only(right: 6.w),
              child: GestureDetector(
                onTap: onSubmit,
                child: Container(
                  width: 36.w,
                  height: 32.h,
                  decoration: BoxDecoration(
                    gradient: const LinearGradient(
                      colors: [Color(0xffA61E3D), Color(0xff7A1630)],
                    ),
                    borderRadius: BorderRadius.circular(30.r),
                  ),
                  child: Icon(
                    Icons.arrow_forward_rounded,
                    color: Colors.white,
                    size: 16.sp,
                  ),
                ),
              ),
            ),
          ],
        ),
      ),
    );
  }
}
