// lib/screens/meals_list/meals_list_screen.dart

import 'package:flutter/material.dart';
import '../../models/meal_category.dart';
import '../../models/meal_summary.dart';
import '../../services/analytics_service.dart';
import '../../services/meal_api_service.dart';
import '../meal_detail/meal_detail_screen.dart';
import 'widgets/meal_card.dart';
import 'widgets/meal_shimmer_grid.dart';

class MealsListScreen extends StatefulWidget {
  final MealCategory category;

  const MealsListScreen({super.key, required this.category});

  @override
  State<MealsListScreen> createState() => _MealsListScreenState();
}

class _MealsListScreenState extends State<MealsListScreen> {
  final _apiService = MealApiService();
  final _analytics = AnalyticsService();
  final _searchController = TextEditingController();

  late Future<List<MealSummary>> _mealsFuture;
  String _searchQuery = '';

  @override
  void initState() {
    super.initState();
    _mealsFuture = _apiService.getMealsByCategory(widget.category.name);
  }

  @override
  void dispose() {
    _searchController.dispose();
    super.dispose();
  }

  Future<void> _refresh() async {
    setState(() {
      _searchQuery = '';
      _searchController.clear();
      _mealsFuture = _apiService.getMealsByCategory(widget.category.name);
    });
    await _mealsFuture;
  }

  void _onSearchChanged(String query) {
    setState(() => _searchQuery = query.toLowerCase().trim());
  }

  List<MealSummary> _filterMeals(List<MealSummary> meals) {
    if (_searchQuery.isEmpty) return meals;
    return meals
        .where((m) => m.name.toLowerCase().contains(_searchQuery))
        .toList();
  }

  void _onMealTap(MealSummary meal) {
    _analytics.logMealViewed(meal.id, meal.name);
    Navigator.push(
      context,
      MaterialPageRoute(
        builder: (_) => MealDetailScreen(mealId: meal.id, mealName: meal.name),
      ),
    );
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      backgroundColor: const Color(0xFFFFF8F0),
      appBar: AppBar(
        backgroundColor: const Color(0xFFFFF8F0),
        elevation: 0,
        scrolledUnderElevation: 0,
        leading: IconButton(
          icon: const Icon(Icons.arrow_back_ios_new_rounded, color: Color(0xFF1A1A1A)),
          onPressed: () => Navigator.pop(context),
        ),
        title: Text(
          widget.category.name,
          style: const TextStyle(
            fontSize: 22,
            fontWeight: FontWeight.w800,
            color: Color(0xFF1A1A1A),
            letterSpacing: -0.5,
          ),
        ),
      ),
      body: Column(
        children: [
          // Wyszukiwarka
          Padding(
            padding: const EdgeInsets.fromLTRB(16, 4, 16, 12),
            child: SearchBar(
              controller: _searchController,
              hintText: 'Szukaj przepisu...',
              onChanged: _onSearchChanged,
              leading: const Icon(Icons.search, color: Colors.grey),
              trailing: [
                if (_searchQuery.isNotEmpty)
                  IconButton(
                    icon: const Icon(Icons.clear, color: Colors.grey),
                    onPressed: () {
                      _searchController.clear();
                      _onSearchChanged('');
                    },
                  ),
              ],
              backgroundColor: WidgetStateProperty.all(Colors.white),
              elevation: WidgetStateProperty.all(0),
              side: WidgetStateProperty.all(
                const BorderSide(color: Color(0xFFE0E0E0)),
              ),
              shape: WidgetStateProperty.all(
                RoundedRectangleBorder(borderRadius: BorderRadius.circular(12)),
              ),
            ),
          ),

          // Siatka posiłków
          Expanded(
            child: FutureBuilder<List<MealSummary>>(
              future: _mealsFuture,
              builder: (context, snapshot) {
                if (snapshot.connectionState == ConnectionState.waiting) {
                  return const MealShimmerGrid();
                }
                if (snapshot.hasError) {
                  return _ErrorView(
                    message: snapshot.error.toString(),
                    onRetry: _refresh,
                  );
                }
                final all = snapshot.data ?? [];
                final meals = _filterMeals(all);
                if (meals.isEmpty) {
                  return _EmptyView(isFiltered: _searchQuery.isNotEmpty);
                }
                return RefreshIndicator(
                  color: const Color(0xFFFF6B35),
                  onRefresh: _refresh,
                  child: GridView.builder(
                    padding: const EdgeInsets.fromLTRB(16, 0, 16, 24),
                    gridDelegate: const SliverGridDelegateWithFixedCrossAxisCount(
                      crossAxisCount: 2,
                      crossAxisSpacing: 12,
                      mainAxisSpacing: 12,
                      childAspectRatio: 0.85,
                    ),
                    itemCount: meals.length,
                    itemBuilder: (context, index) => MealCard(
                      meal: meals[index],
                      onTap: () => _onMealTap(meals[index]),
                    ),
                  ),
                );
              },
            ),
          ),
        ],
      ),
    );
  }
}

class _ErrorView extends StatelessWidget {
  final String message;
  final VoidCallback onRetry;

  const _ErrorView({required this.message, required this.onRetry});

  @override
  Widget build(BuildContext context) {
    return Center(
      child: Padding(
        padding: const EdgeInsets.all(32),
        child: Column(
          mainAxisSize: MainAxisSize.min,
          children: [
            const Icon(Icons.wifi_off_rounded, size: 64, color: Colors.grey),
            const SizedBox(height: 16),
            const Text('Coś poszło nie tak',
                style: TextStyle(fontSize: 18, fontWeight: FontWeight.w700)),
            const SizedBox(height: 8),
            Text(message,
                textAlign: TextAlign.center,
                style: const TextStyle(color: Colors.grey, fontSize: 13)),
            const SizedBox(height: 24),
            FilledButton.icon(
              onPressed: onRetry,
              style: FilledButton.styleFrom(backgroundColor: const Color(0xFFFF6B35)),
              icon: const Icon(Icons.refresh),
              label: const Text('Spróbuj ponownie'),
            ),
          ],
        ),
      ),
    );
  }
}

class _EmptyView extends StatelessWidget {
  final bool isFiltered;
  const _EmptyView({required this.isFiltered});

  @override
  Widget build(BuildContext context) {
    return Center(
      child: Column(
        mainAxisSize: MainAxisSize.min,
        children: [
          const Icon(Icons.search_off_rounded, size: 48, color: Colors.grey),
          const SizedBox(height: 12),
          Text(
            isFiltered ? 'Brak wyników dla tej frazy' : 'Brak posiłków w tej kategorii',
            style: const TextStyle(color: Colors.grey, fontSize: 15),
          ),
        ],
      ),
    );
  }
}
