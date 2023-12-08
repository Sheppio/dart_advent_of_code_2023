import 'dart:async';
import 'dart:collection';
import 'dart:io';
import 'dart:isolate';
import 'dart:math';

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
  //print(nodes);

//Part 1
  // var currentNode = nodes['AAA']!;
  // var stepCount = 0;
  // do {
  //   final direction = directions[stepCount % directions.length];
  //   print("Going ${direction == 'L' ? 'left' : 'right'}");
  //   switch (direction) {
  //     case 'L':
  //       currentNode = nodes[currentNode.left]!;
  //       break;
  //     case 'R':
  //       currentNode = nodes[currentNode.right]!;
  //       break;
  //     default:
  //       throw Exception('Unexpected direction: "$direction"');
  //   }
  //   stepCount++;
  //   print('step: $stepCount, currentNode: $currentNode');
  // } while (currentNode.id != 'ZZZ');
//End of part 1

  print('Part 2');
  print(nodes.keys.where((element) => element.endsWith('A')).join(', '));
  print('');
  print(nodes.keys.where((element) => element.endsWith('Z')).join(', '));

  final startNodes = nodes.values.where((element) => element.id.endsWith('A')).toList();

  final futures = List.generate(
      startNodes.length,
      (index) => Isolate.run(() async {
            return getStepCount(startNodes[index], nodes, directions, 'index_$index');
          }));

  var stepCounts = await Future.wait(futures);
  print(stepCounts.join(", "));
  var answer = BigInt.from(1);
  for (var i = 0; i < stepCounts.length; i++) {
    answer *= BigInt.from(stepCounts[i]);
    print(answer);
  }
  print('Done');
}

int getStepCount(Node startNode, Map<String, Node> nodes, String directions, String tag) {
  var currentNode = startNode;
  var stepCount = 0;
  do {
    final direction = directions[stepCount % directions.length];
    //print("Going ${direction == 'L' ? 'left' : 'right'}");
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
    if (stepCount % 1000000 == 0) {
      print('tag: $tag, step: $stepCount, currentNode: $currentNode');
      Future.delayed(Duration.zero);
    }
  } while (!currentNode.id.endsWith('Z'));
  print('DONE --> tag: $tag, step: $stepCount, currentNode: $currentNode');
  return stepCount;
}



  // print('Starting nodes: ${currentNodes.map((e) => e.id).join(', ')}');
  // var stepCount = 0;
  // var zEndings = 0;
  // var zEndingsMax = 0;
  // do {
  //   final direction = directions[stepCount % directions.length];
  //   //print("Going ${direction == 'L' ? 'left' : 'right'}");
  //   switch (direction) {
  //     case 'L':
  //       for (int i = 0; i < currentNodes.length; i++) {
  //         currentNodes[i] = nodes[currentNodes[i].left]!;
  //       }
  //       break;
  //     case 'R':
  //       for (int i = 0; i < currentNodes.length; i++) {
  //         currentNodes[i] = nodes[currentNodes[i].right]!;
  //       }
  //       break;
  //     default:
  //       throw Exception('Unexpected direction: "$direction"');
  //   }
  //   stepCount++;
  //   zEndings = currentNodes.where((e) => e.id.endsWith('Z')).length;
  //   zEndingsMax = max(zEndings, zEndingsMax);
  //   //print('step: $stepCount, zEndings: $zEndings, currentNodes: ${currentNodes.map((e) => e.id)}');
  //   if (stepCount % 1000000 == 0) {
  //     print(
  //         'step: $stepCount, zEndings: $zEndings, zEndingsMax: $zEndingsMax, currentNodes: ${currentNodes.map((e) => e.id)}');
  //     await Future.delayed(Duration.zero); // <-- gives VSC an opportunity to stop if requested
  //   }
  // } while (zEndings != currentNodes.length);
  // print(
  //     'step: $stepCount, zEndings: $zEndings, zEndingsMax: $zEndingsMax, currentNodes: ${currentNodes.map((e) => e.id)}');