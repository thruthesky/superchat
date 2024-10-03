import 'package:flutter/material.dart';
import 'package:superchat/src/models/chat.room.dart';

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
            await ChatRoom.create(
              name: nameController.text,
              description: descriptionController.text,
              open: open,
            );
            widget.onCreate?.call();
          },
          child: const Text('Create'),
        ),
      ],
    );
  }
}
