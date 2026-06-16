// lib/services/analytics_service.dart

import 'package:firebase_analytics/firebase_analytics.dart';

class AnalyticsService {
  final FirebaseAnalytics _analytics = FirebaseAnalytics.instance;

  // Event 1 — wybór kategorii
  Future<void> logCategorySelected(String categoryName) async {
    await _analytics.logEvent(
      name: 'category_selected',
      parameters: {'category_name': categoryName},
    );
  }

  // Event 2 — wejście w szczegóły przepisu
  Future<void> logMealViewed(String mealId, String mealName) async {
    await _analytics.logEvent(
      name: 'meal_viewed',
      parameters: {'meal_id': mealId, 'meal_name': mealName},
    );
  }

  // Event 3 — dodanie/usunięcie z ulubionych
  Future<void> logFavoriteToggled({
    required String mealId,
    required String mealName,
    required bool added,
  }) async {
    await _analytics.logEvent(
      name: 'favorite_toggled',
      parameters: {
        'meal_id': mealId,
        'meal_name': mealName,
        'action': added ? 'added' : 'removed',
      },
    );
  }
}
