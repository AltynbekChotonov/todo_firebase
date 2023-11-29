import 'dart:js_interop';

import 'package:cloud_firestore/cloud_firestore.dart';
import 'package:flutter/cupertino.dart';
import 'package:flutter/material.dart';
import 'package:todo_app/model/todo_model.dart';

class AddTodoPage extends StatefulWidget {
  const AddTodoPage({super.key});

  @override
  State<AddTodoPage> createState() => _AddTodoPageState();
}

class _AddTodoPageState extends State<AddTodoPage> {
  final _formkey = GlobalKey<FormState>();
  bool _isCompleted = false;
  final _title = TextEditingController();
  final _descrption = TextEditingController();
  final _theAuthor = TextEditingController();

  Future<void> addTodo() async {
    final db = FirebaseFirestore.instance;
    final todo = Todo(
      title: _title.text,
      description: _descrption.text,
      isCompleted: _isCompleted,
      theAuthor: _theAuthor.text,
    );
    await db.collection("todos").add(todo.toMap());
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(
        centerTitle: true,
        title: const Text('AddTodoPage'),
      ),
      body: Padding(
        padding: const EdgeInsets.fromLTRB(15, 20, 15, 20),
        child: Form(
          key: _formkey,
          child: ListView(
            children: [
              TextFormField(
                controller: _title,
                decoration: const InputDecoration(
                  hintText: 'Title',
                  border: OutlineInputBorder(),
                ),
                validator: (value) {
                  if (value == null || value.isEmpty) {
                    return 'Please enter text';
                  }
                  return null;
                },
              ),
              const SizedBox(height: 30),
              TextFormField(
                controller: _descrption,
                maxLines: 8,
                decoration: const InputDecoration(
                    hintText: 'description', border: OutlineInputBorder()),
              ),
              const SizedBox(height: 30),
              CheckboxListTile(
                title: const Text('Is Completed'),
                value: _isCompleted,
                onChanged: (v) {
                  setState(() {
                    _isCompleted = v ?? false;
                  });
                },
              ),
              const SizedBox(height: 30),
              TextFormField(
                controller: _theAuthor,
                decoration: const InputDecoration(
                  hintText: 'the author',
                  border: OutlineInputBorder(),
                ),
                validator: (value) {
                  if (value == null || value.isEmpty) {
                    return 'Please enter text';
                  }
                  return null;
                },
              ),
              const SizedBox(height: 50),
              ElevatedButton.icon(
                onPressed: () async {
                  if (_formkey.currentState!.validate()) {
                    showDialog(
                      context: context,
                      builder: (BuildContext context) {
                        return const CupertinoAlertDialog(
                          title: Text('Please waiting'),
                          content: Center(
                              child: Padding(
                            padding: EdgeInsets.symmetric(vertical: 30),
                            child: CupertinoActivityIndicator(
                              radius: 20,
                              color: Colors.blue,
                            ),
                          )),
                        );
                      },
                    );

                    await addTodo();
                    Navigator.popUntil(context, (Route) => Route.isFirst);
                  }
                },
                icon: const Icon(Icons.publish),
                label: const Text('Add Todo'),
              ),
            ],
          ),
        ),
      ),
    );
  }
}
