import 'package:firebase_database/firebase_database.dart';
import 'package:superchat/superchat.dart';

class ChatJoin {
  /// For field names
  static const field = (
    joinedAt: 'joinedAt',
    singleOrder: 'singleOrder',
    groupOrder: 'groupOrder',
    openOrder: 'openOrder',
    order: 'order',
    lastMessageUid: 'lastMessageUid',
    lastMessageAt: 'lastMessageAt',
    lastMessageDeleted: 'lastMessageDeleted',
    lastText: 'lastText',
    lastUrl: 'lastUrl',
    lastProtocol: 'lastProtocol',
    unreadMessageCount: 'unreadMessageCount',
    name: 'name',
    iconUrl: 'iconUrl',
    displayName: 'displayName',
    photoUrl: 'photoUrl',
  );

  final String roomId;
  final int joinedAt;
  final int? singleOrder;
  final int? groupOrder;
  final int? openOrder;
  final int order;
  final String? lastMessageUid;
  final DateTime? lastMessageAt;
  final bool? lastMessageDeleted;
  final String? lastText;
  final String? lastUrl;
  final String? lastProtocol;

  final int unreadMessageCount;

  final String? name;
  final String? iconUrl;
  final String? displayName;
  final String? photoUrl;

  bool get group => groupOrder != null;
  bool get single => singleOrder != null;
  bool get open => openOrder != null;

  ChatJoin({
    required this.roomId,
    required this.joinedAt,
    required this.singleOrder,
    required this.groupOrder,
    required this.openOrder,
    required this.order,
    required this.lastMessageUid,
    required this.lastMessageAt,
    required this.lastMessageDeleted,
    required this.lastText,
    required this.lastUrl,
    required this.lastProtocol,
    this.unreadMessageCount = 0,
    this.name,
    this.iconUrl,
    this.displayName,
    this.photoUrl,
  });

  factory ChatJoin.fromSnapshot(DataSnapshot snapshot) {
    return ChatJoin.fromJson(snapshot.value as Map, snapshot.key!);
  }

  factory ChatJoin.fromJson(Map<dynamic, dynamic> json, String roomId) {
    return ChatJoin(
      roomId: roomId,
      joinedAt: json[field.joinedAt] is ServerValue
          ? DateTime.now().millisecondsSinceEpoch
          : json[field.joinedAt],
      singleOrder: json[field.singleOrder],
      groupOrder: json[field.groupOrder],
      openOrder: json[field.openOrder],
      order: json[field.order] is ServerValue
          ? DateTime.now().millisecondsSinceEpoch
          : json[field.order],
      lastMessageUid: json[field.lastMessageUid],
      lastMessageAt:
          DateTime.fromMillisecondsSinceEpoch(json[field.lastMessageAt] ?? 0),
      lastMessageDeleted: json[field.lastMessageDeleted],
      lastUrl: json[field.lastUrl],
      lastText: json[field.lastText],
      lastProtocol: json[field.lastProtocol],
      unreadMessageCount: json[field.unreadMessageCount] ?? 0,
      name: json[field.name],
      iconUrl: json[field.iconUrl],
      displayName: json[field.displayName],
      photoUrl: json[field.photoUrl],
    );
  }

  Map<String, dynamic> toJson() {
    return {
      'roomId': roomId,
      field.joinedAt: joinedAt,
      field.singleOrder: singleOrder,
      field.groupOrder: groupOrder,
      field.openOrder: openOrder,
      field.order: order,
      field.lastMessageUid: lastMessageUid,
      field.lastMessageAt: lastMessageAt,
      field.lastMessageDeleted: lastMessageDeleted,
      field.lastText: lastText,
      field.lastUrl: lastUrl,
      field.lastProtocol: lastProtocol,
      field.unreadMessageCount: unreadMessageCount,
      field.name: name,
      field.iconUrl: iconUrl,
      field.displayName: displayName,
      field.photoUrl: photoUrl,
    };
  }
}
