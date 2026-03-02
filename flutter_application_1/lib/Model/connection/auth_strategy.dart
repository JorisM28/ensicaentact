import 'i_auth_strategy.dart';

class AuthRepository {
  IAuthStrategy _currentStrategy;

  AuthRepository(this._currentStrategy);

  void setStrategy(IAuthStrategy newStrategy) {
    _currentStrategy = newStrategy;
  }

  Future<AuthResult> login({String? email, String? password}) {
    return _currentStrategy.signIn(email: email, password: password);
  }

  Future<void> logout(){
    return _currentStrategy.signOut();
  }
}