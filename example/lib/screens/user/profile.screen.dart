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
          ElevatedButton(
            onPressed: () async {
              await saveWithDummyData();
              ScaffoldMessenger.of(context).showSnackBar(
                const SnackBar(
                  content: Text('Saved with Dummy Data'),
                ),
              );
            },
            child: const Text('Update with Dummy Data'),
          ),
        ],
      ),
    );
  }

  saveWithDummyData() async {
    final millisecond = DateTime.now().millisecondsSinceEpoch;
    Map<String, dynamic> dummyData = {
      'boolean': true,
      'displayName': 'John Doe $millisecond',
      'photoURL': 'https://picsum.photos/200/300',
      'email': 'john.doe$millisecond@example.com',
      'createdAt': Timestamp.now(),
      'phone_number': '1234567890',
      'birthday': DateTime.now(),
      'gender': 'm',
      'stateMessage': 'Hello, I am John Doe. Its $millisecond',
      'statePhotoUrl': 'https://picsum.photos/200/300',
      'array': ['apple1', 'banana1', 'orange1', 'grape1'],
      'latLng': const GeoPoint(35.6895, 139.6917),
      'test': {
        'test1': 'test1',
        'test2': 'test2',
        'test3': 'test3',
      }
    };

    await UserService.instance.myDoc.set(dummyData, SetOptions(merge: false));
  }
}
