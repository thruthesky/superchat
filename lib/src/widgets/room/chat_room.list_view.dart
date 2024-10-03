import 'package:firebase_database/firebase_database.dart';
import 'package:flutter/material.dart';
import 'package:superchat/src/models/chat.room.dart';

import 'package:superchat/superchat.dart';

class ChatRoomListView extends StatefulWidget {
  const ChatRoomListView({
    super.key,
    this.width,
    this.height,
    this.single,
    this.group,
    this.open,
  });

  final double? width;
  final double? height;

  final bool? single;
  final bool? group;
  final bool? open;

  @override
  State<ChatRoomListView> createState() => _ChatRoomListViewState();
}

class _ChatRoomListViewState extends State<ChatRoomListView> {
  @override
  Widget build(BuildContext context) {
    /// Prepare
    if (queryError) {
      return const ErrorText('Only one of single, group, or open can be true.');
    }

    return ValueListView(
      query: query,
      builder: (snapshot, fetchMore) {
        return ListView.separated(
          itemCount: snapshot.docs.length,
          separatorBuilder: (context, index) => const Divider(),
          itemBuilder: (context, index) {
            // dog('snapshot.length: ${snapshot.docs.length}, index: $index');
            fetchMore(index);
            final DataSnapshot doc = snapshot.docs[index];
            final room = ChatRoom.fromSnapshot(doc);
            return ListTile(
              title: Text(
                '''id: ${doc.key},  name: ${(doc.value as Map)['name'] ?? 'Unknown'}, open: ${(doc.value as Map)['open'] ?? false}''',
              ),
              subtitle: Text(room.description),
            );
          },
        );
      },
    );
  }

  get query => roomListQuery(
        single: widget.single,
        group: widget.group,
        open: widget.open,
      );

  bool get queryError =>
      oneTrue([widget.single, widget.group, widget.open]) == false;
}
