import 'package:device_preview/device_preview.dart';
import 'package:flutter/material.dart';
import 'package:flutter_localizations/flutter_localizations.dart';
import 'package:flutter_screenutil/flutter_screenutil.dart';
import 'package:get/get.dart';
import 'package:villas_qatar/Core/services/storage_service.dart';
import 'package:villas_qatar/modules/onboard/views/splash_screen.dart';

// ADD YOUR DEEP LINK SERVICE IMPORT
import 'package:villas_qatar/Core/services/deep_link_service.dart';

import 'core/localization/app_translation.dart';
import 'core/theme/app_theme.dart';
import 'core/utils/responsive.dart';

Future<void> main() async {
  WidgetsFlutterBinding.ensureInitialized();

  await StorageService.init();
  runApp(
    DevicePreview(
      enabled: false,
      builder: (context) => const VillasQatarApp(),
    ),
  );
}

class VillasQatarApp extends StatefulWidget {
  const VillasQatarApp({
    super.key,
  });

  @override
  State<VillasQatarApp> createState() =>
      _VillasQatarAppState();
}

class _VillasQatarAppState
    extends State<VillasQatarApp> {
  @override
  void initState() {
    super.initState();

    /// Initialize deep links only after
    /// GetMaterialApp navigator is created.
    WidgetsBinding.instance.addPostFrameCallback(
      (_) {
        DeepLinkService.initialize();
      },
    );
  }

  @override
  void dispose() {
    DeepLinkService.dispose();
    super.dispose();
  }

  @override
  Widget build(BuildContext context) {
    return LayoutBuilder(
      builder: (context, constraints) {
        Size designSize;

        if (Responsive.isDesktop(context)) {
          designSize =
              const Size(1440, 1024);
        } else if (Responsive.isTablet(context)) {
          designSize =
              const Size(760, 1024);
        } else {
          designSize =
              const Size(394, 852);
        }

        return ScreenUtilInit(
          designSize: designSize,
          minTextAdapt: true,
          splitScreenMode: true,
          builder: (_, child) {
            return GetMaterialApp(
              debugShowCheckedModeBanner: false,

              title: 'Villas Qatar',

              useInheritedMediaQuery: true,

              locale:
                  DevicePreview.locale(context),

              translations:
                  AppTranslations(),

              fallbackLocale:
                  const Locale('en', 'US'),

              supportedLocales: const [
                Locale('en', 'US'),
                Locale('ar', 'QA'),
              ],

              localizationsDelegates: const [
                GlobalMaterialLocalizations
                    .delegate,
                GlobalWidgetsLocalizations
                    .delegate,
                GlobalCupertinoLocalizations
                    .delegate,
              ],

              builder: (context, child) {
                child =
                    DevicePreview.appBuilder(
                  context,
                  child,
                );

                final locale =
                    Get.locale ??
                    DevicePreview.locale(
                      context,
                    ) ??
                    const Locale(
                      'en',
                      'US',
                    );

                return Directionality(
                  textDirection:
                      locale.languageCode == 'ar'
                          ? TextDirection.rtl
                          : TextDirection.ltr,
                  child: child ?? const SizedBox.shrink(),
                );
              },

              theme:
                  AppTheme.lightTheme,

              home:
                  SplashScreen(),
            );
          },
        );
      },
    );
  }
}