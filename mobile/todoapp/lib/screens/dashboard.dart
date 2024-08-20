import 'dart:convert';
import 'package:flutter/material.dart';
import 'package:http/http.dart' as http;
import 'package:fl_chart/fl_chart.dart';

class Dashboard extends StatefulWidget {
  const Dashboard({super.key});

  @override
  State<Dashboard> createState() => _DashboardState();
}

class _DashboardState extends State<Dashboard> {
  late Future<List<Todo>> _todosFuture;

  @override
  void initState() {
    super.initState();
    _todosFuture = fetchTodos();
  }

  Future<List<Todo>> fetchTodos() async {
    final response =
        await http.get(Uri.parse('http://127.0.0.1:8000/api/todo/get/'));

    if (response.statusCode == 200) {
      final List<dynamic> todosList = json.decode(response.body);
      // Print the response body for debugging
      // print('Response body: ${response.body}');
      return todosList.map((json) => Todo.fromJson(json)).toList();
    } else {
      throw Exception('Failed to load todos');
    }
  }

  @override
  Widget build(BuildContext context) {
    final screenWidth = MediaQuery.of(context).size.width;
    final screenHeight = MediaQuery.of(context).size.height;
    final radius = screenWidth * 0.2; // Adjust the radius based on screen width
    final fontSize =
        screenWidth * 0.04; // Adjust the font size based on screen width

    return Scaffold(
      body: Padding(
        padding: const EdgeInsets.all(16.0),
        child: FutureBuilder<List<Todo>>(
          future: _todosFuture,
          builder: (context, snapshot) {
            if (snapshot.hasData) {
              final todos = snapshot.data!;
              final completedTodos = todos.where((todo) => todo.done).toList();
              final incompleteTodos =
                  todos.where((todo) => !todo.done).toList();

              return Center(
                child: Column(
                  children: [
                    SizedBox(
                      height: screenHeight * 0.4,
                      width: screenWidth * 0.8,
                      child: PieChart(
                        PieChartData(
                          sections: [
                            PieChartSectionData(
                              color: const Color.fromARGB(255, 255, 137, 137),
                              value: completedTodos.length.toDouble(),
                              title:
                                  '${completedTodos.length} (${(completedTodos.length / todos.length * 100).toStringAsFixed(0)}%)',
                              radius: radius,
                              titleStyle: TextStyle(
                                fontSize: fontSize,
                                fontWeight: FontWeight.bold,
                                color: Colors.white,
                              ),
                            ),
                            PieChartSectionData(
                              color: const Color(0xFF85C4BD),
                              value: incompleteTodos.length.toDouble(),
                              title:
                                  '${incompleteTodos.length} (${(incompleteTodos.length / todos.length * 100).toStringAsFixed(0)}%)',
                              radius: radius,
                              titleStyle: TextStyle(
                                fontSize: fontSize,
                                fontWeight: FontWeight.bold,
                                color: Colors.white,
                              ),
                              badgePositionPercentageOffset: .98,
                            ),
                          ],
                          centerSpaceRadius: screenWidth *
                              0.15, // Adjust the center space radius based on screen width
                          startDegreeOffset: -90,
                          sectionsSpace: 2,
                          borderData: FlBorderData(show: false),
                        ),
                      ),
                    ),
                    const SizedBox(height: 16),
                    Row(
                      children: [
                        const Icon(Icons.task_sharp, color: Colors.black),
                        const SizedBox(width: 8),
                        const Text(
                          'All My Todos: ',
                          style: TextStyle(
                            color: Colors.black,
                            fontWeight: FontWeight.bold,
                            fontSize: 24,
                          ),
                        ),
                        Text(
                          ' ${todos.length}',
                          style: const TextStyle(
                            color: Colors.black,
                            fontWeight: FontWeight.bold,
                            fontSize: 24,
                          ),
                        ),
                      ],
                    ),
                    const SizedBox(height: 10),
                    Row(
                      children: [
                        const Icon(Icons.check_circle, color: Colors.teal),
                        const SizedBox(width: 8),
                        const Text('Completed Todos: ',
                            style: TextStyle(
                              color: Colors.teal,
                              fontWeight: FontWeight.bold,
                              fontSize: 16,
                            )),
                        Text(
                          '${completedTodos.length}',
                          style: const TextStyle(
                            color: Colors.teal,
                            fontWeight: FontWeight.bold,
                            fontSize: 20,
                          ),
                        ),
                      ],
                    ),
                    const SizedBox(height: 10),
                    Row(
                      children: [
                        const Icon(Icons.cancel, color: Colors.red),
                        const SizedBox(width: 8),
                        const Text(
                          'Incomplete Todos: ',
                          style: TextStyle(
                            color: Colors.red,
                            fontWeight: FontWeight.bold,
                            fontSize: 16,
                          ),
                        ),
                        Text(
                          '${incompleteTodos.length}',
                          style: const TextStyle(
                            color: Colors.red,
                            fontWeight: FontWeight.bold,
                            fontSize: 20,
                          ),
                        ),
                      ],
                    ),
                  ],
                ),
              );
            } else if (snapshot.hasError) {
              return Center(
                child: Text('Error: ${snapshot.error}'),
              );
            } else {
              return const Center(
                child: CircularProgressIndicator(
                  color: Colors.black,
                ),
              );
            }
          },
        ),
      ),
    );
  }
}

class Todo {
  final int id;
  final String title;
  final String description;
  final bool done;

  Todo({
    required this.id,
    required this.title,
    required this.description,
    required this.done,
  });

  factory Todo.fromJson(Map<String, dynamic> json) {
    // Print the raw JSON to debug
    // print('Raw JSON: $json');
    // Check if 'done' is actually in the JSON
    final doneValue = json['done'];
    // print('Done value: $doneValue');

    return Todo(
      id: json['id'],
      title: json['title'],
      description: json['description'],
      done: doneValue != null ? doneValue : false, // Default to false if null
    );
  }
}
