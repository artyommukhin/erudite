import 'package:erudite_app/word_calculator/domain/models/word.dart';
import 'package:erudite_app/word_calculator/ui/widgets/letter.dart';
import 'package:flutter/material.dart';

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
