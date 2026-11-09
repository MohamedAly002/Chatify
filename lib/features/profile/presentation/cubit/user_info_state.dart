part of 'user_info_cubit.dart';

sealed class UserInfoState {}

final class UserInfoInitial extends UserInfoState {}
class UserInfoLoading extends UserInfoState {}

class UserInfoLoaded extends UserInfoState {
  final String username;
  final String email;
  final String profilePhotoUrl;
  final String about;

  UserInfoLoaded({
    required this.username,
    required this.email,
    required this.profilePhotoUrl,
    required this.about
  });
}

class UserInfoError extends UserInfoState {
  final String error;
  UserInfoError({required this.error});
}

class UserInfoUpdating extends UserInfoState {}
class UserInfoUpdatedSuccess extends UserInfoState {
  
}
class UserInfoUpdatedError extends UserInfoState {}