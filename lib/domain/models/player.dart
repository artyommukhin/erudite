import 'package:erudite_app/domain/models/move.dart';

class Player {
  Player({
    required this.name,
  });

  final String name;
  int score = 0;
  final List<Move> _moves = [];

  List<Move> get moves => _moves;

  void addMove(Move move) {
    _moves.add(move);
    if (move.word != null) {
      score += move.word!.computeScore();
    }
    if (move.usedAllLetters) {
      score += 15;
    }
  }

  void removeLastMove() {
    final lastMove = _moves.removeLast();
    if (lastMove.word != null) {
      score -= lastMove.word!.computeScore();
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
