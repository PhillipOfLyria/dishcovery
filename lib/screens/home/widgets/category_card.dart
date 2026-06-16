// lib/screens/home/widgets/category_card.dart

import 'package:cached_network_image/cached_network_image.dart';
import 'package:flutter/material.dart';
import '../../../models/meal_category.dart';

class CategoryCard extends StatelessWidget {
  final MealCategory category;
  final VoidCallback onTap;

  const CategoryCard({
    super.key,
    required this.category,
    required this.onTap,
  });

  @override
  Widget build(BuildContext context) {
    return GestureDetector(
      onTap: onTap,
      child: ClipRRect(
        borderRadius: BorderRadius.circular(16),
        child: Stack(
          fit: StackFit.expand,
          children: [
            // ── Zdjęcie kategorii ──────────────────────────
            CachedNetworkImage(
              imageUrl: category.thumbUrl,
              fit: BoxFit.cover,
              placeholder: (_, __) => Container(color: Colors.grey.shade200),
              errorWidget: (_, __, ___) => Container(
                color: Colors.grey.shade300,
                child: const Icon(Icons.broken_image, color: Colors.grey),
              ),
            ),

            // ── Gradient overlay (ciemnieje ku dołowi) ────
            DecoratedBox(
              decoration: BoxDecoration(
                gradient: LinearGradient(
                  begin: Alignment.topCenter,
                  end: Alignment.bottomCenter,
                  colors: [
                    Colors.transparent,
                    Colors.black.withOpacity(0.72),
                  ],
                  stops: const [0.45, 1.0],
                ),
              ),
            ),

            // ── Nazwa kategorii ────────────────────────────
            Align(
              alignment: Alignment.bottomLeft,
              child: Padding(
                padding: const EdgeInsets.all(12),
                child: Text(
                  category.name,
                  style: const TextStyle(
                    color: Colors.white,
                    fontSize: 15,
                    fontWeight: FontWeight.w700,
                    letterSpacing: 0.3,
                  ),
                  maxLines: 2,
                  overflow: TextOverflow.ellipsis,
                ),
              ),
            ),
          ],
        ),
      ),
    );
  }
}
