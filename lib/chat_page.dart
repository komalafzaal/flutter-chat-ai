import 'dart:convert';
import 'package:flutter/material.dart';
import 'package:http/http.dart' as http;
import 'chat_bubble.dart';

class ChatPage extends StatefulWidget {
  @override
  _ChatPageState createState() => _ChatPageState();
}

class _ChatPageState extends State<ChatPage> {
  final List<Map<String, String>> messages = [];
  final TextEditingController _controller = TextEditingController();

  final String apiKey = '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';

  Future<void> sendMessage(String userInput) async {
    if (userInput.trim().isEmpty) return;

    setState(() {
      messages.add({'role': 'user', 'content': userInput});
    });
    _controller.clear();

    final url = Uri.parse('https://openrouter.ai/api/v1/chat/completions');
    final headers = {
      'Authorization': 'Bearer $apiKey',
      'Content-Type': 'application/json',
    };

    final body = jsonEncode({
      'model': 'deepseek/deepseek-r1-distill-qwen-7b',
      'messages': messages
          .map((msg) => {
        'role': msg['role'],
        'content': msg['content'],
      })
          .toList(),
    });

    final response = await http.post(url, headers: headers, body: body);

    if (response.statusCode == 200) {
      final data = jsonDecode(response.body);
      final reply = data['choices'][0]['message']['content'];
      setState(() {
        messages.add({'role': 'assistant', 'content': reply});
      });
    } else {
      print('API Error: ${response.statusCode}');
      print('Body: ${response.body}');
      setState(() {
        messages
            .add({'role': 'assistant', 'content': '❌ Error: ${response.body}'});
      });
    }
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(
        title: Text('Chat with AI', style: TextStyle(color: Colors.white)),
        backgroundColor: Colors.black,
      ),
      body: Column(
        children: [
          Expanded(
            child: ListView(
              padding: EdgeInsets.symmetric(vertical: 8),
              children: messages.map((msg) => ChatBubble(message: msg)).toList(),
            ),
          ),
          Divider(height: 1),
          SafeArea(
            child: Padding(
              padding: EdgeInsets.fromLTRB(8, 8, 8, 16),
              child: Row(
                children: [
                  Expanded(
                    child: TextField(
                      controller: _controller,
                      onSubmitted: sendMessage,
                      decoration: InputDecoration(
                        hintText: 'Type a message...',
                        enabledBorder: OutlineInputBorder(
                          borderSide: BorderSide(color: Colors.black),
                        ),
                        focusedBorder: OutlineInputBorder(
                          borderSide: BorderSide(color: Colors.black, width: 2),
                        ),
                        contentPadding: EdgeInsets.symmetric(horizontal: 12),
                      ),
                    ),
                  ),
                  IconButton(
                    icon: Icon(Icons.send, color: Colors.black),
                    onPressed: () {
                      sendMessage(_controller.text.trim());
                    },
                  ),
                ],
              ),
            ),
          ),
        ],
      ),
    );
  }
}
