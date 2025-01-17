part of 'edit_profile_info_cubit.dart';

sealed class EditProfileInfoState {}

final class EditProfileInfoInitial extends EditProfileInfoState {}

final class EditProfileInfoLoading extends EditProfileInfoState {}

final class EditProfileInfoError extends EditProfileInfoState {
  final String error;
  EditProfileInfoError({required this.error});
}

final class EditProfileInfoSuccess extends EditProfileInfoState {
  final String? profilePhotoUrl;
  EditProfileInfoSuccess([ this.profilePhotoUrl ]);
}

final class EditProfilePhotoSelected extends EditProfileInfoState {}

