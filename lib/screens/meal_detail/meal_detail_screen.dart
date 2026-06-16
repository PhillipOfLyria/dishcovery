// lib/screens/meal_detail/meal_detail_screen.dart

import 'package:cached_network_image/cached_network_image.dart';
import 'package:flutter/material.dart';
import '../../models/meal_detail.dart';
import '../../models/meal_favorite.dart';
import '../../services/analytics_service.dart';
import '../../services/favorites_service.dart';
import '../../services/meal_api_service.dart';
import 'widgets/ingredient_tile.dart';
import 'widgets/section_header.dart';

class MealDetailScreen extends StatefulWidget {
  final String mealId;
  final String mealName;

  const MealDetailScreen({
    super.key,
    required this.mealId,
    required this.mealName,
  });

  @override
  State<MealDetailScreen> createState() => _MealDetailScreenState();
}

class _MealDetailScreenState extends State<MealDetailScreen> {
  final _apiService = MealApiService();
  final _favoritesService = FavoritesService();
  final _analytics = AnalyticsService();

  late Future<MealDetail> _mealFuture;
  bool _isFavorite = false;

  @override
  void initState() {
    super.initState();
    _mealFuture = _apiService.getMealById(widget.mealId);
    _isFavorite = _favoritesService.isFavorite(widget.mealId);
  }

