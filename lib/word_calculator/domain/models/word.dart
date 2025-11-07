import 'package:erudite_app/word_calculator/domain/letter_scores.dart';
import 'package:erudite_app/word_calculator/domain/models/multiplier.dart';
import 'package:flutter/foundation.dart';

import 'letter.dart';

class Word {
  Word(this.letters);

  Word.fromString(String input)
      : letters = input.split('').map((e) {
          final score = letterScores[e.toLowerCase()];
          if (score == null) throw Exception('Unknown letter: $e');

          return LetterDto(
            value: LetterValue(symbol: e, score: score),
            multiplier: Multiplier.none,
          );
        }).toList();

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

  @override
  bool operator ==(Object other) {
    return other is Word &&
        other.runtimeType == runtimeType &&
        listEquals(other.letters, letters);
  }

  @override
  int get hashCode => Object.hashAll(letters);
}
