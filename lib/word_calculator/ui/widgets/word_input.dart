import 'package:erudite_app/word_calculator/domain/models/word.dart';
import 'package:erudite_app/word_calculator/domain/models/letter.dart';
import 'package:erudite_app/word_calculator/domain/letter_scores.dart';
import 'package:erudite_app/word_calculator/domain/models/multiplier.dart';
import 'package:erudite_app/word_calculator/ui/widgets/word_view.dart';
import 'package:flutter/material.dart';
import 'package:flutter/services.dart';

class WordInput extends StatefulWidget {
  const WordInput({
    super.key,
    this.controller,
    required this.onUpdate,
    required this.horizontalPadding,
  });

  final TextEditingController? controller;
  final ValueChanged<(Word?, bool)> onUpdate;

  final double horizontalPadding;

  @override
  State<WordInput> createState() => _WordInputState();
}

class _WordInputState extends State<WordInput> {
  late TextEditingController _controller;
  String? _text;
  Word? _word;
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
    final word = input.isEmpty ? null : Word(_mapInputToLetters(input));
    setState(() => _word = word);
    widget.onUpdate((word, allLettersUsed));
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

  void _onLetterTap(int i) {
    setState(() {
      final current = _word!.letters[i];
      final newMultiplier = Multiplier
          .values[(current.multiplier.index + 1) % Multiplier.values.length];
      _word!.letters[i] = LetterDto(
        value: current.value,
        multiplier: newMultiplier,
      );
      widget.onUpdate((_word!, allLettersUsed));
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
              FilteringTextInputFormatter.allow(RegExp(r'[ЁёА-я]')),
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
        if (_word != null) ...[
          SizedBox(height: 8),
          CheckboxListTile(
            controlAffinity: ListTileControlAffinity.leading,
            value: allLettersUsed,
            onChanged: (value) {
              setState(() => allLettersUsed = value ?? false);
              widget.onUpdate((_word!, allLettersUsed));
            },
            title: Text('Использованы все буквы с руки'),
          ),
          SizedBox(height: 8),
          WordView(
            word: _word!,
            onLetterTap: _onLetterTap,
            horizontalPadding: widget.horizontalPadding,
          ),
        ],
      ],
    );
  }
}
