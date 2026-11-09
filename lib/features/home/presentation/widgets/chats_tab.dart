import 'dart:developer';
import 'package:chatify/core/theme/app_colors.dart';
import 'package:chatify/core/constants/app_strings.dart';

import 'package:chatify/features/chat/presentation/screens/chat_screen.dart';
import 'package:chatify/features/contacts/presentation/screens/contacts_screen.dart';
import 'package:chatify/features/chat/presentation/cubit/user_chat_list_cubit.dart';
import 'package:chatify/features/chat/presentation/cubit/chat_message_cubit.dart';
import 'package:chatify/features/chat/presentation/widgets/chat_list_card.dart';
import 'package:chatify/core/widgets/custom_button.dart';
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
            return Center(
              child: Column(
                mainAxisAlignment: MainAxisAlignment.center,
                children: [
                  Text('${AppStrings.errorDetailsPrefix}${state.error}'),
                  const SizedBox(height: 10),
                  Text(state.error, textAlign: TextAlign.center),
                  const SizedBox(height: 20),
                  CustomButton(
                      text: AppStrings.retry,
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
                  AppStrings.noChatsYet,
                  style: TextStyle(
                      color: AppColors.primary,
                      fontSize: 20,
                      fontWeight: FontWeight.w700),
                ),
                const SizedBox(height: 40),
                CustomButton(
                  text: AppStrings.startChatting,
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
                            builder: (context) => BlocProvider(
                              create: (_) => ChatMessageCubit(),
                              child: ChatScreen(
                                  user: chat,
                                  currentUserId:
                                      FirebaseAuth.instance.currentUser!.uid,
                                ))));
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
                  '${AppStrings.somethingWentWrong}\n${AppStrings.checkInternetConnection}',
                  textAlign: TextAlign.center,
                  style: TextStyle(
                    color: AppColors.error,
                    fontSize: 16,
                  )));
        },
      ),
    );
  }
}
