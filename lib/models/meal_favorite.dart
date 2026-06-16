// lib/models/meal_favorite.dart
// WERSJA TYMCZASOWA — bez adnotacji Hive (bez build_runner)
// Hive TypeAdapter dodamy później

class MealFavorite {
  final String id;
  final String name;
  final String thumbUrl;
  final String category;

  MealFavorite({
    required this.id,
    required this.name,
    required this.thumbUrl,
    required this.category,
  });

  // Zapis do mapy (dla Hive lub SharedPreferences)
  Map<String, dynamic> toMap() => {
        'id': id,
        'name': name,
        'thumbUrl': thumbUrl,
        'category': category,
      };

  factory MealFavorite.fromMap(Map<String, dynamic> map) => MealFavorite(
        id: map['id'] as String,
        name: map['name'] as String,
        thumbUrl: map['thumbUrl'] as String,
        category: map['category'] as String,
      );
}
