import 'package:flutter/material.dart';
import 'package:get/get_core/src/get_main.dart';
import 'package:get/get_instance/src/extension_instance.dart';
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


  const MainScreen({super.key, this.initialIndex = 0,this.initialSearch,
    this.initialType,
    this.initialPurpose,
    this.initialCategory,});

  @override
  State<MainScreen> createState() => _MainScreenState();
}

class _MainScreenState extends State<MainScreen> {
  late int currentIndex;

  late final List<Widget> pages;

  @override
  void initState() {
    super.initState();

    currentIndex = widget.initialIndex;

    pages = [
      HomeScreen(
        onSearch: _handleHomeSearch,
        onCategorySelected: _handleCategorySearch,
      ),
      SearchScreen(),
      MyPropertiesScreen(),
      ChatListScreen(),

      const SettingsScreen(),
    ];
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
          setState(() {
            currentIndex = index;
          });
        },
      ),
    );
  }

  void _handleCategorySearch(String type) {
    debugPrint("CATEGORY CLICKED: $type");

    final controller = Get.isRegistered<PropertySearchController>()
        ? Get.find<PropertySearchController>()
        : Get.put(PropertySearchController());

    // Clear previous property-name search
    controller.search = "";

    // Set selected category/type
    controller.type = type;

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
}
