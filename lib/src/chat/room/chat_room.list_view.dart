import 'package:firebase_database/firebase_database.dart';
import 'package:flutter/material.dart';
import 'package:superchat/src/models/chat.join.dart';
import 'package:superchat/src/chat/room/chat_room.screen.dart';

import 'package:superchat/superchat.dart';

// TODO should be listing chat joins
///
/// Chat Room List View is a List View for
/// all the **current user's joined chats**.
class ChatRoomListView extends StatefulWidget {
  const ChatRoomListView({
    super.key,
    this.single,
    this.group,
    this.open,
  });

  // if single, group and open are not true, it means I want to view all my chats
  final bool? single;
  final bool? group;
  final bool? open;

  @override
  State<ChatRoomListView> createState() => _ChatRoomListViewState();
}

class _ChatRoomListViewState extends State<ChatRoomListView> {
  @override
  Widget build(BuildContext context) {
    // Prepare
    if (queryError) {
      // TODO reconsider, If it is Enum, we don't have to do this
      // Reconsider Enum instead of multiple bools (all, single, group, open)
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
            // // Should be from
            // final room = ChatRoom.fromSnapshot(doc);

            final join = ChatJoin.fromSnapshot(doc);

            // return ListTile(
            //   title: Text(
            //     '''id: ${doc.key},  name: ${(doc.value as Map)['name'] ?? 'Unknown'}, open: ${(doc.value as Map)['open'] ?? false}''',
            //   ),
            //   subtitle: Text(room.description),
            // );

            return ListTile(
              // title: Text(room.name),
              // subtitle: Text(room.description),
              title: Text(
                join.name?.isNotEmpty == true ? join.name! : join.roomId,
              ),
              onTap: () async {
                await showGeneralDialog(
                  context: context,
                  pageBuilder: (context, a1, a2) {
                    return ChatRoomScreen(
                      join: join,
                    );
                  },
                );
              },
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
      oneTrue([widget.single, widget.group, widget.open]) == false ||
      // single group open can be false all at once
      // TODO optimize code
      (widget.single != true && widget.group != true && widget.open != true);
}
