import 'dart:developer';

import 'package:firebase_auth/firebase_auth.dart';
import 'package:firebase_database/firebase_database.dart';
import 'package:flutter/foundation.dart';
import 'package:superchat/src/chats/chat.exception.dart';
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

Query roomListQuery({bool? single, bool? group, bool? open}) {
  final chatRef = ChatService.instance.database.ref('chat');
  Query query;

  if (single == true) {
    query = chatRef.child(myUid).orderByChild('singleOrder').startAt(false);
  } else if (group == true) {
    query = chatRef.child(myUid).orderByChild('groupOrder').startAt(false);
  } else {
    query = chatRef.child('rooms').orderByChild('openOrder').startAt(false);
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
