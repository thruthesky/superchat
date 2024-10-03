import 'package:firebase_core/firebase_core.dart';
import 'package:firebase_database/firebase_database.dart';
import 'package:superchat/src/user.service.dart';

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

  bool debug = false;

  init({
    required String databaseURL,
    String userCollectionName = 'users',
    bool debug = false,
  }) {
    this.databaseURL = databaseURL;
    this.debug = debug;
    UserService.instance.init(
      collectionName: userCollectionName,
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
}
