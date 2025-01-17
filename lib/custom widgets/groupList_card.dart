import 'package:cloud_firestore/cloud_firestore.dart';
import 'package:flutter/material.dart';
import 'package:intl/intl.dart';

class GroupListCard extends StatelessWidget {
  const GroupListCard({
    super.key,
    required this.name,
    required this.lastmessage,
    this.time,
    required this.imageUrl,
    required this.isCurrentUser,
    required this.lastMessagesenderName,
  });

  final String name;
  final String lastmessage;
  final Timestamp? time;
  final String imageUrl;
  final bool isCurrentUser;
  final String lastMessagesenderName;

  @override
  Widget build(BuildContext context) {
    return Container(
      padding: const EdgeInsets.all(12),
      child: Row(
        crossAxisAlignment: CrossAxisAlignment.start, // Ensure alignment
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
                    if (time != null)
                      Text(
                        DateFormat.jm().format(time!.toDate()),
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
                    if (lastmessage.isNotEmpty)
                      Text(
                        isCurrentUser ? 'You: ' : '~$lastMessagesenderName: ',
                        style: const TextStyle(
                          fontWeight: FontWeight.bold,
                          fontSize: 14,
                          color: Colors.black,
                        ),
                      ),
                    Expanded(
                      child: Text(
                        lastmessage,
                        style: const TextStyle(
                          fontSize: 14,
                          color: Colors.black54,
                        ),
                        overflow: TextOverflow.ellipsis,
                      ),
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
