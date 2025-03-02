import 'package:erudite_app/word_calculator/ui/widgets/word_calculator.dart';
import 'package:flutter/material.dart';

class CalculatorPage extends StatelessWidget {
  const CalculatorPage({super.key});

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(
        title: Text('Калькулятор слов'),
      ),
      body: ListView(
        padding: EdgeInsets.symmetric(vertical: 24),
        children: [
          WordCalculator(),
        ],
      ),
    );
  }
}
