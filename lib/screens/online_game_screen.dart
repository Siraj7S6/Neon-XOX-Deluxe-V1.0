import 'package:flutter/material.dart';
import 'package:google_fonts/google_fonts.dart';
import '../logic/online_controller.dart';
import '../widgets/game_cell.dart';
import '../utils/constants.dart';

class OnlineGameScreen extends StatefulWidget {
  final String roomCode;
  final String mySymbol; 
  final bool isMatchmaking; // NEW: Flag to control UI visibility

  const OnlineGameScreen({
    super.key, 
    required this.roomCode, 
    required this.mySymbol,
    this.isMatchmaking = false, // Defaults to false for private rooms
  });

  @override
  State<OnlineGameScreen> createState() => _OnlineGameScreenState();
}

class _OnlineGameScreenState extends State<OnlineGameScreen> {
  late OnlineController _controller;

  @override
  void initState() {
    super.initState();
    // The logic remains the same; we just hide the code from the user's eyes
    _controller = OnlineController(roomCode: widget.roomCode, mySymbol: widget.mySymbol);
  }

  @override
  void dispose() {
    _controller.dispose();
    super.dispose();
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      backgroundColor: AppColors.primaryBg, // Pure Black background
      body: Container(
        decoration: const BoxDecoration(gradient: AppColors.mainGradient),
        child: SafeArea(
          child: ValueListenableBuilder<OnlineState>(
            valueListenable: _controller,
            builder: (context, state, _) {
              bool isMyTurn = (state.isXTurn && widget.mySymbol == "X") ||
                  (!state.isXTurn && widget.mySymbol == "O");

              return Column(
                children: [
                  _buildHeader(),
                  const SizedBox(height: 20),
                  
                  // Turn Indicator with Glow
                  Text(
                    state.winner == null 
                      ? (isMyTurn ? "YOUR TURN (${widget.mySymbol})" : "WAITING FOR OPPONENT...")
                      : "GAME OVER",
                    style: GoogleFonts.orbitron(
                        color: isMyTurn ? AppColors.playerXColor : Colors.white70,
                        fontSize: 18,
                        fontWeight: FontWeight.bold,
                        shadows: isMyTurn ? AppStyles.neonShadow(AppColors.playerXColor) : null,
                    ),
                  ),
                  const Spacer(),
                  _buildGrid(state, isMyTurn),
                  const Spacer(),
                  if (state.winner != null) _buildResult(state.winner!),
                  const SizedBox(height: 50),
                ],
              );
            },
          ),
        ),
      ),
    );
  }

  Widget _buildHeader() {
    return Padding(
      padding: const EdgeInsets.all(16.0),
      child: Row(
        children: [
          IconButton(
            icon: const Icon(Icons.arrow_back_ios, color: Colors.white),
            onPressed: () => Navigator.pop(context),
          ),
          // MODIFIED: Logic to hide room code
          Text(
            widget.isMatchmaking ? "" : "ROOM: ${widget.roomCode}",
            style: GoogleFonts.orbitron(
              color: Colors.white, 
              fontSize: 18, 
              fontWeight: FontWeight.w600,
              letterSpacing: 1.5,
            ),
          ),
        ],
      ),
    );
  }

  Widget _buildGrid(OnlineState state, bool isMyTurn) {
    return Padding(
      padding: const EdgeInsets.symmetric(horizontal: 30),
      child: AspectRatio(
        aspectRatio: 1,
        child: GridView.builder(
          shrinkWrap: true,
          physics: const NeverScrollableScrollPhysics(),
          gridDelegate: const SliverGridDelegateWithFixedCrossAxisCount(
              crossAxisCount: 3, crossAxisSpacing: 12, mainAxisSpacing: 12),
          itemCount: 9,
          itemBuilder: (context, index) {
            bool isWinning = state.winningLine != null && state.winningLine!.contains(index);

            return GameCell(
              value: state.board[index],
              isWinningCell: isWinning, 
              onTap: (isMyTurn && state.winner == null) 
                  ? () => _controller.makeMove(index) 
                  : () {},
            );
          },
        ),
      ),
    );
  }

  Widget _buildResult(String winner) {
    return Container(
      padding: const EdgeInsets.all(20),
      margin: const EdgeInsets.symmetric(horizontal: 20),
      decoration: BoxDecoration(
        color: Colors.black.withOpacity(0.5), 
        borderRadius: BorderRadius.circular(20),
        border: Border.all(color: Colors.white10),
        boxShadow: [
          BoxShadow(color: Colors.black.withOpacity(0.3), blurRadius: 10)
        ]
      ),
      child: Column(
        children: [
          Text(
            winner == "Draw" ? "IT'S A DRAW!" : "PLAYER $winner WINS!",
            style: GoogleFonts.orbitron(
              color: Colors.white, 
              fontSize: 22, 
              fontWeight: FontWeight.bold,
              shadows: [const Shadow(blurRadius: 10, color: Colors.white38)]
            ),
          ),
          const SizedBox(height: 20),
          Row(
            mainAxisAlignment: MainAxisAlignment.center,
            children: [
              ElevatedButton(
                style: ElevatedButton.styleFrom(
                  backgroundColor: AppColors.playerXColor.withOpacity(0.8),
                  padding: const EdgeInsets.symmetric(horizontal: 24, vertical: 12),
                  shape: RoundedRectangleBorder(borderRadius: BorderRadius.circular(12)),
                ),
                onPressed: () => _controller.resetGame(),
                child: const Text("PLAY AGAIN", style: TextStyle(color: Colors.black, fontWeight: FontWeight.bold)),
              ),
              const SizedBox(width: 15),
              TextButton(
                onPressed: () => Navigator.pop(context),
                child: Text("EXIT", style: GoogleFonts.orbitron(color: Colors.white70, fontSize: 12)),
              ),
            ],
          ),
        ],
      ),
    );
  }
}