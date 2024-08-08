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
        primaryColor: Colors.black,
        splashColor: Color(0x69494444),
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
        checkboxTheme: CheckboxThemeData(
          checkColor: WidgetStateProperty.resolveWith((states) => Colors.green),
          fillColor: WidgetStateProperty.resolveWith((states) => Colors.white),
          shape: RoundedRectangleBorder(
            borderRadius: BorderRadius.circular(1.0),
          ),
          overlayColor: WidgetStateProperty.resolveWith((states) => Colors.red),
        ),
        elevatedButtonTheme: ElevatedButtonThemeData(
          style: ElevatedButton.styleFrom(
            padding: const EdgeInsets.symmetric(
              horizontal: 80,
              vertical: 15,
            ),
            foregroundColor: Colors.white,
            backgroundColor: Colors.black, // Text color
            shape: RoundedRectangleBorder(
              borderRadius: BorderRadius.circular(8.0),
            ),
          ),
        ),
      ),
      home: const OnBoardingPage(),
    );
  }
}
