# Super Chat

- A highly scalable and complete chat application based on Realtime Database.
- This is designed especially for FlutterFlow developers.
  - If you are looking for a package for Flutter, look for `easychat` package.


- Build a highly scalable chat app

- If you are building a mid-sized chat app, you should not use Firestore simply because it's too expensive.

- Super chat library uses the realtime database which is very cheap and provides a complete chat features with highly customizable UI.





# Features


- Complete chat features


# Initialize

- Call `ChatService.instance.init()` in the `main.dart` in your FlutterFlow project.
  - `databaseURL` must be set to user the realtime database in the web platform.

Example:

```dart
import 'package:superchat/superchat.dart';

Future initSuperchat() async {
  ChatService.instance.init(
    /// Provide databaseURL for web
    databaseURL: "https://firebase-database-url.com",
  );
}
```

# Customize widget

Using FF

# Overview

- This package users the realtime database.
  - It is very
    - cheap
    - simple
    - fast

# How to

## Chat room list custom design

# Widgets

## ValueListView

- Use this widget to list the values of a node in Realtime database. This can handle most of the cases of listing the values of a node in Realtime database.
- If you don't call `fetchMore(index)`, it will only fetch the first page of data.
- If you want to get only the first page of list to show the latest or the oldest, you don't have to call `fetchMore`.

- In this example, it is using `PageView` to list the data. You can use `ListView`, `GridView`, `CarouselView`, or even `Column`, `Row`, or whatever.

- Use `reverseQuery` to show the oldest data first.

Example:

```dart
ValueListView(
  query: FirebaseDatabase.instance.ref('/tmp'),
  pageSize: 3,
  builder: (snapshot, fetchMore) {
    return PageView.builder(
      itemCount: snapshot.docs.length,
      itemBuilder: (context, index) {
        print('index: $index');
        fetchMore(index);
        return ListTile(
          contentPadding: const EdgeInsets.all(64),
          title: Text(snapshot.docs[index].key!),
        );
      },
    );
  },
  errorBuilder: (s) => Text('Error: $s'),
  loadingBuilder: () => const CircularProgressIndicator(),
  emptyBuilder: () => const Text('Empty'),
),
```

- The example below is using `reverseQuery` to show the oldest data first.

```dart
ValueListView(
  query: FirebaseDatabase.instance.ref('/tmp'),
  pageSize: 3,
  reverseQuery: true,
  builder: (snapshot, fetchMore) {
    return ListView.builder(
      itemCount: snapshot.docs.length,
      itemBuilder: (context, index) {
        print('index: $index');
        fetchMore(index);
        return ListTile(
          contentPadding: const EdgeInsets.all(64),
          title: Text(snapshot.docs[index].key!),
        );
      },
    );
  },
  errorBuilder: (s) => Text('Error: $s'),
  loadingBuilder: () => const CircularProgressIndicator(),
  emptyBuilder: () => const Text('Empty'),
),
```
