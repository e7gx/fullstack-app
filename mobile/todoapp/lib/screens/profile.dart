import 'package:flutter/material.dart';
import 'package:todoapp/services/shared_preferences_service.dart';

class UserProfile extends StatefulWidget {
  const UserProfile({super.key});

  @override
  _UserProfileState createState() => _UserProfileState();
}

class _UserProfileState extends State<UserProfile> {
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

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(
        title: const Text('Profile'),
      ),
      body: Center(
        child: Text(
          '👋 أهلا وسهلا بك, $_firstName',
          textAlign: TextAlign.end,
          style: const TextStyle(
            fontFamily: 'Cario',
            color: Colors.black,
          ),
        ),
      ),
    );
  }
}
