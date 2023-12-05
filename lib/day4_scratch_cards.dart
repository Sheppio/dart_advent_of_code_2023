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

    final cardCounts = <int, int>{};
    for (var card in cards) {
      cardCounts[card.id] = 1;
    }
    for (var card in cards) {
      final id = card.id;
      final wins = card.winningNumberCount;
      for (var v = 0; v < cardCounts[id]!; v++) {
        for (var i = 1; i <= wins; i++) {
          final idToInc = id + i;
          if (cardCounts.containsKey(idToInc)) {
            cardCounts[idToInc] = cardCounts[idToInc]! + 1;
          }
        }
      }
    }
    final cardCount = cardCounts.values
        .fold(0, (previousValue, element) => previousValue + element);
    print('card count: $cardCount');
  }
}

Set<int> getNumbers(String numberString) {
  RegExp exp = RegExp(r"\d+");
  return exp
      .allMatches(numberString)
      .map((e) => int.parse(e[0].toString()))
      .toSet();
}
