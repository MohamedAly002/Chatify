import 'dart:developer';
import 'package:chatify/features/groups/presentation/screens/create_group_screen.dart';
import 'package:chatify/features/groups/presentation/screens/group_screen.dart';
import 'package:chatify/features/groups/presentation/cubit/group_list_cubit.dart';
import 'package:chatify/features/groups/presentation/cubit/group_message_cubit.dart';
import 'package:chatify/core/widgets/custom_button.dart';
import 'package:chatify/features/groups/presentation/widgets/group_list_card.dart';
import 'package:cloud_firestore/cloud_firestore.dart';
import 'package:firebase_auth/firebase_auth.dart';
import 'package:flutter/material.dart';
import 'package:flutter_bloc/flutter_bloc.dart';
import 'package:chatify/core/theme/app_colors.dart';
import 'package:chatify/core/constants/app_strings.dart';

class GroupsTab extends StatelessWidget {
  GroupsTab({super.key});
  final String currentUserId = FirebaseAuth.instance.currentUser!.uid;

  @override
  Widget build(BuildContext context) {
    return BlocProvider(
      create: (context) => GroupListCubit()..getGroupList(),
      child: BlocBuilder<GroupListCubit, GroupListState>(
        builder: (context, state) {
          if (state is GroupListLoading) {
            return const SizedBox();
          }
          if (state is GroupListError) {
            log(state.errorMessage);
            return Center(
              child: Column(
                mainAxisAlignment: MainAxisAlignment.center,
                children: [
                  Text('${AppStrings.errorDetailsPrefix}${state.errorMessage}'),
                  const SizedBox(height: 10),
                  Text(state.errorMessage, textAlign: TextAlign.center),
                  const SizedBox(height: 20),
                  CustomButton(
                      text: AppStrings.retry,
                      onPressed: () {
                        context.read<GroupListCubit>().getGroupList();
                      })
                ],
              ),
            );
          }
          if (state is GroupListInitial) {
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
                  AppStrings.noGroupsYet,
                  style: TextStyle(
                      color: AppColors.primary,
                      fontSize: 20,
                      fontWeight: FontWeight.w700),
                ),
                const SizedBox(height: 40),
                CustomButton(
                  text: AppStrings.createGroupAction,
                  onPressed: () {
                    Navigator.pushNamed(context, CreateGroupScreen.routeName);
                  },
                  fontSize: 20,
                  padding:
                      const EdgeInsets.symmetric(horizontal: 30, vertical: 10),
                )
              ],
            );
          }
          if (state is GroupListLoaded) {
            if (state.groups.isEmpty) {}
            // Display chats list
            return ListView.builder(
              itemCount: state.groups.length,
              itemBuilder: (context, index) {
                final group = state.groups[index];

                return InkWell(
                  onTap: () {
                    Navigator.push(
                        context,
                        MaterialPageRoute(
                            builder: (context) => BlocProvider(
                              create: (_) => GroupMessageCubit(),
                              child: GroupScreen(
                                  group: group,
                                  groupId: group['groupId'],
                                ))));
                  },
                  child: GroupListCard(
                    name: group['groupName'],
                    lastmessage: group['lastMessage'] ?? "",
                    imageUrl: group['groupPhotoUrl'],
                    isCurrentUser:
                        group['lastMessageSenderId'] == currentUserId,
                    lastMessagesenderName: group['senderName'] ?? "",
                    time: group['lastMessageTimestamp'] as Timestamp,
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
