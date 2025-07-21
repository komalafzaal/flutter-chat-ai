import 'package:flutter/material.dart';
import 'chat_page.dart';

void main() => runApp(ChatApp());

class ChatApp extends StatelessWidget {
  @override
  Widget build(BuildContext context) {
    return MaterialApp(
      home: ChatPage(),
      debugShowCheckedModeBanner: false,
    );
  }
}
