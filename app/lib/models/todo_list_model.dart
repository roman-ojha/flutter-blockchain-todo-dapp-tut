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
  bool isLoading = true;
  int taskCount = 0;
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
  late EthereumAddress _contractAddress;

  late Credentials _credentials;

  late EthereumAddress _ownAddress;
  // now we need our own address

  late DeployedContract _contract;

  // making smart contract function, variables, mapping
  late ContractFunction _taskCount; //contract function
  late ContractFunction _todos; // contract mapping
  late ContractFunction _createTask;
  late ContractEvent _taskCreatedEvent;

  TodoListModel() {
    initialSetup();
  }

  Future<void> initialSetup() async {
    // this function will call all the other method and initiate the variable 'Web3Client'
    _client = Web3Client(_rpcUrl, Client(), socketConnector: () {
      return IOWebSocketChannel.connect(_wsUrl).cast<String>();
    });

    await getAbi();
    await getCredentials();
    await getDeployedContract();
    getTodos();
  }

  Future<void> getAbi() async {
    // and here we will fetch the abi

    String abiStringFile =
        await rootBundle.loadString("src/contracts/TodoList.json");
    // first we will scan the whole json file as string

    var jsonAbi = jsonDecode(abiStringFile);
    // this will going to hold the decode value of this json abi

    _abiCode = jsonEncode(jsonAbi["abi"]);
    //here we are assigning abi part of json file

    _contractAddress =
        EthereumAddress.fromHex(jsonAbi["networks"]["5777"]["address"]);
    // here we will assign the given address of contract form json file
  }

  Future<void> getCredentials() async {
    _credentials = await EthPrivateKey.fromHex(_privateKey);
    // this will going to create a credentials using you private key

    _ownAddress = await _credentials.extractAddress();
    // this will extract address from '_credentials' and assign it
  }

  // this function will get copy of our deployed contract
  Future<void> getDeployedContract() async {
    _contract = DeployedContract(
        ContractAbi.fromJson(_abiCode, "TodoList"), _contractAddress);
    // in function we have to pass abi and contract address
    // fromJson(<abiCode>,<name_of_contract>)

    _taskCount = _contract.function("taskCount");
    // here we are assigning the "taskCount" getter function and assigning in the variable
    // assigning all the function,mapping,event
    _createTask = _contract.function("createTask");
    _todos = _contract.function("todos");
    _taskCreatedEvent = _contract.event("TaskCreated");
  }

  getTodos() async {
    // this function will first get the task count
    // calling smart contract function
    List totalTaskList = await _client
        .call(contract: _contract, function: _taskCount, params: []);
    BigInt totalTask = totalTaskList[0];
    // taskCount function doesn't take any parameter so we are passing empty list
    // solidity smart contract return multiple value from the function so it will return as the list

    // first we will create all the todos list
    taskCount = totalTask.toInt();
    todos.clear();
    for (int i = 0; i < taskCount.toInt(); i++) {
      var task = await _client.call(
          contract: _contract, function: _todos, params: [BigInt.from(i)]);
      // while calling smart contract 'todos' mapping we have to pass 'uint256' which is the index of the mapping as parameter so that it can fetch that particular mapping 'Tasks' data;
      todos.add(Task(taskName: task[0], isCompleted: task[1]));
      // now we will add to todos list
    }
    isLoading = false;
    notifyListeners();
  }

  addTask(String taskName) async {
    // this function will going to add the task
    isLoading = true;
    notifyListeners();

    // when we are changing the state of the blockchain then we have to send the transaction
    await _client.sendTransaction(
        _credentials,
        Transaction.callContract(
            contract: _contract,
            function: _createTask,
            parameters: [taskName]));
    // here we have to pass the credentials
    getTodos();
  }
}

class Task {
  String taskName;
  bool isCompleted;
  Task({required this.taskName, required this.isCompleted});
}
