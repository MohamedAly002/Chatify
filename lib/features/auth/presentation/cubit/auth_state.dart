abstract class AuthStates {}

class AuthInitial extends AuthStates {}

class AuthLoading extends AuthStates {}

class AuthSignInSuccess extends AuthStates {}

class AuthSignUpSuccess extends AuthStates {}

class AuthError extends AuthStates {
  final String error;
  AuthError(this.error);
}
class AuthPasswordVisibility extends AuthStates {
  AuthPasswordVisibility();
}
class AuthSignOutSuccess extends AuthStates {}
