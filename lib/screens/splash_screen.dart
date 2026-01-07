import 'package:flutter/material.dart';
import 'package:google_fonts/google_fonts.dart';
import '../utils/constants.dart';
import 'menu_screen.dart';

class SplashScreen extends StatefulWidget {
  const SplashScreen({super.key});

  @override
  State<SplashScreen> createState() => _SplashScreenState();
}

class _SplashScreenState extends State<SplashScreen> with TickerProviderStateMixin {
  late AnimationController _controller;
  late AnimationController _pulseController;
  late Animation<double> _scaleAnimation;
  late Animation<double> _pulseAnimation;

  @override
  void initState() {
    super.initState();
    
    // Main Entry Animation (Elastic Scale)
    _controller = AnimationController(vsync: this, duration: const Duration(seconds: 2));
    _scaleAnimation = CurvedAnimation(parent: _controller, curve: Curves.elasticOut);
    
    // Continuous Pulsing Neon Animation
    _pulseController = AnimationController(
      vsync: this, 
      duration: const Duration(milliseconds: 1500)
    )..repeat(reverse: true);
    
    _pulseAnimation = Tween<double>(begin: 0.6, end: 1.0).animate(
      CurvedAnimation(parent: _pulseController, curve: Curves.easeInOut),
    );

    _controller.forward();

    Future.delayed(const Duration(seconds: 4), () {
      if (mounted) {
        Navigator.pushReplacement(context, MaterialPageRoute(builder: (_) => const MenuScreen()));
      }
    });
  }

  @override
  void dispose() {
    _controller.dispose();
    _pulseController.dispose();
    super.dispose();
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      backgroundColor: AppColors.primaryBg, // Pure Black from constants
      body: Container(
        width: double.infinity,
        decoration: const BoxDecoration(gradient: AppColors.mainGradient),
        child: Column(
          mainAxisAlignment: MainAxisAlignment.center,
          children: [
            // Animated Icon with Glow
            ScaleTransition(
              scale: _scaleAnimation,
              child: Container(
                decoration: BoxDecoration(
                  shape: BoxShape.circle,
                  boxShadow: [
                    BoxShadow(
                      color: AppColors.playerXColor.withOpacity(0.5),
                      blurRadius: 40,
                      spreadRadius: 5,
                    ),
                  ],
                ),
                child: const Icon(Icons.grid_3x3, size: 100, color: Colors.white),
              ),
            ),
            const SizedBox(height: 40),
            
            // Neon Pulsing Title
            FadeTransition(
              opacity: _pulseAnimation,
              child: ScaleTransition(
                scale: _pulseAnimation,
                child: Text(
                  "NEON XOX\nDELUXE",
                  textAlign: TextAlign.center,
                  style: GoogleFonts.orbitron(
                    fontSize: 38,
                    fontWeight: FontWeight.w900, // Fixed Weight
                    color: Colors.white,
                    letterSpacing: 4,
                    shadows: [
                      const Shadow(blurRadius: 10, color: AppColors.playerXColor),
                      const Shadow(blurRadius: 20, color: AppColors.playerOColor),
                      const Shadow(blurRadius: 40, color: Colors.cyanAccent),
                    ],
                  ),
                ),
              ),
            ),
          ],
        ),
      ),
    );
  }
}