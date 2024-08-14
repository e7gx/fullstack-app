import 'package:flutter/material.dart';
import 'package:todoapp/auth/signup.dart';
import 'package:todoapp/components/navbar.dart';
import 'package:todoapp/services/api_service.dart';
import 'package:todoapp/services/shared_preferences_service.dart';

class LoginPage extends StatefulWidget {
  const LoginPage({super.key});

  @override
  _LoginPageState createState() => _LoginPageState();
}

class _LoginPageState extends State<LoginPage> {
  final _formKey = GlobalKey<FormState>();
  final TextEditingController _usernameController = TextEditingController();
  final TextEditingController _passwordController = TextEditingController();
  bool _isLoading = false;

  void _login() async {
    if (_formKey.currentState!.validate()) {
      setState(() {
        _isLoading = true;
      });

      try {
        final user = await ApiService().loginUser(
          _usernameController.text,
          _passwordController.text,
        );
        if (user != null) {
          // Save the username if the user is authenticated
          await SharedPreferencesService.saveFirstName(
              _usernameController.text);

          Navigator.pushReplacement(
            context,
            MaterialPageRoute(builder: (context) => const HomeScreen()),
          );
        }
      } catch (e) {
        String errorMessage;

        if (e.toString().contains('Invalid username')) {
          errorMessage =
              'Username not found. Please check your username and try again.';
        } else if (e.toString().contains('Invalid password')) {
          errorMessage = 'Incorrect password. Please try again.';
        } else if (e.toString().contains('An unexpected error occurred')) {
          errorMessage =
              'We are experiencing technical difficulties. Please try again later.';
        } else {
          errorMessage =
              'Login failed. Please check your credentials and try again.';
        }

        ScaffoldMessenger.of(context).showSnackBar(
          SnackBar(
            content: Text(errorMessage),
            backgroundColor: Colors.red,
            duration: const Duration(seconds: 4),
            behavior: SnackBarBehavior.floating,
            shape: RoundedRectangleBorder(
              borderRadius: BorderRadius.circular(10),
            ),
            margin: const EdgeInsets.all(16),
            padding: const EdgeInsets.symmetric(horizontal: 16, vertical: 12),
            action: SnackBarAction(
              label: 'Dismiss',
              textColor: Colors.white,
              onPressed: () {
                ScaffoldMessenger.of(context).hideCurrentSnackBar();
              },
            ),
          ),
        );
      } finally {
        setState(() {
          _isLoading = false;
        });
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
                      fontFamily: 'Cairo',
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
                  Row(
                    crossAxisAlignment: CrossAxisAlignment.end,
                    mainAxisAlignment: MainAxisAlignment.end,
                    children: [
                      TextButton(
                        onPressed: () {
                          Navigator.of(context).push(
                            MaterialPageRoute(
                              builder: (context) => const SignUpPage(),
                            ),
                          );
                        },
                        child: const Text(
                          'Sign Up Now!',
                          style: TextStyle(
                            color: Colors.black,
                            fontFamily: 'Cairo',
                          ),
                        ),
                      ),
                    ],
                  ),
                  const SizedBox(
                    height: 30,
                  ),
                  if (_isLoading)
                    const CircularProgressIndicator(
                      color: Colors.black,
                    )
                  else
                    ElevatedButton(
                      onPressed: _login,
                      style: ElevatedButton.styleFrom(
                        padding: const EdgeInsets.symmetric(
                          horizontal: 80,
                          vertical: 14,
                        ),
                        textStyle: const TextStyle(
                          fontSize: 20,
                        ),
                      ),
                      child: const Text(
                        'Login',
                        style: TextStyle(
                            color: Colors.white,
                            fontFamily: 'Cairo',
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
