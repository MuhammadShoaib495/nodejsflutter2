import 'package:flutter/material.dart';
import 'dart:convert';
import 'package:web_socket_channel/web_socket_channel.dart';
import 'dart:core';

class ChatScreen extends StatefulWidget {
  const ChatScreen({super.key});

  @override
  State<ChatScreen> createState() => _ChatScreenState();
}

class _ChatScreenState extends State<ChatScreen> {
  final TextEditingController _messageController = TextEditingController();
  final WebSocketChannel _channel =
  WebSocketChannel.connect(Uri.parse('ws://localhost:8080'));

  List<Map<String, dynamic>> _messages = []; // Store messages here

  void _sendMessage() {
    const user_id = 'bd2dd908-b756-48dd-ac51-9c7ebc72f6a4';
    final message = _messageController.text;

    if (message.isNotEmpty) {
      final messageData = {
        'user_id': user_id,
        'content': message,
        'timestamp': DateTime.now().toIso8601String(),
      };
      print(messageData);

      _channel.sink.add(jsonEncode(messageData)); // Send data to server
      _messageController.clear();
    }
  }

  @override
  void initState() {
    super.initState();

    // Listen to the WebSocket stream and update the _messages list
    _channel.stream.listen((data) {
      final response = jsonDecode(data);

      if (response['type'] == 'oldMessages') {
        setState(() {
          _messages = List<Map<String, dynamic>>.from(response['messages']); // fetching old message data
        });
      } else if (response['type'] == 'newMessages') {
        setState(() {
          _messages.add(response['message']); // adding new message data
        });
      }
    });
  }

  @override
  void dispose() {
    super.dispose();
    _channel.sink.close();
    _messageController.dispose();
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(
        title: const Text('Chat Screen'),
      ),
      body: Column(
        children: <Widget>[
          Expanded(
            child: _messages.isEmpty
                ? const Center(child: CircularProgressIndicator())
                : ListView.builder(
              itemCount: _messages.length,
              itemBuilder: (context, index) {
                final message = _messages[index];
                return ListTile(
                  title: Text('User: ${message['user_id']}'),
                  subtitle: Text('Message: ${message['content']}'),
                  trailing: Text('Time: ${message['timestamp']}'),
                );
              },
            ),
          ),
          Padding(
            padding: const EdgeInsets.all(8.0),
            child: Row(
              children: <Widget>[
                Expanded(
                  child: TextField(
                    controller: _messageController,
                    decoration: const InputDecoration(
                      labelText: 'Enter the message',
                    ),
                  ),
                ),
                IconButton(
                  onPressed: _sendMessage,
                  icon: const Icon(Icons.send),
                ),
              ],
            ),
          ),
        ],
      ),
    );
  }
}
