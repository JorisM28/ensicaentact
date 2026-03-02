import 'dart:convert';
import 'package:http/http.dart' as http;
import 'package:flutter_secure_storage/flutter_secure_storage.dart';
import 'package:flutter/material.dart';

class ApiService {
  static final ApiService _instance = ApiService._internal();
  factory ApiService() => _instance;
  ApiService._internal();

  final _storage = const FlutterSecureStorage();

  final Map<String, String> _defaultHeaders = {
    "Content-Type": "application/json",
    "Accept": "application/json",
  };

  Future<String?> getToken() async {
    return await _storage.read(key: 'jwt_token');
  }

  Future<dynamic> get(String url) async {
    try {
      String? token = await getToken();
      Map<String, String> requestHeaders = Map.from(_defaultHeaders);
      
      if (token != null) {
        requestHeaders['Authorization'] = 'Bearer $token';
        requestHeaders['X-Authorization'] = 'Bearer $token';
      }
      debugPrint("🚀 [GET] Vers : $url");
      debugPrint("🔑 [TOKEN ENVOYÉ] : $token");

      final response = await http.get(Uri.parse(url), headers: requestHeaders);
      return _processResponse(response);
    } catch (e) {
      debugPrint("⚠️ Erreur interceptée (GET): $e");
      return [];
      
    }
  }

  Future<dynamic> post(String url, Map<String, dynamic> body) async {
    try {
      String? token = await getToken();
      Map<String, String> requestHeaders = Map.from(_defaultHeaders);
      
      if (token != null) {
        requestHeaders['Authorization'] = 'Bearer $token';
        requestHeaders['X-Authorization'] = 'Bearer $token';
      }
      debugPrint("🚀 [POST] Vers : $url");
      debugPrint("🔑 [TOKEN ENVOYÉ] : $token");

      final response = await http.post(
        Uri.parse(url),
        headers: requestHeaders,
        body: jsonEncode(body),
      );
      return _processResponse(response);
    } catch (e) {
      debugPrint("⚠️ Erreur interceptée (POST): $e");
      return [];<
    }
  }

  dynamic _processResponse(http.Response response) {
    if (response.statusCode >= 200 && response.statusCode < 300) {
      if (response.body.isEmpty) return {};
      return jsonDecode(response.body);
    } else if (response.statusCode == 401 || response.statusCode == 403) {
      debugPrint("🛑 API Refusée (401/403). Le token est invalide ou expiré.");
      return[];
      } else {
      debugPrint("❌ Erreur Serveur ${response.statusCode}: ${response.body}");
      return [];
    }
  }
}