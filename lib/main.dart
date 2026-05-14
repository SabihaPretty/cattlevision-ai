import 'package:flutter/material.dart';
import 'core/app_theme.dart';
import 'screens/intro_screen.dart';

void main() {
  runApp(const CattleVisionApp());
}

class CattleVisionApp extends StatelessWidget {
  const CattleVisionApp({super.key});

  @override
  Widget build(BuildContext context) {
    return MaterialApp(
      title: 'CattleVision AI',
      debugShowCheckedModeBanner: false,
      theme: AppTheme.darkTheme,
      home: const IntroScreen(),
    );
  }
}