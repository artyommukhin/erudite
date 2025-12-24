import 'package:erudite_app/can_exit_controller.dart';
import 'package:erudite_app/game/domain/models/player.dart';
import 'package:erudite_app/game/ui/game_page.dart';
import 'package:flutter/material.dart';
import 'package:flutter/services.dart';
import 'package:provider/provider.dart';

import 'widgets/player_list_item.dart';

class CreateGamePage extends StatefulWidget {
  const CreateGamePage({super.key});

  @override
  State<CreateGamePage> createState() => _CreateGamePageState();
}

class _CreateGamePageState extends State<CreateGamePage> {
  List<Player> players = [];
  int? winScore;

  final playerNameController = TextEditingController();

  void _updateCanExit() {
    final canExit = context.read<CanExitController>();
    if (players.isNotEmpty || winScore != null) {
      canExit.forbid();
    } else {
      canExit.allow();
    }
  }

  void _addPlayer(String name) {
    setState(() {
      players.add(Player(name: name));
      playerNameController.clear();
      _updateCanExit();
    });
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
              textInputAction: TextInputAction.next,
              onChanged: (value) => setState(() {
                winScore = int.tryParse(value);
                _updateCanExit();
              }),
            ),
            SizedBox(height: 16),
            ValueListenableBuilder(
              valueListenable: playerNameController,
              builder: (context, playerNameValue, child) {
                final playerName = playerNameValue.text;
                return TextField(
                  controller: playerNameController,
                  decoration: InputDecoration(
                    border: OutlineInputBorder(),
                    labelText: 'Добавить игрока',
                    floatingLabelBehavior: FloatingLabelBehavior.always,
                    suffix: IconButton(
                      onPressed: playerName == ''
                          ? null
                          : () => _addPlayer(playerName),
                      icon: Icon(Icons.add),
                    ),
                  ),
                  textInputAction: TextInputAction.none,
                  onSubmitted: _addPlayer,
                );
              },
            ),
            SizedBox(height: 16),
            if (players.isNotEmpty) ...[
              ReorderableListView(
                shrinkWrap: true,
                header: Text(
                  'Добавленные игроки\nВыберите первого игрока на этом экране, пока можно поменять порядок',
                  textAlign: TextAlign.center,
                ),
                onReorder: (oldIndex, newIndex) {
                  setState(() {
                    if (oldIndex < newIndex) newIndex--;
                    final player = players.removeAt(oldIndex);
                    players.insert(newIndex, player);
                  });
                },
                children: players.indexed.map<Widget>((e) {
                  final (index, player) = e;
                  return PlayerListItem(
                    key: ValueKey(player),
                    index: index,
                    name: player.name,
                    onRemove: () => setState(() {
                      players.removeAt(index);
                      _updateCanExit();
                    }),
                  );
                }).toList(),
              ),
              SizedBox(height: 16),
            ],
            Center(
              child: FilledButton(
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
            ),
          ],
        ),
      ),
    );
  }
}
