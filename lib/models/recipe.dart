import 'package:html/parser.dart' show parse;

class Recipe {
  final String title;
  final String instructions;
  final List<String> ingredients;

  Recipe({
    required this.title,
    required this.instructions,
    required this.ingredients,
  });

  factory Recipe.fromJson(Map<String, dynamic> json) {
    // Extract ingredients
    List<String> ingredientsList = [];
    if (json['extendedIngredients'] != null) {
      json['extendedIngredients'].forEach((ingredient) {
        ingredientsList.add(ingredient['original']);
      });
    }

    // Parse and clean instructions
    String cleanInstructions = parse(json['instructions'] ?? 'No instructions available.').documentElement?.text ?? 'No instructions available.';

    return Recipe(
      title: json['title'] ?? 'No title',
      instructions: cleanInstructions,
      ingredients: ingredientsList,
    );
  }
}
