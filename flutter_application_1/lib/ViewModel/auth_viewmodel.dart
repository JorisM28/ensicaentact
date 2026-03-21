import 'package:flutter/foundation.dart';
import 'package:flutter_dotenv/flutter_dotenv.dart';
import 'package:aad_oauth/aad_oauth.dart';
import 'package:aad_oauth/model/config.dart';
import '../Model/connection/i_auth_strategy.dart';
import '../Model/data/services/auth_service.dart';
import '../Model/connection/auth_strategy.dart';
import '../Model/user_model.dart';
import '../service_locator.dart';
import '/Model/connection/ensicaen_auth_adapter.dart';
import '/Model/connection/microsoft_auth_adapter.dart';
import '/View/navigation.dart';

class AuthViewModel extends ChangeNotifier {
  final AuthService _authService = sl<AuthService>();
  final AuthRepository _authRepository = sl<AuthRepository>();
  MicrosoftAuthAdapter? _microsoftAdapter;

  bool _isLoading = false;
  bool get isLoading => _isLoading;

  User? get currentUser => _authService.currentUser;
  bool get isLoggedIn => _authService.isLoggedIn;
  bool get isAdmin => currentUser?.role == 'admin';

  Future<AuthResult> loginWithEmail(String email, String password) async {
    _setLoading(true);
    _authRepository.setStrategy(EnsiCaenAuthAdapter());
    final result = await _authRepository.login(email: email, password: password);
    await _processSuccessfulResult(result);
    _setLoading(false);
    return result;
  }

  Future<AuthResult> loginWithMicrosoft() async {
    _setLoading(true);
    try {
      if (_microsoftAdapter == null) {
        final Config config = Config(
          tenant: dotenv.env['AZURE_TENANT_ID'] ?? "",
          clientId: dotenv.env['AZURE_CLIENT_ID'] ?? "",
          scope: "openid profile User.Read",
          redirectUri: dotenv.env['AZURE_REDIRECT_URI'] ?? "http://localhost:39019/redirect.html",
          navigatorKey: navigatorKey,
          webUseRedirect: false,
        );
        _microsoftAdapter = MicrosoftAuthAdapter(AadOAuth(config));
      }

      _authRepository.setStrategy(_microsoftAdapter!);
      final result = await _authRepository.login();
      await _processSuccessfulResult(result);
      _setLoading(false);
      return result;
    } catch (e) {
      _setLoading(false);
      throw Exception(e.toString());
    }
  }

  Future<void> _processSuccessfulResult(AuthResult result) async {
    if (result.isSuccess && result.user != null) {
      final user = result.user!;
      if (['admin', 'student', 'alumni'].contains(user.role)) {
        String tokenToSave = result.token ?? 'microsoft_session_token';
        await _authService.saveSession(user, tokenToSave);
      }
    }
  }

  Future<void> logout() async {
    _setLoading(true);
    await _authRepository.logout();
    await _authService.logout();
    _setLoading(false);
  }

  void _setLoading(bool value) {
    _isLoading = value;
    notifyListeners();
  }
}