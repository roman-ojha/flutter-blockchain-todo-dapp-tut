import 'package:flutter/material.dart';
import 'package:provider/provider.dart';
import 'package:todolist/models/todo_list_model.dart';

class TodoList extends StatelessWidget {
  const TodoList({Key? key}) : super(key: key);
  @override
  Widget build(BuildContext context) {
    var list = Provider.of<TodoListModel>(context);
    return Scaffold(
      appBar: AppBar(
        title: const Text("TodoList"),
      ),
      body: Column(
        children: [
          Expanded(
            flex: 4,
            child: ListView.builder(
              itemCount: 10,
              itemBuilder: (context, index) => const ListTile(
                title: Text("Todo"),
              ),
            ),
          ),
          Expanded(
            flex: 1,
            child: Row(
              children: [
                const Expanded(
                  flex: 5,
                  child: TextField(),
                ),
                Expanded(
                  flex: 1,
                  child: ElevatedButton(
                    onPressed: () {},
                    child: const Text("ADD"),
                  ),
                )
              ],
            ),
          ),
        ],
      ),
    );
  }
}
