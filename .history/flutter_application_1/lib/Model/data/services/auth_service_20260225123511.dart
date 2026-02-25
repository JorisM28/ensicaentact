import 'dart:convert';

import 'package:flutter_secure_storage/flutter_secure_storage.dart';

class AuthService {
  final _storage = const FlutterSecureStorage();
  Map<String, dynamic>? currentUser;
  bool get isLoggedIn => currentUser!=null;
  bool get isAdmin => currentUser?['role'] == 'admin';

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