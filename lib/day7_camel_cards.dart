import 'dart:async';
import 'dart:io';

enum HandType { highCard, onePair, twoPair, threeOfAKind, fullHouse, fourOfAKind, fiveOfAKind }

class Hand implements Comparable<Hand> {
  List<String> cards;
  int bid;
  Hand({
    required this.cards,
    required this.bid,
  });

  Map<String, int> get valueCounts {
    final counts = <String, int>{};
    for (var c in cards) {
      if (counts.containsKey(c)) {
        counts[c] = counts[c]! + 1;
      } else {
        counts[c] = 1;
      }
    }
    return counts;
  }

  static int getCardWeight(String c) {
    switch (c) {
      case 'A':
        return 14;
      case 'K':
        return 13;
      case 'Q':
        return 12;
      case 'J':
        return 11;
      case 'T':
        return 10;
      default:
        return int.parse(c);
    }
  }

  HandType get handType {
    if (valueCounts.containsValue(5)) return HandType.fiveOfAKind;
    if (valueCounts.containsValue(4)) return HandType.fourOfAKind;
    if (valueCounts.containsValue(3) && valueCounts.containsValue(2)) return HandType.fullHouse;
    if (valueCounts.containsValue(3)) return HandType.threeOfAKind;
    if (valueCounts.values.where((value) => value == 2).length == 2) return HandType.twoPair;
    if (valueCounts.containsValue(2)) return HandType.onePair;
    return HandType.highCard;
  }

  @override
  String toString() => 'Hand(cards: $cards, bid: $bid, type: $handType)';

  @override
  int compareTo(Hand other) {
    final typeComp = handType.index.compareTo(other.handType.index);
    if (typeComp != 0) {
      return typeComp;
    }
    for (var i = 0; i < cards.length; i++) {
      final weightComp = Hand.getCardWeight(cards[i]).compareTo(Hand.getCardWeight(other.cards[i]));
      if (weightComp != 0) return weightComp;
    }
    return 0;
  }
}

Future<void> Day7CamelCards() async {
  final input = await File('assets/day7_camel_cards.txt').readAsLines();
  final hands = getHandsFromInput(input);
  hands.sort();
  print(hands.join('\n'));

  var winnings = 0;
  for (var i = 0; i < hands.length; i++) {
    final rank = i + 1;
    winnings += hands[i].bid * rank;
  }
  print('Winnings: $winnings');
}

List<Hand> getHandsFromInput(List<String> input) {
  return input.map((e) {
    final tokens = e.split(' ');
    return Hand(cards: tokens[0].split(''), bid: int.parse(tokens[1]));
  }).toList();
}
