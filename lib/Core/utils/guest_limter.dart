import 'package:shared_preferences/shared_preferences.dart';
import 'package:villas_qatar/Core/services/storage_service.dart';

class GuestLimiter {
  static const _estimateKey = "guest_estimate_count";

  static Future<bool> canUseEstimator() async {
    if (StorageService.getToken()?.isNotEmpty == true) {
      return true; // Logged in
    }

    final prefs = await SharedPreferences.getInstance();

    int count = prefs.getInt(_estimateKey) ?? 0;

    if (count >= 2) {
      return false;
    }

    await prefs.setInt(_estimateKey, count + 1);

    return true;
  }
}