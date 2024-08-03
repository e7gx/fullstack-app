import 'package:flutter/material.dart';
import 'package:todoapp/screens/view/intro.dart';

void main() {
  runApp(const MyApp());
}

class MyApp extends StatelessWidget {
  const MyApp({super.key});

  @override
  Widget build(BuildContext context) {
    return MaterialApp(
      debugShowCheckedModeBanner: false,
      title: 'Todo App',
      theme: ThemeData(
        brightness: Brightness.light,
        scaffoldBackgroundColor: Colors.white,
        cardColor: Colors.white,
        canvasColor: Colors.white,
        fontFamily: 'Cairo', // Apply the custom font family here
        appBarTheme: const AppBarTheme(
          color: Colors.white, // Custom color for AppBar
        ),

        inputDecorationTheme: InputDecorationTheme(
          border: OutlineInputBorder(
            borderRadius: BorderRadius.circular(8.0),
          ),
        ),
        elevatedButtonTheme: ElevatedButtonThemeData(
          style: ElevatedButton.styleFrom(
            foregroundColor: Colors.white,
            backgroundColor: Colors.black, // Text color
          ),
        ),
      ),
      home: const OnBoardingPage(),
    );
  }
}
