import 'package:flutter/material.dart';

class AddTodoPage extends StatefulWidget {
  const AddTodoPage({super.key});

  @override
  State<AddTodoPage> createState() => _AddTodoPageState();
}

class _AddTodoPageState extends State<AddTodoPage> {
  bool isCompleted = false;

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
          child: Column(
            mainAxisAlignment: MainAxisAlignment.spaceEvenly,
            children: [
              TextFormField(
                decoration: const InputDecoration(hintText: 'Title'),
              ),
              TextFormField(
                decoration: const InputDecoration(hintText: 'description'),
              ),
              CheckboxListTile(
                  title: Text('Is Completed'),
                  value: isCompleted,
                  onChanged: (v) {
                    setState(() {
                      isCompleted = v ?? false;
                    });
                  }),
              TextFormField(
                decoration: const InputDecoration(hintText: 'the author'),
              ),
            ],
          ),
        ),
      ),
    );
  }
}
