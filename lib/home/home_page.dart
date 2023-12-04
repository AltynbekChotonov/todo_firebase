import 'package:cloud_firestore/cloud_firestore.dart';
import 'package:flutter/cupertino.dart';
import 'package:flutter/material.dart';
import 'package:todo_app/home/add_todo_page.dart';
import 'package:todo_app/model/todo_model.dart';

class MyHomePage extends StatefulWidget {
  const MyHomePage({super.key, required this.title});

  final String title;

  @override
  State<MyHomePage> createState() => _MyHomePageState();
}

class _MyHomePageState extends State<MyHomePage> {
  @override
  void initState() {
    super.initState();
    readTodos();
  }

  Stream<QuerySnapshot> readTodos() {
    final db = FirebaseFirestore.instance;
    return db.collection('todos').snapshots();
  }

  Future<void> updateTodo(Todo todo) async {
    final db = FirebaseFirestore.instance;
    await db
        .collection("todos")
        .doc(todo.id)
        .update({'isCompleted': !todo.isCompleted});
  }

  Future<void> deleteTodo(Todo todo) async {
    final db = FirebaseFirestore.instance;
    await db.collection("todos").doc(todo.id).delete();
  }

  // Future<void> createTodo(Todo todo) async {
  //   final db = FirebaseFirestore.instance;
  //   await db.collection("todos").doc(todo.id).create();
  // }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(
        title: Text(widget.title),
      ),
      body: StreamBuilder(
        stream: readTodos(),
        builder: (context, snapshot) {
          if (snapshot.connectionState == ConnectionState.waiting) {
            return const Center(child: CupertinoActivityIndicator());
          } else if (snapshot.hasError) {
            return Center(child: Text(snapshot.error!.toString()));
          } else if (snapshot.hasData) {
            final List<Todo> todos = snapshot.data!.docs
                .map((e) =>
                    Todo.fromMap(e.data() as Map<String, dynamic>)..id = e.id)
                .toList();
            return ListView.builder(
                itemCount: todos.length,
                itemBuilder: (BuildContext, int Index) {
                  final Todo = todos[Index];
                  return Card(
                    child: ListTile(
                      title: Text(Todo.title),
                      trailing: Row(
                        mainAxisSize: MainAxisSize.min,
                        children: [
                          Checkbox(
                            value: Todo.isCompleted,
                            onChanged: (value) async {
                              await updateTodo(Todo);
                            },
                          ),
                          IconButton(
                              onPressed: () async {
                                await deleteTodo(Todo);
                              },
                              icon: const Icon(Icons.delete)),
                          IconButton(
                              onPressed: () async {
                                await deleteTodo(Todo);
                              },
                              icon: const Icon(Icons.create)),
                        ],
                      ),
                      subtitle: Column(
                        crossAxisAlignment: CrossAxisAlignment.start,
                        children: [
                          Text(Todo.description ?? ''),
                          Text(Todo.theAuthor),
                        ],
                      ),
                    ),
                  );
                });
          } else {
            return const Center(child: Text("Error"));
          }
        },
      ),
      floatingActionButton: FloatingActionButton(
        onPressed: () {
          Navigator.push(
            context,
            MaterialPageRoute(builder: (context) => AddTodoPage()),
          );
        },
        tooltip: 'Increment',
        child: const Icon(Icons.add),
      ),
    );
  }
}
