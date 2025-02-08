import 'package:erudite_app/domain/models/word.dart';
import 'package:erudite_app/ui/models/game.dart';
import 'package:flutter/material.dart';

class PlayerTable extends StatelessWidget {
  const PlayerTable({super.key, required this.game});

  final Game game;

  @override
  Widget build(BuildContext context) {
    final List<(int, List<Word?>)> gameRounds = [];
    for (var r = 1; r <= game.roundNumber; r++) {
      final words =
          game.players.map((e) => e.words.elementAtOrNull(r - 1)).toList();
      gameRounds.add((r, words));
    }

    return Table(
      children: [
        TableRow(children: [
          Text('Тур'),
          for (final p in game.players)
            Text(
              '${p.name} (${p.score})',
              style: p.name == game.currentPlayer.name
                  ? TextStyle(fontWeight: FontWeight.bold)
                  : null,
            )
        ]),
        for (final r in gameRounds)
          TableRow(children: [
            Text(r.$1.toString()),
            for (final w in r.$2)
              w == null ? SizedBox.shrink() : Text('$w: ${w.computeScore()}')
          ]),
      ],
    );
  }
}
