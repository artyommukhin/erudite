import 'package:erudite_app/game/domain/models/move.dart';
import 'package:erudite_app/game/domain/models/player.dart';
import 'package:erudite_app/word_calculator/domain/models/word.dart';
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

  void move(List<Word> words, bool usedAllLetters) {
    for (int i = 0; i < words.length; i++) {
      for (int j = i + 1; j < words.length; j++) {
        if (words[i].hasEqualLetters(words[j])) {
          throw Exception('Слова не могут повторяться');
        }
      }
    }

    for (final word in words) {
      if (isWordAlreadyInGame(word)) {
        throw Exception('Слово "$word" уже есть');
      }
    }

    final move = Move(words: words, usedAllLetters: usedAllLetters);
    currentPlayer.addMove(move);
    moves.add(move);
    if (isWinScoreReached()) {
      finish();
      return;
    }
    increaseCurrentPlayerIndex();
    moveNumber++;
    notifyListeners();
  }

  void skipMove() {
    currentPlayer.addMove(Move.empty);
    moves.add(Move.empty);
    increaseCurrentPlayerIndex();
    moveNumber++;
    notifyListeners();
  }

  bool isWordAlreadyInGame(Word word) {
    return moves
        .map((m) => m.words)
        .expand((w) => w)
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
    currentPlayer.removeLastMove();
    notifyListeners();
  }

  void finish() {
    isFinished = true;
  }
}
