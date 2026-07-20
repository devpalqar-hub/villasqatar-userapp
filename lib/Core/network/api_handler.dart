import 'dart:convert';
import 'dart:io';

import 'package:get/get.dart';
import 'package:http/http.dart' as http;

import 'package:villas_qatar/Core/services/storage_service.dart';
import 'package:villas_qatar/modules/onboard/controller/auth_controller.dart';
import 'package:villas_qatar/modules/onboard/views/welcome_screen.dart';

class ApiHandler {
  ApiHandler._();

  static const String baseUrl = "https://apivillas.palqar.cloud";

  static Future<dynamic> get(
    String endpoint, {
    Map<String, String>? headers,
  }) async {
    try {
      final String url = "$baseUrl$endpoint";

      final requestHeaders = _headers(headers);

      _printRequest(method: "GET", url: url, headers: requestHeaders);

      final response = await http.get(Uri.parse(url), headers: requestHeaders);

      _printResponse(response);

      return await _handleResponse(response);
    } on SocketException {
      throw Exception("No Internet Connection");
    }
  }

  // ============================================================
  // POST
  // ============================================================

  static Future<dynamic> post(
    String endpoint, {
    Map<String, dynamic>? body,
    Map<String, String>? headers,
  }) async {
    try {
      final String url = "$baseUrl$endpoint";

      final requestHeaders = _headers(headers);

      _printRequest(
        method: "POST",
        url: url,
        headers: requestHeaders,
        body: body,
      );

      final response = await http.post(
        Uri.parse(url),
        headers: requestHeaders,
        body: body != null ? jsonEncode(body) : null,
      );

      _printResponse(response);

      return await _handleResponse(response);
    } on SocketException {
      throw Exception("No Internet Connection");
    }
  }

  // ============================================================
  // PUT
  // ============================================================

  static Future<dynamic> put(
    String endpoint, {
    Map<String, dynamic>? body,
    Map<String, String>? headers,
  }) async {
    try {
      final String url = "$baseUrl$endpoint";

      final requestHeaders = _headers(headers);

      _printRequest(
        method: "PUT",
        url: url,
        headers: requestHeaders,
        body: body,
      );

      final response = await http.put(
        Uri.parse(url),
        headers: requestHeaders,
        body: body != null ? jsonEncode(body) : null,
      );

      _printResponse(response);

      return await _handleResponse(response);
    } on SocketException {
      throw Exception("No Internet Connection");
    }
  }

  // ============================================================
  // PATCH
  // ============================================================

  static Future<dynamic> patch(
    String endpoint, {
    Map<String, dynamic>? body,
    Map<String, String>? headers,
  }) async {
    try {
      final String url = "$baseUrl$endpoint";

      final requestHeaders = _headers(headers);

      _printRequest(
        method: "PATCH",
        url: url,
        headers: requestHeaders,
        body: body,
      );

      final response = await http.patch(
        Uri.parse(url),
        headers: requestHeaders,
        body: body != null ? jsonEncode(body) : null,
      );

      _printResponse(response);

      return await _handleResponse(response);
    } on SocketException {
      throw Exception("No Internet Connection");
    }
  }

  // ============================================================
  // DELETE
  // ============================================================

  static Future<dynamic> delete(
    String endpoint, {
    Map<String, String>? headers,
  }) async {
    try {
      final String url = "$baseUrl$endpoint";

      final requestHeaders = _headers(headers);

      _printRequest(method: "DELETE", url: url, headers: requestHeaders);

      final response = await http.delete(
        Uri.parse(url),
        headers: requestHeaders,
      );

      _printResponse(response);

      return await _handleResponse(response);
    } on SocketException {
      throw Exception("No Internet Connection");
    }
  }

  // ============================================================
  // HEADERS
  // ============================================================

  static Map<String, String> _headers(Map<String, String>? headers) {
    final String? token = StorageService.getToken();

    return {
      "Content-Type": "application/json",
      "Accept": "application/json",

      if (token != null && token.isNotEmpty) "Authorization": "Bearer $token",

      ...?headers,
    };
  }

  // ============================================================
  // RESPONSE HANDLER
  // ============================================================

  static Future<dynamic> _handleResponse(http.Response response) async {
    dynamic data;

    if (response.body.isNotEmpty) {
      try {
        data = jsonDecode(response.body);
      } catch (_) {
        data = response.body;
      }
    }

    switch (response.statusCode) {
      case 200:
      case 201:
      case 202:
        return data;

      case 204:
        return null;

      case 400:
        throw Exception(_getErrorMessage(data, "Bad Request"));

      case 401:
        await StorageService.logout();

        if (Get.isRegistered<AuthController>()) {
          Get.delete<AuthController>(force: true);
        }

        Get.offAll(() => WelcomeScreen());

        throw Exception(_getErrorMessage(data, "Session Expired"));

      case 403:
        throw Exception(_getErrorMessage(data, "Forbidden"));

      case 404:
        throw Exception(_getErrorMessage(data, "Not Found"));

      case 409:
        throw Exception(_getErrorMessage(data, "Conflict"));

      case 422:
        throw Exception(_getErrorMessage(data, "Invalid Data"));

      case 500:
      case 502:
      case 503:
        throw Exception(_getErrorMessage(data, "Server Error"));

      default:
        throw Exception(_getErrorMessage(data, "Error ${response.statusCode}"));
    }
  }

  // ============================================================
  // ERROR MESSAGE
  // ============================================================

  static String _getErrorMessage(dynamic data, String fallback) {
    if (data is Map) {
      final dynamic message = data["message"];

      if (message is String && message.isNotEmpty) {
        return message;
      }

      if (message is List) {
        return message.join(", ");
      }

      final dynamic error = data["error"];

      if (error is String && error.isNotEmpty) {
        return error;
      }
    }

    if (data is String && data.isNotEmpty) {
      return data;
    }

    return fallback;
  }

  // ============================================================
  // REQUEST LOG
  // ============================================================

  static void _printRequest({
    required String method,
    required String url,
    Map<String, String>? headers,
    dynamic body,
  }) {
    // print(
    //   "========================================",
    // );

    // print("$method REQUEST");

    // print("URL: $url");

    // print(
    //   "HEADERS: ${headers ?? {}}",
    // );

    if (body != null) {
      // print("BODY:");

      try {
        // print(
        //   const JsonEncoder.withIndent(
        //     "  ",
        //   ).convert(body),
        // );
      } catch (_) {
        // print(body);
      }
    }

    // print(
    //   "========================================",
    // );
  }

  // ============================================================
  // RESPONSE LOG
  // ============================================================

  static void _printResponse(http.Response response) {
    // print(
    //   "========================================",
    // );

    // print(
    //   "STATUS CODE: ${response.statusCode}",
    // );

    if (response.body.isNotEmpty) {
      try {
        final dynamic json = jsonDecode(response.body);

        // print("RESPONSE:");

        // print(
        //   const JsonEncoder.withIndent(
        //     "  ",
        //   ).convert(json),
        // );
      } catch (_) {
        // print("RESPONSE:");

        // print(response.body);
      }
    }

    // print(
    //   "========================================",
    // );
  }
}
