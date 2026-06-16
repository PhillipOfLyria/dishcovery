// lib/services/analytics_service.dart
// WERSJA TYMCZASOWA — logi tylko w konsoli, bez Firebase
// Docelowo podepniemy Firebase Analytics

class AnalyticsService {
  Future<void> logCategorySelected(String categoryName) async {
    print('[Analytics] category_selected: $categoryName');
  }

  Future<void> logMealViewed(String mealId, String mealName) async {
    print('[Analytics] meal_viewed: $mealName ($mealId)');
  }

  Future<void> logFavoriteToggled({
    required String mealId,
    required String mealName,
    required bool added,
  }) async {
    print('[Analytics] favorite_toggled: $mealName -> ${added ? 'added' : 'removed'}');
  }
}
