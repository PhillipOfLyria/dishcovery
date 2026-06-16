// lib/models/meal_summary.dart

class MealSummary {
  final String id;
  final String name;
  final String thumbUrl;

  const MealSummary({
    required this.id,
    required this.name,
    required this.thumbUrl,
  });

  factory MealSummary.fromJson(Map<String, dynamic> json) {
    return MealSummary(
      id: json['idMeal'] as String,
      name: json['strMeal'] as String,
      thumbUrl: json['strMealThumb'] as String,
    );
  }
}
