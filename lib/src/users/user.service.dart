import 'dart:async';

import 'package:cloud_firestore/cloud_firestore.dart';
import 'package:firebase_auth/firebase_auth.dart';
import 'package:firebase_database/firebase_database.dart';
import 'package:flutter/material.dart';
import 'package:superchat/superchat.dart';

class UserService {
  static UserService? _instance;
  static UserService get instance => _instance ??= UserService._();
  UserService._();

  /// Firestore collection name for users
  String collectionName = 'users';

  /// List of private fields that should not be synced to the database
  List<String>? _userPrivateFields;

  /// Default private fields
  List<String> defaultPrivateFields = ['email', 'phone_number'];

  init({
    required String collectionName,
    List<String>? userPrivateFields,
  }) {
    dog('UserService.init: $collectionName');
    this.collectionName = collectionName;
    _userPrivateFields = userPrivateFields ?? defaultPrivateFields;
    dog(_userPrivateFields);
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
          Map<String, dynamic> newData = {};

          print('Mirror from Firestore to Database');
          Map<String, dynamic> snapshotData =
              Map<String, dynamic>.from(snapshot.data() as Map);

          for (dynamic key in snapshotData.keys) {
            final value = snapshotData[key];

            if (_userPrivateFields!.contains(key) || value == null) {
              continue;
            }
            if (value is String ||
                value is int ||
                value is double ||
                value is bool ||
                (value is Object && value is List)) {
              newData[key] = value;
            } else if (value is Object) {
              if (value is Timestamp) {
                newData[key] = value.millisecondsSinceEpoch;
              } else if (value is GeoPoint) {
                final geoPoint = value;
                newData['latitude'] = geoPoint.latitude;
                newData['longitude'] = geoPoint.longitude;
              } else if (value is Map) {
                dog('key $key is Map');
                newData[key] = value;
              } else {
                dog('key $key is unknown object type');
              }
            } else {
              dog('key $key is unknown type');
            }
          }
          debugPrint('newData : $newData');
          data(user.uid).update(newData);
        });
      }
    });
  }
}
