// lib/services/favorites_service.dart
// Singleton — wszystkie ekrany dzielą tę samą instancję,
// dzięki czemu ulubione zapisane na jednym ekranie są widoczne na innych.

import '../models/meal_favorite.dart';

class FavoritesService {
  FavoritesService._internal();
  static final FavoritesService _instance = FavoritesService._internal();
  factory FavoritesService() => _instance;

  // Mapa id -> MealFavorite (wspólna dla całej aplikacji)
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
