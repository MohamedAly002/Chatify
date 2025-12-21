import 'package:chatify/cubit/chat_message_cubit/chat_message_cubit.dart';
import 'package:chatify/cubit/chat_message_cubit/chat_message_states.dart';
import 'package:chatify/custom%20widgets/chat_message_bubble.dart';
import 'package:cloud_firestore/cloud_firestore.dart';
import 'package:flutter/material.dart';
import 'package:flutter_bloc/flutter_bloc.dart';

class ChatScreen extends StatelessWidget {
  final Map<String, dynamic> user;
  final String currentUserId;
  final TextEditingController controller = TextEditingController();
  final _controller = ScrollController();

  ChatScreen({super.key, required this.user, required this.currentUserId});

  @override
  Widget build(BuildContext context) {
    final chatId = BlocProvider.of<ChatMessageCubit>(context).generateChatId(
      currentUserId,
      user['id'],
    );

    BlocProvider.of<ChatMessageCubit>(context).getMessages(chatId);

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
              backgroundImage: NetworkImage(user['profile_photo_url'] ??
                  Image.asset('assets/user.png').image),
            ),
            const SizedBox(width: 10),
            Text(
              user['username'],
              style: const TextStyle(fontSize: 19, fontWeight: FontWeight.bold),
            ),
          ],
        ),
      ),
      body: Column(
        children: [
          Expanded(
            child: BlocBuilder<ChatMessageCubit, ChatMessageState>(
                builder: (context, state) {
              var messagesList =
                  BlocProvider.of<ChatMessageCubit>(context).messageList;
              return ListView.builder(
                reverse: false,
                controller: _controller,
                itemCount: messagesList.length,
                itemBuilder: (context, index) {
                  final message = messagesList[index];
                  return ChatMessageBubble(
                    isCurrentUser: message['senderId'] == currentUserId,
                    message: message['message'] ?? '',
                    time: message['timesent'] as Timestamp?,
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
                      BlocProvider.of<ChatMessageCubit>(context).sendMessage(
                        chatId,
                        currentUserId,
                        user['id'],
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
