import 'package:erudite_app/can_exit_controller.dart';
import 'package:erudite_app/game/ui/finish_confirmation_dialog.dart';
import 'package:erudite_app/game/ui/game_results_page.dart';
import 'package:erudite_app/game/ui/leave_confirmation_dialog.dart';
import 'package:erudite_app/game/ui/models/game.dart';
import 'package:erudite_app/game/domain/models/player.dart';
import 'package:erudite_app/game/ui/widgets/player_table.dart';
import 'package:erudite_app/game_route_observer.dart';
import 'package:erudite_app/word_calculator/ui/widgets/word_input/word_input.dart';
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

  void _submitWord(WordInputValue value, Game game) {
    try {
      game.move(value.words, value.allLettersUsed);
    } catch (e) {
      ScaffoldMessenger.of(context)
        ..hideCurrentSnackBar()
        ..showSnackBar(SnackBar(content: Text(e.toString())));
      return;
    }

    _wordsController.clear();
  }

  void _navigateToResults(Game game) {
    Navigator.of(context).pushReplacement(MaterialPageRoute(
      builder: (context) => GameResultsPage(game: game),
    ));
    context.read<CanExitController>().allow();
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
      create: (context) {
        final game = Game(
          players: widget.players,
          winScore: widget.winScore,
        );
        game.addListener(() {
          if (game.isFinished) _navigateToResults(game);
        });
        return game;
      },
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
                actionsPadding: EdgeInsets.only(right: 8),
                actions: [
                  IconButton(
                    onPressed: () {
                      game.skipMove();
                      _wordsController.clear();
                    },
                    icon: Icon(Icons.skip_next),
                    tooltip: 'Пропустить ход',
                  ),
                  IconButton(
                    onPressed:
                        game.moveNumber == 1 ? null : () => game.revertMove(),
                    icon: Icon(Icons.backspace),
                    tooltip: 'Отменить ход',
                  ),
                  IconButton(
                    onPressed: () async {
                      final shouldFinish =
                          await showFinishConfirmationDialog(context);
                      if (shouldFinish == true && context.mounted) {
                        game.finish();
                        _navigateToResults(game);
                      }
                    },
                    icon: Icon(Icons.exit_to_app),
                    tooltip: 'Завершить игру',
                  ),
                ],
              ),
              body: Padding(
                padding: EdgeInsets.symmetric(vertical: 16),
                child: Column(
                  children: [
                    if (game.winScore != null) ...[
                      Padding(
                        padding: const EdgeInsets.symmetric(horizontal: 16),
                        child: Text('Очков для победы: ${game.winScore}'),
                      ),
                      SizedBox(height: 16),
                    ],
                    Expanded(
                      child: SingleChildScrollView(
                        padding: const EdgeInsets.only(
                          left: 16,
                          right: 16,
                          bottom: 16,
                        ),
                        child: PlayerTable(game: game),
                      ),
                    ),
                    WordInput(
                      wordsController: _wordsController,
                      onSubmit: (value) => _submitWord(value, game),
                    ),
                  ],
                ),
              ),
            ),
          );
        },
      ),
    );
  }
}
