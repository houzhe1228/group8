import 'dart:convert';
import 'package:http/http.dart' as http;
import '../models/recipe.dart';

class ApiService {
  static const String _apiKey = 'a5bd33504cc945828d029510846a78a7'; // Replace with your actual API key
  static const String _baseUrl = 'https://api.spoonacular.com';

  // Search recipes and fetch detailed information for each recipe
  static Future<List<Recipe>> searchRecipes(String query) async {
    final response = await http.get(Uri.parse('$_baseUrl/recipes/complexSearch?query=$query&number=10&apiKey=$_apiKey'));

    if (response.statusCode == 200) {
      final List<dynamic> data = json.decode(response.body)['results'];
      List<Recipe> recipes = [];

      for (var recipeJson in data) {
        final recipeId = recipeJson['id'];
        final recipeDetail = await fetchRecipeDetail(recipeId);
        if (recipeDetail != null) {
          recipes.add(recipeDetail);
        }
      }

      return recipes;
    } else {
      throw Exception('Failed to load recipes');
    }
  }

  // Fetch recipe details using recipe ID
  static Future<Recipe?> fetchRecipeDetail(int id) async {
    final response = await http.get(Uri.parse('$_baseUrl/recipes/$id/information?apiKey=$_apiKey'));

    if (response.statusCode == 200) {
      final Map<String, dynamic> data = json.decode(response.body);
      return Recipe.fromJson(data);
    } else {
      return null;
    }
  }
}
