part of 'create_group_cubit.dart';


sealed class CreateGroupState {}

final class CreateGroupInitial extends CreateGroupState {}

final class CreateGroupLoading extends CreateGroupState {}

final class CreateGroupSuccess extends CreateGroupState {}

final class CreateGroupError extends CreateGroupState {
  final String errormessage;
  CreateGroupError({required this.errormessage});
}

final class GroupPhotoSelected extends CreateGroupState {}

final class GroupPhotoError extends CreateGroupState {
  final String errormessage;
  GroupPhotoError({required this.errormessage});
}

final class GroupPhotoInitial extends CreateGroupState {}
