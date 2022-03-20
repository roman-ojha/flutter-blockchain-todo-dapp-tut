import 'package:flutter/material.dart';
import './screens/todo_list.dart';

/*
  -> flutter pub add web3dart
  -> flutter pub add web_socket_channel
  -> flutter pub add http
  -> flutter pub add provider
*/

void main() {
  runApp(const MyApp());
}

class MyApp extends StatelessWidget {
  const MyApp({Key? key}) : super(key: key);
  @override
  Widget build(BuildContext context) {
    return const MaterialApp(
      home: TodoList(),
      debugShowCheckedModeBanner: false,
    );
  }
}
