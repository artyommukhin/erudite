import 'package:erudite_app/can_exit_controller.dart';
import 'package:erudite_app/game/ui/game_results_page.dart';
import 'package:erudite_app/game/ui/leave_confirmation_dialog.dart';
import 'package:erudite_app/game/ui/models/game.dart';
import 'package:erudite_app/game/domain/models/player.dart';
import 'package:erudite_app/game/ui/widgets/player_table.dart';
import 'package:erudite_app/game_route_observer.dart';
import 'package:erudite_app/word_calculator/ui/widgets/word_calculator.dart';
import 'package:erudite_app/word_calculator/ui/widgets/word_input/word_input_controller.dart';
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

class _GamePageState extends State<GamePage> with RouteAware {
  final _wordsController = WordInputController();
  late GameRouteObserver _routeObserver;

  void _submitWord(Game game) {
    try {
      game.move(_wordsController.words, _wordsController.allLettersUsed);
    } catch (e) {
      ScaffoldMessenger.of(context)
        ..hideCurrentSnackBar()
        ..showSnackBar(SnackBar(content: Text(e.toString())));
      return;
    }

    _wordsController.clear();
  }

  @override
  void didChangeDependencies() {
    super.didChangeDependencies();
    _routeObserver = context.watch<GameRouteObserver>()
      ..subscribe(this, ModalRoute.of(context)!);
  }

  @override
  void dispose() {
    _routeObserver.unsubscribe(this);
    super.dispose();
  }

  @override
  void didPush() {
    context.read<CanExitController>().forbid();
  }

  @override
  Widget build(BuildContext context) {
    return ChangeNotifierProvider(
      create: (context) => Game(
        players: widget.players,
        winScore: widget.winScore,
      ),
      child: Consumer<Game>(
        builder: (context, game, child) {
          return PopScope(
            canPop: false,
            onPopInvokedWithResult: (didPop, result) async {
              if (didPop) return;
              final shouldPop = await showLeaveConfirmationDialog(context);
              if (shouldPop == true && context.mounted) {
                Navigator.of(context).pop();
              }
            },
            child: Scaffold(
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
                    wordsController: _wordsController,
                  ),
                  SizedBox(height: 16),
                  Padding(
                    padding: const EdgeInsets.symmetric(horizontal: 16),
                    child: Column(
                      children: [
                        Row(
                          children: [
                            ValueListenableBuilder(
                              valueListenable: _wordsController,
                              builder: (context, value, child) {
                                return FilledButton(
                                  onPressed: value.words.isEmpty
                                      ? null
                                      : () => _submitWord(game),
                                  child: Text('Ввести слово'),
                                );
                              },
                            ),
                          ],
                        ),
                        SizedBox(height: 8),
                        Row(
                          children: [
                            FilledButton(
                              onPressed: () {
                                game.skipMove();
                                _wordsController.clear();
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
                                  : () => game.revertMove(),
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
                                      context.read<CanExitController>().allow();
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
            ),
          );
        },
      ),
    );
  }
}
