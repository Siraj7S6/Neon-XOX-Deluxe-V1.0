import 'package:flutter/material.dart';
import 'package:google_fonts/google_fonts.dart';
import 'dart:async';
import '../logic/matchmaking_controller.dart';
import '../utils/constants.dart';
import 'online_game_screen.dart';

class MatchmakingScreen extends StatefulWidget {
  const MatchmakingScreen({super.key});

  @override
  State<MatchmakingScreen> createState() => _MatchmakingScreenState();
}

class _MatchmakingScreenState extends State<MatchmakingScreen> with SingleTickerProviderStateMixin {
  final MatchmakingController _matchmaking = MatchmakingController();
  late AnimationController _rotationController;
  
  // Countdown State
  int _countdown = 3;
  bool _isCountdownActive = false;
  String? _pendingRoom;
  String? _pendingSymbol;
  Timer? _timer;

  @override
  void initState() {
    super.initState();
    _rotationController = AnimationController(vsync: this, duration: const Duration(seconds: 2))..repeat();
    
    _matchmaking.findMatch(onMatchFound: (roomCode, symbol) {
      if (mounted) {
        setState(() {
          _isCountdownActive = true;
          _pendingRoom = roomCode;
          _pendingSymbol = symbol;
        });
        _startTimer();
      }
    });
  }

  void _startTimer() {
    _timer = Timer.periodic(const Duration(seconds: 1), (timer) {
      if (_countdown > 1) {
        setState(() {
          _countdown--;
        });
      } else {
        _timer?.cancel();
        _navigateToGame();
      }
    });
  }

  void _navigateToGame() {
    if (_pendingRoom != null && _pendingSymbol != null) {
      Navigator.pushReplacement(
        context,
        MaterialPageRoute(
          builder: (_) => OnlineGameScreen(
            roomCode: _pendingRoom!, 
            mySymbol: _pendingSymbol!,
            isMatchmaking: true, // Hide room code as requested
          ),
        ),
      );
    }
  }

  @override
  void dispose() {
    _rotationController.dispose();
    _timer?.cancel();
    _matchmaking.cancelSearch();
    super.dispose();
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      backgroundColor: AppColors.primaryBg,
      body: Container(
        decoration: const BoxDecoration(gradient: AppColors.mainGradient),
        child: Center(
          child: Column(
            mainAxisAlignment: MainAxisAlignment.center,
            children: [
              if (!_isCountdownActive) ...[
                // SEARCHING VIEW
                RotationTransition(
                  turns: _rotationController,
                  child: Icon(Icons.sync, size: 80, color: AppColors.playerXColor, 
                    shadows: [Shadow(blurRadius: 20, color: AppColors.playerXColor)]),
                ),
                const SizedBox(height: 40),
                Text(
                  "SEARCHING FOR\nOPPONENT...",
                  textAlign: TextAlign.center,
                  style: GoogleFonts.orbitron(
                    color: Colors.white,
                    fontSize: 22,
                    fontWeight: FontWeight.bold,
                    letterSpacing: 2,
                  ),
                ),
              ] else ...[
                // COUNTDOWN VIEW
                Text(
                  "MATCH FOUND!",
                  style: GoogleFonts.orbitron(
                    color: Colors.greenAccent,
                    fontSize: 28,
                    fontWeight: FontWeight.bold,
                    shadows: [const Shadow(blurRadius: 15, color: Colors.greenAccent)],
                  ),
                ),
                const SizedBox(height: 30),
                AnimatedSwitcher(
                  duration: const Duration(milliseconds: 500),
                  transitionBuilder: (child, animation) => ScaleTransition(scale: animation, child: child),
                  child: Text(
                    "$_countdown",
                    key: ValueKey(_countdown),
                    style: GoogleFonts.orbitron(
                      color: Colors.white,
                      fontSize: 120,
                      fontWeight: FontWeight.w900,
                      shadows: [
                        const Shadow(blurRadius: 20, color: AppColors.playerXColor),
                        const Shadow(blurRadius: 40, color: AppColors.playerOColor),
                      ],
                    ),
                  ),
                ),
                Text(
                  "GET READY",
                  style: GoogleFonts.orbitron(
                    color: Colors.white70,
                    fontSize: 18,
                    letterSpacing: 4,
                  ),
                ),
              ],
              const SizedBox(height: 60),
              if (!_isCountdownActive)
                TextButton(
                  onPressed: () => Navigator.pop(context),
                  child: Text("CANCEL", style: GoogleFonts.orbitron(color: Colors.white38)),
                )
            ],
          ),
        ),
      ),
    );
  }
}