import 'package:erudite_app/domain/models/multiplier.dart';
import 'package:flutter/material.dart';

class Letter extends StatelessWidget {
  const Letter({
    super.key,
    required this.letter,
    required this.score,
    required this.multiplier,
    required this.onMultiplierTap,
  });

  final String letter;
  final int score;
  final Multiplier multiplier;
  final VoidCallback onMultiplierTap;

  @override
  Widget build(BuildContext context) {
    return Column(
      children: [
        InkWell(
          onTap: onMultiplierTap,
          child: Container(
            width: 64,
            height: 64,
            padding: EdgeInsets.all(8),
            decoration: BoxDecoration(
              color: multiplier.color,
              border: Border.all(color: Colors.green),
              borderRadius: BorderRadius.all(Radius.circular(4)),
            ),
            child: Column(
              mainAxisAlignment: MainAxisAlignment.spaceBetween,
              children: [
                Align(
                  alignment: Alignment.centerLeft,
                  child: Text(
                    letter.toUpperCase(),
                    style: TextStyle(fontSize: 18),
                  ),
                ),
                Align(
                  alignment: Alignment.centerRight,
                  child: Text(score.toString()),
                ),
              ],
            ),
          ),
        ),
        SizedBox(height: 8),
        Text(multiplier.name)
      ],
    );
  }
}
