abstract class SelectPhotoState {}

final class ProfilePhotoInitial extends SelectPhotoState {}

class ProfilePhotoSelected extends SelectPhotoState {}

class ProfilePhotoUploading extends SelectPhotoState {}

class ProfilePhotoSuccess extends SelectPhotoState {
  final String profilePhotoUrl;
  ProfilePhotoSuccess({required this.profilePhotoUrl});
}

class ProfilePhotoError extends SelectPhotoState {
  final String error;
  ProfilePhotoError({required this.error});
}
