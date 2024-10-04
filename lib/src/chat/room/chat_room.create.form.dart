import 'package:firebase_database/firebase_database.dart';
import 'package:flutter/material.dart';
import 'package:superchat/src/models/chat.join.dart';
import 'package:superchat/src/models/chat.room.dart';
import 'package:superchat/superchat.dart';

class ChatRoomCreateForm extends StatefulWidget {
  const ChatRoomCreateForm({super.key, this.onCreate});

  final Function? onCreate;

  @override
  State<ChatRoomCreateForm> createState() => _ChatRoomCreateFormState();
}

class _ChatRoomCreateFormState extends State<ChatRoomCreateForm> {
  final nameController = TextEditingController();
  final descriptionController = TextEditingController();
  bool open = true;
  @override
  Widget build(BuildContext context) {
    return Column(
      children: [
        const Text("ChatRoomCreateForm"),
        TextField(
          controller: nameController,
          decoration: const InputDecoration(
            border: OutlineInputBorder(),
            labelText: 'Room name',
          ),
        ),
        TextField(
          controller: descriptionController,
          decoration: const InputDecoration(
            border: OutlineInputBorder(),
            labelText: 'Room description',
          ),
        ),
        SwitchListTile(
            title: const Text('Open Chat'),
            value: open,
            onChanged: (value) {
              setState(() {
                open = value;
              });
            }),
        ElevatedButton(
          onPressed: () async {
            final chatRef = await ChatRoom.create(
              name: nameController.text,
              description: descriptionController.text,
              open: open,
            );

            final chatRoomDoc = await FirebaseDatabase.instance
                .ref()
                .child('chat')
                .child('rooms')
                .child(chatRef.key!)
                .get();
            final chatRoom = ChatRoom.fromSnapshot(chatRoomDoc);

            // TODO, do somewhere else
            await ChatService.instance.join(chatRoom);

            widget.onCreate?.call();
          },
          child: const Text('Create'),
        ),
      ],
    );
  }
}
