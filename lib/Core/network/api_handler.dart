import 'dart:convert';
import 'dart:io';

import 'package:get/get.dart';
import 'package:get/get_core/src/get_main.dart';
import 'package:get/get_instance/src/extension_instance.dart';
import 'package:http/http.dart' as http;
import 'package:http/http.dart';
import 'package:villas_qatar/Core/services/storage_service.dart';
import 'package:villas_qatar/modules/onboard/controller/auth_controller.dart';
import 'package:villas_qatar/modules/onboard/views/login_screen.dart';
import 'package:villas_qatar/modules/onboard/views/welcome_screen.dart';

class ApiHandler {
  ApiHandler._();

  static const String baseUrl = "https://apivillas.palqar.cloud";

  static Future<dynamic> get(
    String endpoint, {
    Map<String, String>? headers,
  }) async {
    try {
      final url = "$baseUrl$endpoint";
      final requestHeaders = _headers(headers);

      _printRequest(method: "GET", url: url, headers: requestHeaders);

      final response = await http.get(Uri.parse(url), headers: requestHeaders);

      _printResponse(response);

      return await _handleResponse(response);
    } on SocketException {
      throw Exception("No Internet Connection");
    }
  }

  static Future<dynamic> post(
    String endpoint, {
    Map<String, dynamic>? body,
    Map<String, String>? headers,
  }) async {
    try {
      final url = "$baseUrl$endpoint";
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
        body: jsonEncode(body),
      );

      _printResponse(response);

      return await _handleResponse(response);
    } on SocketException {
      throw Exception("No Internet Connection");
    }
  }

  static Future<dynamic> put(
    String endpoint, {
    Map<String, dynamic>? body,
    Map<String, String>? headers,
  }) async {
    try {
      final url = "$baseUrl$endpoint";
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
        body: jsonEncode(body),
      );

      _printResponse(response);

      return _handleResponse(response);
    } on SocketException {
      throw Exception("No Internet Connection");
    }
  }

  static Future<dynamic> patch(
    String endpoint, {
    Map<String, dynamic>? body,
    Map<String, String>? headers,
  }) async {
    try {
      final url = "$baseUrl$endpoint";
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
        body: jsonEncode(body),
      );

      _printResponse(response);

      return _handleResponse(response);
    } on SocketException {
      throw Exception("No Internet Connection");
    }
  }

  static Future<dynamic> delete(
    String endpoint, {
    Map<String, String>? headers,
  }) async {
    try {
      final url = "$baseUrl$endpoint";
      final requestHeaders = _headers(headers);

      _printRequest(method: "DELETE", url: url, headers: requestHeaders);

      final response = await http.delete(
        Uri.parse(url),
        headers: requestHeaders,
      );

      _printResponse(response);

      return _handleResponse(response);
    } on SocketException {
      throw Exception("No Internet Connection");
    }
  }

  static Map<String, String> _headers(Map<String, String>? headers) {
    final token = StorageService.getToken();

    return {
      "Content-Type": "application/json",
      "Accept": "application/json",
      if (token != null && token.isNotEmpty) "Authorization": "Bearer $token",
      ...?headers,
    };
  }

  static Future<dynamic> _handleResponse(http.Response response) async {
    final data = response.body.isNotEmpty ? jsonDecode(response.body) : null;

    switch (response.statusCode) {
      case 200:
      case 201:
        return data;

      case 400:
        throw Exception(data["message"] ?? "Bad Request");
      case 401:
        await StorageService.logout();
        if (Get.isRegistered<AuthController>()) {
          Get.delete<AuthController>(force: true);
        }
        Get.offAll(() => WelcomeScreen());

        throw Exception(data["message"] ?? "Session Expired");
      case 403:
        throw Exception(data["message"] ?? "Forbidden");

      case 404:
        throw Exception(data["message"] ?? "Not Found");

      case 500:
        throw Exception(data["message"] ?? "Server Error");

      default:
        throw Exception("Error ${response.statusCode}");
    }
  }

  static void _printRequest({
    required String method,
    required String url,
    Map<String, String>? headers,
    dynamic body,
  }) {
    print("========================================");
    print("$method REQUEST");
    print("URL: $url");
    print("HEADERS: ${headers ?? {}}");

    if (body != null) {
      print("BODY:");
      print(const JsonEncoder.withIndent("  ").convert(body));
    }

    print("========================================");
  }

  static void _printResponse(http.Response response) {
    print("========================================");
    print("STATUS CODE: ${response.statusCode}");

    if (response.body.isNotEmpty) {
      try {
        final json = jsonDecode(response.body);
        print("RESPONSE:");
        print(const JsonEncoder.withIndent("  ").convert(json));
      } catch (_) {
        print("RESPONSE:");
        print(response.body);
      }
    }

    print("========================================");
  }
}
