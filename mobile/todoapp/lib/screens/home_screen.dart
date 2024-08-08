// ignore_for_file: library_private_types_in_public_api

import 'package:flutter/material.dart';
import 'package:lottie/lottie.dart';
import 'package:todoapp/auth/login.dart';
import 'package:todoapp/components/reuse.dart';
import 'package:todoapp/model/todo.dart';
import 'package:todoapp/screens/add_todo.dart';
import 'package:todoapp/screens/delete_todo_screen.dart';
import 'package:todoapp/screens/edit_todo.dart';
import 'package:todoapp/screens/profile.dart';
import 'package:todoapp/services/shared_preferences_service.dart';
import 'package:todoapp/utils/constants.dart';
import '../services/api_service.dart';
// import 'package:shared_preferences/shared_preferences.dart';

class HomeScreen extends StatefulWidget {
  const HomeScreen({super.key});

  @override
  _HomeScreenState createState() => _HomeScreenState();
}

class _HomeScreenState extends State<HomeScreen> {
  late Future<List<Todo>> futureTodos;
  int _selectedIndex = 0;
  String _firstName = '';

  @override
  void initState() {
    super.initState();
    _loadUserData();
    futureTodos = ApiService().fetchTodos();
  }

  Future<void> _loadUserData() async {
    final firstName = await SharedPreferencesService.getFirstName();
    setState(() {
      _firstName = firstName;
    });
  }

  void _refreshTodos() {
    setState(() {
      futureTodos = ApiService().fetchTodos();
    });
  }

  void _onItemTapped(int index) {
    setState(() {
      _selectedIndex = index;
    });
  }

  final List<Widget> _pages = [
    const HomeScreenContent(),
    const AddTodoScreen(),
    // You can add other screens like EditTodoScreen and DeleteTodoScreen here
  ];

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(
        title: Row(
          crossAxisAlignment: CrossAxisAlignment.start,
          mainAxisAlignment: MainAxisAlignment.start,
          children: [
            Text(
              'Welcome $_firstName  👋',
              style: TextStyle(
                fontFamily: 'Cario',
                color: Colors.black,
              ),
            ),
          ],
        ),
        backgroundColor: Colors.white,
      ),
      endDrawer: Drawer(
        backgroundColor: Colors.white,
        child: ListView(
          padding: EdgeInsets.zero,
          children: <Widget>[
            const DrawerHeader(
              decoration: BoxDecoration(
                color: primaryColor,
              ),
              child: Text(
                'Drawer Header',
                style: TextStyle(
                  color: Colors.white,
                  fontSize: 24,
                ),
              ),
            ),
            ListTile(
              title: const Text('Item 1'),
              onTap: () {
                Navigator.pop(context);
              },
            ),
            ListTile(
              title: const Text('Profile 2'),
              onTap: () {
                Navigator.push(
                    context,
                    MaterialPageRoute(
                      builder: (context) => const UserProfile(),
                    ));
              },
            ),
            ListTile(
              title: const Text('Logout'),
              leading: const Icon(Icons.logout, color: Colors.red),
              onTap: () async {
                // Clear authentication tokens from shared preferences
                // final prefs = await SharedPreferences.getInstance();
                // await prefs.remove('access_token');
                // await prefs.remove('refresh_token');

                // Perform any additional cleanup if necessary

                // Navigate to the Login Screen
                Navigator.of(context).pushReplacement(
                  MaterialPageRoute(
                      builder: (context) =>
                          const LoginScreen()), // Replace with your login screen
                );
              },
            ),
          ],
        ),
      ),

      body: Stack(
        children: [
          stackBacground(),
          _pages[_selectedIndex],
        ],
      ),
      // floatingActionButton: FloatingActionButton(
      //   onPressed: () {
      //     setState(() {
      //       _selectedIndex = 1; // Switch to the AddTodoScreen
      //     });
      //   },
      //   backgroundColor: primaryColor,
      //   child: const Icon(Icons.add),
      // ),
      bottomNavigationBar: BottomNavigationBar(
        items: const <BottomNavigationBarItem>[
          BottomNavigationBarItem(
            icon: Icon(
              Icons.home,
              color: Colors.black,
            ),
            label: 'Home',
          ),
          BottomNavigationBarItem(
            icon: Icon(Icons.add_task_rounded, color: Colors.black),
            label: 'Add',
          ),
          // Add more items as needed
        ],
        currentIndex: _selectedIndex,
        backgroundColor: Colors.white,
        selectedItemColor: Colors.black,
        onTap: _onItemTapped,
      ),
    );
  }
}

class HomeScreenContent extends StatelessWidget {
  const HomeScreenContent({super.key});

  @override
  Widget build(BuildContext context) {
    return FutureBuilder<List<Todo>>(
      future: ApiService().fetchTodos(),
      builder: (context, snapshot) {
        if (snapshot.connectionState == ConnectionState.waiting) {
          return const Center(child: CircularProgressIndicator());
        } else if (snapshot.hasError) {
          return Center(child: Text('Error: ${snapshot.error}'));
        } else if (!snapshot.hasData || snapshot.data!.isEmpty) {
          return Column(
            crossAxisAlignment: CrossAxisAlignment.center,
            mainAxisAlignment: MainAxisAlignment.center,
            children: [
              Lottie.asset('assets/animation/ppmana.json'),
              const Text(
                'No todos found',
                style: TextStyle(
                  fontSize: 40,
                  color: Colors.black,
                ),
              ),
            ],
          );
        } else {
          return ListView.builder(
            itemCount: snapshot.data!.length,
            itemBuilder: (context, index) {
              return Card(
                color: Colors.white,
                margin: const EdgeInsets.all(8.0),
                child: Padding(
                  padding: const EdgeInsets.all(16.0),
                  child: Column(
                    children: [
                      Image.asset(
                        'assets/images/task.png',
                        width: double.infinity,
                        height: 100,
                      ),
                      Row(
                        children: [
                          Expanded(
                            child: Text(
                              snapshot.data![index].title,
                              style: const TextStyle(fontSize: 16.0),
                            ),
                          ),
                          IconButton(
                            icon: const Icon(Icons.edit),
                            onPressed: () {
                              Navigator.push(
                                context,
                                MaterialPageRoute(
                                  builder: (context) => EditTodoScreen(
                                      todo: snapshot.data![index]),
                                ),
                              ).then((value) {
                                // Trigger the refresh function if needed
                              });
                            },
                          ),
                          IconButton(
                            icon: const Icon(Icons.delete),
                            onPressed: () {
                              Navigator.push(
                                context,
                                MaterialPageRoute(
                                  builder: (context) => DeleteTodoScreen(
                                      todoId: snapshot.data![index].id),
                                ),
                              ).then((value) {
                                // Trigger the refresh function if needed
                              });
                            },
                          ),
                        ],
                      ),
                    ],
                  ),
                ),
              );
            },
          );
        }
      },
    );
  }
}
