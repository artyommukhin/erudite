import 'package:erudite_app/domain/models/word.dart';
import 'package:erudite_app/ui/widgets/word_input.dart';
import 'package:flutter/material.dart';

class WordCalculator extends StatefulWidget {
  const WordCalculator({
    super.key,
    this.horizontalPadding = 16,
    this.onUpdate,
    this.controller,
  });

  final double horizontalPadding;
  final ValueSetter<(Word?, bool)>? onUpdate;
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
            final (word, allLettersUsed) = result;
            setState(() {
              _score = word?.computeScore() ?? 0;
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
