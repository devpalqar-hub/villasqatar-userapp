import 'package:get/get.dart';
import 'package:villas_qatar/Core/utils/app_location.dart';
import 'package:villas_qatar/modules/PlansandFeatures/services/FeaturedPropertiesController.dart';
import 'package:villas_qatar/modules/dealers/service/dealer_controller.dart';
import 'package:villas_qatar/modules/home/model/PropertyModel.dart';
import 'package:villas_qatar/modules/home/service/UtilsController.dart';
import 'package:villas_qatar/modules/home/service/banner_controller.dart';
import 'package:villas_qatar/modules/home/service/loaction_controller.dart';

class Homecontroller extends GetxController {
  late final FeaturedPropertiesController featureController;

  late final Utilscontroller utilsController;
  late final BannerController bannerController;
  late final LocationController locationController;
  late final DealerController dealerController;

  List<PropertyModel> featuredProperties = [];

  @override
  void onInit() {
    super.onInit();

    featureController = Get.isRegistered<FeaturedPropertiesController>()
        ? Get.find<FeaturedPropertiesController>()
        : Get.put(
            FeaturedPropertiesController(),
            permanent: true,
          );

    utilsController = Get.isRegistered<Utilscontroller>()
        ? Get.find<Utilscontroller>()
        : Get.put(Utilscontroller(), permanent: true);

    bannerController = Get.isRegistered<BannerController>()
        ? Get.find<BannerController>()
        : Get.put(BannerController(), permanent: true);

    locationController = Get.isRegistered<LocationController>()
        ? Get.find<LocationController>()
        : Get.put(LocationController(), permanent: true);

    dealerController = Get.isRegistered<DealerController>()
        ? Get.find<DealerController>()
        : Get.put(DealerController(), permanent: true);

    loadHomeScreenData();
  }

  Future<void> loadHomeScreenData() async {
    try {
      final properties = await featureController.fetchFeatureProperty(
        isHome: true,
      );

      featuredProperties = properties;

      print(
        'HOME FEATURED PROPERTIES COUNT: ${featuredProperties.length}',
      );

      update();
    } catch (e, stackTrace) {
      print('HOME FEATURED PROPERTY ERROR: $e');
      print(stackTrace);
    }

    utilsController.fetchPropertyType();
    bannerController.fetchBanners();
    dealerController.fetchDealers();
  }

  Future<void> refreshHomeScreenData() async {
    await Future.wait([
      _refreshFeaturedProperties(),
      utilsController.fetchPropertyType(),
      bannerController.refreshBanners(),
      dealerController.refreshDealers(),
      if (AppLocation.hasLocation)
        locationController.fetchNearbyProperties(refresh: true),
    ]);
  }

  Future<void> _refreshFeaturedProperties() async {
    try {
      final properties = await featureController.fetchFeatureProperty(
        isHome: true,
      );

      featuredProperties = properties;

      print(
        'REFRESH FEATURED COUNT: ${featuredProperties.length}',
      );

      update();
    } catch (e, stackTrace) {
      print('REFRESH FEATURED ERROR: $e');
      print(stackTrace);
    }
  }
}