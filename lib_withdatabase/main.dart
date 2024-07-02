import 'package:flutter/material.dart';
import 'screens/home_screen.dart';
import 'database_helper.dart'; // 确保导入 DatabaseHelper

void main() async {
  WidgetsFlutterBinding.ensureInitialized(); // 确保 Flutter 环境已初始化
  await DatabaseHelper.instance.database; // 初始化数据库
  runApp(MyApp());
}

class MyApp extends StatelessWidget {
  @override
  Widget build(BuildContext context) {
    return MaterialApp(
      title: 'Recipe and Meal Planning App',
      theme: ThemeData(
        primarySwatch: Colors.blue,
      ),
      home: HomeScreen(),
    );
  }
}

