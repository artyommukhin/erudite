import 'package:erudite_app/domain/models/player.dart';
import 'package:erudite_app/ui/game_page.dart';
import 'package:flutter/material.dart';
import 'package:flutter/services.dart';

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
              Text('Добавленные игроки:'),
              SizedBox(height: 8),
              Column(
                crossAxisAlignment: CrossAxisAlignment.start,
                children: players.map<Widget>((e) => Text(e.name)).toList(),
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
