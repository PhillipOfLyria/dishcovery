// lib/services/meal_api_service.dart

import '../core/constants/api_constants.dart';
import '../core/network/api_client.dart';
import '../models/meal_category.dart';
import '../models/meal_detail.dart';
import '../models/meal_summary.dart';

class MealApiService {
  final ApiClient _client;

  MealApiService({ApiClient? client}) : _client = client ?? ApiClient();

  /// Pobiera listę wszystkich kategorii (ekran Home)
  Future<List<MealCategory>> getCategories() async {
    final data = await _client.get(ApiConstants.categories);
    final list = data['categories'] as List<dynamic>;
    return list
        .map((e) => MealCategory.fromJson(e as Map<String, dynamic>))
        .toList();
  }

  /// Pobiera listę posiłków dla danej kategorii (ekran MealsList)
  Future<List<MealSummary>> getMealsByCategory(String category) async {
    final data = await _client.get(
      ApiConstants.filterByCategory,
      queryParams: {'c': category},
    );
    final list = data['meals'] as List<dynamic>? ?? [];
    return list
        .map((e) => MealSummary.fromJson(e as Map<String, dynamic>))
        .toList();
  }

  /// Pobiera pełne szczegóły posiłku po ID (ekran MealDetail)
  Future<MealDetail> getMealById(String id) async {
    final data = await _client.get(
      ApiConstants.lookupById,
      queryParams: {'i': id},
    );
    final meals = data['meals'] as List<dynamic>;
    return MealDetail.fromJson(meals.first as Map<String, dynamic>);
  }

  /// Wyszukiwarka po nazwie (SearchBar na ekranie listy)
  Future<List<MealSummary>> searchMeals(String query) async {
    final data = await _client.get(
      ApiConstants.search,
      queryParams: {'s': query},
    );
    final list = data['meals'] as List<dynamic>? ?? [];
    return list
        .map((e) => MealSummary.fromJson(e as Map<String, dynamic>))
        .toList();
  }

  /// Losowy posiłek — przycisk "Surprise me!" (bonus)
  Future<MealDetail> getRandomMeal() async {
    final data = await _client.get(ApiConstants.random);
    final meals = data['meals'] as List<dynamic>;
    return MealDetail.fromJson(meals.first as Map<String, dynamic>);
  }
}
