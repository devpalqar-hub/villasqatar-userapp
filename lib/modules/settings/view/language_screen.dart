import 'package:flutter/material.dart';
import 'package:get/get.dart';

class LanguageScreen extends StatelessWidget {
  const LanguageScreen({super.key});

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(
        title:  Text("Select Language".tr),
        centerTitle: true,
      ),
      body: Column(
        children: [
          ListTile(
            leading: const Icon(Icons.language),
            title:  Text("English".tr),
            trailing: Get.locale?.languageCode == 'en'
                ? const Icon(Icons.check, color: Colors.blue)
                : null,
            onTap: () {
              Get.updateLocale(const Locale('en', 'US'));
              Get.back(); // go back after selection
            },
          ),

          const Divider(),

          ListTile(
            leading: const Icon(Icons.language),
            title:  Text("العربية".tr),
            trailing: Get.locale?.languageCode == 'ar'
                ? const Icon(Icons.check, color: Colors.blue)
                : null,
            onTap: () {
              Get.updateLocale(const Locale('ar', 'QA'));
              Get.back(); // go back after selection
            },
          ),
        ],
      ),
    );
  }
}