// lib/models/meal_category.dart

class MealCategory {
  final String id;
  final String name;
  final String thumbUrl;
  final String description;

  const MealCategory({
    required this.id,
    required this.name,
    required this.thumbUrl,
    required this.description,
  });

  factory MealCategory.fromJson(Map<String, dynamic> json) {
    return MealCategory(
      id: json['idCategory'] as String,
      name: json['strCategory'] as String,
      thumbUrl: json['strCategoryThumb'] as String,
      description: json['strCategoryDescription'] as String? ?? '',
    );
  }
}
