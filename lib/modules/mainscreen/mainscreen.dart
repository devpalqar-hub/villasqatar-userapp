import 'package:flutter/material.dart';
import 'package:get/get_core/src/get_main.dart';
import 'package:get/get_instance/src/extension_instance.dart';
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

  late final List<Widget> pages;

  @override
  void initState() {
    super.initState();

    /// Select requested bottom navigation tab
    currentIndex = widget.initialIndex;

    /// Get or create ONE search controller
    final controller = Get.isRegistered<PropertySearchController>()
        ? Get.find<PropertySearchController>()
        : Get.put(PropertySearchController());

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

    /// Create pages AFTER controller values are set
    pages = [
      HomeScreen(
        onSearch: _handleHomeSearch,

        onCategorySelected: _handleCategorySearch,

        onPurposeSelected: _handlePurposeSearch,
      ),

      SearchScreen(),

      MyPropertiesScreen(),

      ChatListScreen(),

      SettingsScreen(),
    ];

    /// If MainScreen was opened directly on Search,
    /// fetch using the initial filters.
    if (widget.initialIndex == 1) {
      WidgetsBinding.instance.addPostFrameCallback((_) {
        controller.fetchProperties();
      });
    }
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      body: AnimatedSwitcher(
        duration: const Duration(milliseconds: 660),

        switchOutCurve: Curves.easeIn,
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
          child: pages[currentIndex],
        ),
      ),
      bottomNavigationBar: HomeBottomNav(
        currentIndex: currentIndex,
        onChanged: (index) {
          if (index == 2 &&
              !AuthGuard.requireLogin(
                message: "Please login to manage your properties.",
              )) {
            return;
          }

         
          if (index == 3 &&
              !AuthGuard.requireLogin(
                message: "Please login to access your chats.",
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
        : Get.put(PropertySearchController());

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

  void _handleHomeSearch(String propertyName) {
    debugPrint("MAIN RECEIVED SEARCH: $propertyName");

    final controller = Get.isRegistered<PropertySearchController>()
        ? Get.find<PropertySearchController>()
        : Get.put(PropertySearchController());

    controller.searchProperty(propertyName);

    setState(() {
      currentIndex = 1;
    });
  }

  void _handlePurposeSearch(String purpose) {
    debugPrint("PURPOSE CLICKED: $purpose");

    final controller = Get.isRegistered<PropertySearchController>()
        ? Get.find<PropertySearchController>()
        : Get.put(PropertySearchController());

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
