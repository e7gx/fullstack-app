import 'package:flutter/material.dart';
import 'package:todoapp/services/api_service.dart';

class DeleteTodoScreen extends StatelessWidget {
  final int todoId;

  const DeleteTodoScreen({super.key, required this.todoId});

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(
        title: const Text('Delete Todo'),
        backgroundColor: Colors.redAccent,
      ),
      backgroundColor:
          Colors.grey[100], // Light background color for better contrast
      body: Padding(
        padding: const EdgeInsets.all(20.0),
        child: Column(
          mainAxisAlignment: MainAxisAlignment.center,
          children: [
            const Icon(
              Icons.warning_amber_rounded,
              color: Colors.redAccent,
              size: 100.0,
            ),
            const SizedBox(height: 20.0),
            const Text(
              'Are you sure you want to delete this todo?',
              textAlign: TextAlign.center,
              style: TextStyle(
                fontSize: 22.0, // Larger font size for emphasis
                fontWeight: FontWeight.bold,
                color: Colors.black87,
              ),
            ),
            const SizedBox(height: 40.0),
            Row(
              mainAxisAlignment: MainAxisAlignment.spaceEvenly,
              children: [
                ElevatedButton.icon(
                  onPressed: () async {
                    try {
                      await ApiService().deleteTodo(todoId);
                      if (context.mounted) {
                        Navigator.popUntil(context, (route) => route.isFirst);
                        _showDialog(
                            context, 'Success', 'Todo deleted successfully');
                      }
                    } catch (e) {
                      if (context.mounted) {
                        Navigator.pop(context);
                        _showDialog(
                            context, 'Error', 'Failed to delete todo: $e');
                      }
                    }
                  },
                  icon: const Icon(Icons.delete, color: Colors.white),
                  label: const Text('Delete'),
                  style: ElevatedButton.styleFrom(
                    backgroundColor: Colors.redAccent,
                    padding: const EdgeInsets.symmetric(
                        horizontal: 25, vertical: 15),
                    shape: RoundedRectangleBorder(
                      borderRadius: BorderRadius.circular(10.0),
                    ),
                    textStyle: const TextStyle(
                      fontSize: 18,
                      fontWeight: FontWeight.bold,
                    ),
                  ),
                ),
                ElevatedButton.icon(
                  onPressed: () {
                    Navigator.pop(context);
                  },
                  icon: const Icon(Icons.cancel, color: Colors.white),
                  label: const Text('Cancel'),
                  style: ElevatedButton.styleFrom(
                    padding: const EdgeInsets.symmetric(
                        horizontal: 25, vertical: 15),
                    shape: RoundedRectangleBorder(
                      borderRadius: BorderRadius.circular(10.0),
                    ),
                    textStyle: const TextStyle(
                      fontSize: 18,
                      fontWeight: FontWeight.bold,
                    ),
                  ),
                ),
              ],
            ),
          ],
        ),
      ),
    );
  }

  void _showDialog(BuildContext context, String title, String message) {
    showDialog(
      context: context,
      builder: (BuildContext context) {
        return AlertDialog(
          title:
              Text(title, style: const TextStyle(fontWeight: FontWeight.bold)),
          content: Text(message),
          actions: [
            TextButton(
              onPressed: () {
                Navigator.pop(context);
              },
              child: const Text('OK'),
            ),
          ],
        );
      },
    );
  }
}
