import 'dart:convert';
import 'package:flutter_secure_storage/flutter_secure_storage.dart';
import 'package:http/http.dart' as http;
import '../user_model.dart';
import 'i_auth_strategy.dart';

class EnsiCaenAuthAdapter implements IAuthStrategy {
  final String loginUrl = 'https://alumni.theo-airey.fr/login_local.php';

  @override
  Future<AuthResult> signIn({String? email, String? password}) async {
    if (email == null || password == null) {
      return AuthResult.failure("Email et mot de passe requis pour la connexion locale.");
    }

    try {
      final response = await http.post(
        Uri.parse(loginUrl),
        headers: {"Content-Type": "application/json"},
        body: jsonEncode({"email": email, "password": password}),
      );

      if (response.statusCode == 200) {
        final data = jsonDecode(response.body);

        if (data['status'] == 'success') {
          final user = User.fromJson(data);
          return AuthResult.success(user, token: data['token']);
        } else {
          return AuthResult.failure(data['message'] ?? "Identifiants incorrects");
        }
      }
      return AuthResult.failure("Erreur serveur : ${response.statusCode}");
    } catch (e) {
      return AuthResult.failure("Impossible de contacter le serveur.");
    }
  }

  @override
  Future<void> signOut() async {
    const storage = FlutterSecureStorage();
    await storage.delete(key: 'jwt_token');
    print("Token deleted !");
  }
}