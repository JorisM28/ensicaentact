import 'package:aad_oauth/aad_oauth.dart';
import 'package:aad_oauth/model/config.dart';
import 'package:http/http.dart' as http;
import 'package:flutter/material.dart';
import 'dart:convert';

final GlobalKey<NavigatorState> navigatorKey = GlobalKey<NavigatorState>();

final Config config = Config(
  tenant: "ID EnsiCaen", // Tenant ID donner par l'école
  clientId: "ID Azure",  // Client ID donner par l'école
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

        // DEBUG :
        // print("Token Microsoft: $idToken");

        return {
          'status': 'success',
          'name': idToken?['given_name']?.toString() ?? "Utilisateur",
          'family_name': idToken?['family_name']?.toString() ?? "",
          'email': idToken?['preferred_username']?.toString() ?? "",
          
          // Par défaut, une connexion Microsoft = un étudiant/membre de l'école
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
  final String loginUrl = 'http://localhost/api_alumni/login_local.php';

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
        
        if (data['status'] == 'success') {
           return {
             'status': 'success',
             'name': data['prenom'] ?? 'Admin',
             'family_name': data['nom'] ?? 'System',
             'email': data['email'] ?? "",
             'role': data['role'] ?? 'guest',
           };
        } else {
          // Erreur mauvais mot de passe renvoyée par le PHP
          // Todo gérer les erreurs de mots de passe.
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