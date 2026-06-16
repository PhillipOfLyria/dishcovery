// lib/screens/meals_list/meals_list_screen.dart
// PLACEHOLDER — pełna implementacja w następnym kroku

import 'package:flutter/material.dart';
import '../../models/meal_category.dart';

class MealsListScreen extends StatelessWidget {
  final MealCategory category;

  const MealsListScreen({super.key, required this.category});

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(title: Text(category.name)),
      body: const Center(child: Text('Tu będzie lista posiłków — coming soon!')),
    );
  }
}
