
import 'package:flutter/material.dart';
import 'package:flutter_screenutil/flutter_screenutil.dart';
import 'package:get/get.dart';

import 'package:villas_qatar/Core/constants/app_colors.dart';
import 'package:villas_qatar/Core/utils/auth_guard.dart';
import 'package:villas_qatar/modules/home/views/home_screen.dart';
import 'package:villas_qatar/modules/pricestimator/views/price_estimator_screen.dart';
import 'package:villas_qatar/modules/propertylist/views/Mypropertiesscreen.dart';
import 'package:villas_qatar/modules/searchscreen/service/searchlist_screen.dart';
import 'package:villas_qatar/modules/searchscreen/view/search_screen.dart';
import 'package:villas_qatar/modules/settings/view/setting_screen.dart';

class MainScreen extends StatefulWidget {
  final int initialIndex;
  final String? initialSearch;
  final String? initialType;
  final String? initialPurpose;
  final String? initialCategory;
  final String? initialLocationId;

  const MainScreen({
    super.key,
    this.initialIndex = 0,
    this.initialSearch,
    this.initialType,
    this.initialPurpose,
    this.initialCategory,
    this.initialLocationId,
  });

  @override
  State<MainScreen> createState() => _MainScreenState();
}

class _MainScreenState extends State<MainScreen> {

  static const Color _inactiveColor = Color(0xFF667085);

  late int _selectedTab;

  PropertySearchController get _searchController =>
      Get.isRegistered<PropertySearchController>()
          ? Get.find<PropertySearchController>()
          : Get.put(PropertySearchController(), permanent: true);

  @override
  void initState() {
    super.initState();

    _selectedTab = widget.initialIndex.clamp(0, 4);

    final controller = _searchController;

    if (widget.initialSearch?.trim().isNotEmpty ?? false) {
      controller.filter.search = widget.initialSearch!.trim();
      controller.searchTextController.text = widget.initialSearch!.trim();
    }

    if (widget.initialType?.trim().isNotEmpty ?? false) {
      controller.filter.type = widget.initialType!.trim();
    }

    if (widget.initialPurpose?.trim().isNotEmpty ?? false) {
      controller.filter.purpose =
          widget.initialPurpose!.trim().toUpperCase();
    }

    if (widget.initialCategory?.trim().isNotEmpty ?? false) {
      controller.filter.type = widget.initialCategory!.trim();
    }

    if (widget.initialLocationId?.trim().isNotEmpty ?? false) {
      controller.filter.locationId = widget.initialLocationId!.trim();
    }

    if (_selectedTab == 1) {
      WidgetsBinding.instance.addPostFrameCallback((_) {
        if (mounted) {
          _searchController.fetchProperties();
        }
      });
    }

    // Validate protected initial tabs after the first frame.
    if (_selectedTab == 2 || _selectedTab == 3) {
      WidgetsBinding.instance.addPostFrameCallback((_) {
        if (!mounted) return;

        final message = _selectedTab == 2
            ? 'Please login to manage your properties.'.tr
            : 'Please login to access AI Price.'.tr;

        if (!AuthGuard.requireLogin(message: message)) {
          setState(() => _selectedTab = 0);
        }
      });
    }
  }

  void _openScreen(int index) {
    if (index < 0 || index > 4) return;

    if (index == 2) {
      if (!AuthGuard.requireLogin(
        message: 'Please login to manage your properties.'.tr,
      )) {
        return;
      }
    }

    if (index == 3) {
      if (!AuthGuard.requireLogin(
        message: 'Please login to access AI Price.'.tr,
      )) {
        return;
      }
    }

    if (index == 1) {
      _searchController.fetchProperties();
    }

    setState(() {
      _selectedTab = index;
    });
  }

  void _goHome() => _openScreen(0);

  void _handleSellTap() => _openScreen(2);

