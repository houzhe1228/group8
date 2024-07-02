import 'package:flutter/material.dart';
import '../services/api_service.dart';
import '../models/recipe.dart'; // Ensure this import is correct
import '../widgets/recipe_card.dart';
import 'recipe_detail_screen.dart'; // Ensure RecipeDetailScreen import is correct

class SearchScreen extends StatefulWidget {
  @override
  _SearchScreenState createState() => _SearchScreenState();
}

class _SearchScreenState extends State<SearchScreen> {
  List<Recipe> _recipes = [];
  bool _isLoading = false;
  String _errorMessage = '';

  Future<void> _searchRecipes(String query) async {
    setState(() {
      _isLoading = true;
      _errorMessage = '';
    });

    try {
      final recipes = await ApiService.searchRecipes(query);
      setState(() {
        _recipes = recipes;
      });
    } catch (e) {
      setState(() {
        _errorMessage = 'Failed to load recipes: $e';
      });
    } finally {
      setState(() {
        _isLoading = false;
      });
    }
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(
        title: Text('Search Recipes'),
      ),
      body: Column(
        children: [
          Padding(
            padding: const EdgeInsets.all(8.0),
            child: TextField(
              decoration: InputDecoration(
                labelText: 'Search',
                border: OutlineInputBorder(),
              ),
              onSubmitted: _searchRecipes,
            ),
          ),
          _isLoading
              ? Center(child: CircularProgressIndicator())
              : _errorMessage.isNotEmpty
              ? Center(child: Text(_errorMessage))
              : Expanded(
            child: ListView.builder(
              itemCount: _recipes.length,
              itemBuilder: (context, index) {
                return RecipeCard(
                  recipe: _recipes[index],
                  onTap: () {
                    Navigator.push(
                      context,
                      MaterialPageRoute(
                        builder: (context) => RecipeDetailScreen(recipe: _recipes[index]),
                      ),
                    );
                  },
                );
              },
            ),
          ),
        ],
      ),
    );
  }
}
