import 'package:firebase_core/firebase_core.dart';
import 'package:flutter/material.dart';
import 'package:cloud_firestore/cloud_firestore.dart';
import 'package:superchat/superchat.dart';

class ProfileScreen extends StatefulWidget {
  static const String routeName = '/Profile';
  const ProfileScreen({super.key});

  @override
  State<ProfileScreen> createState() => _ProfileScreenState();
}

class _ProfileScreenState extends State<ProfileScreen> {
  final displayNameController = TextEditingController();
  final photoUrlController = TextEditingController();
  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(
        title: const Text('Profile'),
      ),
      body: Column(
        children: [
          const Text("Profile"),
          TextField(
            controller: displayNameController,
            decoration: const InputDecoration(
              border: OutlineInputBorder(),
              labelText: 'Display Name',
            ),
          ),
          TextField(
            controller: photoUrlController,
            decoration: const InputDecoration(
              border: OutlineInputBorder(),
              labelText: 'Photo URL',
            ),
          ),
          ElevatedButton(
            onPressed: () async {
              dog('database app: ${Firebase.app().options.projectId}');
              final data = {
                'displayName': displayNameController.text,
                'photoURL': photoUrlController.text,
              };
              //
              dog('data; $data');
              await UserService.instance.myDoc
                  .set(data, SetOptions(merge: true));
              // Navigator.of(context).pop();
            },
            child: const Text('Update'),
          ),
        ],
      ),
    );
  }
}
