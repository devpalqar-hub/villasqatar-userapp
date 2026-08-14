import 'package:flutter/material.dart';
import 'package:get/get_core/src/get_main.dart';
import 'package:get/get_instance/src/extension_instance.dart';
import 'package:get/get_utils/src/extensions/internacionalization.dart';
import 'package:villas_qatar/Core/theme/app_motion.dart';
import 'package:villas_qatar/Core/utils/auth_guard.dart';
import 'package:villas_qatar/modules/chats/views/chatlistscreen.dart';
import 'package:villas_qatar/modules/home/views/home_screen.dart';
import 'package:villas_qatar/modules/mainscreen/home_bottom_nav.dart';
import 'package:villas_qatar/modules/propertylist/views/Mypropertiesscreen.dart';
import 'package:villas_qatar/modules/propertylist/views/add_listproperty.dart';
import 'package:villas_qatar/modules/searchscreen/service/searchlist_screen.dart';
import 'package:villas_qatar/modules/searchscreen/view/search_screen.dart';
import 'package:villas_qatar/modules/settings/view/setting_screen.dart';

class MainScreen extends StatefulWidget {
  final int initialIndex;

  final String? initialSearch;
  final String? initialType;
  final String? initialPurpose;
  final String? initialCategory;

  const MainScreen({
    super.key,
    this.initialIndex = 0,
    this.initialSearch,
    this.initialType,
    this.initialPurpose,
    this.initialCategory,
  });

  @override
  State<MainScreen> createState() => _MainScreenState();
}

class _MainScreenState extends State<MainScreen> {
  late int currentIndex;

  /// Built lazily, one tab at a time, in [_pageFor] — some tab widgets
  /// (e.g. SettingsScreen) fire off API calls from a field initializer
  /// the moment they're constructed. Building all 5 up front in
  /// initState() used to construct every tab (including ones a guest
  /// never visits) right after Skip, which fired those calls before the
  /// user ever left Home. Caching by index still keeps each tab's state
  /// alive across switches, just without building tabs nobody opened.
  final Map<int, Widget> _pageCache = {};

  @override
  void initState() {
    super.initState();

    /// Select requested bottom navigation tab
    currentIndex = widget.initialIndex;

    /// Get or create ONE search controller
    final controller = Get.isRegistered<PropertySearchController>()
        ? Get.find<PropertySearchController>()
        : Get.put(PropertySearchController(), permanent: true);

    /// Apply initial SEARCH if provided
    if (widget.initialSearch != null &&
        widget.initialSearch!.trim().isNotEmpty) {
      controller.filter.search = widget.initialSearch!.trim();

      controller.searchTextController.text = widget.initialSearch!.trim();
    }

    /// Apply initial PROPERTY TYPE if provided
    if (widget.initialType != null && widget.initialType!.trim().isNotEmpty) {
      controller.filter.type = widget.initialType!.trim();
    }

    /// Apply initial BUY / RENT
    if (widget.initialPurpose != null &&
        widget.initialPurpose!.trim().isNotEmpty) {
      controller.filter.purpose = widget.initialPurpose!.trim().toUpperCase();
    }

    /// Apply initial category if needed
    if (widget.initialCategory != null &&
        widget.initialCategory!.trim().isNotEmpty) {
      controller.filter.type = widget.initialCategory!.trim();
    }

    /// If MainScreen was opened directly on Search,
    /// fetch using the initial filters.
    if (widget.initialIndex == 1) {
      WidgetsBinding.instance.addPostFrameCallback((_) {
        controller.fetchProperties();
      });
    }
  }

  Widget _pageFor(int index) {
    return _pageCache.putIfAbsent(index, () {
      switch (index) {
        case 0:
          return HomeScreen(
            onSearch: _handleHomeSearch,
            onCategorySelected: _handleCategorySearch,
            onPurposeSelected: _handlePurposeSearch,
          );
        case 1:
          return SearchScreen();
        case 2:
          return MyPropertiesScreen();
        case 3:
          return ChatListScreen();
        case 4:
        default:
          return SettingsScreen();
      }
    });
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      body: AnimatedSwitcher(
        duration: AppMotion.slow,
        switchInCurve: AppMotion.curve,
        switchOutCurve: AppMotion.smooth,
        transitionBuilder: (child, animation) {
          return FadeTransition(
            opacity: animation,
            child: SlideTransition(
              position: Tween<Offset>(
                begin: const Offset(0.03, 0),
                end: Offset.zero,
              ).animate(animation),
              child: child,
            ),
          );
        },
        child: KeyedSubtree(
          key: ValueKey(currentIndex),
          child: _pageFor(currentIndex),
        ),
      ),
      bottomNavigationBar: HomeBottomNav(
        currentIndex: currentIndex,
        onChanged: (index) {
          if (index == 2 &&
              !AuthGuard.requireLogin(
                message: "Please login to manage your properties.".tr,
              )) {
            return;
          }

          if (index == 3 &&
              !AuthGuard.requireLogin(
                message: "Please login to access your chats.".tr,
              )) {
            return;
          }

          setState(() {
            currentIndex = index;
          });
        },
      ),
    );
  }

  void _handleCategorySearch(String type) {
    final controller = Get.isRegistered<PropertySearchController>()
        ? Get.find<PropertySearchController>()
        : Get.put(PropertySearchController(), permanent: true);

    // Clear previous property-name search
    controller.filter.search = "";

    // Set selected category/type
    controller.filter.type = type;

    // Fetch filtered properties
    controller.fetchProperties();

    // Switch bottom navigation to Search
    setState(() {
      currentIndex = 1;
    });
  }

  void _handleHomeSearch(String propertyName, String purpose) {
    debugPrint("MAIN RECEIVED SEARCH: $propertyName ($purpose)");

    final controller = Get.isRegistered<PropertySearchController>()
        ? Get.find<PropertySearchController>()
        : Get.put(PropertySearchController(), permanent: true);

    controller.searchTextController.text = propertyName;

    // Apply the query and the Rent/Sale toggle together in one fetch,
    // so the Search screen (and its filter chips) opens already matching
    // what was picked on the home banner.
    controller.applyFilters(search: propertyName, purpose: purpose);

    // Switch the EXISTING MainScreen to the Search tab — bottomNavigationBar
    // stays put since it's outside the AnimatedSwitcher that swaps pages.
    setState(() {
      currentIndex = 1;
    });
  }

  void _handlePurposeSearch(String purpose) {
    debugPrint("PURPOSE CLICKED: $purpose");

    final controller = Get.isRegistered<PropertySearchController>()
        ? Get.find<PropertySearchController>()
        : Get.put(PropertySearchController(), permanent: true);

    /// Clear previous property-name search
    controller.filter.search = "";
    controller.searchTextController.clear();

    /// Clear previous category
    controller.filter.type = "";

    /// Set BUY or RENT
    /// BUY  = SALE
    /// RENT = RENT
    controller.filter.purpose = purpose;

    /// Rebuild SearchFilterCard
    controller.update();

    /// Fetch filtered properties
    controller.fetchProperties();

    /// Switch EXISTING MainScreen to Search tab
    setState(() {
      currentIndex = 1;
    });
  }
}
