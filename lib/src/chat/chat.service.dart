import 'package:firebase_core/firebase_core.dart';
import 'package:firebase_database/firebase_database.dart';
import 'package:flutter/material.dart';
import 'package:superchat/src/models/chat.join.dart';
import 'package:superchat/src/models/chat.message.dart';
import 'package:superchat/src/widgets/room/chat_room.screen.dart';
import 'package:superchat/superchat.dart';

class ChatService {
  static ChatService? _instance;
  static ChatService get instance => _instance ??= ChatService._();
  ChatService._();

  bool initialized = false;

  FirebaseDatabase? _database;

  /// Why?
  /// FlutterFlow uses GoogleServiceInfo.plist and google-service.json for
  /// iOS and Android, respectively. The databaseURL is in the service files.
  /// But for Web, the databaseURL is not in the firebase options. So, it
  /// cannot connect to the Firebase Realtime Database in the web without
  /// knowing the databaseURL.
  String? databaseURL;

  DatabaseReference get messagesRef => database.ref().child('chat/messages');

  DatabaseReference messageRef(String roomId) => messagesRef.child(roomId);

  /// Reference: the list of user and the room list that the user invited to.
  DatabaseReference get invitedUsersRef =>
      database.ref().child('chat/invited-users');

  /// Reference: the chat room list that the user invited to.
  DatabaseReference invitedUserRef(String uid) => invitedUsersRef.child(uid);

  bool debug = false;

  init({
    required String databaseURL,
    String userCollectionName = 'users',
    bool debug = false,
    List<String>? userPrivateFields,
  }) {
    this.databaseURL = databaseURL;
    this.debug = debug;
    UserService.instance.init(
      collectionName: userCollectionName,
      userPrivateFields: userPrivateFields,
    );
    initialized = true;
  }

  FirebaseDatabase get database {
    if (initialized == false) {
      throw Exception('ChatService is not initialized');
    }
    if (databaseURL == null) {
      throw Exception('ChatService.getDatabase is not initialized');
    }
    _database ??= FirebaseDatabase.instanceFor(
        app: Firebase.app(), databaseURL: databaseURL!);
    return _database!;
  }

  /// Database path for chat room and message
  /// Database of chat room and message
  DatabaseReference get roomsRef => database.ref().child('chat/rooms');

  DatabaseReference roomRef(String roomId) => roomsRef.child(roomId);

  // TODO move to somewhere else
  Future<void> join(
    ChatRoom room, {
    String? protocol,
  }) async {
    dog("Joining");

    // if (room.joined) return;

    final timestamp = await getServerTimestamp();
    final negativeTimestamp = -1 * timestamp;

    // int timestamp = await getServerTimestamp();
    // final order = timestamp * -1; // int.parse("-1$timestamp");
    final joinValues = {
      // Incase there is an invitation, remove the invitation
      // TODO
      // invitedUserRef(myUid!).child(room.id).path: null,
      // In case, invitation was mistakenly rejected
      // TODO
      // rejectedUserRef(myUid!).child(room.id).path: null,
      // Add uid in users
      room.ref.child('users').child(myUid!).path: true,
      // Add in chat joins
      'chat/joins/$myUid/${room.id}/joinedAt': ServerValue.timestamp,
      // Should be in top in order
      // This will make the newly joined room at top.
      'chat/joins/$myUid/${room.id}/order': negativeTimestamp,
      if (room.single)
        'chat/joins/$myUid/${room.id}/singleOrder': negativeTimestamp,
      if (room.group)
        'chat/joins/$myUid/${room.id}/groupOrder': negativeTimestamp,
      if (room.open)
        'chat/joins/$myUid/${room.id}/openOrder': negativeTimestamp,
    };

    /// Add your uid into the user list of the chat room instead of reading from database.
    /// * This must be here before await. So it can return fast.
    room.users[myUid] = true;
    await FirebaseDatabase.instance.ref().update(joinValues);
    // await sendMessage(room, protocol: protocol ?? ChatProtocol.join);
  }

  /// Display the chat room screen.
  ///
  /// [join] is the chat join data.
  Future<T?> showChatRoomScreen<T>(
    BuildContext context, {
    // User? user,
    ChatRoom? room,
    ChatJoin? join,
  }) async {
    // TODO assert
    // assert(user != null || room != null || join != null);
    if (!context.mounted) return null;
    return await showGeneralDialog<T>(
      context: context,
      barrierLabel: "Chat Room",
      pageBuilder: (_, __, ___) => ChatRoomScreen(
        // user: user,
        room: room,
        join: join,
      ),
    );
  }

  /// Invite a user into the chat room.
  ///
  /// Purpose:
  /// - This can be used to invite a user into the chat room.
  /// - It can be used for single chat and group chat.
  ///
  /// Where:
  /// - It's used in ChatRoomScreen menu to invite a user.
  /// - It's called from ChatService::inviteOtherUserInSingleChat
  /// - This can be used in any where.
  Future<void> inviteUser(ChatRoom room, String uid) async {
    // To prevent the invitation from getting overlooked or from
    // getting buried by earlier ignored invitations.
    final reverseOrder = (await getServerTimestamp()) * -1;
    await invitedUserRef(uid).child(room.id).set(reverseOrder);
    // TODO reimplement
    // await onInvite?.call(room: room, uid: uid);
  }

  /// States for chat message reply
  ///
  /// Why:
  /// - The reply action is coming from the chat bubble menu.
  /// - And the UI (popup) for the reply appears on top of the chat input box.
  /// - It needs to keep the state whether the reply is enabled or not.
  // TODO implement
  // ValueNotifier<ChatMessage?> reply = ValueNotifier<ChatMessage?>(null);
  // bool get replyEnabled => reply.value != null;
  // clearReply() => reply.value = null;

  /// Send message
  ///
  /// Note that, it should only do the task that is related to sending message.
  Future<void> sendMessage(
    ChatRoom room, {
    String? text,
    String? photoUrl,
    String? protocol,
    ChatMessage? replyTo,
  }) async {
    if (room.joined == false) {
      // Rear exception
      throw ChatException('join-required-to-send-message', 'Join required');
    }
    // Create new message
    final newMessage = await ChatMessage.create(
      roomId: room.id,
      text: text,
      url: photoUrl,
      protocol: protocol,
      replyTo: replyTo,
    );
    // onSendMessage should be called after sending message
    // other extra process comes after it.
    // TODO other extra processes
    // await onSendMessage?.call(message: newMessage, room: room);
    // await updateUnreadMessageCountAndJoinAfterMessageSent(
    //   room: room,
    //   text: text,
    //   photoUrl: photoUrl,
    //   protocol: protocol,
    // );
    // await updateUrlPreview(newMessage, text);
  }
}
