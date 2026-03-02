import 'dart:convert';
import 'package:aad_oauth/aad_oauth.dart';
import '../user_model.dart';
import 'i_auth_strategy.dart';

class MicrosoftAuthAdapter implements IAuthStrategy {
  final AadOAuth oauth;

  MicrosoftAuthAdapter(this.oauth);

  @override
  Future<AuthResult> signIn({String? email, String? password}) async {
    try {
      await oauth.login();
      String? token = await oauth.getAccessToken();

      if (token != null) {
        String? rawIdToken = await oauth.getIdToken();
        Map<String, dynamic>? idToken;

        if (rawIdToken != null) {
          idToken = _decodeJWT(rawIdToken);
        }

        final user = User.fromJson({
          'name': idToken?['given_name']?.toString() ?? "Utilisateur",
          'family_name': idToken?['family_name']?.toString() ?? "",
          'email': idToken?['preferred_username']?.toString() ?? "",
          'role': idToken?['role'] ?? 'student',
        });

        return AuthResult.success(user, token: token);
      }
      return AuthResult.failure("Échec de la récupération du token Microsoft.");
    } catch (e) {
      return AuthResult.failure("Erreur Microsoft: $e");
    }
  }

  @override
  Future<void> signOut() async => await oauth.logout();

  Map<String, dynamic> _decodeJWT(String token) {
    final parts = token.split('.');

    if (parts.length != 3) {
      throw Exception('Invalid token');
    }

    final payload = parts[1];
    var normalized = base64Url.normalize(payload);
    var resp = utf8.decode(base64Url.decode(normalized));
    return jsonDecode(resp);
  }
}