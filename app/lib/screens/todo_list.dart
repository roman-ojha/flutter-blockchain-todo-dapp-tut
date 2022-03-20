import 'package:flutter/material.dart';
import 'package:provider/provider.dart';
import 'package:todolist/models/todo_list_model.dart';

class TodoList extends StatelessWidget {
  // const TodoList({Key? key}) : super(key: key);

  TextEditingController t1 = TextEditingController();
  @override
  Widget build(BuildContext context) {
    var listModel = Provider.of<TodoListModel>(context);

    return Scaffold(
      appBar: AppBar(
        title: const Text("TodoList"),
      ),
      body: listModel.isLoading
          ? const Center(
              child: CircularProgressIndicator(),
            )
          : Column(
              children: [
                Expanded(
                  flex: 4,
                  child: ListView.builder(
                    itemCount: listModel.taskCount,
                    itemBuilder: (context, index) => ListTile(
                      title: Text(listModel.todos[0].taskName),
                    ),
                  ),
                ),
                Expanded(
                  flex: 1,
                  child: Row(
                    children: [
                      Expanded(
                        flex: 5,
                        child: TextField(
                          controller: t1,
                        ),
                      ),
                      Expanded(
                        flex: 1,
                        child: ElevatedButton(
                          onPressed: () {
                            listModel.addTask(t1.text);
                          },
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
