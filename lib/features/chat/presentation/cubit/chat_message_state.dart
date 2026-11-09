class ChatMessageState {}

class ChatMessageInitial extends ChatMessageState {}

class ChatMessageLoaded extends ChatMessageState {
  List<Map<String, dynamic>> messages;
  ChatMessageLoaded({required this.messages});
}

class ChatMessageLoading extends ChatMessageState {}

class ChatMessageError extends ChatMessageState {
  final String error;
  ChatMessageError({required this.error});
}


