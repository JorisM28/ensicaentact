import 'dart:convert';

import 'package:flutter_secure_storage/flutter_secure_storage.dart';
import 'api_service.dart';

class AuthService {
  final _storage = const FlutterSecureStorage();
  final ApiService _api = ApiService();

  Map<String, dynamic>? currentUser;
  bool get isLoggedIn => currentUser!=null;
  bool get isAdmin => currentUser?['role'] == 'admin';

  static const String loginUrl = 'https://alumni.theo-airey.fr/login_check.php'; 

  Future<Map<String, dynamic>?> login(String email, String password) async {
    try {
      final response = await _api.post(loginUrl, {
        "email": email,
        "password": password,
      });

      if (response['status'] == 'success') {
        String token = response['token']; 
        await _storage.write(key: 'jwt_token', value: token);
        return response['user']; 
      }
    } catch (e) {
      print("Erreur login: $e");
    }
    return null;
  }

  Future<void> saveSession(Map<String, dynamic> user, String token) async {
    currentUser = user;
    await _storage.write(key: 'jwt_token', value:token);
    await _storage.write(key: 'user_data', value : jsonEncode(user));
  }

  Future<void> logout() async {
    await _storage.delete(key: 'jwt_token');
    await _storage.delete(key: 'user_data');
  }

  Future<bool> loadSession() async {
    final token = await _storage.read(key: 'jwt_token');
    final userData = await _storage.read(key:'user_data');
    if(token != null && userData != null){
      currentUser = jsonDecode(userData);
      return true;
    }
    return false;
  }
}