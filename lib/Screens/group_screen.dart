import 'package:chatify/cubit/group_message_cubit/cubit/group_message_cubit.dart';
import 'package:chatify/custom%20widgets/group_message_bubble.dart';
import 'package:cloud_firestore/cloud_firestore.dart';
import 'package:firebase_auth/firebase_auth.dart';
import 'package:flutter/material.dart';
import 'package:flutter_bloc/flutter_bloc.dart';

class GroupScreen extends StatelessWidget {
  GroupScreen({super.key, required this.group, required this.groupId});
  final Map<String, dynamic> group;
  final String groupId;
  final String currentUserId = FirebaseAuth.instance.currentUser!.uid;

  final TextEditingController controller = TextEditingController();
  final _controller = ScrollController();

  @override
  Widget build(BuildContext context) {
        BlocProvider.of<GroupMessageCubit>(context).getMessages(groupId);

    return Scaffold(
      appBar: AppBar(
        forceMaterialTransparency: true,
        elevation: 0,
        backgroundColor: Colors.white,
        titleSpacing: 0,
        leading: const BackButton(color: Color(0xFF31C48D)),
        title: Row(
          children: [
            CircleAvatar(
              radius: 26,
              backgroundImage: group['groupPhotoUrl'] != null
      ? NetworkImage(group['groupPhotoUrl'])
      : const AssetImage('assets/user.png') as ImageProvider,
),
            const SizedBox(width: 10),
            Text(
              group['groupName'],
              style: const TextStyle(fontSize: 19, fontWeight: FontWeight.bold),
            ),
          ],
        ),
      ),
      body: Column(
        children: [
          Expanded(
            child: BlocBuilder<GroupMessageCubit, GroupMessageState>(
                builder: (context, state) {
              var messagesList =
                  BlocProvider.of<GroupMessageCubit>(context).messageList;
              return ListView.builder(
                reverse: false,
                controller: _controller,
                itemCount: messagesList.length,
                itemBuilder: (context, index) {
                  final message = messagesList[index];
                  return GroupMessageBubble(
                  isCurrentUser: message['senderId'] == currentUserId,
      message: message['message'] ?? '',
      time: message['timesent'] as Timestamp?,
      username: message['username'] ?? 'Unknown',
                  );
                },
              );
            }),
          ),
          Padding(
            padding:
                const EdgeInsets.only(left: 8, right: 2, bottom: 16, top: 16),
            child: Row(
              children: [
                Expanded(
                  child: TextField(
                    controller: controller,
                    decoration: InputDecoration(
                        hintText: 'Send Message',
                        contentPadding: const EdgeInsets.all(14),
                        border: OutlineInputBorder(
                          borderRadius: BorderRadius.circular(20),
                        ),
                        enabledBorder: OutlineInputBorder(
                          borderRadius: BorderRadius.circular(20),
                          borderSide: const BorderSide(
                            color: Color(0xFF31C48D),
                          ),
                        ),
                        focusedBorder: OutlineInputBorder(
                          borderRadius: BorderRadius.circular(20),
                          borderSide: const BorderSide(
                            color: Color(0xFF31C48D),
                          ),
                        )),
                  ),
                ),
                IconButton(
                  onPressed: () {
                    final message = controller.text.trim();
                    if (message.isNotEmpty) {
                      BlocProvider.of<GroupMessageCubit>(context).sendMessage(
                        groupId,
                        currentUserId,
                        message,

                       
                      );
                      controller.clear();
                      Future.delayed(const Duration(milliseconds: 50), () {
                        _controller
                            .jumpTo(_controller.position.maxScrollExtent);
                      });
                    }
                  },
                  icon: const Icon(Icons.send),
                  color: const Color(0xFF31C48D),
                ),
              ],
            ),
          ),
        ],
      ),
    );
  }
}
