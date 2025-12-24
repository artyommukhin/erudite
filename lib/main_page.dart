import 'package:erudite_app/game/ui/create_game_page/create_game_page.dart';
import 'package:erudite_app/word_calculator/ui/calculator_page.dart';
import 'package:flutter/material.dart';

class MainPage extends StatefulWidget {
  const MainPage({super.key});

  @override
  State<MainPage> createState() => _MainPageState();
}

class _MainPageState extends State<MainPage> {
  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(
        title: Text('Эрудит'),
      ),
      body: Padding(
        padding: EdgeInsets.all(16),
        child: Column(
          children: [
            FilledButton(
              onPressed: () {
                Navigator.of(context).push(MaterialPageRoute(
                  builder: (context) => CreateGamePage(),
                ));
              },
              child: Text('Создать игру'),
            ),
            SizedBox(height: 8),
            FilledButton(
              onPressed: () {
                Navigator.of(context).push(MaterialPageRoute(
                  builder: (context) => CalculatorPage(),
                ));
              },
              child: Text('Калькулятор'),
            ),
          ],
        ),
      ),
    );
  }
}
