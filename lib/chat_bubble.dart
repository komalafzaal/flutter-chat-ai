import 'package:flutter/material.dart';

class ChatBubble extends StatelessWidget {
  final Map<String, String> message;

  const ChatBubble({required this.message});

  @override
  Widget build(BuildContext context) {
    bool isUser = message['role'] == 'user';

    return Align(
      alignment: isUser ? Alignment.centerRight : Alignment.centerLeft,
      child: Container(
        margin: EdgeInsets.symmetric(vertical: 6, horizontal: 12),
        padding: EdgeInsets.all(12),
        decoration: BoxDecoration(
          color: isUser ? Colors.black : Colors.grey[300],
          borderRadius: BorderRadius.circular(12),
        ),
        child: Text(
          message['content'] ?? '',
          style: TextStyle(color: isUser ? Colors.white : Colors.black87),
        ),
      ),
    );
  }
}
