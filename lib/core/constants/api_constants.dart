// lib/core/constants/api_constants.dart

class ApiConstants {
  ApiConstants._();

  static const String _base = 'https://www.themealdb.com/api/json/v1/1';

  static const String categories       = '$_base/categories.php';
  static const String filterByCategory = '$_base/filter.php';
  static const String lookupById       = '$_base/lookup.php';
  static const String search           = '$_base/search.php';
  static const String random           = '$_base/random.php';

  static const String favoritesBox = 'favorites';
}
