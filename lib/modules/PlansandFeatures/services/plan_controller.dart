import 'package:flutter/material.dart';
import 'package:get/get.dart';
import 'package:villas_qatar/Core/network/api_handler.dart';
import 'package:villas_qatar/Core/network/api_endpoints.dart';
import 'package:villas_qatar/modules/PlansandFeatures/model/featured_palnmodel.dart';

class FeaturedPlanController extends GetxController {
  bool isLoading = false;

  String error = '';

  List<FeaturedPlanModel> plans = [];

  FeaturedPlanModel? selectedPlan;

  /// ============================================================
  /// INITIAL LOAD
  /// ============================================================

  @override
  void onInit() {
    super.onInit();

    fetchFeaturedPlans();
  }

  /// ============================================================
  /// FETCH PLANS
  /// ============================================================

  Future<void> fetchFeaturedPlans({bool showLoading = true}) async {
    try {
      if (showLoading) {
        isLoading = true;
      }

      error = '';

      update();

      debugPrint("========== FETCH FEATURED PLANS ==========");

      final dynamic response = await ApiHandler.get(ApiEndpoints.featuredPlans);

      debugPrint("Featured Plans Response: $response");

      if (response is List) {
        plans = response
            .whereType<Map<String, dynamic>>()
            .map((json) => FeaturedPlanModel.fromJson(json))
            .toList();
      } else {
        plans = [];
      }

      /// Only keep active plans.
      plans = plans.where((plan) => plan.isActive).toList();

      /// Automatically select first plan.
      if (plans.isNotEmpty) {
        /// Keep previous selection if it still exists.
        if (selectedPlan != null) {
          final previousId = selectedPlan!.id;

          final index = plans.indexWhere((plan) => plan.id == previousId);

          selectedPlan = index >= 0 ? plans[index] : plans.first;
        } else {
          selectedPlan = plans.first;
        }
      } else {
        selectedPlan = null;
      }

      debugPrint("Featured Plans Loaded: ${plans.length}");

      if (selectedPlan != null) {
        debugPrint("Selected Plan: ${selectedPlan!.name}");
      }
    } catch (e) {
      debugPrint("Fetch Featured Plans Error: $e");

      error = e.toString().replaceFirst("Exception: ", "");

      plans = [];
      selectedPlan = null;
    } finally {
      isLoading = false;

      update();
    }
  }

  /// ============================================================
  /// SELECT PLAN
  /// ============================================================

  void selectPlan(FeaturedPlanModel plan) {
    selectedPlan = plan;

    debugPrint("========== PLAN SELECTED ==========");

    debugPrint("Plan ID: ${plan.id}");

    debugPrint("Plan: ${plan.name}");

    debugPrint("Price: ${plan.formattedPrice}");

    debugPrint("Duration: ${plan.formattedDuration}");

    update();
  }

  /// ============================================================
  /// CHECK SELECTED
  /// ============================================================

  bool isPlanSelected(FeaturedPlanModel plan) {
    return selectedPlan?.id == plan.id;
  }

  /// ============================================================
  /// RETRY
  /// ============================================================

  Future<void> retry() async {
    await fetchFeaturedPlans();
  }
}
