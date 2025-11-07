import 'package:erudite_app/word_calculator/domain/models/letter.dart';
import 'package:erudite_app/word_calculator/ui/widgets/word_input/word_input_controller.dart';
import 'package:erudite_app/word_calculator/ui/widgets/word_view.dart';
import 'package:flutter/material.dart';
import 'package:flutter/services.dart';
import 'package:separate/separate.dart';

class WordInput extends StatefulWidget {
  const WordInput({
    super.key,
    required this.horizontalPadding,
    this.wordsController,
  });

  final double horizontalPadding;
  final WordInputController? wordsController;

  @override
  State<WordInput> createState() => _WordInputState();
}

class _WordInputState extends State<WordInput> {
  final _controller = TextEditingController();
  late WordInputController _wordsController;

  String? _text;

  @override
  void initState() {
    super.initState();
    _wordsController = widget.wordsController ?? WordInputController();

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
    setState(() {
      final words = _wordsController.words;
      final currentWord = words[wordIndex];
      final currentLetter = currentWord.letters[letterIndex];
      final newMultiplier = currentLetter.multiplier.next;

      currentWord.letters[letterIndex] = LetterDto(
        value: currentLetter.value,
        multiplier: newMultiplier,
      );

      words[wordIndex] = currentWord;
      _wordsController.updateWords(words);
    });
  }

  @override
  Widget build(BuildContext context) {
    return Column(
      children: [
        Padding(
          padding: EdgeInsets.symmetric(horizontal: widget.horizontalPadding),
          child: TextField(
            controller: _controller,
            inputFormatters: [
              FilteringTextInputFormatter.allow(RegExp(r'[ЁёА-я ]')),
            ],
            decoration: InputDecoration(
              border: OutlineInputBorder(),
              suffixIcon: IconButton(
                onPressed: () => _controller.clear(),
                icon: Icon(Icons.clear),
              ),
            ),
          ),
        ),
        if (_wordsController.words.isNotEmpty) ...[
          SizedBox(height: 8),
          CheckboxListTile(
            controlAffinity: ListTileControlAffinity.leading,
            value: _wordsController.allLettersUsed,
            onChanged: (value) {
              _wordsController.updateAllLettersUsed(value ?? false);
            },
            title: Text('Использованы все буквы с руки'),
          ),
          SizedBox(height: 8),
          ..._wordsController.words.indexed
              .map<Widget>((word) => WordView(
                    word: word.$2,
                    onLetterTap: (letterIndex) =>
                        _onWordLetterTap(word.$1, letterIndex),
                    horizontalPadding: widget.horizontalPadding,
                  ))
              .separate((i, e0, e1) => SizedBox(height: 8)),
        ],
      ],
    );
  }
}
