import 'package:erudite_app/game/domain/models/move.dart';

class Player {
  Player({
    required this.name,
  });

  final String name;
  int score = 0;
  final List<Move> _moves = [];

  List<Move> get moves => _moves;

  double get effectiveness {
    final letterCount = moves
        .expand((m) => m.words)
        .fold(0, (count, word) => count + word.letters.length);

    return score / letterCount;
  }

  void addMove(Move move) {
    _moves.add(move);
    for (final word in move.words) {
      score += word.computeScore();
    }
    if (move.usedAllLetters) {
      score += 15;
    }
  }

  void removeLastMove() {
    final lastMove = _moves.removeLast();
    for (final word in lastMove.words) {
      score -= word.computeScore();
    }
    if (lastMove.usedAllLetters) {
      score -= 15;
    }
  }

  @override
  String toString() {
    return name;
  }
}
