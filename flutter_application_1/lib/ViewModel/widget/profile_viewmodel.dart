import 'package:flutter/foundation.dart';
import '/Model/data/services/alumni_repository.dart';
import '/Model/data/services/auth_service.dart';
import '/Model/connection/auth_strategy.dart';
import '/service_locator.dart';

class ProfileViewModel extends ChangeNotifier {
  final AlumniRepository _repository = sl<AlumniRepository>();
  final AuthService _authService = sl<AuthService>();
  final AuthRepository _authRepository = sl<AuthRepository>();

  bool _isLoading = false;
  bool get isLoading => _isLoading;

  bool get isGuest {
    final user = _authService.currentUser;
    return user == null || user.role == 'guest';
  }

  String get role => _authService.currentUser?.role ?? 'guest';

  String get firstName => _authService.currentUser?.firstname ?? '';

  String get lastName => _authService.currentUser?.lastname ?? '';

  String get email => _authService.currentUser?.email ?? '';

  String get initial {
    final fName = firstName;
    return fName.isNotEmpty ? fName[0].toUpperCase() : "?";
  }


  Future<bool> changePassword(String email, String oldPassword, String newPassword) async {
    _isLoading = true;
    notifyListeners();
    try {
      await _repository.updatePassword({
        'email': email,
        'old_password': oldPassword,
        'new_password': newPassword
      });
      return true;
    } catch (e) {
      return false;
    } finally {
      _isLoading = false;
      notifyListeners();
    }
  }

  Future<void> logout() async {
    await _authRepository.logout();
    await _authService.logout();
    notifyListeners();
  }
}