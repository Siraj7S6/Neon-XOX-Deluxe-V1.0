import 'package:flutter_test/flutter_test.dart';
import 'package:tick_tac_toe/logic/game_controller.dart'; // Adjust path to your controller

void main() {
  group('Neon XOX Deluxe - Game Logic Tests', () {
    late GameController controller;

    setUp(() {
      controller = GameController();
    });

    test('Initial board should be empty', () {
      expect(controller.value.board.every((cell) => cell == ""), true);
    });

    test('Player X should move first', () {
      controller.makeMove(0);
      expect(controller.value.board[0], "X");
      expect(controller.value.isXTurn, false);
    });

    test('Impossible AI should block a winning move', () {
      // Setup a scenario where Player X is about to win
      // [X] [X] [ ]
      controller.makeMove(0); // X
      controller.makeMove(3); // AI O
      controller.makeMove(1); // X
      
      // The AI move logic (triggered by your controller)
      // should automatically pick index 2 to block
      expect(controller.value.board[2], "O"); 
    });
  });
}