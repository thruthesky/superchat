import 'package:example/screens/chat/chat_room.create.screen.dart';
import 'package:flutter/material.dart';
import 'package:superchat/superchat.dart';

class ChatRoomListScreen extends StatefulWidget {
  static const String routeName = '/ChatRoomList';
  const ChatRoomListScreen({super.key});

  @override
  State<ChatRoomListScreen> createState() => _ChatRoomListScreenState();
}

class _ChatRoomListScreenState extends State<ChatRoomListScreen> {
  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(
        title: const Text('ChatRoomList'),
        actions: [
          IconButton(
            icon: const Icon(Icons.add),
            onPressed: () {
              showGeneralDialog(
                context: context,
                pageBuilder: (_, __, ___) {
                  return const ChatRoomCreateScreen();
                },
              );
            },
          ),
        ],
      ),
      body: const Column(
        children: [
          Text("ChatRoomList"),
          Expanded(
            child: ChatRoomListView(
              open: true,
            ),
          ),
        ],
      ),
    );
  }
}
