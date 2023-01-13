import 'package:cloud_firestore/cloud_firestore.dart';
import 'package:flutter/cupertino.dart';
import 'package:flutter/material.dart';
import 'package:todo_app/model/todo_model.dart';

import 'add_todo_page.dart';

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
        .collection('todos')
        .doc(todo.id)
        .update({'isCompleted': !todo.isCompleted});
  }

  Future<void> deleteTodo(Todo todo) async {
    final db = FirebaseFirestore.instance;
    await db.collection('todos').doc(todo.id).delete();
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(
        backgroundColor: Color.fromARGB(255, 237, 88, 19),
        title: Text(widget.title),
      ),
      body: StreamBuilder(
        stream: readTodos(),
        builder: ((context, snapshot) {
          if (snapshot.connectionState == ConnectionState.waiting) {
            return const Center(child: CupertinoActivityIndicator());
          } else if (snapshot.hasError) {
            return Center(child: Text(snapshot.error!.toString()));
          } else if (snapshot.hasData) {
            final List<Todo> todos = snapshot.data!.docs
                .map(
                  (d) =>
                      Todo.fromMap(d.data() as Map<String, dynamic>)..id = d.id,
                )
                .toList();
            return ListView.builder(
              itemCount: todos.length,
              itemBuilder: (BuildContext context, int index) {
                final todo = todos[index];
                return Card(
                  child: ListTile(
                    title: Text(todo.title),
                    trailing: Row(
                      mainAxisSize: MainAxisSize.min,
                      children: [
                        Checkbox(
                          value: todo.isCompleted,
                          onChanged: (v) async {
                            await updateTodo(todo);
                          },
                        ),
                        IconButton(
                          onPressed: () async {
                            await deleteTodo(todo);
                          },
                          icon: const Icon(Icons.delete),
                        ),
                      ],
                    ),
                    subtitle: Column(
                      crossAxisAlignment: CrossAxisAlignment.start,
                      children: [
                        Text(todo.description ?? ''),
                        Text(todo.author),
                      ],
                    ),
                  ),
                );
              },
            );
          } else {
            return const Center(child: Text('Some Error'));
          }
        }),
      ),
      floatingActionButton: FloatingActionButton(
        onPressed: () {
          Navigator.push(
            context,
            MaterialPageRoute(builder: (context) => const AddTodoPage()),
          );
        },
        tooltip: 'Increment',
        child: const Icon(Icons.add),
      ),
    );
  }
}
