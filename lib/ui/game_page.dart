import 'package:erudite_app/ui/game_results_page.dart';
import 'package:erudite_app/ui/models/game.dart';
import 'package:erudite_app/domain/models/player.dart';
import 'package:erudite_app/domain/models/word.dart';
import 'package:erudite_app/ui/widgets/player_table.dart';
import 'package:erudite_app/ui/widgets/word_calculator.dart';
import 'package:flutter/material.dart';
import 'package:provider/provider.dart';

class GamePage extends StatefulWidget {
  const GamePage({
    super.key,
    required this.winScore,
    required this.players,
  });

  final int? winScore;
  final List<Player> players;

  @override
  State<GamePage> createState() => _GamePageState();
}

class _GamePageState extends State<GamePage> {
  final inputController = TextEditingController();

  Word? currentWord;
  bool allLettersUsed = false;

  void _submitWord(Game game) {
    try {
      game.move(currentWord!, allLettersUsed);
    } catch (e) {
      ScaffoldMessenger.of(context)
        ..hideCurrentSnackBar()
        ..showSnackBar(SnackBar(content: Text(e.toString())));
      return;
    }

    setState(() => inputController.clear());
  }

  @override
  Widget build(BuildContext context) {
    return ChangeNotifierProvider(
      create: (context) =>
          Game(winScore: widget.winScore)..players.addAll(widget.players),
      child: Consumer<Game>(
        builder: (context, game, child) {
          return Scaffold(
            appBar: AppBar(
              backgroundColor: Theme.of(context).colorScheme.inversePrimary,
              title: Text('Ходит ${game.currentPlayer.name}'),
            ),
            body: ListView(
              padding: EdgeInsets.symmetric(vertical: 24),
              children: [
                if (game.winScore != null) ...[
                  Padding(
                    padding: const EdgeInsets.symmetric(horizontal: 16),
                    child: Text('Очков для победы: ${game.winScore}'),
                  ),
                  SizedBox(height: 16),
                ],
                Padding(
                  padding: const EdgeInsets.symmetric(horizontal: 16),
                  child: PlayerTable(game: game),
                ),
                SizedBox(height: 16),
                WordCalculator(
                  controller: inputController,
                  onUpdate: (value) {
                    setState(() {
                      final (word, allLettersUsed) = value;
                      currentWord = word;
                      this.allLettersUsed = allLettersUsed;
                    });
                  },
                ),
                SizedBox(height: 16),
                Padding(
                  padding: const EdgeInsets.symmetric(horizontal: 16),
                  child: Column(
                    children: [
                      Row(
                        children: [
                          FilledButton(
                            onPressed: currentWord == null
                                ? null
                                : () => _submitWord(game),
                            child: Text('Ввести слово'),
                          ),
                        ],
                      ),
                      SizedBox(height: 8),
                      Row(
                        children: [
                          FilledButton(
                            onPressed: () {
                              game.skipMove();
                              setState(() => inputController.clear());
                            },
                            child: Text('Пропустить ход'),
                          ),
                        ],
                      ),
                      SizedBox(height: 8),
                      Row(
                        children: [
                          FilledButton(
                            onPressed: game.moveNumber == 1
                                ? null
                                : () => setState(() {
                                      game.revertMove();
                                    }),
                            child: Text('Отменить ход'),
                          ),
                        ],
                      ),
                      SizedBox(height: 8),
                      Row(
                        children: [
                          FilledButton(
                            onPressed: game.isFinished
                                ? null
                                : () {
                                    game.finish();
                                    Navigator.of(context)
                                        .pushReplacement(MaterialPageRoute(
                                      builder: (context) =>
                                          GameResultsPage(game: game),
                                    ));
                                  },
                            child: Text('Завершить игру'),
                          ),
                        ],
                      ),
                    ],
                  ),
                ),
              ],
            ),
          );
        },
      ),
    );
  }
}
