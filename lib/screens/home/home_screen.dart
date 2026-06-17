// lib/screens/home/home_screen.dart

import 'package:flutter/material.dart';
import '../../models/meal_category.dart';
import '../../services/analytics_service.dart';
import '../../services/meal_api_service.dart';
import '../meal_detail/meal_detail_screen.dart';
import '../meals_list/meals_list_screen.dart';
import 'widgets/category_card.dart';
import 'widgets/category_shimmer_grid.dart';

class HomeScreen extends StatefulWidget {
  const HomeScreen({super.key});

  @override
  State<HomeScreen> createState() => _HomeScreenState();
}

class _HomeScreenState extends State<HomeScreen> {
  final _apiService = MealApiService();
  final _analytics = AnalyticsService();

  late Future<List<MealCategory>> _categoriesFuture;

  @override
  void initState() {
    super.initState();
    _categoriesFuture = _apiService.getCategories();
  }

  /// Pull-to-refresh — tworzy nowy Future żeby odświeżyć dane
  Future<void> _refresh() async {
    setState(() {
      _categoriesFuture = _apiService.getCategories();
    });
    await _categoriesFuture;
  }

  void _onCategoryTap(MealCategory category) {
    // Firebase Analytics — event 1
    _analytics.logCategorySelected(category.name);

    Navigator.push(
      context,
      MaterialPageRoute(
        builder: (_) => MealsListScreen(category: category),
      ),
    );
  }

  /// Losowy posiłek — przycisk z ikoną kostki w AppBar
  Future<void> _onRandomMealTap() async {
    try {
      final meal = await _apiService.getRandomMeal();
      if (!mounted) return;

      Navigator.push(
        context,
        MaterialPageRoute(
          builder: (_) => MealDetailScreen(mealId: meal.id, mealName: meal.name),
        ),
      );
    } catch (e) {
      if (!mounted) return;
      ScaffoldMessenger.of(context).showSnackBar(
        SnackBar(
          content: const Text('Nie udało się pobrać losowego przepisu'),
          backgroundColor: Colors.red.shade400,
          behavior: SnackBarBehavior.floating,
        ),
      );
    }
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      backgroundColor: const Color(0xFFFFF8F0), // ciepłe kremowe tło

      // ── AppBar ───────────────────────────────────────────
      appBar: AppBar(
        backgroundColor: const Color(0xFFFFF8F0),
        elevation: 0,
        scrolledUnderElevation: 0,
        title: RichText(
          text: const TextSpan(
            children: [
              TextSpan(
                text: 'Dish',
                style: TextStyle(
                  fontSize: 26,
                  fontWeight: FontWeight.w800,
                  color: Color(0xFF1A1A1A),
                  letterSpacing: -0.5,
                ),
              ),
              TextSpan(
                text: 'covery',
                style: TextStyle(
                  fontSize: 26,
                  fontWeight: FontWeight.w800,
                  color: Color(0xFFFF6B35), // akcent pomarańczowy
                  letterSpacing: -0.5,
                ),
              ),
            ],
          ),
        ),
        actions: [
          // Przycisk losowego posiłku (bonus)
          IconButton(
            icon: const Icon(Icons.casino_outlined, color: Color(0xFF1A1A1A)),
            tooltip: 'Losowy przepis',
            onPressed: _onRandomMealTap,
          ),
        ],
      ),

      // ── Body ─────────────────────────────────────────────
      body: Column(
        crossAxisAlignment: CrossAxisAlignment.start,
        children: [
          // Podtytuł
          const Padding(
            padding: EdgeInsets.symmetric(horizontal: 16, vertical: 4),
            child: Text(
              'Co dziś gotujesz?',
              style: TextStyle(
                fontSize: 14,
                color: Color(0xFF888888),
                fontWeight: FontWeight.w400,
              ),
            ),
          ),

          // Siatka kategorii
          Expanded(
            child: FutureBuilder<List<MealCategory>>(
              future: _categoriesFuture,
              builder: (context, snapshot) {
                // ── Ładowanie ────────────────────────────
                if (snapshot.connectionState == ConnectionState.waiting) {
                  return const CategoryShimmerGrid();
                }

                // ── Błąd ─────────────────────────────────
                if (snapshot.hasError) {
                  return _ErrorView(
                    message: snapshot.error.toString(),
                    onRetry: _refresh,
                  );
                }

                // ── Brak danych ──────────────────────────
                final categories = snapshot.data ?? [];
                if (categories.isEmpty) {
                  return const _EmptyView();
                }

                // ── Siatka ───────────────────────────────
                return RefreshIndicator(
                  color: const Color(0xFFFF6B35),
                  onRefresh: _refresh,
                  child: GridView.builder(
                    padding: const EdgeInsets.fromLTRB(16, 8, 16, 24),
                    gridDelegate:
                        const SliverGridDelegateWithFixedCrossAxisCount(
                      crossAxisCount: 2,
                      crossAxisSpacing: 12,
                      mainAxisSpacing: 12,
                      childAspectRatio: 1.0,
                    ),
                    itemCount: categories.length,
                    itemBuilder: (context, index) => CategoryCard(
                      category: categories[index],
                      onTap: () => _onCategoryTap(categories[index]),
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

// ── Widżety pomocnicze ─────────────────────────────────────

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
            const Text(
              'Coś poszło nie tak',
              style: TextStyle(fontSize: 18, fontWeight: FontWeight.w700),
            ),
            const SizedBox(height: 8),
            Text(
              message,
              textAlign: TextAlign.center,
              style: const TextStyle(color: Colors.grey, fontSize: 13),
            ),
            const SizedBox(height: 24),
            FilledButton.icon(
              onPressed: onRetry,
              style: FilledButton.styleFrom(
                backgroundColor: const Color(0xFFFF6B35),
              ),
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
  const _EmptyView();

  @override
  Widget build(BuildContext context) {
    return const Center(
      child: Text(
        'Brak kategorii do wyświetlenia.',
        style: TextStyle(color: Colors.grey),
      ),
    );
  }
}
