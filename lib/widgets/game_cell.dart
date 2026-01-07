import 'package:flutter/material.dart';
import 'package:google_fonts/google_fonts.dart';
import '../utils/constants.dart';

class GameCell extends StatelessWidget {
  final String value;
  final VoidCallback onTap;
  final bool isWinningCell; // MATCHES THE ERROR LOG IN YOUR TERMINAL

  const GameCell({
    super.key,
    required this.value,
    required this.onTap,
    this.isWinningCell = false,
  });

  @override
  Widget build(BuildContext context) {
    final Color neonColor = value == "X" ? AppColors.playerXColor : AppColors.playerOColor;
    
    return GestureDetector(
      onTap: onTap,
      child: AnimatedContainer(
        duration: const Duration(milliseconds: 300),
        decoration: BoxDecoration(
          color: isWinningCell ? neonColor.withOpacity(0.2) : Colors.black.withOpacity(0.3),
          borderRadius: BorderRadius.circular(AppStyles.borderRadius),
          border: Border.all(
            color: isWinningCell ? neonColor : Colors.white10,
            width: isWinningCell ? 3 : 1,
          ),
          boxShadow: isWinningCell ? [
            BoxShadow(color: neonColor.withOpacity(0.5), blurRadius: 15, spreadRadius: 2)
          ] : [],
        ),
        child: Center(
          child: Text(
            value,
            style: GoogleFonts.orbitron(
              fontSize: 45,
              fontWeight: FontWeight.w900, // FIXED: Changed from .black to .w900
              color: neonColor,
              shadows: [
                Shadow(blurRadius: 10, color: neonColor),
                Shadow(blurRadius: 20, color: neonColor),
              ],
            ),
          ),
        ),
      ),
    );
  }
}