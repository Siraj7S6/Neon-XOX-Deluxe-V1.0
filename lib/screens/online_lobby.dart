import 'package:flutter/material.dart';
import 'package:google_fonts/google_fonts.dart';
import '../utils/constants.dart';
import 'online_game_screen.dart';

class OnlineLobby extends StatefulWidget {
  const OnlineLobby({super.key});

  @override
  State<OnlineLobby> createState() => _OnlineLobbyState();
}

class _OnlineLobbyState extends State<OnlineLobby> {
  final TextEditingController _codeController = TextEditingController();

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      backgroundColor: AppColors.primaryBg,
      body: Container(
        decoration: const BoxDecoration(gradient: AppColors.mainGradient),
        child: SafeArea(
          child: Padding(
            padding: const EdgeInsets.symmetric(horizontal: 30),
            child: Column(
              children: [
                _buildHeader(),
                const Spacer(),
                
                // Neon Icon Glow
                Icon(
                  Icons.sensors,
                  size: 80,
                  color: AppColors.playerXColor,
                  shadows: AppStyles.neonShadow(AppColors.playerXColor),
                ),
                const SizedBox(height: 20),
                
                Text(
                  "MULTIPLAYER LOBBY",
                  style: GoogleFonts.orbitron(
                    color: Colors.white,
                    fontSize: 22,
                    fontWeight: FontWeight.bold,
                    letterSpacing: 2,
                  ),
                ),
                const SizedBox(height: 40),

                // Room Code Input with Neon Border
                TextField(
                  controller: _codeController,
                  style: GoogleFonts.orbitron(color: Colors.white, letterSpacing: 5),
                  textAlign: TextAlign.center,
                  decoration: InputDecoration(
                    hintText: "ENTER ROOM CODE",
                    hintStyle: GoogleFonts.orbitron(color: Colors.white30, fontSize: 12),
                    filled: true,
                    fillColor: Colors.white.withOpacity(0.05),
                    enabledBorder: OutlineInputBorder(
                      borderRadius: BorderRadius.circular(15),
                      borderSide: const BorderSide(color: Colors.white10),
                    ),
                    focusedBorder: OutlineInputBorder(
                      borderRadius: BorderRadius.circular(15),
                      borderSide: const BorderSide(color: AppColors.playerXColor, width: 2),
                    ),
                  ),
                ),
                const SizedBox(height: 30),

                // Join Button (Neon Blue)
                _buildNeonButton(
                  text: "JOIN ROOM",
                  color: AppColors.playerXColor,
                  onPressed: () => _joinRoom(_codeController.text, "O"),
                ),
                const SizedBox(height: 15),

                // Create Button (Neon Pink)
                _buildNeonButton(
                  text: "CREATE ROOM",
                  color: AppColors.playerOColor,
                  onPressed: () {
                    // Logic to generate a random code and join as "X"
                    String newCode = (1000 + (DateTime.now().millisecond % 9000)).toString();
                    _joinRoom(newCode, "X");
                  },
                ),
                
                const Spacer(flex: 2),
              ],
            ),
          ),
        ),
      ),
    );
  }

  Widget _buildHeader() {
    return Row(
      children: [
        IconButton(
          icon: const Icon(Icons.arrow_back_ios, color: Colors.white),
          onPressed: () => Navigator.pop(context),
        ),
      ],
    );
  }

  Widget _buildNeonButton({required String text, required Color color, required VoidCallback onPressed}) {
    return Container(
      width: double.infinity,
      height: 55,
      decoration: BoxDecoration(
        borderRadius: BorderRadius.circular(15),
        boxShadow: [
          BoxShadow(
            color: color.withOpacity(0.3),
            blurRadius: 12,
            offset: const Offset(0, 4),
          ),
        ],
      ),
      child: ElevatedButton(
        onPressed: onPressed,
        style: ElevatedButton.styleFrom(
          backgroundColor: Colors.black,
          foregroundColor: color,
          side: BorderSide(color: color, width: 2),
          shape: RoundedRectangleBorder(borderRadius: BorderRadius.circular(15)),
          elevation: 0,
        ),
        child: Text(
          text,
          style: GoogleFonts.orbitron(fontWeight: FontWeight.bold, letterSpacing: 1.5),
        ),
      ),
    );
  }

  void _joinRoom(String code, String symbol) {
    if (code.isNotEmpty) {
      Navigator.push(
        context,
        MaterialPageRoute(
          builder: (context) => OnlineGameScreen(roomCode: code, mySymbol: symbol),
        ),
      );
    }
  }
}