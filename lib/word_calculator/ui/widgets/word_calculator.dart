import 'package:erudite_app/word_calculator/domain/models/word.dart';
import 'package:erudite_app/word_calculator/ui/widgets/word_input.dart';
import 'package:flutter/material.dart';

class WordCalculator extends StatefulWidget {
  const WordCalculator({
    super.key,
    this.horizontalPadding = 16,
    this.onUpdate,
    this.controller,
  });

  final double horizontalPadding;
  final ValueSetter<(List<Word>, bool)>? onUpdate;
  final TextEditingController? controller;

  @override
  State<WordCalculator> createState() => _WordCalculatorState();
}

class _WordCalculatorState extends State<WordCalculator> {
  int _score = 0;

  @override
  Widget build(BuildContext context) {
    return Column(
      children: [
        WordInput(
          controller: widget.controller,
          horizontalPadding: widget.horizontalPadding,
          onUpdate: (result) {
            widget.onUpdate?.call(result);
            final (words, allLettersUsed) = result;
            setState(() {
              _score = words.fold<int>(0, (prev, w) => prev + w.computeScore());
              if (allLettersUsed) _score += 15;
            });
          },
        ),
        if (_score != 0) ...[
          SizedBox(height: 16),
          Center(
            child: Text(
              'Сумма: $_score',
              style: TextStyle(fontSize: 24),
            ),
          ),
        ]
      ],
    );
  }
}
