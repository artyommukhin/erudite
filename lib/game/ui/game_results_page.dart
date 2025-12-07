import 'package:erudite_app/game/ui/models/game.dart';
import 'package:erudite_app/game/ui/widgets/player_table.dart';
import 'package:erudite_app/word_calculator/domain/models/word.dart';
import 'package:flutter/material.dart';

class GameResultsPage extends StatelessWidget {
  const GameResultsPage({
    super.key,
    required this.game,
  });

  final Game game;

  Iterable<Word> get longestWords {
    final biggestWordLength = game.moves
        .expand((m) => m.words)
        .map((w) => w.letters.length)
        .toSet()
        .fold(0, (max, len) => len > max ? len : max);

    final longestWords = game.moves
        .expand((m) => m.words)
        .where((element) => element.letters.length == biggestWordLength);

    return longestWords;
  }

  Iterable<Word> get bestScoringWords {
    final biggestWordScore = game.moves
        .expand((m) => m.words)
        .map((w) => w.computeScore())
        .toSet()
        .fold(0, (max, score) => score > max ? score : max);

    final bestScoringWords = game.moves
        .expand((m) => m.words)
        .where((element) => element.computeScore() == biggestWordScore);

    return bestScoringWords;
  }

  @override
  Widget build(BuildContext context) {
    final sortedPlayers = game.players.toList()
      ..sort((a, b) => b.score.compareTo(a.score));

    final winner = sortedPlayers.first;

    return Scaffold(
      appBar: AppBar(
        title: Text('Игра закончена'),
      ),
      body: ListView(
        padding: EdgeInsets.symmetric(horizontal: 16, vertical: 24),
        children: [
          Center(child: Text('Победитель: $winner')),
          Center(child: Text('Счёт: ${winner.score}')),
          Center(
            child: Text(
                'Эффективность: ${winner.effectiveness.toStringAsFixed(2)} очков за букву'),
          ),
          SizedBox(height: 16),
          Text('Другие игроки:'),
          for (final p in sortedPlayers.sublist(1))
            Text(
                '${p.name}: ${p.score} (${p.effectiveness.toStringAsFixed(2)} очков на букву)'),
          SizedBox(height: 16),
          if (longestWords.isNotEmpty) ...[
            Text(
              longestWords.length == 1
                  ? 'Самое длинное слово:'
                  : 'Самые длинные слова:',
            ),
            for (final word in longestWords)
              Text('$word - ${word.letters.length} букв'),
            SizedBox(height: 16),
          ],
          if (bestScoringWords.isNotEmpty) ...[
            Text(
              bestScoringWords.length == 1
                  ? 'Самое дорогое слово:'
                  : 'Самые дорогие слова:',
            ),
            for (final word in bestScoringWords)
              Text('$word - ${word.computeScore()} очков'),
            SizedBox(height: 16),
          ],
          PlayerTable(game: game),
          SizedBox(height: 16),
          Center(
            child: FilledButton(
              onPressed: () => Navigator.of(context).pop(),
              child: Text('Ок'),
            ),
          ),
        ],
      ),
    );
  }
}
