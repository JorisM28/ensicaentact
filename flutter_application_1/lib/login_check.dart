import 'package:aad_oauth/aad_oauth.dart';
import 'package:aad_oauth/model/config.dart';
import 'package:http/http.dart' as http;
import 'package:flutter/material.dart';
import 'dart:convert';

final GlobalKey<NavigatorState> navigatorKey = GlobalKey<NavigatorState>();

final Config config = Config(
  tenant: "ID EnsiCaen",
  clientId: "ID Azure",
  scope: "openid profile User.Read",
  redirectUri: "http://localhost:39019/redirect.html",
  navigatorKey: navigatorKey,
);

class MicrosoftConnection {
  final AadOAuth oauth = AadOAuth(config);

  Future<Map<String, dynamic>?> signIn() async {
    try {
      await oauth.login();
      String? token = await oauth.getAccessToken();

      if (token != null) {
        String? rawIdToken = await oauth.getIdToken();
        Map<String, dynamic>? idToken;

        if (rawIdToken != null) {
          idToken = _decodeJWT(rawIdToken);
        }

        return {
          'status': 'success',
          'name': idToken?['given_name']?.toString() ?? "Utilisateur",
          'family_name': idToken?['family_name']?.toString() ?? "",
          'email': idToken?['preferred_username']?.toString() ?? "",
          'phone': "",
          'role': 'student',
        };
      }
    } catch (exception) {
      debugPrint("[Error]: Microsoft connection -> $exception ");
    }
    return null;
  }

  Map<String, dynamic> _decodeJWT(String token) {
    final parts = token.split('.');
    if (parts.length != 3) throw Exception('Invalid token');

    final payload = parts[1];
    var normalized = base64Url.normalize(payload);
    var resp = utf8.decode(base64Url.decode(normalized));
    return jsonDecode(resp);
  }

  Future<void> signOut() async => await oauth.logout();
}

class EnsiCaenConnection {
  final String loginUrl = 'https://alumni.theo-airey.fr/login_local.php';

  Future<Map<String, dynamic>> signIn(String email, String password) async {
    try {
      print("Tentative de connexion locale vers : $loginUrl");

      final response = await http.post(
        Uri.parse(loginUrl),
        body: {
          "email": email,
          "password": password,
        },
      );

      if (response.statusCode == 200) {
        final data = jsonDecode(response.body);

        print("Réponse du serveur : $data");

        if (data['status'] == 'success') {
          return {
            'status': 'success',
            'name': data['name'] ?? 'Utilisateur',
            'family_name': data['family_name'] ?? '',
            'email': data['email'] ?? "",
            'phone': data['phone'] ?? "",
            'role': data['role'] ?? '',
          };
        } else {
          return data;
        }

      } else {
        return {
          "status": "error",
          "message": "Erreur serveur ${response.statusCode}"
        };
      }
    } catch (e) {
      print("Erreur réseau: $e");
      return {
        "status": "error",
        "message": "Impossible de contacter le serveur"
      };
    }
  }
}