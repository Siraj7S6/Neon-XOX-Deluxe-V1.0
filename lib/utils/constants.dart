import 'package:flutter/material.dart';

class AppColors {
  // NEON THEME: Deep black/dark background colors
  static const Color primaryBg = Color(0xFF000000); // Pure Black
  static const Color secondaryBg = Color(0xFF0F0F0F); // Deep Charcoal
  static const Color accentBg = Color(0xFF1A1A1A); // Dark Surface

  // HIGH QUALITY NEON GRADIENT: Transitions from black to deep charcoal
  static const LinearGradient mainGradient = LinearGradient(
    begin: Alignment.topLeft,
    end: Alignment.bottomRight,
    colors: [
      Color(0xFF000000), 
      Color(0xFF121212), 
      Color(0xFF1A1A1A)
    ],
  );

  // NEON SYMBOLS: High-vibrancy colors for glowing effects
  static const Color playerXColor = Colors.cyanAccent; // Neon Blue
  static const Color playerOColor = Colors.pinkAccent; // Neon Pink
  
  // EXTRA: Added a Neon Green for winning line highlights
  static const Color winnerColor = Color(0xFF39FF14); 
}

class AppStyles {
  static const double borderRadius = 16.0;

  // Added a helper for Neon Shadows to be used in GameCells
  static List<Shadow> neonShadow(Color color) => [
    Shadow(blurRadius: 10, color: color, offset: const Offset(0, 0)),
    Shadow(blurRadius: 20, color: color, offset: const Offset(0, 0)),
  ];
}