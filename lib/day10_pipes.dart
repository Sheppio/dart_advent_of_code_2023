import 'dart:io';
import 'dart:math';

class PipePiece {
  int x;
  int y;
  String type;
  String inflowDir;
  String outflowDir;
  int dist;
  bool isStart;
  PipePiece({
    required this.x,
    required this.y,
    required this.type,
    required this.inflowDir,
    required this.outflowDir,
    required this.dist,
    required this.isStart,
  });

  @override
  String toString() {
    return 'PipePiece(x: $x, y: $y, t: $type, inDir: $inflowDir, outDir: $outflowDir, dst: $dist, isStart: $isStart)';
  }
}

Future<void> Day10Pipes() async {
  print('↰↱↲↳ ↴↵ ←↑→↓ ⤴⤵⤶⤷');
  var pipes = <List<String>>[];
  final input = await File('assets/day10_input_pipes.txt').readAsLines();
  for (var i = 0; i < input.length; i++) {
    pipes.add(input[i].split(''));
  }
  prettyPrint(pipes);
  final start = findStart(pipes);
  if (start == null) {
    throw Exception("Can't find start");
  }
  print('');
  // final myPipe = <PipePiece>[ //Test puzzle
  //   PipePiece(x: start.x, y: start.y, type: 'F', inflowDir: 'N', outflowDir: 'E', dist: 0, isStart: true)
  // ];
  // final myPipe = <PipePiece>[  //Test puzzle 2
  //   PipePiece(x: start.x, y: start.y, type: 'F', inflowDir: 'N', outflowDir: 'E', dist: 0, isStart: true)
  // ];
  final myPipe = <PipePiece>[
    //real
    PipePiece(x: start.x, y: start.y, type: 'J', inflowDir: 'E', outflowDir: 'N', dist: 0, isStart: true)
  ];
  print(myPipe.last);
  do {
    Future.delayed(Duration.zero);
    myPipe.add(getNextPipePiece(myPipe.last, pipes));
    print(myPipe.last);
  } while (!(myPipe.last.x == myPipe.first.x && myPipe.last.y == myPipe.first.y));

  print('Day 10 pt1: maxDist from start  --> ${myPipe.last.dist / 2}');

  //Part 2

  // Ideas:
  // We need to work out internal/external side.  Could project out from each side of pipe until
  // we hit edge of map. Forget and move on to next section if we hit another myPipe piece during the projection.
  //
  // Once we know internal side we then project out from this side until we hit a myPipe piece and
  // add to an 'enclosed' list.  This will produce dupes, but just need final process to remove, then count.
}

PipePiece getNextPipePiece(PipePiece pp, List<List<String>> pipes) {
  var p = Point<int>(0, 0);
  switch (pp.outflowDir) {
    case 'E':
      p = Point<int>(pp.x + 1, pp.y);
      break;
    case 'W':
      p = Point<int>(pp.x - 1, pp.y);
      break;
    case 'N':
      p = Point<int>(pp.x, pp.y - 1);
      break;
    case 'S':
      p = Point<int>(pp.x, pp.y + 1);
      break;
  }
  final nextType = getPieceAtPoint(p, pipes);
  var nextOutFlow = '';
  switch (nextType) {
    case 'F':
      nextOutFlow = pp.outflowDir == 'N' ? 'E' : 'S';
      break;
    case '-':
      nextOutFlow = pp.outflowDir == 'E' ? 'E' : 'W';
      break;
    case '|':
      nextOutFlow = pp.outflowDir == 'S' ? 'S' : 'N';
      break;
    case 'J':
      nextOutFlow = pp.outflowDir == 'S' ? 'W' : 'N';
      break;
    case '7':
      nextOutFlow = pp.outflowDir == 'E' ? 'S' : 'W';
      break;
    case 'L':
      nextOutFlow = pp.outflowDir == 'S' ? 'E' : 'N';
      break;
    default:
  }
  return PipePiece(
      x: p.x,
      y: p.y,
      type: nextType,
      inflowDir: pp.outflowDir,
      outflowDir: nextOutFlow,
      dist: pp.dist + 1,
      isStart: false);
}

String getPieceAtPoint(Point<int> p, List<List<String>> pipes) {
  return pipes[p.y][p.x];
}

Point<int>? findStart(List<List<String>> pipes) {
  for (var y = 0; y < pipes.length; y++) {
    final x = pipes[y].indexOf('S');
    if (x >= 0) {
      return Point(x, y);
    }
  }
  return null;
}

prettyPrint(List<List<String>> pipes) {
  for (var y = 0; y < pipes.length; y++) {
    //print(pipes[y].map((e) => prettyPrintReplace(e)).join(''));
    print(pipes[y].join(''));
  }
}

String prettyPrintReplace(String s) {
  switch (s) {
    case 'F':
      return '⌜';
    case '7':
      return '⌝';
    case 'J':
      return '⌟';
    case 'L':
      return '⌞';
    // case 'F':
    //   return '↱';
    // case 'F':
    //   return '↱';
    default:
      return s;
  }
}
