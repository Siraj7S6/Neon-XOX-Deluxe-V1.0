import 'package:flutter_test/flutter_test.dart';
import 'package:tick_tac_toe/logic/game_controller.dart'; 

void main() {
  // We use a clean Group name to ensure VS Code refreshes the test list
  group('Neon XOX Deluxe - Core Engine Tests', () {
    late GameController controller;

    setUp(() {
      // We initialize with PVP mode to test the basic rules of the game
      controller = GameController(mode: GameMode.pvp);
    });

    test('Initial board state should be empty', () {
      expect(controller.value.board.every((cell) => cell == ""), true);
    });

    test('Player X should move first and the turn should toggle to O', () {
      controller.makeMove(0); // X moves at index 0
      expect(controller.value.board[0], "X");
      expect(controller.value.isXTurn, false); // It should now be O's turn
    });

    test('Logic should block moves on cells that are already taken', () {
      controller.makeMove(0); // X occupies index 0
      controller.makeMove(0); // O tries to occupy index 0
      
      expect(controller.value.board[0], "X"); // Should still be X
      expect(controller.value.isXTurn, false); // Turn should not have toggled again
    });

    test('Win condition detection - Horizontal Win', () {
      // Simulate a game where X wins horizontally on the top row
      // [X] [X] [X]
      // [O] [O] [ ]
      controller.makeMove(0); // X
      controller.makeMove(3); // O
      controller.makeMove(1); // X
      controller.makeMove(4); // O
      controller.makeMove(2); // X - Winning move
      
      expect(controller.value.winner, "X"); // Logic should detect X as winner
      expect(controller.value.winningLine, containsAll([0, 1, 2]));
    });

    test('Draw condition detection', () {
      // Fill the board in a way that results in a draw
      List<int> moves = [0, 1, 2, 4, 3, 5, 7, 6, 8];
      for (int move in moves) {
        controller.makeMove(move);
      }
      
      expect(controller.value.isDraw, true);
      expect(controller.value.winner, isNull); // No winner in a draw
    });
  });
}