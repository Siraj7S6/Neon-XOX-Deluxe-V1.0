import 'package:firebase_database/firebase_database.dart';
import 'package:flutter/material.dart';
import 'dart:async';

class MatchmakingController {
  // Use the specific Database URL from your OnlineController
  final DatabaseReference _dbRef = FirebaseDatabase.instanceFor(
    app: FirebaseDatabase.instance.app,
    databaseURL: 'https://ticktacktoe-282aa-default-rtdb.firebaseio.com/',
  ).ref();

  StreamSubscription? _queueSubscription;
  String? _currentRoomCode;

  void findMatch({
    required Function(String roomCode, String symbol) onMatchFound,
  }) async {
    final queueRef = _dbRef.child('matchmaking_queue');

    // 1. Check if there's an available player in the queue
    DataSnapshot snapshot = await queueRef.get();

    if (snapshot.exists && snapshot.value != null) {
      // JOINER LOGIC: Found someone waiting
      Map<dynamic, dynamic> queueData = snapshot.value as Map;
      String roomCode = queueData.keys.first;

      // Immediately remove from queue so a 3rd person doesn't join
      await queueRef.child(roomCode).remove();

      // Notify the room that a player has joined
      await _dbRef.child("rooms/$roomCode").update({'playerJoined': true});

      debugPrint("Matchmaking: Joined existing room $roomCode");
      onMatchFound(roomCode, "O");
    } else {
      // HOST LOGIC: No one is waiting, create a new entry
      String myRoomCode = (1000 + (DateTime.now().millisecond % 9000)).toString();
      _currentRoomCode = myRoomCode;

      // Initialize the room data exactly as OnlineController expects
      await _dbRef.child("rooms/$myRoomCode").set({
        'board': List.filled(9, ""),
        'isXTurn': true,
        'winner': null,
        'winningLine': null,
        'playerJoined': false, // Add this flag to track the handshake
      });

      // Put this room in the matchmaking queue
      await queueRef.child(myRoomCode).set(true);

      // Listen for a player to join our specific room
      _queueSubscription = _dbRef.child("rooms/$myRoomCode/playerJoined").onValue.listen((event) {
        if (event.snapshot.value == true) {
          _queueSubscription?.cancel();
          debugPrint("Matchmaking: Opponent joined our room $myRoomCode");
          onMatchFound(myRoomCode, "X");
        }
      });
    }
  }

  void cancelSearch() async {
    _queueSubscription?.cancel();
    if (_currentRoomCode != null) {
      // Clean up the queue and the room if we leave
      await _dbRef.child('matchmaking_queue').child(_currentRoomCode!).remove();
      await _dbRef.child('rooms').child(_currentRoomCode!).remove();
    }
  }
}