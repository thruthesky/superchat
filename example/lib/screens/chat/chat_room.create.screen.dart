import 'package:flutter/material.dart';
import 'package:superchat/superchat.dart';

class ChatRoomCreateScreen extends StatefulWidget {
  static const String routeName = '/ChatRoomCrate';
  const ChatRoomCreateScreen({super.key});

  @override
  State<ChatRoomCreateScreen> createState() => _ChatRoomCreateScreenState();
}

class _ChatRoomCreateScreenState extends State<ChatRoomCreateScreen> {
  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(
        title: const Text('ChatRoomCreate'),
      ),
      body: Column(
        children: [
          const Text("ChatRoomCreate"),
          ChatRoomCreateForm(
            onCreate: () {
              Navigator.of(context).pop();
            },
          ),
        ],
      ),
    );
  }
}
