import 'package:erudite_app/domain/models/word.dart';
import 'package:erudite_app/ui/widgets/letter.dart';
import 'package:erudite_app/domain/models/letter.dart';
import 'package:erudite_app/domain/letter_scores.dart';
import 'package:erudite_app/domain/models/multiplier.dart';
import 'package:flutter/material.dart';
import 'package:flutter/services.dart';

class WordInput extends StatefulWidget {
  const WordInput({
    super.key,
    this.controller,
    required this.onUpdate,
    required this.horizontalPadding,
    // required this.onSubmit,
  });

  final TextEditingController? controller;
  final ValueChanged<Word?> onUpdate;
  // final ValueSetter<Word> onSubmit;

  final double horizontalPadding;

  @override
  State<WordInput> createState() => _WordInputState();
}

class _WordInputState extends State<WordInput> {
  late TextEditingController _controller;
  String? _text;
  Word? _word;

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
    widget.onUpdate(word);
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
      widget.onUpdate(_word!);
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
        SizedBox(height: 16),
        if (_word != null)
          WordView(
            word: _word!,
            onLetterTap: _onLetterTap,
            horizontalPadding: widget.horizontalPadding,
          ),
      ],
    );
  }
}

class WordView extends StatelessWidget {
  const WordView({
    super.key,
    required this.word,
    required this.onLetterTap,
    required this.horizontalPadding,
  });

  final Word word;
  final void Function(int i) onLetterTap;
  final double horizontalPadding;

  @override
  Widget build(BuildContext context) {
    return SingleChildScrollView(
      padding: EdgeInsets.symmetric(horizontal: horizontalPadding),
      scrollDirection: Axis.horizontal,
      child: Row(
        children: word.letters.indexed.map((e) {
          final (i, l) = e;
          return Row(
            children: [
              Letter(
                letter: l.value.symbol,
                score: l.value.score,
                multiplier: l.multiplier,
                onMultiplierTap: () => onLetterTap(i),
              ),
              SizedBox(width: 16),
            ],
          );
        }).toList(),
      ),
    );
  }
}
