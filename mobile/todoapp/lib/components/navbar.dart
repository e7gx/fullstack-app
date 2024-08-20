import 'package:flutter/material.dart';
import 'package:todoapp/auth/login.dart';
import 'package:todoapp/components/reuse.dart';
import 'package:todoapp/screens/add_todo.dart';
import 'package:todoapp/screens/chat/chat.dart';
import 'package:todoapp/screens/dashboard.dart';
import 'package:todoapp/screens/home_screen.dart';
import 'package:todoapp/screens/profile.dart';
import 'package:todoapp/services/shared_preferences_service.dart';

class HomeScreen extends StatefulWidget {
  const HomeScreen({super.key});

  @override
  // ignore: library_private_types_in_public_api
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
    const Dashboard(),
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
          // ListTile(
          //   title: const Text('Chat'),
          //   leading: const Icon(Icons.task, color: Colors.black),
          //   onTap: () {
          //     Navigator.push(
          //       context,
          //       MaterialPageRoute(
          //         builder: (context) => const AiChatPage(),
          //       ),
          //     );
          //   },
          // ),
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
                  builder: (context) => const LoginPage(),
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
            Icons.dashboard,
            color: Colors.black,
          ),
          label: 'Dashboard',
        ),
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
