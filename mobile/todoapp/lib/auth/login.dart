// ignore_for_file: library_private_types_in_public_api, use_build_context_synchronously

import 'package:flutter/material.dart';
import 'package:shared_preferences/shared_preferences.dart';
import 'package:todoapp/services/api_service.dart';
import 'package:todoapp/screens/home_screen.dart';

class LoginScreen extends StatefulWidget {
  const LoginScreen({super.key});

  @override
  _LoginScreenState createState() => _LoginScreenState();
}

class _LoginScreenState extends State<LoginScreen> {
  final _formKey = GlobalKey<FormState>();
  final _usernameController = TextEditingController();
  final _passwordController = TextEditingController();

  void _login() async {
    if (_formKey.currentState!.validate()) {
      final username = _usernameController.text;
      final password = _passwordController.text;
      try {
        final user = await ApiService().loginUser(username, password);
        if (user != null) {
          // Save the username to SharedPreferences
          final prefs = await SharedPreferences.getInstance();
          await prefs.setString('first_name',
              username); // or use `user.username` if that's what you get from the login response

          // Handle successful login and navigate to HomeScreen
          Navigator.of(context).pushReplacement(
            MaterialPageRoute(builder: (context) => const HomeScreen()),
          );
        }
      } catch (e) {
        ScaffoldMessenger.of(context).showSnackBar(
          SnackBar(content: Text('Login failed: ${e.toString()}')),
        );
      }
    }
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      body: Stack(
        children: [
          BackgroundImageFb0(
            imageUrl:
                "https://firebasestorage.googleapis.com/v0/b/flutterbricks-public.appspot.com/o/finance_app_2%2Fbackground1.png?alt=media&token=c54b7fd8-c4a6-4192-82a6-08335e7fcea5",
            child: Container(),
          ),
          Padding(
            padding: const EdgeInsets.all(16.0),
            child: Form(
              key: _formKey,
              child: Column(
                crossAxisAlignment: CrossAxisAlignment.center,
                mainAxisAlignment: MainAxisAlignment.center,
                children: [
                  Image.asset('assets/images/task.png', width: 200),
                  const SizedBox(height: 20),
                  const Text(
                    'Login to your account',
                    style: TextStyle(
                      fontSize: 30,
                      fontWeight: FontWeight.bold,
                      fontFamily: 'Cario',
                      color: Colors.black,
                    ),
                  ),
                  const SizedBox(height: 20),
                  TextFormField(
                    controller: _usernameController,
                    decoration: const InputDecoration(
                      labelText: 'Username',
                      labelStyle: TextStyle(
                        color: Colors.black,
                      ),
                      filled: true,
                      fillColor: Colors.white,
                      focusColor: Colors.black,
                      focusedBorder: OutlineInputBorder(
                        borderSide: BorderSide(color: Colors.black),
                      ),
                    ),
                    validator: (value) {
                      if (value == null || value.isEmpty) {
                        return 'Please enter your username';
                      }
                      return null;
                    },
                  ),
                  const SizedBox(height: 20),
                  TextFormField(
                    controller: _passwordController,
                    decoration: const InputDecoration(
                      labelText: 'Password',
                      labelStyle: TextStyle(
                        color: Colors.black,
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
                    obscureText: true,
                    validator: (value) {
                      if (value == null || value.isEmpty) {
                        return 'Please enter your password';
                      }
                      return null;
                    },
                  ),
                  const SizedBox(
                    height: 50,
                  ),
                  ElevatedButton(
                    onPressed: _login,
                    style: ElevatedButton.styleFrom(
                      padding: const EdgeInsets.symmetric(
                        horizontal: 80,
                        vertical: 6,
                      ),
                      textStyle: const TextStyle(
                        fontSize: 20,
                      ),
                    ),
                    child: const Text(
                      'Login',
                      style: TextStyle(
                          color: Colors.white,
                          fontFamily: 'Cario',
                          fontSize: 20,
                          fontWeight: FontWeight.bold),
                    ),
                  ),
                ],
              ),
            ),
          ),
        ],
      ),
    );
  }
}

class BackgroundImageFb0 extends StatelessWidget {
  final Widget child;
  final String imageUrl;
  const BackgroundImageFb0(
      {required this.child, required this.imageUrl, super.key});

  @override
  Widget build(BuildContext context) {
    return Container(
      // Place as the child widget of a scaffold
      width: double.infinity,
      height: double.infinity,
      decoration: BoxDecoration(
        image: DecorationImage(
          image: NetworkImage(imageUrl),
          fit: BoxFit.cover,
        ),
      ),
      child: child,
    );
  }
}
