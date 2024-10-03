import 'dart:async';

import 'package:cloud_firestore/cloud_firestore.dart';
import 'package:firebase_auth/firebase_auth.dart';
import 'package:firebase_database/firebase_database.dart';
import 'package:superchat/superchat.dart';

class UserService {
  static UserService? _instance;
  static UserService get instance => _instance ??= UserService._();
  UserService._();

  String collectionName = 'users';

  init({
    required String collectionName,
  }) {
    // ignore: avoid_print
    print('UserService.init: $collectionName');
    this.collectionName = collectionName;

    mirror();
  }

  /// Firestore document reference for the current user
  DocumentReference get myDoc {
    final user = FirebaseAuth.instance.currentUser;
    if (user == null) {
      throw Exception('UserService.myDoc: user is not signed in');
    }
    final ref = doc(user.uid);
    return ref;
  }

  /// Firestore document reference for the user with [uid]
  DocumentReference doc(String uid) {
    final ref = FirebaseFirestore.instance.collection(collectionName).doc(uid);

    dog('path of ref: ${ref.path}');
    return ref;
  }

  /// Database reference for the current user
  DatabaseReference get myData {
    final user = FirebaseAuth.instance.currentUser;
    if (user == null) {
      throw Exception('UserService.myRef: user is not signed in');
    }
    final ref = data(user.uid);
    return ref;
  }

  /// Database reference for the user with [uid]
  DatabaseReference data(String uid) {
    final ref =
        ChatService.instance.database.ref().child(collectionName).child(uid);

    dog('path of ref: ${ref.path}');
    return ref;
  }

  StreamSubscription<User?>? mirrorSubscription;
  StreamSubscription? userDocumentSubscription;

  /// Mirror user's displayName and photoURL from Firestore to Database
  ///
  /// Why?
  /// The superchat is using Firebase Realtime Database for chat and other
  /// functionalities. But the user's displayName and photoURL are stored in
  /// Firestore by FlutterFlow.
  mirror() {
    dog('UserService.mirror');
    mirrorSubscription?.cancel();
    mirrorSubscription =
        FirebaseAuth.instance.authStateChanges().listen((user) {
      if (user != null) {
        userDocumentSubscription?.cancel();
        userDocumentSubscription = doc(user.uid).snapshots().listen((snapshot) {
          if (snapshot.exists == false) {
            return;
          }

          // ignore: avoid_print
          print('Mirror from Firestore to Database');
          data(user.uid).update({
            'displayName': snapshot['displayName'],
            'photoURL': snapshot['photoURL'],
          });
        });
      }
    });
  }
}
