// ignore_for_file: library_private_types_in_public_api

import 'package:flutter/material.dart';
import 'package:lottie/lottie.dart';
import 'package:skeletonizer/skeletonizer.dart';
import 'package:todoapp/auth/signup.dart';
import 'package:todoapp/components/reuse.dart';
import 'package:todoapp/model/todo.dart';
import 'package:todoapp/screens/add_todo.dart';
import 'package:todoapp/screens/chat/chat.dart';
import 'package:todoapp/screens/delete_todo_screen.dart';
import 'package:todoapp/screens/edit_todo.dart';
import 'package:todoapp/screens/profile.dart';
import 'package:todoapp/services/shared_preferences_service.dart';
import '../services/api_service.dart';

class HomeScreen extends StatefulWidget {
  const HomeScreen({super.key});

  @override
  _HomeScreenState createState() => _HomeScreenState();
}

class _HomeScreenState extends State<HomeScreen> {
  int _selectedIndex = 0;
  String _firstName = '';

  @override
  void initState() {
    super.initState();
    _loadUserData();
  }

  Future<void> _loadUserData() async {
    final firstName = await SharedPreferencesService.getFirstName();
    setState(() {
      _firstName = firstName;
    });
  }

  void _onItemTapped(int index) {
    setState(() {
      _selectedIndex = index;
    });
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: CustomAppBar(firstName: _firstName),
      endDrawer: const CustomDrawer(),
      body: Stack(
        children: [
          stackBacground(),
          _pages[_selectedIndex],
        ],
      ),
      bottomNavigationBar: CustomBottomNavigationBar(
        selectedIndex: _selectedIndex,
        onItemTapped: _onItemTapped,
      ),
    );
  }

  final List<Widget> _pages = [
    const HomeScreenContent(),
    const AddTodoScreen(),
    const AiChatPage(),
  ];
}

class CustomAppBar extends StatelessWidget implements PreferredSizeWidget {
  final String firstName;

  const CustomAppBar({super.key, required this.firstName});

  @override
  Widget build(BuildContext context) {
    return AppBar(
      title: Row(
        crossAxisAlignment: CrossAxisAlignment.start,
        mainAxisAlignment: MainAxisAlignment.start,
        children: [
          Text(
            'Welcome $firstName 👋',
            style: const TextStyle(
              fontFamily: 'Cario',
              color: Colors.black,
            ),
          ),
        ],
      ),
      backgroundColor: Colors.white,
    );
  }

  @override
  Size get preferredSize => const Size.fromHeight(kToolbarHeight);
}

class CustomDrawer extends StatelessWidget {
  const CustomDrawer({super.key});

  @override
  Widget build(BuildContext context) {
    return Drawer(
      backgroundColor: Colors.white,
      child: ListView(
        padding: EdgeInsets.zero,
        children: <Widget>[
          DrawerHeader(
            decoration: const BoxDecoration(),
            child: CircleAvatar(
              radius: 50,
              backgroundColor: Colors.white,
              child: Image.asset(
                'assets/images/task.png',
                width: 150,
                height: 150,
              ),
            ),
          ),
          ListTile(
            title: const Text('Chat'),
            leading: const Icon(Icons.task, color: Colors.black),
            onTap: () {
              Navigator.push(
                context,
                MaterialPageRoute(
                  builder: (context) => const AiChatPage(),
                ),
              );
            },
          ),
          ListTile(
            title: const Text('Profile 2'),
            leading: const Icon(Icons.person_2_rounded, color: Colors.black),
            onTap: () {
              Navigator.push(
                context,
                MaterialPageRoute(
                  builder: (context) => const UserProfile(),
                ),
              );
            },
          ),
          ListTile(
            title: const Text('Logout'),
            leading: const Icon(Icons.logout, color: Colors.red),
            onTap: () async {
              // Perform logout operations here

              // Navigate to the Login Screen
              Navigator.of(context).pushReplacement(
                MaterialPageRoute(
                  builder: (context) => const RegisterScreen(),
                ),
              );
            },
          ),
        ],
      ),
    );
  }
}

class CustomBottomNavigationBar extends StatelessWidget {
  final int selectedIndex;
  final Function(int) onItemTapped;

  const CustomBottomNavigationBar({
    super.key,
    required this.selectedIndex,
    required this.onItemTapped,
  });

  @override
  Widget build(BuildContext context) {
    return BottomNavigationBar(
      items: const <BottomNavigationBarItem>[
        BottomNavigationBarItem(
          icon: Icon(
            Icons.home,
            color: Colors.black,
          ),
          label: 'Home',
        ),
        BottomNavigationBarItem(
          icon: Icon(
            Icons.add_task_rounded,
            color: Colors.black,
          ),
          label: 'Add',
        ),
        BottomNavigationBarItem(
          icon: Icon(
            Icons.chat,
            color: Colors.black,
          ),
          label: 'Chat',
        ),
      ],
      currentIndex: selectedIndex,
      backgroundColor: Colors.white,
      selectedItemColor: Colors.black,
      onTap: onItemTapped,
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
          return Center(
            child: Padding(
              padding: const EdgeInsets.symmetric(
                horizontal: 16.0,
                vertical: 30.0,
              ),
              child: Skeletonizer(
                child: ListView.builder(
                  itemCount: 4,
                  itemBuilder: (context, index) {
                    return const Card(
                      child: ListTile(
                        title: Text('Item number as title'),
                      ),
                    );
                  },
                ),
              ),
            ),
          );
        } else if (snapshot.hasError) {
          return Padding(
            padding: const EdgeInsets.all(8.0),
            child: Column(
              crossAxisAlignment: CrossAxisAlignment.center,
              mainAxisAlignment: MainAxisAlignment.start,
              children: [
                Lottie.asset(
                  'assets/animation/WOR.json',
                  height: 300,
                  width: 500,
                ),
                Text(
                  'Opps  ${snapshot.error}',
                  textAlign: TextAlign.center,
                  style: const TextStyle(
                    fontSize: 23,
                    fontFamily: 'Cario',
                    fontWeight: FontWeight.w800,
                    color: Colors.black,
                  ),
                ),
              ],
            ),
          );
        } else if (!snapshot.hasData || snapshot.data!.isEmpty) {
          return Column(
            crossAxisAlignment: CrossAxisAlignment.center,
            mainAxisAlignment: MainAxisAlignment.center,
            children: [
              Lottie.asset('assets/animation/internet.json'),
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
                            child: Column(
                              crossAxisAlignment: CrossAxisAlignment.start,
                              mainAxisAlignment: MainAxisAlignment.start,
                              children: [
                                Text(
                                  'Task Id :${snapshot.data![index].id.toString()}',
                                  style: const TextStyle(
                                      fontSize: 16.0, color: Colors.redAccent),
                                ),
                                Text(
                                  'Task title: ${snapshot.data![index].title}',
                                  style: const TextStyle(
                                      fontSize: 16.0, color: Colors.teal),
                                ),
                              ],
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
