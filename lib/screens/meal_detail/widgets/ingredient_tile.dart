// lib/screens/meal_detail/widgets/ingredient_tile.dart

import 'package:flutter/material.dart';
import '../../../models/meal_detail.dart';

class IngredientTile extends StatelessWidget {
  final Ingredient ingredient;

  const IngredientTile({super.key, required this.ingredient});

  @override
  Widget build(BuildContext context) {
    return Padding(
      padding: const EdgeInsets.symmetric(vertical: 6),
      child: Row(
        children: [
          // Pomarańczowa kropka
          Container(
            width: 8,
            height: 8,
            decoration: const BoxDecoration(
              color: Color(0xFFFF6B35),
              shape: BoxShape.circle,
            ),
          ),
          const SizedBox(width: 12),
          // Nazwa składnika
          Expanded(
            child: Text(
              ingredient.name,
              style: const TextStyle(
                fontSize: 14,
                fontWeight: FontWeight.w500,
                color: Color(0xFF1A1A1A),
              ),
            ),
          ),
          // Miara
          Text(
            ingredient.measure,
            style: const TextStyle(
              fontSize: 14,
              color: Color(0xFF888888),
            ),
          ),
        ],
      ),
    );
  }
}
