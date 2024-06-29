import 'package:flutter/material.dart';
import '../models/recipe.dart'; // Ensure this import is correct

class RecipeDetailScreen extends StatelessWidget {
  final Recipe recipe;

  RecipeDetailScreen({required this.recipe});

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(
        title: Text(recipe.title),
      ),
      body: Padding(
        padding: const EdgeInsets.all(16.0),
        child: SingleChildScrollView(
          child: Column(
            crossAxisAlignment: CrossAxisAlignment.start,
            children: <Widget>[
              Text(
                recipe.title,
                style: TextStyle(fontSize: 24.0, fontWeight: FontWeight.bold),
              ),
              SizedBox(height: 16.0),
              Text(
                'Ingredients',
                style: TextStyle(fontSize: 20.0, fontWeight: FontWeight.bold),
              ),
              ...recipe.ingredients.map((ingredient) => Text(ingredient)).toList(),
              SizedBox(height: 16.0),
              Text(
                'Instructions',
                style: TextStyle(fontSize: 20.0, fontWeight: FontWeight.bold),
              ),
              Text(
                recipe.instructions,
                style: TextStyle(fontSize: 16.0),
              ),
            ],
          ),
        ),
      ),
    );
  }
}
