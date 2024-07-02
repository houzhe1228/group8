import 'package:flutter/material.dart';
import '../models/user.dart';
import '../database_helper.dart';

class UserProfileScreen extends StatefulWidget {
  final int userId;
  final String username;

  UserProfileScreen({required this.userId, required this.username});

  @override
  _UserProfileScreenState createState() => _UserProfileScreenState();
}

class _UserProfileScreenState extends State<UserProfileScreen> {
  User? user;

  @override
  void initState() {
    super.initState();
    loadUser();
  }

  void loadUser() async {
    try {
      final userData = await DatabaseHelper.instance.getUserById(widget.userId);
      setState(() {
        user = User.fromJson(userData);
      });
    } catch (e) {
      print('Error loading user: $e');
    }
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(
        title: Text('User Profile'),
        backgroundColor: Colors.orange,
      ),
      body: Center(
        child: user == null
            ? CircularProgressIndicator()
            : Column(
                children: [
                  Text('Username: ${user!.username}'),
                  Text('Email: ${user!.email}'),
                  Text('Phone: ${user!.phone}'),
                ],
              ),
      ),
    );
  }
}
