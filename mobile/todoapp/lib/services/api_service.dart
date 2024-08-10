import 'dart:convert';
import 'package:http/http.dart' as http;
import 'package:todoapp/model/todo.dart';
import 'package:todoapp/model/user.dart'; // Assuming you have a User model
import 'package:shared_preferences/shared_preferences.dart';

class ApiService {
  static const String baseUrl =
      'http://127.0.0.1:8000/api'; // Base URL for the API

  // Fetch all todos
  Future<List<Todo>> fetchTodos() async {
    final token = await _getToken();
    final response = await http.get(
      Uri.parse('$baseUrl/todo/get/'),
      headers: {
        'Authorization': 'Token $token',
      },
    );
    if (response.statusCode == 200) {
      List jsonResponse = json.decode(response.body);
      return jsonResponse.map((todo) => Todo.fromJson(todo)).toList();
    } else {
      throw Exception('Failed to load todos: ${response.reasonPhrase}');
    }
  }

  // Fetch a single todo by id
  Future<Todo> fetchTodoById(int id) async {
    final token = await _getToken();
    final response = await http.get(
      Uri.parse('$baseUrl/todo/$id'),
      headers: {
        'Authorization': 'Token $token',
      },
    );
    if (response.statusCode == 200) {
      return Todo.fromJson(json.decode(response.body));
    } else {
      throw Exception('Failed to load todo: ${response.reasonPhrase}');
    }
  }

  // Create a new todo
  Future<void> createTodo(Todo todo) async {
    final token = await _getToken();
    final response = await http.post(
      Uri.parse('$baseUrl/todo/create'),
      headers: {
        'Content-Type': 'application/json',
        'Authorization': 'Token $token',
      },
      body: json.encode(todo.toJson()),
    );
    if (response.statusCode != 201) {
      throw Exception('Failed to create todo: ${response.reasonPhrase}');
    }
  }

  // Update an existing todo
  Future<void> updateTodo(int id, Todo todo) async {
    final token = await _getToken();
    final response = await http.put(
      Uri.parse('$baseUrl/todo/put/$id'),
      headers: {
        'Content-Type': 'application/json',
        'Authorization': 'Token $token',
      },
      body: json.encode(todo.toJson()),
    );
    if (response.statusCode != 200) {
      throw Exception('Failed to update todo: ${response.reasonPhrase}');
    }
  }

  // Delete a todo
  Future<void> deleteTodo(int id) async {
    final token = await _getToken();
    final response = await http.delete(
      Uri.parse('$baseUrl/todo/delete/$id'),
      headers: {
        'Authorization': 'Token $token',
      },
    );
    if (response.statusCode != 204) {
      throw Exception('Failed to delete todo: ${response.reasonPhrase}');
    }
  }

  // Register a new user (Signup)
  Future<User?> registerUser(Map<String, dynamic> user) async {
    final response = await http.post(
      Uri.parse('$baseUrl/auth/signup/'),
      headers: {'Content-Type': 'application/json'},
      body: json.encode(user),
    );
    if (response.statusCode == 200) {
      final userData = User.fromJson(json.decode(response.body));
      await _saveToken(userData.token);
      return userData;
    } else {
      throw Exception('Failed to register user: ${response.reasonPhrase}');
    }
  }


  // Login user
  Future<User?> loginUser(String username, String password) async {
    final response = await http.post(
      Uri.parse('$baseUrl/auth/login/'),
      headers: {'Content-Type': 'application/json'},
      body: json.encode({
        'username': username,
        'password': password,
      }),
    );

    if (response.statusCode == 200) {
      final Map<String, dynamic> jsonResponse = json.decode(response.body);
      final user = User.fromJson(jsonResponse);
      await _saveToken(user.token);
      return user;
    } else if (response.statusCode == 401) {
      final Map<String, dynamic> errorResponse = json.decode(response.body);
      throw Exception('Login failed: ${errorResponse['error']}');
    } else {
      throw Exception('Failed to login user: ${response.reasonPhrase}');
    }
  }

  // Helper methods to manage the token using SharedPreferences
  Future<void> _saveToken(String token) async {
    SharedPreferences prefs = await SharedPreferences.getInstance();
    await prefs.setString('token', token);
  }

  Future<String?> _getToken() async {
    SharedPreferences prefs = await SharedPreferences.getInstance();
    return prefs.getString('token');
  }
}
