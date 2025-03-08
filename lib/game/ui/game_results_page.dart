import 'package:erudite_app/game/ui/models/game.dart';
import 'package:erudite_app/game/ui/widgets/player_table.dart';
import 'package:flutter/material.dart';

class GameResultsPage extends StatelessWidget {
  const GameResultsPage({
    super.key,
    required this.game,
  });

  final Game game;

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
          Text('Другие игроки:'),
          for (final p in sortedPlayers) Text('${p.name}: ${p.score}'),
          PlayerTable(game: game),
          FilledButton(
            onPressed: () => Navigator.of(context).pop(),
            child: Text('Ок'),
          ),
        ],
      ),
    );
  }
}
