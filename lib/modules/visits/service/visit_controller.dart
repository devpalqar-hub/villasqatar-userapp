import 'package:flutter/material.dart';
import 'package:get/get.dart';
import 'package:villas_qatar/Core/network/api_endpoints.dart';
import 'package:villas_qatar/Core/network/api_handler.dart';
import 'package:villas_qatar/modules/visits/model/visit_model.dart';

class VisitController extends GetxController {
  bool isScheduling = false;
  bool isAccepting = false;

  bool isOwnerVisitsLoading = false;
  bool isVisitorVisitsLoading = false;

  dynamic scheduledVisit;

  List<VisitModel> ownerVisits = [];
  List<VisitModel> visitorVisits = [];

  @override
  void onInit() {
    super.onInit();

    fetchOwnerVisits();
    fetchVisitorVisits();
  }

  // =========================================================
  // SCHEDULE VISIT
  // POST /api/visits/{propertyId}
  // =========================================================

  Future<bool> scheduleVisit({
    required String propertyId,
    required DateTime scheduledAt,
    String? notes,
  }) async {
    try {
      isScheduling = true;
      update();

      final body = {
        "scheduledAt": scheduledAt.toUtc().toIso8601String(),
        "notes": notes?.trim() ?? "",
      };

      debugPrint("========== SCHEDULE VISIT ==========");
      debugPrint("Property ID: $propertyId");
      debugPrint("BODY: $body");

      final response = await ApiHandler.post(
        ApiEndpoints.scheduleVisit(propertyId),
        body: body,
      );

      debugPrint("Schedule Visit Response: $response");

      scheduledVisit = response;

      // Refresh visitor list after booking
      await fetchVisitorVisits(showLoading: false);

      Get.snackbar(
        "Success",
        "Visit scheduled successfully",
        snackPosition: SnackPosition.BOTTOM,
      );

      return true;
    } catch (e) {
      debugPrint("Schedule Visit Error: $e");

      Get.snackbar(
        "Error",
        e.toString().replaceFirst("Exception: ", ""),
        snackPosition: SnackPosition.BOTTOM,
      );

      return false;
    } finally {
      isScheduling = false;
      update();
    }
  }

  // =========================================================
  // ACCEPT VISIT
  // POST /api/visits/{visitId}/accept
  // =========================================================

  Future<bool> acceptVisit({required String visitId}) async {
    try {
      isAccepting = true;
      update();

      debugPrint("========== ACCEPT VISIT ==========");
      debugPrint("Visit ID: $visitId");

      final response = await ApiHandler.patch(ApiEndpoints.acceptVisit(visitId),
       body: {}, );

      debugPrint("Accept Visit Response: $response");

      // Refresh owner visits after accepting
      await fetchOwnerVisits(showLoading: false);

      Get.snackbar(
        "Success",
        "Visit accepted successfully",
        snackPosition: SnackPosition.BOTTOM,
      );

      return true;
    } catch (e) {
      debugPrint("Accept Visit Error: $e");

      Get.snackbar(
        "Error",
        e.toString().replaceFirst("Exception: ", ""),
        snackPosition: SnackPosition.BOTTOM,
      );

      return false;
    } finally {
      isAccepting = false;
      update();
    }
  }

  // =========================================================
  // GET VISITS AS OWNER
  // GET /api/visits/as-owner
  // =========================================================

  Future<void> fetchOwnerVisits({bool showLoading = true}) async {
    try {
      if (showLoading) {
        isOwnerVisitsLoading = true;
        update();
      }

      debugPrint("========== FETCH OWNER VISITS ==========");

      final response = await ApiHandler.get(ApiEndpoints.visitsAsOwner);

      debugPrint("Owner Visits Response: $response");

      if (response is List) {
        ownerVisits = response
            .whereType<Map<String, dynamic>>()
            .map((json) => VisitModel.fromJson(json))
            .toList();
      } else {
        ownerVisits = [];
      }

      debugPrint("Owner Visits Count: ${ownerVisits.length}");
    } catch (e) {
      debugPrint("Fetch Owner Visits Error: $e");

      ownerVisits = [];
    } finally {
      isOwnerVisitsLoading = false;
      update();
    }
  }

  // =========================================================
  // GET VISITS AS VISITOR
  // GET /api/visits/as-visitor
  // =========================================================

  Future<void> fetchVisitorVisits({bool showLoading = true}) async {
    try {
      if (showLoading) {
        isVisitorVisitsLoading = true;
        update();
      }

      debugPrint("========== FETCH VISITOR VISITS ==========");

      final response = await ApiHandler.get(ApiEndpoints.visitsAsVisitor);

      debugPrint("Visitor Visits Response: $response");

      if (response is List) {
        visitorVisits = response
            .whereType<Map<String, dynamic>>()
            .map((json) => VisitModel.fromJson(json))
            .toList();
      } else {
        visitorVisits = [];
      }

      debugPrint("Visitor Visits Count: ${visitorVisits.length}");
    } catch (e) {
      debugPrint("Fetch Visitor Visits Error: $e");

      visitorVisits = [];
    } finally {
      isVisitorVisitsLoading = false;
      update();
    }
  }
}
