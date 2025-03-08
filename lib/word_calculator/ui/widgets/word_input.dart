import 'package:erudite_app/word_calculator/domain/models/word.dart';
import 'package:erudite_app/word_calculator/domain/models/letter.dart';
import 'package:erudite_app/word_calculator/domain/letter_scores.dart';
import 'package:erudite_app/word_calculator/domain/models/multiplier.dart';
import 'package:erudite_app/word_calculator/ui/widgets/word_view.dart';
import 'package:flutter/material.dart';
import 'package:flutter/services.dart';
import 'package:separate/separate.dart';

class WordInput extends StatefulWidget {
  const WordInput({
    super.key,
    this.controller,
    required this.onUpdate,
    required this.horizontalPadding,
  });

  final TextEditingController? controller;
  final ValueChanged<(List<Word>, bool)> onUpdate;

  final double horizontalPadding;

  @override
  State<WordInput> createState() => _WordInputState();
}

class _WordInputState extends State<WordInput> {
  late TextEditingController _controller;
  String? _text;
  List<Word> _words = [];
  bool allLettersUsed = false;

  @override
  void initState() {
    super.initState();
    _controller = widget.controller ?? TextEditingController();

    _controller.addListener(() {
      final input = _controller.text;
      if (input != _text) {
        _text = input;
        _onInputUpdate(input);
      }
    });
  }

  void _onInputUpdate(String input) {
    final filteredInput = input.trim();
    if (filteredInput.isEmpty) {
      setState(() => _words = []);
      widget.onUpdate((_words, allLettersUsed));
      return;
    }

    final words = filteredInput
        .trim()
        .split(' ')
        .where((element) => element.isNotEmpty)
        .map((e) {
      final letters = _mapInputToLetters(e);
      return Word(letters);
    }).toList();

    setState(() => _words = words);
    widget.onUpdate((words, allLettersUsed));
  }

  List<LetterDto> _mapInputToLetters(String input) {
    final letters = input.characters.map((e) {
      final score = letterScores[e.toLowerCase()];
      if (score == null) {
        throw Exception('Unknown letter: $e');
      }

      return LetterDto(
        value: LetterValue(symbol: e, score: score),
        multiplier: Multiplier.none,
      );
    }).toList();

    return letters;
  }

  void _onWordLetterTap(int wordIndex, int letterIndex) {
    setState(() {
      final currentWord = _words[wordIndex];
      final currentLetter = currentWord.letters[letterIndex];

      final newMultiplier = Multiplier.values[
          (currentLetter.multiplier.index + 1) % Multiplier.values.length];
      currentWord.letters[letterIndex] = LetterDto(
        value: currentLetter.value,
        multiplier: newMultiplier,
      );
      _words[wordIndex] = currentWord;
      widget.onUpdate((_words, allLettersUsed));
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
        if (_words.isNotEmpty) ...[
          SizedBox(height: 8),
          CheckboxListTile(
            controlAffinity: ListTileControlAffinity.leading,
            value: allLettersUsed,
            onChanged: (value) {
              setState(() => allLettersUsed = value ?? false);
              widget.onUpdate((_words, allLettersUsed));
            },
            title: Text('Использованы все буквы с руки'),
          ),
          SizedBox(height: 8),
          ..._words.indexed
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
