import 'dart:developer';

import 'package:chatify/Screens/chat_screen.dart';
import 'package:chatify/Screens/contacts_screen.dart';
import 'package:chatify/cubit/user_chatList_cubit/cubit/user_chatList_cubit.dart';
import 'package:chatify/custom%20widgets/chatList_card.dart';
import 'package:chatify/custom%20widgets/custom_button.dart';
import 'package:cloud_firestore/cloud_firestore.dart';
import 'package:firebase_auth/firebase_auth.dart';
import 'package:flutter/material.dart';
import 'package:flutter_bloc/flutter_bloc.dart';

class ChatsTab extends StatelessWidget {
     ChatsTab({super.key});
  final String currentUserId = FirebaseAuth.instance.currentUser!.uid;

  @override
  Widget build(BuildContext context) {

    return BlocProvider(
      create: (context) => UserChatsCubit()..getUserChats(),
      child: BlocBuilder<UserChatsCubit, UserChatListState>(
        builder: (context, state) {
          if (state is UserChatListLoading) {
            return const SizedBox();
          }
          if (state is UserChatListError) {
            log(state.error);
            return Center(
              child: Column(
                mainAxisAlignment: MainAxisAlignment.center,
                children: [
                  Text('Something went wrong: ${state.error}'),
                  const SizedBox(height: 10),
                  Text(state.error, textAlign: TextAlign.center),
                  const SizedBox(height: 20),
                  CustomButton(
                      text: 'Retry',
                      onPressed: () {
                        context.read<UserChatsCubit>().getUserChats();
                      })
                ],
              ),
            );
          }
          if (state is UserChatListInitial) {
            return Column(
              mainAxisAlignment: MainAxisAlignment.center,
              children: [
                Opacity(
                  opacity: 0.5,
                  child: Image.asset(
                    'assets/chatify_logo.png',
                    height: 104,
                  ),
                ),
                const SizedBox(height: 40),
                const Text(
                  'You haven’t chat yet',
                  style: TextStyle(
                      color: Color(0xFF31C48D),
                      fontSize: 20,
                      fontWeight: FontWeight.w700),
                ),
                const SizedBox(height: 40),
                CustomButton(
                  text: 'Start Chatting',
                  onPressed: () {
                    Navigator.pushNamed(context, ContactsScreen.routeName);
                  },
                  fontSize: 20,
                  padding:
                      const EdgeInsets.symmetric(horizontal: 30, vertical: 10),
                )
              ],
            );
          }
          if (state is UserChatListLoaded) {
            if (state.chats.isEmpty) {}
            // Display chats list
            return ListView.builder(
              itemCount: state.chats.length,
              itemBuilder: (context, index) {
                final chat = state.chats[index];

                return InkWell(
                  onTap: () {
                    log(chat.toString());
                    Navigator.push(
                        context,
                        MaterialPageRoute(
                            builder: (context) => ChatScreen(
                                  user: chat,
                                  currentUserId:
                                      FirebaseAuth.instance.currentUser!.uid,
                                )));
                  },
                  child: ChatListCard(
                    name: chat['username'],
                    lastmessage: chat['lastMessage'],
                    time: chat['lastMessageTimestamp'] as Timestamp?,
                    imageUrl: chat['profile_photo_url'],
                    isCurrentUser: chat['lastMessageSenderId'] == currentUserId,
                    
                  ),
                );
              },
            );
          }

          return const Center(
              child: Text(
                  'Something went wrong.\nPlease check your internet connection.',
                  textAlign: TextAlign.center,
                  style: TextStyle(
                    color: Colors.red,
                    fontSize: 16,
                  )));
        },
      ),
    );
  }
}
