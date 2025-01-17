import 'package:chatify/cubit/chat_message_cubit/chat_message_states.dart';
import 'package:cloud_firestore/cloud_firestore.dart';
import 'package:flutter_bloc/flutter_bloc.dart';

class ChatMessageCubit extends Cubit<ChatMessageState> {
  ChatMessageCubit() : super(ChatMessageInitial());
  List<Map<String, dynamic>> messageList = [];
  String generateChatId(String userId1, String userId2) {
    final sortedIds = [userId1, userId2]..sort();
    return '${sortedIds[0]}_${sortedIds[1]}';
  }

  void getMessages(String chatId) {
    emit(ChatMessageLoading());
    try {
      FirebaseFirestore.instance
          .collection('chats')
          .doc(chatId)
          .collection('messages')
          .orderBy('timesent', descending: false)
          .snapshots()
          .map((snapshot) => snapshot.docs.map((doc) => doc.data()).toList())
          .listen((event) {
        messageList.clear();
        for (var message in event) {
          messageList.add({
            ...message,
            'timesent': message['timesent'],
          });
        }
        emit(ChatMessageLoaded(messages: messageList));
      });
    } catch (e) {
      emit(ChatMessageError(error: e.toString()));
    }
  }

  void sendMessage(
      String chatId, String senderId, String receiverId, String message) async {
    if (message.isEmpty) return;

    final chatRef = FirebaseFirestore.instance.collection('chats').doc(chatId);
    final messageRef = chatRef.collection('messages');

    try {
      // Check if the chat exists
      final chatDoc = await chatRef.get();
      if (!chatDoc.exists) {
        await chatRef.set({
          'chatId': chatId,
          'participants': [senderId, receiverId],
          'otherUserId': receiverId,
          'lastMessage': message,
          'lastMessageTimestamp': FieldValue.serverTimestamp(),
          'lastMessageSenderId': senderId
        });
      } else {
        // Update the existing chat document
        await chatRef.update({
          'lastMessage': message,
          'lastMessageTimestamp': FieldValue.serverTimestamp(),
          'lastMessageSenderId': senderId
        });
      }

      // Add the message to the messages subcollection
      await messageRef.add({
        'senderId': senderId,
        'receiverId': receiverId,
        'message': message,
        'timesent': FieldValue.serverTimestamp(),
      });
    } catch (e) {
      emit(ChatMessageError(error: e.toString()));
    }
  }
}
