// lib/main.dart
// WERSJA TYMCZASOWA — bez Firebase i Hive (do testowania UI)
// Docelowo wrócimy do pełnej wersji po skonfigurowaniu Firebase

import 'package:flutter/material.dart';
import 'screens/home/home_screen.dart';

Future<void> main() async {
  WidgetsFlutterBinding.ensureInitialized();
  runApp(const DishcoveryApp());
}

class DishcoveryApp extends StatelessWidget {
  const DishcoveryApp({super.key});

  @override
  Widget build(BuildContext context) {
    return MaterialApp(
      title: 'Dishcovery',
      debugShowCheckedModeBanner: false,
      theme: ThemeData(
        colorSchemeSeed: Colors.orange,
        useMaterial3: true,
      ),
      home: const HomeScreen(),
    );
  }
}
