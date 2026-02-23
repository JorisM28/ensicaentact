import 'package:flutter_secure_storage/flutter_secure_storage.dart';
import 'api_service.dart';

class AuthService {
  final _storage = const FlutterSecureStorage();
  final ApiService _api = ApiService();

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

  Future<void> logout() async {
    await _storage.delete(key: 'jwt_token');
  }
}