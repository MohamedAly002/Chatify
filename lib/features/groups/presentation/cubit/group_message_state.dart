part of 'group_message_cubit.dart';

sealed class GroupMessageState {}

final class GroupMessageInitial extends GroupMessageState {}

final class GroupMessageLoading extends GroupMessageState {}

final class GroupMessageLoaded extends GroupMessageState {
  final List<Map<String, dynamic>> messages;
  GroupMessageLoaded({required this.messages});
}

final class GroupMessageError extends GroupMessageState {
  final String error;
  GroupMessageError({required this.error});
}
