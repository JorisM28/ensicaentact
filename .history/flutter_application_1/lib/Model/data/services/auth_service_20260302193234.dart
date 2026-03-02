import 'dart:convert';
import 'package:flutter_secure_storage/flutter_secure_storage.dart';
import '../../user_model.dart';

class AuthService {
  final _storage = const FlutterSecureStorage();
  User? currentUser;
  bool get isLoggedIn => currentUser != null;
  bool get isAdmin => currentUser?.isAdmin ?? false;

  Future<void> saveSession(User user, String token) async {
    currentUser = user;
    await _storage.write(key: 'jwt_token', value: token);

    final userDataMap = {
      'id': user.id,
      'nom': user.nom,
      'prenom': user.prenom,
      'email': user.email,
      'role': user.role,
    };
    await _storage.write(key: 'user_data', value: jsonEncode(userDataMap));
  }

  Future<void> logout() async {
    currentUser = null;
    await _storage.delete(key: 'jwt_token');
    await _storage.delete(key: 'user_data');
  }

  Future<bool> loadSession() async {
    final token = await _storage.read(key: 'jwt_token');
    final userDataString = await _storage.read(key: 'user_data');

    if (token != null && userDataString != null) {
      final Map<String, dynamic> decodedData = jsonDecode(userDataString);
      currentUser = User.fromJson(decodedData);
      return true;
    }
    return false;
  }
}