// lib/screens/favorites/favorites_screen.dart

import 'package:cached_network_image/cached_network_image.dart';
import 'package:flutter/material.dart';
import '../../models/meal_favorite.dart';
import '../../services/favorites_service.dart';
import '../meal_detail/meal_detail_screen.dart';

class FavoritesScreen extends StatefulWidget {
  const FavoritesScreen({super.key});

  @override
  State<FavoritesScreen> createState() => _FavoritesScreenState();
}

class _FavoritesScreenState extends State<FavoritesScreen> {
  final _favoritesService = FavoritesService();

  void _removeFavorite(String id) async {
    await _favoritesService.removeFavorite(id);
    setState(() {});

    if (mounted) {
      ScaffoldMessenger.of(context).showSnackBar(
        SnackBar(
          content: const Text('Usunięto z ulubionych'),
          backgroundColor: const Color(0xFFFF6B35),
          behavior: SnackBarBehavior.floating,
          shape:
              RoundedRectangleBorder(borderRadius: BorderRadius.circular(10)),
          duration: const Duration(seconds: 2),
        ),
      );
    }
  }

  @override
  Widget build(BuildContext context) {
    final favorites = _favoritesService.getFavorites();

    return Scaffold(
      backgroundColor: const Color(0xFFFFF8F0),
      appBar: AppBar(
        backgroundColor: const Color(0xFFFFF8F0),
        elevation: 0,
        scrolledUnderElevation: 0,
        title: const Text(
          'Ulubione',
          style: TextStyle(
            fontSize: 22,
            fontWeight: FontWeight.w800,
            color: Color(0xFF1A1A1A),
            letterSpacing: -0.5,
          ),
        ),
      ),

      // ── Pusta lista ────────────────────────────────────
      body: favorites.isEmpty
          ? _EmptyFavorites()
          : ListView.separated(
              padding: const EdgeInsets.fromLTRB(16, 8, 16, 24),
              itemCount: favorites.length,
              separatorBuilder: (_, __) => const SizedBox(height: 12),
              itemBuilder: (context, index) => _FavoriteCard(
                meal: favorites[index],
                onTap: () async {
                  await Navigator.push(
                    context,
                    MaterialPageRoute(
                      builder: (_) => MealDetailScreen(
                        mealId: favorites[index].id,
                        mealName: favorites[index].name,
                      ),
                    ),
                  );
                  // Odśwież listę po powrocie (user mógł usunąć z ulubionych)
                  setState(() {});
                },
                onRemove: () => _removeFavorite(favorites[index].id),
              ),
            ),
    );
  }
}

// ── Karta ulubionego przepisu ──────────────────────────────

class _FavoriteCard extends StatelessWidget {
  final MealFavorite meal;
  final VoidCallback onTap;
  final VoidCallback onRemove;

  const _FavoriteCard({
    required this.meal,
    required this.onTap,
    required this.onRemove,
  });

  @override
  Widget build(BuildContext context) {
    return GestureDetector(
      onTap: onTap,
      child: Container(
        decoration: BoxDecoration(
          color: Colors.white,
          borderRadius: BorderRadius.circular(16),
          boxShadow: [
            BoxShadow(
              color: Colors.black.withOpacity(0.06),
              blurRadius: 12,
              offset: const Offset(0, 4),
            ),
          ],
        ),
        child: Row(
          children: [
            // Zdjęcie
            ClipRRect(
              borderRadius:
                  const BorderRadius.horizontal(left: Radius.circular(16)),
              child: CachedNetworkImage(
                imageUrl: meal.thumbUrl,
                width: 100,
                height: 90,
                fit: BoxFit.cover,
                placeholder: (_, __) =>
                    Container(color: Colors.grey.shade200, width: 100, height: 90),
                errorWidget: (_, __, ___) =>
                    Container(color: Colors.grey.shade300, width: 100, height: 90),
              ),
            ),

            const SizedBox(width: 14),

            // Nazwa + kategoria
            Expanded(
              child: Column(
                crossAxisAlignment: CrossAxisAlignment.start,
                children: [
                  Text(
                    meal.name,
                    maxLines: 2,
                    overflow: TextOverflow.ellipsis,
                    style: const TextStyle(
                      fontSize: 15,
                      fontWeight: FontWeight.w700,
                      color: Color(0xFF1A1A1A),
                      height: 1.3,
                    ),
                  ),
                  const SizedBox(height: 4),
                  Text(
                    meal.category,
                    style: const TextStyle(
                      fontSize: 12,
                      color: Color(0xFFFF6B35),
                      fontWeight: FontWeight.w500,
                    ),
                  ),
                ],
              ),
            ),

            // Przycisk usuń
            IconButton(
              icon: const Icon(Icons.favorite, color: Colors.red, size: 22),
              onPressed: onRemove,
              tooltip: 'Usuń z ulubionych',
            ),
          ],
        ),
      ),
    );
  }
}

// ── Pusty stan ─────────────────────────────────────────────

class _EmptyFavorites extends StatelessWidget {
  @override
  Widget build(BuildContext context) {
    return Center(
      child: Column(
        mainAxisSize: MainAxisSize.min,
        children: [
          Icon(
            Icons.favorite_border_rounded,
            size: 72,
            color: Colors.grey.shade300,
          ),
          const SizedBox(height: 16),
          const Text(
            'Brak ulubionych przepisów',
            style: TextStyle(
              fontSize: 17,
              fontWeight: FontWeight.w600,
              color: Color(0xFF888888),
            ),
          ),
          const SizedBox(height: 8),
          const Text(
            'Kliknij ❤️ na przepisie żeby go zapisać',
            style: TextStyle(fontSize: 13, color: Colors.grey),
          ),
        ],
      ),
    );
  }
}
