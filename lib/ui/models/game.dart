import 'package:erudite_app/domain/models/move.dart';
import 'package:erudite_app/domain/models/player.dart';
import 'package:erudite_app/domain/models/word.dart';
import 'package:flutter/foundation.dart';

class Game extends ChangeNotifier {
  Game({this.winScore});

  final List<Player> players = [];
  final int? winScore;
  int _currentPlayerIndex = 0;
  int moveNumber = 1;
  List<Move> moves = [];
  bool isFinished = false;

  Player get currentPlayer {
    return players[_currentPlayerIndex];
  }

  int get roundNumber => (moveNumber / players.length).ceil();

  void move(Word word) {
    if (isWordAlreadyInGame(word)) {
      throw Exception('Такое слово уже есть');
    }
    currentPlayer.addWord(word);
    moves.add(Move(word: word));
    if (isWinScoreReached()) {
      finish();
      return;
    }
    increaseCurrentPlayerIndex();
    moveNumber++;
    notifyListeners();
  }

  void skipMove() {
    currentPlayer.addWord(null);
    moves.add(Move(word: null));
    increaseCurrentPlayerIndex();
    moveNumber++;
    notifyListeners();
  }

  bool isWordAlreadyInGame(Word word) {
    return moves
        .map((m) => m.word)
        .nonNulls
        .any((w) => w.hasEqualLetters(word));
  }

  bool isWinScoreReached() {
    return winScore != null && currentPlayer.score >= winScore!;
  }

  void increaseCurrentPlayerIndex() {
    _currentPlayerIndex = (_currentPlayerIndex + 1) % players.length;
  }

  void decreaseCurrentPlayerIndex() {
    _currentPlayerIndex = (_currentPlayerIndex - 1) % players.length;
  }

  void revertMove() {
    if (moveNumber == 1) throw Exception('There is no moves to revert');
    moveNumber--;
    decreaseCurrentPlayerIndex();
    moves.removeLast();
    currentPlayer.removeLastWord();
    notifyListeners();
  }

  void finish() {
    isFinished = true;
  }
}
