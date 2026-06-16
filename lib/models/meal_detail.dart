// lib/models/meal_detail.dart

/// Para składnik + miara, np. "Chicken" + "200g"
class Ingredient {
  final String name;
  final String measure;

  const Ingredient({required this.name, required this.measure});
}

class MealDetail {
  final String id;
  final String name;
  final String category;
  final String area;
  final String instructions;
  final String thumbUrl;
  final String? youtubeUrl;
  final String? sourceUrl;
  final List<Ingredient> ingredients;

  const MealDetail({
    required this.id,
    required this.name,
    required this.category,
    required this.area,
    required this.instructions,
    required this.thumbUrl,
    this.youtubeUrl,
    this.sourceUrl,
    required this.ingredients,
  });

  factory MealDetail.fromJson(Map<String, dynamic> json) {
    // API zwraca składniki jako strIngredient1…strIngredient20
    // i miary jako strMeasure1…strMeasure20
    final ingredients = <Ingredient>[];
    for (int i = 1; i <= 20; i++) {
      final name = (json['strIngredient$i'] as String?)?.trim() ?? '';
      final measure = (json['strMeasure$i'] as String?)?.trim() ?? '';
      if (name.isNotEmpty) {
        ingredients.add(Ingredient(name: name, measure: measure));
      }
    }

    return MealDetail(
      id: json['idMeal'] as String,
      name: json['strMeal'] as String,
      category: json['strCategory'] as String? ?? '',
      area: json['strArea'] as String? ?? '',
      instructions: json['strInstructions'] as String? ?? '',
      thumbUrl: json['strMealThumb'] as String,
      youtubeUrl: json['strYoutube'] as String?,
      sourceUrl: json['strSource'] as String?,
      ingredients: ingredients,
    );
  }
}
