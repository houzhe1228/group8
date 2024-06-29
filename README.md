import 'package:flutter/material.dart';
import 'screens/home_screen.dart';

void main() {
runApp(RecipeMealPlanningApp());
}

class RecipeMealPlanningApp extends StatelessWidget {
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
