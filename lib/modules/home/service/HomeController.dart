import 'package:get/get.dart';
import 'package:villas_qatar/modules/PlansandFeatures/services/FeaturedPropertiesController.dart';
import 'package:villas_qatar/modules/home/model/PropertyModel.dart';

class Homecontroller extends GetxController {
  FeaturedPropertiesController featureController = Get.put(
    FeaturedPropertiesController(),
  );
  List<PropertyModel> featuredProperties = [];

  void loadHomeScreenData() async {
    featuredProperties = await featureController.fetchFeatureProperty(
      isHome: true,
    );

    
    update();
  }

  onInit() {
    super.onInit();

    loadHomeScreenData();
  }
}
