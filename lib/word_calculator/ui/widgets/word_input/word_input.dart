import 'package:erudite_app/word_calculator/ui/widgets/word_input/word_input_controller.dart';
import 'package:erudite_app/word_calculator/ui/widgets/word_view.dart';
import 'package:flutter/material.dart';
import 'package:flutter/services.dart';
import 'package:separate/separate.dart';

class WordInput extends StatefulWidget {
  const WordInput({
    super.key,
    this.horizontalPadding = 16,
    this.wordsController,
    this.onSubmit,
  });

  final double horizontalPadding;
  final WordInputController? wordsController;
  final ValueChanged<WordInputValue>? onSubmit;

  @override
  State<WordInput> createState() => _WordInputState();
}

class _WordInputState extends State<WordInput> {
  final _controller = TextEditingController();
  late WordInputController _wordsController;

  int _score = 0;
  String? _text;

  @override
  void initState() {
    super.initState();
    _wordsController = widget.wordsController ?? WordInputController();
    _wordsController.addListener(_recalculateScore);

    _controller.addListener(() {
      final input = _controller.text;
      if (input != _text) {
        _text = input;
        _wordsController.text = input;
      }
    });

    _wordsController.addListener(() {
      if (_wordsController.words.isEmpty) {
        _controller.clear();
      }
    });
  }

  void _onWordLetterTap(int wordIndex, int letterIndex) {
    _wordsController.updateLetterMultiplier(wordIndex, letterIndex);
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
        if (_score != 0) ...[
          Center(
            child: Text(
              'Сумма: $_score',
              style: TextStyle(fontSize: 24),
            ),
          ),
          SizedBox(height: 16),
        ],
        ValueListenableBuilder(
          valueListenable: _wordsController,
          builder: (context, wordInputValue, child) {
            if (wordInputValue.words.isEmpty) return SizedBox();
            return Column(
              children: [
                ...wordInputValue.words.indexed
                    .map<Widget>((word) => WordView(
                          word: word.$2,
                          onLetterTap: (letterIndex) =>
                              _onWordLetterTap(word.$1, letterIndex),
                          horizontalPadding: widget.horizontalPadding,
                        ))
                    .separate((i, e0, e1) => SizedBox(height: 8)),
                SizedBox(height: 8),
                CheckboxListTile(
                  controlAffinity: ListTileControlAffinity.leading,
                  value: wordInputValue.allLettersUsed,
                  onChanged: (value) {
                    _wordsController.updateAllLettersUsed(value ?? false);
                  },
                  title: Text('Использованы все буквы с руки'),
                ),
                SizedBox(height: 8),
              ],
            );
          },
        ),
        Padding(
          padding: EdgeInsets.symmetric(horizontal: widget.horizontalPadding),
          child: TextField(
            autofocus: true,
            controller: _controller,
            inputFormatters: [
              FilteringTextInputFormatter.allow(RegExp(r'[ЁёА-я ]')),
            ],
            textInputAction: TextInputAction.none,
            onSubmitted: widget.onSubmit == null
                ? null
                : (_) => widget.onSubmit!(_wordsController.value),
            decoration: InputDecoration(
              border: OutlineInputBorder(),
              suffix: widget.onSubmit == null
                  ? null
                  : ValueListenableBuilder(
                      valueListenable: _wordsController,
                      builder: (context, value, child) {
                        return IconButton(
                          onPressed: value.words.isEmpty
                              ? null
                              : () => widget.onSubmit!(value),
                          icon: Icon(Icons.send),
                        );
                      },
                    ),
            ),
          ),
        ),
      ],
    );
  }
}
