import 'package:erudite_app/word_calculator/domain/models/multiplier.dart';

import 'letter.dart';

class Word {
  Word(this.letters);

  final List<LetterDto> letters;

  int computeScore() {
    final wordMultipliers = letters
        .where((element) => element.multiplier.isForWord)
        .map((e) => e.multiplier);

    int letterSum = 0;
    for (var letter in letters) {
      letterSum += letter.value.score * letter.multiplier.forLetter;
    }

    for (var multiplier in wordMultipliers) {
      letterSum *= multiplier.forWord;
    }

    return letterSum;
  }

  void updateMultiplierAt(int letterIndex, Multiplier multiplier) {
    final letter = letters[letterIndex];
    letters[letterIndex] =
        LetterDto(value: letter.value, multiplier: multiplier);
  }

  @override
  String toString() {
    return letters.map((e) => e.value.symbol).join();
  }

  bool hasEqualLetters(Word other) {
    return toString() == other.toString();
  }
}
