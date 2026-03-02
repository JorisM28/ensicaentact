import '../user_model.dart';
class AuthResult {
  final bool isSuccess;
  final String? errorMessage;
  final User? user;
  final String? token;

  AuthResult._({required this.isSuccess, this.errorMessage, this.user, this.token});

  factory AuthResult.success(User user, {String? token}) =>
      AuthResult._(isSuccess: true, user: user, token: token);

  factory AuthResult.failure(String error) =>
      AuthResult._(isSuccess: false, errorMessage: error);
}

abstract class IAuthStrategy {
  Future<AuthResult> signIn({String? email, String? password});
  Future<void> signOut();
}