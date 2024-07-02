// File: screens/recipe_overview_screen.dart
import 'package:flutter/material.dart';
import '../models/recipe.dart';
import '../database_helper.dart';
import '../widgets/recipe_card.dart';
import 'recipe_detail_screen.dart';

class RecipeOverviewScreen extends StatefulWidget {
  @override
  _RecipeOverviewScreenState createState() => _RecipeOverviewScreenState();
}

class _RecipeOverviewScreenState extends State<RecipeOverviewScreen> {
  List<Recipe> recipes = [];

  @override
  void initState() {
    super.initState();
    loadRecipes();
  }

  void loadRecipes() {
    DatabaseHelper.instance.getRecipes().then((loadedRecipes) {
      setState(() {
        recipes = loadedRecipes;
      });
    }).catchError((error) {
      print("Error loading recipes: $error");
    });
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(
        title: Text('Recipe List'),
      ),
      body: ListView.builder(
        itemCount: recipes.length,
        itemBuilder: (context, index) {
          return RecipeCard(
            recipe: recipes[index],
            onTap: () {
              Navigator.push(
                context,
                MaterialPageRoute(
                  builder: (context) => RecipeDetailScreen(recipe: recipes[index]),
                ),
              );
            },
          );
        },
      ),
    );
  }
}
