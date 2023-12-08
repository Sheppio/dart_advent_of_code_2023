import 'dart:async';
import 'dart:collection';
import 'dart:io';

class Node {
  String id;
  String left;
  String right;
  Node({
    required this.id,
    required this.left,
    required this.right,
  });

  @override
  String toString() => 'Node(id: $id, left: $left, right: $right)';
}

Future<void> Day8CamelDirections() async {
  final input = await File('assets/day8_input_camel_directions.txt').readAsLines();
  final directions = input.removeAt(0);
  input.removeAt(0); //discards blank line
  final re = RegExp(r'(?<key>[A-Z]+) = \((?<left>[A-Z]+), (?<right>[A-Z]+)\)');
  final nodes = <String, Node>{};
  for (var line in input) {
    final match = re.firstMatch(line) as RegExpMatch;
    final id = match.namedGroup('key')!;
    final node = Node(id: id, left: match.namedGroup('left')!, right: match.namedGroup('right')!);
    nodes[id] = node;
  }
  print(nodes);
  var currentNode = nodes['AAA']!;
  var stepCount = 0;
  do {
    final direction = directions[stepCount % directions.length];
    print("Going ${direction == 'L' ? 'left' : 'right'}");
    switch (direction) {
      case 'L':
        currentNode = nodes[currentNode.left]!;
        break;
      case 'R':
        currentNode = nodes[currentNode.right]!;
        break;
      default:
        throw Exception('Unexpected direction: "$direction"');
    }
    stepCount++;
    print('step: $stepCount, currentNode: $currentNode');
  } while (currentNode.id != 'ZZZ');
}
