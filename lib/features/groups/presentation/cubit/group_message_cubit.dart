

import 'package:cloud_firestore/cloud_firestore.dart';
import 'package:flutter_bloc/flutter_bloc.dart';

part 'group_message_state.dart';

class GroupMessageCubit extends Cubit<GroupMessageState> {
  GroupMessageCubit() : super(GroupMessageInitial());
  List<Map<String, dynamic>> messageList = [];


  void getMessages(String groupId) {
    emit(GroupMessageLoading());
    try {
      FirebaseFirestore.instance
          .collection('groups')
          .doc(groupId)
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
        emit(GroupMessageLoaded(messages: messageList));
      });
    } catch (e) {
      emit(GroupMessageError(error: e.toString()));
    }
  }

  void sendMessage(
     String groupId, String senderId, String message) async {
    if (message.isEmpty) return;
final String username = await FirebaseFirestore.instance.collection('users').doc(senderId).get().then((value) => value.get('username')) as String;
    final chatRef = FirebaseFirestore.instance.collection('groups').doc(groupId);
    final messageRef = chatRef.collection('messages');

    try {
      // Check if the chat exists
      final chatDoc = await chatRef.get();
      if (!chatDoc.exists) {
        await chatRef.set({
          'groupId': groupId,
          'senderId': senderId,
          'lastMessage': message,
          'lastMessageTimestamp': FieldValue.serverTimestamp(),
        });
      } else {
        // Update the existing chat document
        await chatRef.update({
          'lastMessage': message,
          'lastMessageSenderId': senderId,
          'lastMessageTimestamp': FieldValue.serverTimestamp(),
          'senderName': username
        });
      }
      
      // Add the message to the messages subcollection
      await messageRef.add({
        'senderId': senderId,
        'message': message,
        'username': username,
        'timesent': FieldValue.serverTimestamp(),
      });

    } catch (e) {
      emit(GroupMessageError(error: e.toString()));
    }
  }
}

  

