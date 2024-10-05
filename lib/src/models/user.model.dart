import 'package:firebase_database/firebase_database.dart';

class User {
  User({
    required this.uid,
    this.display_name,
    this.photo_url,
    this.email,
    this.phone_number,
    this.created_at,
    this.data,
  });

  final String uid;
  String? display_name;
  String? photo_url;
  String? email;
  String? phone_number;
  DateTime? created_at;
  Map<String, dynamic>? data;

  factory User.fromDatabaseSnapshot(DataSnapshot snapshot) {
    if (snapshot.exists == false) {
      throw Exception('User.fromDatabaseSnapshot: value does not exists');
    }
    final Map<String, dynamic> data =
        Map<String, dynamic>.from((snapshot.value as Map) ?? {});
    return User.fromJson(data, snapshot.key!);
  }

  factory User.fromJson(Map<String, dynamic> json, String uid) {
    return User(
      uid: uid,
      display_name: json['display_name'],
      photo_url: json['photo_url'],
      email: json['email'],
      phone_number: json['phone_number'],
      created_at: json['created_at'] is int
          ? DateTime.fromMillisecondsSinceEpoch(json['created_at'])
          : DateTime.now(),
      data: json,
    );
  }
}