  void _handleAiPriceTap() => _openScreen(3);

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      body: IndexedStack(
        index: _selectedTab,
        children: [
          HomeScreen(
            onSearch: _handleHomeSearch,
            onCategorySelected: _handleCategorySearch,
            onPurposeSelected: _handlePurposeSearch,
            onOpenSearch: _handleOpenSearch,
          ),
          SearchScreen(),
          const MyPropertiesScreen(),
          PriceEstimatorScreen(),
          SettingsScreen(),
        ],
      ),
      bottomNavigationBar: _buildBottomNavigationBar(),
    );
  }

  Widget _buildBottomNavigationBar() {
    return SafeArea(
      top: false,
      child: Container(
        height: 82.h,
        padding: EdgeInsets.fromLTRB(5.w, 5.h, 5.w, 5.h),
        decoration: BoxDecoration(
          color: Colors.white,
          boxShadow: [
            BoxShadow(
              color: Colors.black.withOpacity(0.07),
              blurRadius: 14.r,
              offset: Offset(0, -3.h),
            ),
          ],
        ),
        child: Row(
          crossAxisAlignment: CrossAxisAlignment.center,
          children: [
            _buildNavigationItem(
              icon: Icons.home_outlined,
              label: 'Home'.tr,
              index: 0,
              onTap: _goHome,
            ),
            _buildNavigationItem(
              icon: Icons.search_rounded,
              label: 'Explore'.tr,
              index: 1,
              onTap: () => _openScreen(1),
            ),
            Expanded(child: _buildSellItem()),
            _buildNavigationItem(
              icon: Icons.auto_awesome_outlined,
              label: 'AI Price'.tr,
              index: 3,
              onTap: _handleAiPriceTap,
            ),
            _buildNavigationItem(
              icon: Icons.person_outline_rounded,
              label: 'Profile'.tr,
              index: 4,
              onTap: () => _openScreen(4),
            ),
          ],
        ),
      ),
    );
  }

  Widget _buildSellItem() {
    final bool isSelected = _selectedTab == 2;

    return Transform.translate(
      offset: Offset(0, -5.h),
      child: InkWell(
        onTap: _handleSellTap,
        borderRadius: BorderRadius.circular(30.r),
        child: Column(
          mainAxisSize: MainAxisSize.min,
          mainAxisAlignment: MainAxisAlignment.center,
          children: [
            Container(
              width: 48.w,
              height: 48.w,
              decoration: BoxDecoration(
                color: AppColors.primary,
                shape: BoxShape.circle,
                boxShadow: [
                  BoxShadow(
                    color: AppColors.primary.withOpacity(0.28),
                    blurRadius: 10.r,
                    offset: Offset(0, 3.h),
                  ),
                ],
              ),
              child: Icon(
                Icons.add_rounded,
                color: Colors.white,
                size: 32.sp,
              ),
            ),
            SizedBox(height: 3.h),
            Text(
              'Sell'.tr,
              maxLines: 1,
              overflow: TextOverflow.ellipsis,
              style: TextStyle(
                fontSize: 10.sp,
                fontWeight: isSelected ? FontWeight.w700 : FontWeight.w500,
                color: isSelected ? AppColors.primary : _inactiveColor,
              ),
            ),
          ],
        ),
      ),
    );
  }

  Widget _buildNavigationItem({
    required IconData icon,
    required String label,
    required int index,
    required VoidCallback onTap,
  }) {
    final bool isSelected = _selectedTab == index;

    return Expanded(
      child: InkWell(
        onTap: onTap,
        borderRadius: BorderRadius.circular(16.r),
        child: Padding(
          padding: EdgeInsets.symmetric(
            horizontal: 2.w,
            vertical: 3.h,
          ),
          child: Column(
            mainAxisSize: MainAxisSize.min,
            mainAxisAlignment: MainAxisAlignment.center,
            children: [
              AnimatedContainer(
                duration: const Duration(milliseconds: 200),
                width: 42.w,
                height: 35.h,
                alignment: Alignment.center,
                decoration: BoxDecoration(
                  color: isSelected
                      ? AppColors.primaryLight
                      : Colors.transparent,
                  borderRadius: BorderRadius.circular(12.r),
                ),
                child: Icon(
                  icon,
                  size: 24.sp,
                  color: isSelected ? AppColors.primary : _inactiveColor,
                ),
              ),
              SizedBox(height: 3.h),
              Text(
                label,
                maxLines: 1,
                overflow: TextOverflow.ellipsis,
                textAlign: TextAlign.center,
                style: TextStyle(
                  fontSize: 10.sp,
                  fontWeight:
                      isSelected ? FontWeight.w700 : FontWeight.w500,
                  color: isSelected ? AppColors.primary : _inactiveColor,
                ),
              ),
            ],
          ),
        ),
      ),
    );
  }

  void _handleOpenSearch({String? locationId}) {
    final controller = _searchController;

    if (locationId != null && locationId.trim().isNotEmpty) {
      controller.filter.locationId = locationId.trim();
    }

    controller.fetchProperties();
    _openScreen(1);
  }

  void _handleCategorySearch(String type) {
    final controller = _searchController;

    controller.filter.search = '';
    controller.searchTextController.clear();
    controller.filter.type = type;

    controller.update();
    controller.fetchProperties();

    _openScreen(1);
  }

  void _handleHomeSearch(
    String propertyName,
    String purpose, {
    double? latitude,
    double? longitude,
  }) {
    final controller = _searchController;

    controller.searchTextController.text = propertyName;

    controller.applyFilters(
      search: propertyName,
      purpose: purpose,
      latitude: latitude,
      longitude: longitude,
    );

    _openScreen(1);
  }

  void _handlePurposeSearch(String purpose) {
    final controller = _searchController;

    controller.filter.search = '';
    controller.searchTextController.clear();
    controller.filter.type = '';
    controller.filter.purpose = purpose;

    controller.update();
    controller.fetchProperties();

    _openScreen(1);
  }
}
