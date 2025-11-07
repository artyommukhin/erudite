import 'package:erudite_app/word_calculator/domain/models/multiplier.dart';

class LetterDto {
  LetterDto({
    required this.value,
    required this.multiplier,
  });

  final LetterValue value;
  final Multiplier multiplier;

  @override
  bool operator ==(Object other) {
    return other is LetterDto &&
        other.runtimeType == runtimeType &&
        other.value == value &&
        other.multiplier == multiplier;
  }

  @override
  int get hashCode => Object.hash(value, multiplier);
}

class LetterValue {
  LetterValue({
    required this.symbol,
    required this.score,
  });

  final String symbol;
  final int score;

  @override
  bool operator ==(Object other) {
    return other is LetterValue &&
        other.runtimeType == runtimeType &&
        other.symbol == symbol &&
        other.score == score;
  }

  @override
  int get hashCode => Object.hash(symbol, score);
}
