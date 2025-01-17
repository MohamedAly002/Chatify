part of 'user_chatList_cubit.dart';

sealed class UserChatListState {}

final class UserChatListInitial extends UserChatListState {}

class UserChatListLoading extends UserChatListState {}

class UserChatListLoaded extends UserChatListState {
  final List<Map<String, dynamic>> chats;

  UserChatListLoaded({required this.chats});
}

class UserChatListError extends UserChatListState {
  final String error;

  UserChatListError(this.error);
}
