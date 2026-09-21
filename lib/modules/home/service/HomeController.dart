import 'package:get/get.dart';
import 'package:villas_qatar/Core/utils/app_location.dart';
import 'package:villas_qatar/modules/PlansandFeatures/services/FeaturedPropertiesController.dart';
import 'package:villas_qatar/modules/dealers/service/dealer_controller.dart';
import 'package:villas_qatar/modules/home/model/PropertyModel.dart';
import 'package:villas_qatar/modules/home/service/UtilsController.dart';
import 'package:villas_qatar/modules/home/service/banner_controller.dart';
import 'package:villas_qatar/modules/home/service/loaction_controller.dart';

class Homecontroller extends GetxController {
  FeaturedPropertiesController featureController = Get.put(
    FeaturedPropertiesController(),
  );
  Utilscontroller utilsController = Get.isRegistered<Utilscontroller>()
      ? Get.find<Utilscontroller>()
      : Get.put(Utilscontroller(), permanent: true);
  BannerController bannerController = Get.isRegistered<BannerController>()
      ? Get.find<BannerController>()
      : Get.put(BannerController(), permanent: true);
  LocationController locationController =
      Get.isRegistered<LocationController>()
      ? Get.find<LocationController>()
      : Get.put(LocationController(), permanent: true);
  DealerController dealerController = Get.isRegistered<DealerController>()
      ? Get.find<DealerController>()
      : Get.put(DealerController(), permanent: true);

  List<PropertyModel> featuredProperties = [];

  void loadHomeScreenData() async {
    featuredProperties = await featureController.fetchFeatureProperty(
      isHome: true,
    );
    utilsController.fetchPropertyType();
    bannerController.fetchFeaturedBanners();
    dealerController.fetchDealers();
    update();
  }

  @override
  void onInit() {
    super.onInit();

    loadHomeScreenData();
  }
}
