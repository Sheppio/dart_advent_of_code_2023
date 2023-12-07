import 'dart:async';
import 'dart:collection';
import 'dart:io';

enum HandType { highCard, onePair, twoPair, threeOfAKind, fullHouse, fourOfAKind, fiveOfAKind }

extension CardHelper on String {
  int cardWeight() {
    return Hand.getCardWeight(this);
  }
  // ···
}

class Hand implements Comparable<Hand> {
  List<String> cards;
  List<String> originalCards;
  int bid;
  Hand({
    required this.cards,
    required this.originalCards,
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

  Hand get bestJokeredHand {
    final jokeredHands = createJokerHandList(this);
    jokeredHands.sort();
    final bjh = jokeredHands.last;
    print('${bjh} --> (${cards.where((element) => element == 'J').length}) : ${jokeredHands.length}');
    return bjh;
  }

  static List<Hand> createJokerHandList(Hand hand) {
    final indexOfJ = hand.cards.indexOf('J');
    if (indexOfJ < 0) return [hand];
    final possibleCards = ['2', '3', '4', '5', '6', '7', '8', '9', 'T', 'Q', 'K', 'A'];
    final newHands = <Hand>[];
    for (var card in possibleCards) {
      final newCards = List<String>.from(hand.cards);
      newCards[indexOfJ] = card;
      final newHand = Hand(cards: newCards, originalCards: List<String>.from(hand.originalCards), bid: hand.bid);
      if (newHand.cards.contains('J')) {
        newHands.addAll(createJokerHandList(newHand));
      } else {
        newHands.add(newHand);
      }
    }
    return newHands;
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

  // HandType get handType {
  //   String highCard = cards[0];
  //   String? pair = null;
  //   if (cards[1] == highCard) {
  //     pair = cards[1];
  //   } else if (cards[1].cardWeight() > cards[0].cardWeight()) highCard = cards[1];
  // }

  @override
  String toString() => 'Hand(cards: ${cards.join('')} (${originalCards.join('')}), bid: $bid, type: $handType)';

//TODO: we need two comparitors.  bestJokeredHand needs to use cards,and normal sorting needs original cards
  @override
  //int compareTo(Hand other) {
    if (originalCards.join('') == '24753' && other.originalCards.join('') == 'AKQ45') {
      print('STOP');
    }
    final typeComp = handType.index.compareTo(other.handType.index);
    if (typeComp != 0) {
      return typeComp;
    }
    for (var i = 0; i < cards.length; i++) {
      final weightComp = originalCards[i].cardWeight().compareTo(other.originalCards[i].cardWeight());
      if (weightComp != 0) return weightComp;
    }
    return 0;
  }
}

Future<void> Day7CamelCardsPt2() async {
  final input = await File('assets/day7_camel_cards.txt').readAsLines();
  //final input = await File('assets/day7_camel_cards_test.txt').readAsLines();
  final hands = getHandsFromInput(input);

  // final bestJokeredHands = hands.map((e) => e.bestJokeredHand).toList();
  // bestJokeredHands.sort();
  // print(bestJokeredHands.join('\n'));

  // var winnings = 0;
  // for (var i = 0; i < bestJokeredHands.length; i++) {
  //   final rank = i + 1;
  //   winnings += bestJokeredHands[i].bid * rank;
  // }
  // print('bestJokeredHands winnings: $winnings');

  final tempHand = Hand(cards: ['J', 'J', 'J', 'J', 'J'], originalCards: ['J', 'J', 'J', 'J', 'J'], bid: 123);
  final allHands = Hand.createJokerHandList(tempHand);
  print(allHands.last);
  allHands.sort();
  print(allHands.last);

  print(tempHand.bestJokeredHand);
  print(allHands.take(1000).join('\n'));
  print(allHands.length);
}

List<Hand> getHandsFromInput(List<String> input) {
  return input.map((e) {
    final tokens = e.split(' ');
    return Hand(cards: tokens[0].split(''), originalCards: tokens[0].split(''), bid: int.parse(tokens[1]));
  }).toList();
}
