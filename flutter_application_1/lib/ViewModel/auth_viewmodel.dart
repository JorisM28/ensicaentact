import 'package:flutter/foundation.dart';
import '../Model/data/services/auth_service.dart';
import '../Model/connection/auth_strategy.dart';
import '../Model/user_model.dart';
import '../service_locator.dart';

class AuthViewModel extends ChangeNotifier {
  final AuthService _authService = sl<AuthService>();
  final AuthRepository _authRepository = sl<AuthRepository>();

  bool _isLoading = false;
  bool get isLoading => _isLoading;

  User? get currentUser => _authService.currentUser;
  bool get isLoggedIn => _authService.isLoggedIn;
  bool get isAdmin => currentUser?.role == 'admin';

  Future<void> login(String username, String password) async {
    _isLoading = true;
    notifyListeners();

    try {
      // Implement login logic here by delegating to _authRepository or _authService
    } finally {
      _isLoading = false;
      notifyListeners();
    }
  }

  Future<void> logout() async {
    _isLoading = true;
    notifyListeners();

    try {
      await _authRepository.logout();
      await _authService.logout();
    } finally {
      _isLoading = false;
      notifyListeners();
    }
  }
}
