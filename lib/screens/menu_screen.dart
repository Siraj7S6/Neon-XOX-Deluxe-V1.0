import 'package:flutter/material.dart';
import 'package:flutter/services.dart';
import 'package:google_fonts/google_fonts.dart'; 
import 'game_screen.dart';
import '../logic/game_controller.dart';
import '../utils/constants.dart';
import 'online_lobby.dart';

class MenuScreen extends StatelessWidget {
  const MenuScreen({super.key});

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      backgroundColor: AppColors.primaryBg, // Pure Black
      body: Container(
        width: double.infinity,
        decoration: const BoxDecoration(gradient: AppColors.mainGradient),
        child: SafeArea(
          child: Column(
            mainAxisAlignment: MainAxisAlignment.center,
            children: [
              const Spacer(flex: 2),
              
              // NEON TITLE WITH MULTI-GLOW
              Text(
                "NEON XOX\nDELUXE",
                textAlign: TextAlign.center,
                style: GoogleFonts.orbitron(
                  color: Colors.white,
                  fontSize: 36,
                  fontWeight: FontWeight.w900, // Fixed Weight
                  letterSpacing: 4,
                  shadows: [
                    const Shadow(blurRadius: 10, color: AppColors.playerXColor),
                    const Shadow(blurRadius: 25, color: Colors.cyanAccent),
                  ],
                ),
              ),
              
              const SizedBox(height: 60),

              // GAME MODE BUTTONS
              _buildNeonMenuButton(
                context, 
                text: "LOCAL PVP", 
                color: AppColors.playerXColor,
                onPressed: () => _launchGame(context, GameMode.pvp),
              ),
              const SizedBox(height: 15),
              _buildNeonMenuButton(
                context, 
                text: "EASY AI", 
                color: Colors.white70,
                onPressed: () => _launchGame(context, GameMode.easy),
              ),
              const SizedBox(height: 15),
              _buildNeonMenuButton(
                context, 
                text: "IMPOSSIBLE AI", 
                color: Colors.white70,
                onPressed: () => _launchGame(context, GameMode.impossible),
              ),
              const SizedBox(height: 15),
              _buildNeonMenuButton(
                context, 
                text: "ONLINE ROOM", 
                color: AppColors.playerOColor,
                onPressed: () {
                  Navigator.push(
                    context,
                    MaterialPageRoute(builder: (context) => const OnlineLobby()),
                  );
                },
              ),
              
              const Spacer(),

              // EXIT BUTTON AT BOTTOM
              _buildNeonMenuButton(
                context, 
                text: "EXIT GAME", 
                color: Colors.redAccent,
                isSmall: true,
                onPressed: () => SystemNavigator.pop(),
              ),
              
              const SizedBox(height: 30),
            ],
          ),
        ),
      ),
    );
  }

  // REUSABLE NEON BUTTON WIDGET
  Widget _buildNeonMenuButton(
    BuildContext context, {
    required String text,
    required Color color,
    required VoidCallback onPressed,
    bool isSmall = false,
  }) {
    return Padding(
      padding: const EdgeInsets.symmetric(horizontal: 40),
      child: Container(
        width: double.infinity,
        height: isSmall ? 50 : 60,
        decoration: BoxDecoration(
          borderRadius: BorderRadius.circular(15),
          boxShadow: [
            BoxShadow(
              color: color.withOpacity(0.2),
              blurRadius: 15,
              spreadRadius: 1,
            ),
          ],
        ),
        child: ElevatedButton(
          onPressed: onPressed,
          style: ElevatedButton.styleFrom(
            backgroundColor: Colors.black.withOpacity(0.6),
            foregroundColor: color,
            side: BorderSide(color: color.withOpacity(0.6), width: 2),
            shape: RoundedRectangleBorder(borderRadius: BorderRadius.circular(15)),
            elevation: 0,
          ),
          child: Text(
            text,
            style: GoogleFonts.orbitron(
              fontSize: isSmall ? 14 : 18,
              fontWeight: FontWeight.bold,
              letterSpacing: 2,
            ),
          ),
        ),
      ),
    );
  }

  void _launchGame(BuildContext context, GameMode mode) {
    Navigator.push(
      context,
      MaterialPageRoute(builder: (context) => GameScreen(mode: mode)),
    );
  }
}