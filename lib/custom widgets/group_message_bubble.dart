import 'package:cloud_firestore/cloud_firestore.dart';
import 'package:flutter/material.dart';
import 'package:intl/intl.dart';

class GroupMessageBubble extends StatelessWidget {
  const GroupMessageBubble({
    super.key,
    required this.message,
    required this.isCurrentUser,
    required this.time,
    required this.username,
  });

  final String message;
  final bool isCurrentUser;
  final Timestamp? time;
  final String username;
  @override
  Widget build(BuildContext context) {
    return Align(
      alignment: isCurrentUser ? Alignment.centerRight : Alignment.centerLeft,
      child: Container(
        padding: const EdgeInsets.symmetric(vertical: 10, horizontal: 14),
        margin: isCurrentUser
            ? const EdgeInsets.only(
                top: 5,
                bottom: 5,
                right: 8,
                left: 50,
              )
            : const EdgeInsets.only(
                top: 5,
                bottom: 5,
                left: 8,
                right: 50,
              ),
        decoration: BoxDecoration(
          color:
              isCurrentUser ? const Color(0xFFDDFFEC) : const Color(0xFFF0F4F9),
          borderRadius: BorderRadius.only(
            topLeft: Radius.circular(isCurrentUser ? 12 : 0),
            topRight: Radius.circular(isCurrentUser ? 0 : 12),
            bottomLeft: const Radius.circular(12),
            bottomRight: const Radius.circular(12),
          ),
        ),
        child: message.length < 28
            ? Column(
                crossAxisAlignment: CrossAxisAlignment.start,
                children: [
                  if (!isCurrentUser)
                    Text(
                      username,
                      style: const TextStyle(
                        fontWeight: FontWeight.bold,
                        color: Colors.grey,
                        fontSize: 12,
                      ),
                    ),
                  Row(
                    mainAxisSize: MainAxisSize.min,
                    crossAxisAlignment: CrossAxisAlignment.end,
                    children: [
                      Text(
                        message,
                        style: const TextStyle(
                          fontSize: 16,
                          fontWeight: FontWeight.w400,
                        ),
                      ),
                      const SizedBox(width: 5),
                      Text(
                        time != null
                            ? DateFormat.jm().format(time!.toDate())
                            : 'sending...',
                        style: const TextStyle(
                          fontSize: 12,
                          color: Colors.grey,
                        ),
                      ),
                    ],
                  ),
                ],
              )
            : Column(
                crossAxisAlignment: CrossAxisAlignment.start,
                mainAxisSize: MainAxisSize.min,
                children: [
                  if (!isCurrentUser)
                    Text(
                      username,
                      style: const TextStyle(
                        fontWeight: FontWeight.bold,
                        color: Colors.grey,
                        fontSize: 12,
                      ),
                    ),
                  Flexible(
                    child: Text(
                      message,
                      style: const TextStyle(
                        fontSize: 16,
                        fontWeight: FontWeight.w400,
                      ),
                    ),
                  ),
                  Text(
                    time != null
                        ? DateFormat.jm().format(time!.toDate())
                        : '...',
                    style: const TextStyle(
                      fontSize: 12,
                      color: Colors.grey,
                    ),
                  ),
                ],
              ),
      ),
    );
  }
}
