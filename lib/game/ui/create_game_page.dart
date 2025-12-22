import 'package:erudite_app/can_exit_controller.dart';
import 'package:erudite_app/game/domain/models/player.dart';
import 'package:erudite_app/game/ui/game_page.dart';
import 'package:flutter/material.dart';
import 'package:flutter/services.dart';
import 'package:provider/provider.dart';

class CreateGamePage extends StatefulWidget {
  const CreateGamePage({super.key});

  @override
  State<CreateGamePage> createState() => _CreateGamePageState();
}

class _CreateGamePageState extends State<CreateGamePage> {
  List<Player> players = [];
  int? winScore;

  final playerNameController = TextEditingController();
  String? playerName;

  void _updateCanExit() {
    final canExit = context.read<CanExitController>();
    if (players.isNotEmpty || winScore != null) {
      canExit.forbid();
    } else {
      canExit.allow();
    }
  }

  @override
  Widget build(BuildContext context) {
    final canStartGame = players.length >= 2;

    return Scaffold(
      appBar: AppBar(
        title: Text('Создание игры'),
      ),
      body: Padding(
        padding: const EdgeInsets.symmetric(horizontal: 16, vertical: 24),
        child: Column(
          crossAxisAlignment: CrossAxisAlignment.start,
          children: [
            TextField(
              decoration: InputDecoration(
                border: OutlineInputBorder(),
                labelText: 'Очков для победы',
                floatingLabelBehavior: FloatingLabelBehavior.always,
                hintText: '∞',
                hintStyle: TextStyle(color: Colors.grey),
              ),
              inputFormatters: [
                FilteringTextInputFormatter.allow(RegExp(r'[0-9]')),
              ],
              onChanged: (value) => setState(() {
                winScore = int.tryParse(value);
                _updateCanExit();
              }),
            ),
            SizedBox(height: 16),
            TextField(
              controller: playerNameController,
              decoration: InputDecoration(
                  border: OutlineInputBorder(),
                  labelText: 'Добавить игрока',
                  floatingLabelBehavior: FloatingLabelBehavior.always,
                  suffixIcon: playerName == null || playerName == ''
                      ? null
                      : IconButton(
                          onPressed: () {
                            setState(() {
                              players.add(Player(name: playerName!));
                              playerNameController.clear();
                              _updateCanExit();
                            });
                          },
                          icon: Icon(Icons.add))),
              onChanged: (value) {
                setState(() {
                  playerName = value;
                });
              },
            ),
            SizedBox(height: 16),
            if (players.isNotEmpty) ...[
              ReorderableListView(
                shrinkWrap: true,
                header: Text('Добавленные игроки:'),
                onReorder: (oldIndex, newIndex) {
                  setState(() {
                    final player = players.removeAt(oldIndex);
                    players.insert(newIndex, player);
                  });
                },
                children: players.indexed.map<Widget>((e) {
                  final (index, player) = e;
                  return ListTile(
                    key: ValueKey(player),
                    title: Text(player.name),
                    trailing: ReorderableDragStartListener(
                      index: index,
                      child: const Icon(Icons.drag_handle),
                    ),
                  );
                }).toList(),
              ),
              SizedBox(height: 16),
            ],
            FilledButton(
              onPressed: !canStartGame
                  ? null
                  : () {
                      Navigator.of(context).pushReplacement(MaterialPageRoute(
                        builder: (context) => GamePage(
                          winScore: winScore,
                          players: players,
                        ),
                      ));
                    },
              child: Text('Начать игру'),
            ),
          ],
        ),
      ),
    );
  }
}
