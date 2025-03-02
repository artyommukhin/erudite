import 'package:erudite_app/game/domain/models/move.dart';
import 'package:erudite_app/game/ui/models/game.dart';
import 'package:flutter/material.dart';

class PlayerTable extends StatelessWidget {
  const PlayerTable({super.key, required this.game});

  final Game game;

  @override
  Widget build(BuildContext context) {
    final List<(int, List<Move?>)> gameRounds = [];
    for (var roundIndex = 0; roundIndex < game.roundNumber; roundIndex++) {
      final playerCount = game.players.length;
      final roundFirstMoveIndex = playerCount * roundIndex;
      final nextRoundFirstMoveIndex = playerCount * (roundIndex + 1);

      final List<Move?> moves = [];
      if (game.moves.length < nextRoundFirstMoveIndex) {
        moves.addAll(game.moves.sublist(roundFirstMoveIndex));
        moves.addAll(List.filled(playerCount - moves.length, null));
      } else {
        moves.addAll(
            game.moves.sublist(roundFirstMoveIndex, nextRoundFirstMoveIndex));
      }
      gameRounds.add((roundIndex + 1, moves));
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
            for (final move in r.$2)
              move == null
                  ? SizedBox.shrink()
                  : move.word == null
                      ? Text('---')
                      : Text('${move.word}: ${move.word!.computeScore()}')
          ]),
      ],
    );
  }
}
