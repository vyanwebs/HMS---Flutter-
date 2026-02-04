import 'dart:convert';
import 'package:flutter/foundation.dart';
import 'package:http/http.dart' as http;

import 'storage_service.dart';

class NetworkHelper {
  final String url;

  NetworkHelper({required this.url});

  /// COMMON HEADERS
  Future<Map<String, String>> _headers({bool auth = false}) async {
    final headers = {
      "Content-Type": "application/json",
      "Accept": "application/json",
    };

    if (auth) {
      final token = await StorageService.getToken();
      if (token != null) {
        headers["Authorization"] = "Bearer $token";
      }
    }

    return headers;
  }

  /// POST (JSON)
  Future<Map<String, dynamic>> post({
    required Map<String, dynamic> body,
    bool auth = false,
  }) async {
    try {
      final response = await http.post(
        Uri.parse(url),
        headers: await _headers(auth: auth),
        body: jsonEncode(body),
      );

      return _processResponse(response);
    } catch (e) {
      _logError(e);
      return {"success": false, "message": "Network error"};
    }
  }
  
  Future<Map<String, dynamic>> postData({
    required Map<String, dynamic> body,
  }) async {
    final response = await http.post(
      Uri.parse(url),
      headers: {
        "Content-Type": "application/x-www-form-urlencoded",
      },
      body: body,
    );

    if (response.statusCode == 200) {
      return jsonDecode(response.body);
    } else {
      throw Exception(response.body);
    }
  }

  /// GET
  Future<Map<String, dynamic>> get({bool auth = false}) async {
    try {
      final response = await http.get(
        Uri.parse(url),
        headers: await _headers(auth: auth),
      );

      return _processResponse(response);
    } catch (e) {
      _logError(e);
      return {"success": false, "message": "Network error"};
    }
  }

  /// RESPONSE HANDLER
  Map<String, dynamic> _processResponse(http.Response response) {
    if (response.statusCode == 200 || response.statusCode == 201) {
      return jsonDecode(response.body);
    } else {
      if (kDebugMode) {
        print("❌ API ERROR (${response.statusCode})");
        print(response.body);
      }
      return {
        "success": false,
        "message": "Server error",
        "status": response.statusCode,
      };
    }
  }

  void _logError(Object e) {
    if (kDebugMode) {
      print("❌ NETWORK ERROR");
      print(e);
    }
  }

  /// PATCH (JSON or x-www-form-urlencoded)
  Future<Map<String, dynamic>> patch({
    required Map<String, dynamic> body,
    bool auth = false,
    bool isFormData = false,
  }) async {
    try {
      final headers = isFormData
          ? {
              "Content-Type": "application/x-www-form-urlencoded",
              "Accept": "application/json",
              if (auth)
                "Authorization": "Bearer ${await StorageService.getToken()}",
            }
          : await _headers(auth: auth);

      final response = await http.patch(
        Uri.parse(url),
        headers: headers,
        body: isFormData ? body : jsonEncode(body),
      );

      return _processResponse(response);
    } catch (e) {
      _logError(e);
      return {"success": false, "message": "Network error"};
    }
  }
}
