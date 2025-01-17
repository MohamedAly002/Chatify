import 'package:cloud_firestore/cloud_firestore.dart';
import 'package:firebase_auth/firebase_auth.dart';
import 'package:flutter_bloc/flutter_bloc.dart';

part 'user_chatList_state.dart';

class UserChatsCubit extends Cubit<UserChatListState> {
  UserChatsCubit() : super(UserChatListInitial());
  void getUserChats() async {
    try {
      emit(UserChatListLoading());
      final currentUserId = FirebaseAuth.instance.currentUser?.uid;

      if (currentUserId == null) {
        emit(UserChatListError('User not logged in.'));
        return;
      }
      final chatRef = FirebaseFirestore.instance.collection('chats');
      chatRef
          .where('participants', arrayContains: currentUserId)
          .snapshots()
          .listen((event) {
        if (event.docs.isEmpty) {
          emit(UserChatListInitial());
          return;
        }
      });

      FirebaseFirestore.instance
          .collection('chats')
          .where('participants', arrayContains: currentUserId)
          .orderBy('lastMessageTimestamp', descending: true)
          .snapshots()
          .listen(
        (snapshot) async {
          if (snapshot.docs.isEmpty) {
            emit(UserChatListInitial());
            return;
          }
          final chats = await Future.wait(snapshot.docs.map((doc) async {
            final data = doc.data();
            final otherUserId =
                data['participants'].firstWhere((id) => id != currentUserId);

            final otherUserDoc = await FirebaseFirestore.instance
                .collection('users')
                .doc(otherUserId)
                .get();

            // Return a map with chat and other user details
            return {
              'chatId': doc.id,
              'participants': data['participants'],
              'lastMessage': data['lastMessage'] ?? '',
              'lastMessageTimestamp': data['lastMessageTimestamp'],
              'id': otherUserId,
              'username': otherUserDoc.data()?['username'] ?? 'Unknown User',
              'profile_photo_url':
                  otherUserDoc.data()?['profile_photo_url'] ?? '',
              'lastMessageSenderId': data['lastMessageSenderId']
            };
          }).toList());
          emit(UserChatListLoaded(chats: chats));
        },
        onError: (error) {
          emit(UserChatListError(error.toString()));
        },
      );
    } catch (e) {
      emit(UserChatListError(e.toString()));
    }
  }
}
