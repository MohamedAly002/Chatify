import 'package:cloud_firestore/cloud_firestore.dart';
import 'package:flutter/material.dart';
import 'package:intl/intl.dart';

class ChatListCard extends StatelessWidget {
  const ChatListCard({
    super.key,
    required this.name,
    required this.lastmessage,
    required this.time,
    required this.imageUrl,
    required this.isCurrentUser,
  });

  final String name;
  final String lastmessage;
  final Timestamp? time;
  final String imageUrl;
  final bool isCurrentUser;

  @override
  Widget build(BuildContext context) {
    return Container(
      padding: const EdgeInsets.all(12),
      child: Row(
        children: [
          CircleAvatar(
            radius: 30,
            backgroundColor: Colors.transparent,
            backgroundImage: NetworkImage(imageUrl),
          ),
          const SizedBox(width: 12),
          Expanded(
            child: Column(
              crossAxisAlignment: CrossAxisAlignment.start,
              children: [
                Row(
                  mainAxisAlignment: MainAxisAlignment.spaceBetween,
                  children: [
                    Expanded(
                      child: Text(
                        name,
                        style: const TextStyle(
                          fontSize: 16,
                          fontWeight: FontWeight.bold,
                        ),
                        overflow: TextOverflow.ellipsis,
                      ),
                    ),
                    Text(
                      time != null
                          ? DateFormat.jm().format(time!.toDate())
                          : '',
                      style: const TextStyle(
                        fontSize: 12,
                        color: Colors.grey,
                      ),
                    ),
                  ],
                ),
                const SizedBox(height: 4),
                Row(
                  children: [
                    // Show 'You: ' if the message is sent by the current user, else nothing.
                    Text(
                      isCurrentUser
                          ? 'You: '
                          : ' ', // Display 'You: ' if not the current user
                      style: const TextStyle(
                        fontWeight: FontWeight.bold,
                        fontSize: 14,
                        color: Colors.black,
                      ),
                    ),
                    Text(
                      lastmessage,
                      style: const TextStyle(
                        fontSize: 14,
                        color: Colors.black54,
                      ),
                      overflow: TextOverflow.ellipsis,
                    ),
                  ],
                ),
              ],
            ),
          ),
        ],
      ),
    );
  }
}
