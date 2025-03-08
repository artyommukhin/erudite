import 'package:erudite_app/word_calculator/domain/models/word.dart';

class Move {
  const Move({
    required this.words,
    required this.usedAllLetters,
  });

  static const empty = Move(words: [], usedAllLetters: false);

  final List<Word> words;
  final bool usedAllLetters;
}
