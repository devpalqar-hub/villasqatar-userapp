import 'package:flutter/foundation.dart';
import 'package:fluttertoast/fluttertoast.dart';
import 'package:get/get.dart';

import 'package:villas_qatar/Core/network/api_endpoints.dart';
import 'package:villas_qatar/Core/network/api_handler.dart';
import 'package:villas_qatar/modules/dealers/service/model/dealer_details_model.dart';
import 'package:villas_qatar/modules/dealers/service/model/dealer_list_model.dart';


class DealerController extends GetxController {
  bool isLoading = false;
  bool isLoadingMore = false;

  bool hasMore = true;

  int page = 1;
  final int limit = 10;

  String error = "";

  List<Dealer> dealers = [];

  DealerDetailsModel? dealer;

  //==========================================================
  // DEALER LIST
  //==========================================================

  Future<void> fetchDealers({
    bool loadMore = false,
  }) async {
    if (loadMore) {
      if (isLoadingMore || !hasMore) return;

      isLoadingMore = true;
    } else {
      if (isLoading) return;

      isLoading = true;
      page = 1;
      hasMore = true;
      error = "";
    }

    update();

    try {
      final uri = Uri.parse(
        ApiEndpoints.dealers,
      ).replace(
        queryParameters: {
          "page": loadMore ? page.toString() : "1",
          "limit": limit.toString(),
        },
      );

      final response = await ApiHandler.get(
        uri.toString(),
      );

      final model = DealerListModel.fromJson(response);

      if (loadMore) {
        dealers.addAll(
          model.data.where(
            (e) => !dealers.any(
              (x) => x.id == e.id,
            ),
          ),
        );
      } else {
        dealers = model.data;
      }

      hasMore = page < model.meta.totalPages;

      if (hasMore) page++;

      update();
    } catch (e) {
      error = e.toString();

      Fluttertoast.showToast(
        msg: error.replaceFirst(
          "Exception: ",
          "",
        ),
      );
    } finally {
      isLoading = false;
      isLoadingMore = false;
      update();
    }
  }

  Future<void> refreshDealers() async {
    page = 1;
    hasMore = true;
    dealers.clear();
    await fetchDealers();
  }

  //==========================================================
  // DEALER DETAILS
  //==========================================================

  Future<void> fetchDealerDetails(
    String dealerId,
  ) async {
    try {
      isLoading = true;
      update();

      final response = await ApiHandler.get(
        ApiEndpoints.dealerDetails(
          dealerId,
        ),
      );

      dealer = DealerDetailsModel.fromJson(
        response,
      );
    } catch (e) {
      Fluttertoast.showToast(
        msg: e.toString().replaceFirst(
          "Exception: ",
          "",
        ),
      );

      debugPrint(e.toString());
    } finally {
      isLoading = false;
      update();
    }
  }
}