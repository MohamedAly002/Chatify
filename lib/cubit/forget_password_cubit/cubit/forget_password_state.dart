
abstract class ForgetPasswordState {}

final class ForgetPasswordInitial extends ForgetPasswordState {}
final class ForgetPasswordLoading extends ForgetPasswordState {}
final class ForgetPasswordSuccess extends ForgetPasswordState {}
final class ForgetPasswordError extends ForgetPasswordState {
  final String error;
  ForgetPasswordError(this.error);
}
