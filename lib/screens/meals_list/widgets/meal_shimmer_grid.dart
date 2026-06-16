// lib/screens/meals_list/widgets/meal_shimmer_grid.dart

import 'package:flutter/material.dart';
import 'package:shimmer/shimmer.dart';

class MealShimmerGrid extends StatelessWidget {
  const MealShimmerGrid({super.key});

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
          childAspectRatio: 0.85,
        ),
        itemCount: 6,
        itemBuilder: (_, __) => ClipRRect(
          borderRadius: BorderRadius.circular(16),
          child: Container(color: Colors.white),
        ),
      ),
    );
  }
}
