import 'package:aad_oauth/aad_oauth.dart';
import 'package:aad_oauth/model/config.dart';
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

  Future<Map<String, String>?> signIn() async {
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
          'status' : 'success',
          'name': idToken?['name']?.toString() ?? "User",
          'email' : idToken?['preferred_username']?.toString() ?? "",
        };
      }
    } catch(exception) {
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

class EnsiCaenConnection {}