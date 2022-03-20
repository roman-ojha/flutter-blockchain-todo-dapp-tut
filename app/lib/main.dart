import 'package:flutter/material.dart';
import 'package:flutter_dotenv/flutter_dotenv.dart';
import 'package:provider/provider.dart';
import './screens/todo_list.dart';
import './models/todo_list_model.dart';

/*
  -> flutter pub add web3dart
  -> flutter pub add web_socket_channel
  -> flutter pub add http
  -> flutter pub add provider

  -> we will initialize the web3 and other filed in 'models/todo_list_model.dart' 

  -> add on pubspec.yaml:
    -> assets:
        - src/contract/TodoList.json

  -> https://pub.dev/documentation/web3dart/latest/web3dart/Web3Client-class.html
*/

Future<void> main() async {
  await dotenv.load(fileName: '.env');
  runApp(const MyApp());
}

class MyApp extends StatelessWidget {
  const MyApp({Key? key}) : super(key: key);
  @override
  Widget build(BuildContext context) {
    return ChangeNotifierProvider(
      create: (context) => TodoListModel(),
      child: MaterialApp(
        home: TodoList(),
        debugShowCheckedModeBanner: false,
      ),
    );
  }
}
