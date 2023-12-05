import "dart:math";
import 'dart:async';
import 'dart:io';

class Card {
  int id;
  Set<int> winningNums;
  Set<int> chosenNums;
  Card({
    required this.id,
    required this.winningNums,
    required this.chosenNums,
  });

  Set<int> get commonNums {
    return winningNums.intersection(chosenNums);
  }

  int get winningNumberCount {
    return commonNums.length;
  }

  int get pointValue {
    return pow(2, winningNumberCount - 1).toInt();
  }

  @override
  String toString() =>
      'Card(id: $id, winningNums: $winningNums, chosenNums: $chosenNums)';
}

Future<void> Day4ScratchCards() async {
  var input = await File('assets/day4_input_scratch_cards.txt').readAsLines();
  final cards = <Card>[];
  RegExp exp = RegExp(
      r"Card\s+(?<cardId>\d{1,}):\s+(?<winningNums>[\s|\d]+) \|\s+(?<chosenNums>[\s|\d]+)$");

  for (var line in input) {
    final m = exp.firstMatch(line);
    final cardId = int.parse(m!.namedGroup('cardId')!);
    final winningNumsString = m.namedGroup('winningNums');
    final chosenNumsString = m.namedGroup('chosenNums');
    final winningNums = getNumbers(winningNumsString!);
    final chosenNums = getNumbers(chosenNumsString!);
    final c =
        Card(id: cardId, winningNums: winningNums, chosenNums: chosenNums);
    print(c);
    cards.add(c);
    final sum =
        cards.fold(0, (previousValue, card) => previousValue + card.pointValue);
    print('Sum of points values: $sum');
  }
}

Set<int> getNumbers(String numberString) {
  RegExp exp = RegExp(r"\d+");
  return exp
      .allMatches(numberString)
      .map((e) => int.parse(e[0].toString()))
      .toSet();
}
