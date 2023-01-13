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
  final _formKey = GlobalKey<FormState>();
  bool _isCompleted = false;
  final _title = TextEditingController();
  final _description = TextEditingController();
  final _author = TextEditingController();

  Future<void> addTodo() async {
    final db = FirebaseFirestore.instance;
    final todo = Todo(
      title: _title.text,
      description: _description.text,
      isCompleted: _isCompleted,
      author: _author.text,
    );
    await db.collection('todos').add(todo.toMap());
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(
        backgroundColor: Color.fromARGB(255, 237, 88, 19),
        title: const Text('AddTodoPage'),
      ),
      body: Padding(
        padding: const EdgeInsets.fromLTRB(15, 20, 15, 20),
        child: Form(
          key: _formKey,
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
                    return 'Please enter title';
                  }
                  return null;
                },
              ),
              const SizedBox(height: 30),
              TextFormField(
                controller: _description,
                maxLines: 7,
                decoration: const InputDecoration(
                  hintText: 'Description',
                  border: OutlineInputBorder(),
                ),
              ),
              const SizedBox(height: 30),
              CheckboxListTile(
                title: const Text('Is completed'),
                value: _isCompleted,
                onChanged: (v) {
                  setState(() {
                    _isCompleted = v ?? false;
                  });
                },
              ),
              const SizedBox(height: 30),
              TextFormField(
                controller: _author,
                decoration: const InputDecoration(
                  hintText: 'Author',
                  border: OutlineInputBorder(),
                ),
                validator: (value) {
                  if (value == null || value.isEmpty) {
                    return 'Please enter author name';
                  }
                  return null;
                },
              ),
              const SizedBox(height: 40),
              ElevatedButton.icon(
                onPressed: () async {
                  if (_formKey.currentState!.validate()) {
                    showDialog(
                      context: context,
                      builder: (conbtext) {
                        return const CupertinoAlertDialog(
                          title: Text('Please waiting'),
                          content: Center(
                            child: Padding(
                              padding: EdgeInsets.symmetric(vertical: 40),
                              child: CupertinoActivityIndicator(
                                radius: 20,
                                color: Color.fromARGB(255, 255, 141, 18),
                              ),
                            ),
                          ),
                        );
                      },
                    );
                    await addTodo();
                    // ignore: use_build_context_synchronously
                    Navigator.popUntil(context, (route) => route.isFirst);
                  }
                },
                icon: const Icon(Icons.publish),
                label: const Text('Add ToDo'),
              ),
            ],
          ),
        ),
      ),
    );
  }
}
