import 'package:flutter/material.dart';
import 'package:todoapp/model/todo.dart';
import '../services/api_service.dart';
import '../screens/add_edit_todo_screen.dart';

class TodoItem extends StatelessWidget {
  final Todo todo;
  final VoidCallback onUpdate;

  const TodoItem({super.key, required this.todo, required this.onUpdate});

  @override
  Widget build(BuildContext context) {
    return ListTile(
      title: Text(
        todo.title,
        style: TextStyle(
          decoration: todo.done ? TextDecoration.lineThrough : null,
        ),
      ),
      subtitle: Text(todo.description),
      trailing: Checkbox(
        value: todo.done,
        onChanged: (bool? value) async {
          Todo updatedTodo = Todo(
            id: todo.id,
            title: todo.title,
            description: todo.description,
            done: value!,
          );
          await ApiService().updateTodo(todo.id, updatedTodo);
          onUpdate();
        },
      ),
      onTap: () {
        Navigator.push(
          context,
          MaterialPageRoute(
            builder: (context) => AddEditTodoScreen(todo: todo),
          ),
        ).then((value) {
          onUpdate();
        });
      },
      onLongPress: () async {
        await ApiService().deleteTodo(todo.id);
        onUpdate();
      },
    );
  }
}
