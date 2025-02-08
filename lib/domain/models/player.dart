import 'package:erudite_app/domain/models/word.dart';

class Player {
  Player({
    required this.name,
  });

  final String name;
  int score = 0;
  final List<Word> _words = [];

  List<Word> get words => _words;

  void addWord(Word word) {
    score += word.computeScore();
    _words.add(word);
  }

  @override
  String toString() {
    return name;
  }
}
