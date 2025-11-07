import 'package:erudite_app/word_calculator/domain/models/word.dart';
import 'package:erudite_app/word_calculator/ui/widgets/word_input/word_input.dart';
import 'package:erudite_app/word_calculator/ui/widgets/word_input/word_input_controller.dart';
import 'package:flutter/foundation.dart';
import 'package:flutter/material.dart';

class WordCalculator extends StatefulWidget {
  const WordCalculator({
    super.key,
    this.horizontalPadding = 16,
    this.onUpdate,
    this.wordsController,
  });

  final double horizontalPadding;
  final ValueSetter<(List<Word>, bool)>? onUpdate;
  final WordInputController? wordsController;

  @override
  State<WordCalculator> createState() => _WordCalculatorState();
}

class _WordCalculatorState extends State<WordCalculator> {
  late WordInputController _wordsController;
  late List<Word> _words;
  late bool _allLettersUsed;

  int _score = 0;

  @override
  void initState() {
    super.initState();
    _wordsController = widget.wordsController ?? WordInputController();
    _words = _wordsController.words;
    _allLettersUsed = _wordsController.allLettersUsed;

    _wordsController.addListener(_recalculateScore);
    _wordsController.addListener(() {
      if (_wordsController.allLettersUsed != _allLettersUsed ||
          !listEquals(_wordsController.words, _words)) {
        setState(() {
          _allLettersUsed = _wordsController.allLettersUsed;
          _words = _wordsController.words;
        });
        widget.onUpdate?.call((_words, _allLettersUsed));
      }
    });
  }

  void _recalculateScore() {
    setState(() {
      _score = _wordsController.words
          .fold<int>(0, (prev, w) => prev + w.computeScore());
      if (_wordsController.allLettersUsed) _score += 15;
    });
  }

  @override
  Widget build(BuildContext context) {
    return Column(
      children: [
        WordInput(
          wordsController: _wordsController,
          horizontalPadding: widget.horizontalPadding,
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
