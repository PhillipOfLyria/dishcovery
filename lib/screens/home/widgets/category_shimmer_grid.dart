// lib/screens/home/widgets/category_shimmer_grid.dart

import 'package:flutter/material.dart';
import 'package:shimmer/shimmer.dart';

/// Siatka "skeleton" wyświetlana podczas ładowania kategorii
class CategoryShimmerGrid extends StatelessWidget {
  const CategoryShimmerGrid({super.key});

  @override
  Widget build(BuildContext context) {
    return Shimmer.fromColors(
      baseColor: Colors.grey.shade300,
      highlightColor: Colors.grey.shade100,
      child: GridView.builder(
        padding: const EdgeInsets.all(16),
        gridDelegate: const SliverGridDelegateWithFixedCrossAxisCount(
          crossAxisCount: 2,
          crossAxisSpacing: 12,
          mainAxisSpacing: 12,
          childAspectRatio: 1.0,
        ),
        itemCount: 8, // 8 placeholderów
        itemBuilder: (_, __) => ClipRRect(
          borderRadius: BorderRadius.circular(16),
          child: Container(color: Colors.white),
        ),
      ),
    );
  }
}
