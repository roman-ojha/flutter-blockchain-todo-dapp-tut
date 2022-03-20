import 'dart:convert';

import 'package:flutter/cupertino.dart';
import 'package:flutter/services.dart';
import 'package:http/http.dart';
import 'package:web3dart/web3dart.dart';
import 'package:web_socket_channel/io.dart';
import 'package:flutter_dotenv/flutter_dotenv.dart';
import './environment.dart';

class TodoListModel extends ChangeNotifier {
  List<Task> todos = [];
  final String _rpcUrl = "http://192.168.10.101:7545";
  // '_rpcurl' will be of ganache network url
  final String _wsUrl = "ws://192.168.10.101:7545/";
  // '_wsUrl' will be of same as '_rpcUrl' different is 'ws' & '/'

  final privateKey = dotenv.env["PRIVATE_KEY"];
  final String _privateKey = Environment.privateKey;
  // ganache private key

  late Web3Client _client;

  late String _abiCode;
  // this will hold the json abi code

  // we also have to get the address part of smart contract which is included in json file
  // EthereumAddress _contractAddress;

  TodoListModel() {
    initialSetup();
  }

  initialSetup() async {
    // this function will call all the other method and initiate the variable 'Web3Client'
    _client = Web3Client(_rpcUrl, Client(), socketConnector: () {
      return IOWebSocketChannel.connect(_wsUrl).cast<String>();
    });

    getAbi();
  }

  Future<void> getAbi() async {
    // and here we will fetch the abi

    String abiStringFile =
        await rootBundle.loadString("src/contract/TodoList.json");
    // first we will scan the whole json file as string

    var jsonAbi = jsonDecode(abiStringFile);
    // this will going to hold the decode value of this json abi

    _abiCode = jsonAbi["abi"];
    //here we are assigning abi part of json file

    print(_abiCode);
  }
}

class Task {
  String taskName;
  bool isCompleted;
  Task({required this.taskName, required this.isCompleted});
}
