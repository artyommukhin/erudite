import 'package:erudite_app/domain/models/word.dart';

class Player {
  Player({
    required this.name,
  });

  final String name;
  int score = 0;
  final List<Word?> _words = [];

  List<Word?> get words => _words;

  void addWord(Word? word) {
    _words.add(word);
    if (word == null) return;
    score += word.computeScore();
  }

  void removeLastWord() {
    final lastWord = _words.removeLast();
    if (lastWord == null) return;
    score -= lastWord.computeScore();
  }

  @override
  String toString() {
    return name;
  }
}
