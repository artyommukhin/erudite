import 'package:erudite_app/ui/models/game.dart';
import 'package:erudite_app/ui/widgets/player_table.dart';
import 'package:flutter/material.dart';

class GameResultsPage extends StatelessWidget {
  const GameResultsPage({
    super.key,
    required this.game,
  });

  final Game game;

  @override
  Widget build(BuildContext context) {
    final winner = (game.players..sort((a, b) => b.score - a.score)).first;

    return Scaffold(
      appBar: AppBar(
        title: Text('Игра закончена'),
      ),
      body: ListView(
        padding: EdgeInsets.symmetric(horizontal: 16, vertical: 24),
        children: [
          Center(child: Text('Победитель: $winner')),
          Text('Другие игроки:'),
          for (final p in game.players) Text('${p.name}: ${p.score}'),
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
