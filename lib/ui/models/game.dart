import 'package:erudite_app/domain/models/player.dart';
import 'package:erudite_app/domain/models/word.dart';
import 'package:flutter/foundation.dart';

class Game extends ChangeNotifier {
  Game({this.winScore});

  final List<Player> players = [];
  final int? winScore;
  int _currentPlayerIndex = 0;
  int moveNumber = 1;
  List<Word> words = [];
  bool isFinished = false;

  Player get currentPlayer {
    return players[_currentPlayerIndex];
  }

  int get roundNumber => (moveNumber / players.length).ceil();

  void move(Word word) {
    currentPlayer.addWord(word);
    words.add(word);
    if (isWinScoreReached()) {
      finish();
      return;
    }
    increaseCurrentPlayerIndex();
    moveNumber++;
    notifyListeners();
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
    words.removeLast();
    final lastWord = currentPlayer.words.removeLast();
    currentPlayer.score -= lastWord.computeScore();
    notifyListeners();
  }

  void finish() {
    isFinished = true;
  }
}
