import 'dart:convert';

import 'package:google_generative_ai/google_generative_ai.dart';

class Recipe {
  Recipe({
    required this.title,
    required this.id,
    required this.description,
    required this.ingredients,
    required this.instructions,
    required this.cuisine,
    required this.allergens,
    required this.servings,
    required this.nutritionInformation,
    this.rating = -1,
  });

  factory Recipe.fromGeneratedContent(GenerateContentResponse content) {
    /// failures should be handled when the response is received
    assert(content.text != null, 'content.text is null');

    final validJson = cleanJson(content.text!);
    print(validJson);
    final json = jsonDecode(validJson) as Map<String, dynamic>;

    print(json);

    return Recipe(
      id: json['id'] as String,
      title: json['title'] as String,
      ingredients: json['ingredients'] is List
          ? (json['ingredients'] as List).map((i) => i.toString()).toList()
          : [],
      instructions: json['instructions'] is List
          ? (json['instructions'] as List).map((i) => i.toString()).toList()
          : [],
      nutritionInformation:
          json['nutritionInformation'] as Map<String, dynamic>,
      allergens: json['allergens'] is List
          ? (json['allergens'] as List).map((i) => i.toString()).toList()
          : [],
      cuisine: json['cuisine'] as String,
      servings: json['servings'] as String,
      description: json['description'] as String,
    );
  }

  final String id;
  final String title;
  final String description;
  final List<String> ingredients;
  final List<String> instructions;
  final String cuisine;
  final List<String> allergens;
  final String servings;
  final Map<String, dynamic> nutritionInformation;
  int rating;
}

String cleanJson(String maybeInvalidJson) {
  if (maybeInvalidJson.contains('```')) {
    final withoutLeading = maybeInvalidJson.split('```json').last;
    final withoutTrailing = withoutLeading.split('```').first;
    return withoutTrailing;
  }
  return maybeInvalidJson;
}
