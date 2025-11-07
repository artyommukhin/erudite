import 'package:flutter/material.dart';

enum Multiplier {
  none,
  letterX2,
  letterX3,
  wordX2,
  wordX3;

  Multiplier get next => values[(index + 1) % values.length];

  bool get isForLetter =>
      this == Multiplier.letterX2 || this == Multiplier.letterX3;

  bool get isForWord => this == Multiplier.wordX2 || this == Multiplier.wordX3;

  int get forLetter => switch (this) {
        Multiplier.none => 1,
        Multiplier.letterX2 => 2,
        Multiplier.letterX3 => 3,
        Multiplier.wordX2 => 1,
        Multiplier.wordX3 => 1,
      };

  int get forWord => switch (this) {
        Multiplier.none => 1,
        Multiplier.letterX2 => 1,
        Multiplier.letterX3 => 1,
        Multiplier.wordX2 => 2,
        Multiplier.wordX3 => 3,
      };

  String get name => switch (this) {
        Multiplier.none => 'x1',
        Multiplier.letterX2 => 'буква x2',
        Multiplier.letterX3 => 'буква x3',
        Multiplier.wordX2 => 'слово x2',
        Multiplier.wordX3 => 'слово x3',
      };

  Color get color => switch (this) {
        Multiplier.none => Colors.transparent,
        Multiplier.letterX2 => Colors.green,
        Multiplier.letterX3 => Colors.yellow,
        Multiplier.wordX2 => Colors.blue,
        Multiplier.wordX3 => Colors.red,
      };
}
