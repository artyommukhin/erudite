import 'package:erudite_app/domain/models/multiplier.dart';



class LetterDto {
  LetterDto({
    required this.value,
    required this.multiplier,
  });

  final LetterValue value;
  final Multiplier multiplier;
}

class LetterValue {
  LetterValue({
    required this.symbol,
    required this.score,
  });

  final String symbol;
  final int score;
}