  Future<void> _toggleFavorite(MealDetail meal) async {
    final adding = !_isFavorite;
    if (adding) {
      await _favoritesService.addFavorite(MealFavorite(
        id: meal.id,
        name: meal.name,
        thumbUrl: meal.thumbUrl,
        category: meal.category,
      ));
    } else {
      await _favoritesService.removeFavorite(meal.id);
    }

    // Firebase Analytics — event 3
    _analytics.logFavoriteToggled(
      mealId: meal.id,
      mealName: meal.name,
      added: adding,
    );

    setState(() => _isFavorite = adding);

    if (mounted) {
      ScaffoldMessenger.of(context).showSnackBar(
        SnackBar(
          content: Text(adding ? 'Dodano do ulubionych!' : 'Usunięto z ulubionych'),
          backgroundColor: const Color(0xFFFF6B35),
          behavior: SnackBarBehavior.floating,
          shape: RoundedRectangleBorder(borderRadius: BorderRadius.circular(10)),
          duration: const Duration(seconds: 2),
        ),
      );
    }
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      backgroundColor: const Color(0xFFFFF8F0),
      body: FutureBuilder<MealDetail>(
        future: _mealFuture,
        builder: (context, snapshot) {
          // ── Ładowanie ──────────────────────────────────
          if (snapshot.connectionState == ConnectionState.waiting) {
            return const Center(
              child: CircularProgressIndicator(color: Color(0xFFFF6B35)),
            );
          }

          // ── Błąd ───────────────────────────────────────
          if (snapshot.hasError) {
            return Center(
              child: Padding(
                padding: const EdgeInsets.all(32),
                child: Column(
                  mainAxisSize: MainAxisSize.min,
                  children: [
                    const Icon(Icons.wifi_off_rounded, size: 64, color: Colors.grey),
                    const SizedBox(height: 16),
                    const Text('Nie udało się załadować przepisu',
                        style: TextStyle(fontSize: 16, fontWeight: FontWeight.w600)),
                    const SizedBox(height: 24),
                    FilledButton.icon(
                      onPressed: () => setState(() {
                        _mealFuture = _apiService.getMealById(widget.mealId);
                      }),
                      style: FilledButton.styleFrom(
                          backgroundColor: const Color(0xFFFF6B35)),
                      icon: const Icon(Icons.refresh),
                      label: const Text('Spróbuj ponownie'),
                    ),
                  ],
                ),
              ),
            );
          }

          final meal = snapshot.data!;

          return CustomScrollView(
            slivers: [
              // ── Zdjęcie + AppBar ──────────────────────
              SliverAppBar(
                expandedHeight: 300,
                pinned: true,
                backgroundColor: const Color(0xFFFFF8F0),
                leading: GestureDetector(
                  onTap: () => Navigator.pop(context),
                  child: Container(
                    margin: const EdgeInsets.all(8),
                    decoration: BoxDecoration(
                      color: Colors.white.withOpacity(0.9),
                      shape: BoxShape.circle,
                    ),
                    child: const Icon(Icons.arrow_back_ios_new_rounded,
                        color: Color(0xFF1A1A1A), size: 18),
                  ),
                ),
                actions: [
                  // Przycisk ulubionych
                  GestureDetector(
                    onTap: () => _toggleFavorite(meal),
                    child: Container(
                      margin: const EdgeInsets.all(8),
                      padding: const EdgeInsets.all(8),
                      decoration: BoxDecoration(
                        color: Colors.white.withOpacity(0.9),
                        shape: BoxShape.circle,
                      ),
                      child: Icon(
                        _isFavorite ? Icons.favorite : Icons.favorite_border,
                        color: _isFavorite ? Colors.red : const Color(0xFF1A1A1A),
                        size: 22,
                      ),
                    ),
                  ),
                ],
                flexibleSpace: FlexibleSpaceBar(
                  background: CachedNetworkImage(
                    imageUrl: meal.thumbUrl,
                    fit: BoxFit.cover,
                    placeholder: (_, __) =>
                        Container(color: Colors.grey.shade200),
                    errorWidget: (_, __, ___) =>
                        Container(color: Colors.grey.shade300),
                  ),
                ),
              ),

              // ── Treść przepisu ────────────────────────
              SliverToBoxAdapter(
                child: Padding(
                  padding: const EdgeInsets.all(20),
                  child: Column(
                    crossAxisAlignment: CrossAxisAlignment.start,
                    children: [
                      // Nazwa
                      Text(
                        meal.name,
                        style: const TextStyle(
                          fontSize: 26,
                          fontWeight: FontWeight.w800,
                          color: Color(0xFF1A1A1A),
                          letterSpacing: -0.5,
                          height: 1.2,
                        ),
                      ),
                      const SizedBox(height: 10),

                      // Tagi: kategoria + kuchnia
                      Wrap(
                        spacing: 8,
                        children: [
                          _Tag(label: meal.category, icon: Icons.category_outlined),
                          _Tag(label: meal.area, icon: Icons.public_outlined),
                        ],
                      ),
                      const SizedBox(height: 28),

                      // Składniki
                      const SectionHeader(title: 'Składniki'),
                      ...meal.ingredients
                          .map((i) => IngredientTile(ingredient: i)),
                      const SizedBox(height: 28),

                      // Instrukcja
                      const SectionHeader(title: 'Przygotowanie'),
                      Text(
                        meal.instructions,
                        style: const TextStyle(
                          fontSize: 14,
                          color: Color(0xFF444444),
                          height: 1.7,
                        ),
                      ),
                      const SizedBox(height: 40),
                    ],
                  ),
                ),
              ),
            ],
          );
        },
      ),
    );
  }
}

// ── Tag (kategoria / kuchnia) ──────────────────────────────

class _Tag extends StatelessWidget {
  final String label;
  final IconData icon;

  const _Tag({required this.label, required this.icon});

  @override
  Widget build(BuildContext context) {
    return Container(
      padding: const EdgeInsets.symmetric(horizontal: 10, vertical: 5),
      decoration: BoxDecoration(
        color: const Color(0xFFFF6B35).withOpacity(0.1),
        borderRadius: BorderRadius.circular(20),
      ),
      child: Row(
        mainAxisSize: MainAxisSize.min,
        children: [
          Icon(icon, size: 13, color: const Color(0xFFFF6B35)),
          const SizedBox(width: 5),
          Text(
            label,
            style: const TextStyle(
              fontSize: 12,
              fontWeight: FontWeight.w600,
              color: Color(0xFFFF6B35),
            ),
          ),
        ],
      ),
    );
  }
}
