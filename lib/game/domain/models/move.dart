import 'package:erudite_app/word_calculator/domain/models/word.dart';

class Move {
  const Move({
    required this.word,
    required this.usedAllLetters,
  });

  static const empty = Move(word: null, usedAllLetters: false);

  final Word? word;
  final bool usedAllLetters;
}
