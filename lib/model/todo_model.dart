import 'dart:convert';

class Todo {
  Todo({
    this.id,
    required this.title,
    this.description,
    required this.isCompleted,
    required this.author,
  });

  String? id;
  final String title;
  final String? description;
  final bool isCompleted;
  final String author;

  Map<String, dynamic> toMap() {
    return <String, dynamic>{
      'title': title,
      'description': description,
      'isCompleted': isCompleted,
      'author': author,
    };
  }

  factory Todo.fromMap(Map<String, dynamic> map) {
    return Todo(
      title: map['title'] as String,
      description: map['description'] as String?,
      isCompleted: map['isCompleted'] as bool,
      author: map['author'] as String,
    );
  }

  String toJson() => json.encode(toMap());

  factory Todo.fromJson(String source) => Todo.fromMap(json.decode(source) as Map<String, dynamic>);
}
