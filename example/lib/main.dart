import 'package:example/firebase_options.dart';
import 'package:example/screens/chat/chat_room.list.screen.dart';
import 'package:example/screens/user/profile.screen.dart';
import 'package:example/screens/user/sign_in.screen.dart';
import 'package:firebase_auth/firebase_auth.dart';
import 'package:firebase_core/firebase_core.dart';
import 'package:flutter/material.dart';
import 'package:superchat/superchat.dart';

void main() async {
  WidgetsFlutterBinding.ensureInitialized();
  await Firebase.initializeApp(options: DefaultFirebaseOptions.currentPlatform);

  /// Initialize super chat service
  ChatService.instance.init(
    /// Provide databaseURL for web
    databaseURL: DefaultFirebaseOptions.currentPlatform.databaseURL!,
    debug: true,
  );
  runApp(const MyApp());
}

class MyApp extends StatelessWidget {
  const MyApp({super.key});

  @override
  Widget build(BuildContext context) {
    return const MaterialApp(
      home: MyHomePage(),
    );
  }
}

class MyHomePage extends StatefulWidget {
  const MyHomePage({super.key});

  @override
  State<MyHomePage> createState() => _MyHomePageState();
}

class _MyHomePageState extends State<MyHomePage> {
  @override
  void initState() {
    super.initState();
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(
        backgroundColor: Theme.of(context).colorScheme.inversePrimary,
        title: const Text('Super chat'),
      ),
      body: Center(
        child: Column(
          mainAxisAlignment: MainAxisAlignment.center,
          children: <Widget>[
            const Text(
              'Sign in first before using chat feature',
            ),
            StreamBuilder(
                stream: FirebaseAuth.instance.authStateChanges(),
                builder: (context, snapshot) {
                  final user = FirebaseAuth.instance.currentUser;
                  if (user != null) {
                    return Column(
                      children: [
                        ElevatedButton(
                          onPressed: () {
                            FirebaseAuth.instance.signOut();
                          },
                          child: Text('UID: $myUid  Sign out'),
                        ),
                        ElevatedButton(
                          onPressed: () {
                            showGeneralDialog(
                              context: context,
                              pageBuilder: (_, __, ___) {
                                return const ProfileScreen();
                              },
                            );
                          },
                          child: const Text('Profile'),
                        )
                      ],
                    );
                  }
                  return ElevatedButton(
                    onPressed: () {
                      showGeneralDialog(
                        context: context,
                        pageBuilder: (_, __, ___) {
                          return const SignInScreen();
                        },
                      );
                    },
                    child: const Text('Sign in'),
                  );
                }),
            const Text(
              'Chat room menus:',
            ),
            ElevatedButton(
              onPressed: () {
                showGeneralDialog(
                  context: context,
                  pageBuilder: (_, __, ___) {
                    return const ChatRoomListScreen();
                  },
                );
              },
              child: const Text('Chat room list'),
            ),
            ElevatedButton(
              onPressed: () {
                showGeneralDialog(
                  context: context,
                  pageBuilder: (_, __, ___) {
                    return const ChatRoomListScreen();
                  },
                );
              },
              child: const Text('Chat Invitations'),
            ),
          ],
        ),
      ),
    );
  }
}
