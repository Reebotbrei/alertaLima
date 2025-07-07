import 'package:flutter/material.dart';

class ChatBubble extends StatelessWidget {
  final String message;
  final bool isCurrentUser;

  const ChatBubble({
    super.key,
    required this.message,
    required this.isCurrentUser,
  });

  @override
  Widget build(BuildContext context) {
    return Container(
      width: message.length > 31 ? 315 : null,
      decoration: BoxDecoration(
        color: isCurrentUser ? Colors.green : Colors.grey.shade500,
        borderRadius: BorderRadius.circular(18),
      ),
      padding: const EdgeInsets.all(11),
      margin: const EdgeInsets.only(right: 5, top: 2.5, left: 5),
      child: Text(message, style: TextStyle(color: Colors.white)),
    );
  }
}
