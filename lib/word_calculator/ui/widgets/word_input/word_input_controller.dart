import 'package:erudite_app/word_calculator/domain/models/word.dart';
import 'package:flutter/foundation.dart';

class WordInputController extends ValueNotifier<WordInputValue> {
  WordInputController() : super(const WordInputValue());

  @override
  WordInputValue get value => _value;
  WordInputValue _value = const WordInputValue();

  @override
  set value(WordInputValue newValue) {
    if (value != newValue) {
      _value = newValue;
      notifyListeners();
    }
  }

  set text(String newText) {
    final filteredInput = newText.trim();
    if (filteredInput.isEmpty) {
      value = WordInputValue(
        words: [],
        allLettersUsed: value.allLettersUsed,
      );
      return;
    }

    final words = filteredInput
        .trim()
        .split(' ')
        .where((element) => element.isNotEmpty)
        .map((e) => Word.fromString(e))
        .toList();

    value = WordInputValue(
      words: words,
      allLettersUsed: value.allLettersUsed,
    );
  }

  List<Word> get words => _value.words;

  bool get allLettersUsed => _value.allLettersUsed;

  void updateWords(List<Word> words) {
    value = WordInputValue(
      words: words,
      allLettersUsed: value.allLettersUsed,
    );
  }

  void updateAllLettersUsed(bool allLettersUsed) {
    value = WordInputValue(
      words: value.words,
      allLettersUsed: allLettersUsed,
    );
  }

  void updateLetterMultiplier(int wordIndex, int letterIndex) {
    final currentWord = words[wordIndex];
    final currentLetter = currentWord.letters[letterIndex];
    final newMultiplier = currentLetter.multiplier.next;
    currentWord.updateMultiplierAt(letterIndex, newMultiplier);
    notifyListeners();
  }

  void clear() {
    value = const WordInputValue();
  }
}

@immutable
class WordInputValue {
  const WordInputValue({
    this.words = const [],
    this.allLettersUsed = false,
  });

  final List<Word> words;
  final bool allLettersUsed;

  @override
  bool operator ==(Object other) {
    return other is WordInputValue &&
        other.runtimeType == runtimeType &&
        other.allLettersUsed == allLettersUsed &&
        listEquals(other.words, words);
  }

  @override
  int get hashCode => Object.hashAll([...words, allLettersUsed]);
}
