import 'dart:convert';
import 'dart:io';

import 'package:http/http.dart' as http;

class ApiHandler {
  ApiHandler._();

  static const String baseUrl = "https://api.villas.palqar.cloud";

  static Future<dynamic> get(
    String endpoint, {
    Map<String, String>? headers,
  }) async {
    try {
      final response = await http.get(
        Uri.parse("$baseUrl$endpoint"),
        headers: _headers(headers),
      );

      return _handleResponse(response);
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
      final response = await http.post(
        Uri.parse("$baseUrl$endpoint"),
        headers: _headers(headers),
        body: jsonEncode(body),
      );

      return _handleResponse(response);
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
      final response = await http.put(
        Uri.parse("$baseUrl$endpoint"),
        headers: _headers(headers),
        body: jsonEncode(body),
      );

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
      final response = await http.patch(
        Uri.parse("$baseUrl$endpoint"),
        headers: _headers(headers),
        body: jsonEncode(body),
      );

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
      final response = await http.delete(
        Uri.parse("$baseUrl$endpoint"),
        headers: _headers(headers),
      );

      return _handleResponse(response);
    } on SocketException {
      throw Exception("No Internet Connection");
    }
  }

  static Map<String, String> _headers(Map<String, String>? headers) {
    return {
      "Content-Type": "application/json",
      "Accept": "application/json",
      ...?headers,
    };
  }

  static dynamic _handleResponse(http.Response response) {
    final data = response.body.isNotEmpty ? jsonDecode(response.body) : null;

    switch (response.statusCode) {
      case 200:
      case 201:
        return data;

      case 400:
        throw Exception(data["message"] ?? "Bad Request");

      case 401:
        throw Exception(data["message"] ?? "Unauthorized");

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
}
