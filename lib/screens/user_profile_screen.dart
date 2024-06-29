import 'package:flutter/material.dart';

class UserProfileScreen extends StatelessWidget {
  final String username;

  UserProfileScreen({required this.username});

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(
        title: Text('User Profile'),
        backgroundColor: Colors.orange,
      ),
      body: Center(
        child: Text('Username: $username'),
      ),
    );
  }
}
