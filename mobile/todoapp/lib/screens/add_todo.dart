// ignore_for_file: library_private_types_in_public_api

import 'package:flutter/material.dart';
import 'package:todoapp/model/todo.dart';
import '../services/api_service.dart';

class AddTodoScreen extends StatefulWidget {
  const AddTodoScreen({super.key});

  @override
  _AddTodoScreenState createState() => _AddTodoScreenState();
}

class _AddTodoScreenState extends State<AddTodoScreen> {
  final _formKey = GlobalKey<FormState>();
  late String _title;
  late String _description;
  late bool _done;

  @override
  void initState() {
    super.initState();
    _title = '';
    _description = '';
    _done = false;
  }

  void _resetForm() {
    setState(() {
      _title = '';
      _description = '';
      _done = false;
    });
    _formKey.currentState!.reset();
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      body: Padding(
        padding: const EdgeInsets.all(16.0),
        child: SingleChildScrollView(
          child: Column(
            crossAxisAlignment: CrossAxisAlignment.center,
            mainAxisAlignment: MainAxisAlignment.center,
            children: [
              Padding(
                padding: const EdgeInsets.only(bottom: 28.0, top: 20),
                child: Image.asset(
                  'assets/images/task.png',
                  height: 200,
                  width: double.infinity,
                ),
              ),
              Form(
                key: _formKey,
                child: Column(
                  mainAxisAlignment: MainAxisAlignment.center,
                  crossAxisAlignment: CrossAxisAlignment.center,
                  children: <Widget>[
                    TextFormField(
                      decoration: const InputDecoration(
                        labelText: 'Title',
                        labelStyle: TextStyle(
                            color: Colors.black,
                            fontFamily: 'Cario',
                            fontWeight: FontWeight.bold),
                        filled: true,
                        fillColor: Colors.white,
                        focusColor: Colors.black,
                        focusedBorder: OutlineInputBorder(
                          borderSide: BorderSide(
                            color: Colors.black,
                          ),
                        ),
                      ),
                      validator: (value) {
                        if (value == null || value.isEmpty) {
                          return 'Please enter a title';
                        }
                        return null;
                      },
                      onSaved: (value) {
                        _title = value!;
                      },
                    ),
                    const SizedBox(height: 16),
                    TextFormField(
                      decoration: const InputDecoration(
                        labelText: 'Description',
                        labelStyle: TextStyle(
                          color: Colors.black,
                          fontFamily: 'Cario',
                          fontWeight: FontWeight.bold,
                        ),
                        filled: true,
                        fillColor: Colors.white,
                        focusColor: Colors.black,
                        focusedBorder: OutlineInputBorder(
                          borderSide: BorderSide(
                            color: Colors.black,
                          ),
                        ),
                      ),
                      validator: (value) {
                        if (value == null || value.isEmpty) {
                          return 'Please enter a description';
                        }
                        return null;
                      },
                      onSaved: (value) {
                        _description = value!;
                      },
                    ),
                    const SizedBox(height: 16),
                    CheckboxListTile(
                      title: const Text('Done'),
                      value: _done,
                      onChanged: (bool? value) {
                        setState(() {
                          _done = value!;
                        });
                      },
                    ),
                    const SizedBox(height: 20),
                    ElevatedButton(
                      onPressed: () async {
                        if (_formKey.currentState!.validate()) {
                          _formKey.currentState!.save();
                          Todo newTodo = Todo(
                            id: 0, // New todo, so ID is 0
                            title: _title,
                            description: _description,
                            done: _done,
                          );
                          ScaffoldMessenger.of(context).showSnackBar(
                            const SnackBar(
                              backgroundColor: Colors.teal,
                              content: Center(
                                child: Text(
                                  'Task added successfully ✅',
                                  style: TextStyle(
                                    fontSize: 24,
                                    fontFamily: 'Cario',
                                    fontWeight: FontWeight.bold,
                                  ),
                                ),
                              ),
                              duration: Duration(
                                seconds: 2,
                              ),
                            ),
                          );
                          _resetForm();
                          await ApiService().createTodo(newTodo);
                        }
                      },
                      style: ElevatedButton.styleFrom(
                        backgroundColor: Colors.black,
                        padding: const EdgeInsets.symmetric(
                            horizontal: 50, vertical: 12),
                        shape: RoundedRectangleBorder(
                          borderRadius: BorderRadius.circular(8.0),
                        ),
                      ),
                      child: const Text(
                        'Add Todo',
                        style: TextStyle(
                          fontSize: 16,
                          fontFamily: 'Cario',
                          fontWeight: FontWeight.w700,
                          color: Colors.white,
                        ),
                      ),
                    ),
                  ],
                ),
              ),
            ],
          ),
        ),
      ),
    );
  }
}
