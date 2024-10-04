import 'dart:developer';

import 'package:firebase_auth/firebase_auth.dart';
import 'package:firebase_database/firebase_database.dart';
import 'package:flutter/foundation.dart';
import 'package:superchat/superchat.dart';

const String chatRoomDivider = '---';

/// return true only if one of the values is true
bool oneTrue(List<bool?> values) {
  return values.where((value) => value == true).length == 1;
}

String get myUid {
  if (FirebaseAuth.instance.currentUser == null) {
    throw Exception(
        'myUid is called in chat.functions.dart, but the user is not signed in');
  }
  return FirebaseAuth.instance.currentUser!.uid;
}

Query roomListQuery({bool? single, bool? group, bool? open, bool? allOpen}) {
  final chatRef = ChatService.instance.database.ref('chat');
  Query query;

  if (single == true) {
    query = chatRef
        .child('joins')
        .child(myUid)
        .orderByChild('singleOrder')
        .startAt(false);
  } else if (group == true) {
    query = chatRef
        .child('joins')
        .child(myUid)
        .orderByChild('groupOrder')
        .startAt(false);
  } else if (open == true) {
    // TODO review
    // This is listing all open rooms
    // To list my open rooms, it should be
    // query = chatRef
    //  .child('joins')
    //  .child(myUid)
    //  .orderByChild('groupOrder')
    //  .startAt(false);
    // Review if this should be a separate widget
    query = chatRef
        .child('joins')
        .child(myUid)
        .orderByChild('openOrder')
        .startAt(false);
  } else if (allOpen == true) {
    // TODO review
    // Be aware that this will have a different datamodel
    // because this is the room itself, not the joins.
    query = chatRef.child('rooms').orderByChild('openOrder').startAt(false);
  } else {
    query = chatRef
        .child('joins')
        .child(myUid)
        .orderByChild('joinedAt')
        .startAt(false);
  }

  return query;
}

DatabaseReference roomRef(String roomId) {
  return ChatService.instance.roomsRef.child(roomId);
}

/// Print log message with emoji 🐶
void dog(dynamic msg, {int level = 0}) {
  if (kReleaseMode) return;
  if (ChatService.instance.debug == false) return;
  log('--> ${msg.toString()}', time: DateTime.now(), name: '🐶', level: level);
}

// /// 채팅방 ID 에서, 1:1 채팅방인지 확인한다.
bool isSingleChatRoom(String roomId) {
  final splits = roomId.split(chatRoomDivider);
  return splits.length == 2 && splits[0].isNotEmpty && splits[1].isNotEmpty;
}

/// Returns the other user's uid from the 1:1 chat room ID.
///
/// If it is a group chat room ID, it returns null.
/// If the user didn't login, it returns null.
///
/// 1:1 채팅방 ID 에서 다른 사용자의 uid 를 리턴한다.
///
/// 그룹 채팅방 ID 이면, null 을 리턴한다.
///
/// 주의, 자기 자신과 대화를 할 수 있으니, 그 경우에는 자기 자신의 uid 를 리턴한다.
String? getOtherUserUidFromRoomId(String roomId) {
  //
  final currentUser = FirebaseAuth.instance.currentUser;
  if (currentUser == null) return null;
  final splits = roomId.split(chatRoomDivider);
  if (splits.length != 2) {
    return null;
  }
  for (final uid in splits) {
    if (uid != currentUser.uid) {
      return uid;
    }
  }
  return currentUser.uid;
}

/// Returns a chat room ID from a user's uid.
/// 대화할 상대방의 UID 를 입력 받아, 일대일 채팅방 ID 를 만든다.
///
/// 로그인 사용자의 uid 와 [otherUserUid] 를 정렬해서 합친다.
String singleChatRoomId(String otherUserUid) {
  if (FirebaseAuth.instance.currentUser?.uid == null) {
    // throw 'chat/auth-required Loign to get the sing chat room id';
    throw ChatException(
      'auth-required',
      'login to get the single chat room id',
    );
  }
  final uids = [FirebaseAuth.instance.currentUser!.uid, otherUserUid];
  uids.sort();
  return uids.join(chatRoomDivider);
}

Future<int> getServerTimestamp() async {
  final ref = FirebaseDatabase.instance
      .ref()
      .child('chat')
      .child('-info')
      .child('timestamp');
  await ref.set(ServerValue.timestamp);
  final snapshot = await ref.get();
  return snapshot.value as int;
}
