// lib/services/favorites_service.dart
// WERSJA TYMCZASOWA — przechowuje ulubione w pamięci (bez Hive)
// Hive podepniemy gdy dodamy build_runner

import '../models/meal_favorite.dart';

class FavoritesService {
  // Mapa id -> MealFavorite (w pamięci aplikacji)
  final Map<String, MealFavorite> _favorites = {};

  Future<void> addFavorite(MealFavorite meal) async {
    _favorites[meal.id] = meal;
  }

  Future<void> removeFavorite(String id) async {
    _favorites.remove(id);
  }

  bool isFavorite(String id) => _favorites.containsKey(id);

  List<MealFavorite> getFavorites() => _favorites.values.toList();
}
