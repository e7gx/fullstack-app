import 'package:flutter/material.dart';
import 'package:todoapp/model/todo.dart';
import 'todo_item.dart';

class TodoList extends StatelessWidget {
  final List<Todo> todos;
  final Function onUpdate;

  const TodoList({super.key, required this.todos, required this.onUpdate});

  @override
  Widget build(BuildContext context) {
    return ListView.builder(
      itemCount: todos.length,
      itemBuilder: (context, index) {
        final todo = todos[index];
        return TodoItem(
          todo: todo,
          onUpdate: () => onUpdate(),
        );
      },
    );
  }
}
