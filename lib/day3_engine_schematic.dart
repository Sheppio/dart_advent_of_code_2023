import "dart:math";
import 'dart:async';
import 'dart:io';

class Part {
  int id;
  Point loc;
  Part({
    required this.id,
    required this.loc,
  });

  int get length {
    return id.toString().length;
  }

  @override
  String toString() => 'Part(number: $id, loc: ${loc.x},${loc.y})';
}

Future<void> Day3EngineSchematic() async {
  var input = await File('assets/day3_input.txt').readAsLines();
  RegExp exp = RegExp(r"\d+");
  final parts = <Part>[];
  for (var i = 0; i < input.length; i++) {
    final matches = exp.allMatches(input[i]).toList();
    for (var match in matches) {
      parts.add(Part(
          id: int.parse(input[i].substring(match.start, match.end)),
          loc: Point(match.start, i)));
    }
    print(parts);
    for (var part in parts) {
      isValid(input, part);
    }
    final sum = parts
        .where((part) => isValid(input, part))
        .fold(0, (previousValue, part) => previousValue + part.id);
    print('Sum of part numbers: $sum');
  }

  //Part 2
  final gearInfo = doGearStuff(input, parts);
  final gearInfoRatioSum = gearInfo.values
      .where((element) => element.length == 2)
      .fold(0, (previousValue, element) {
    final a = element[0].id;
    final b = element[1].id;
    return previousValue + (a * b);
  });
  print('gearInfoRatioSum: $gearInfoRatioSum');
  print(gearInfo);
}

bool isValid(List<String> schematic, Part part) {
  final locsToCheck = getLocationsToCheckForSymbols(
      part, schematic[0].length, schematic.length);
  final boundaryString = locsToCheck
      .map((e) => schematic[e.y as int].substring(e.x as int, (e.x as int) + 1))
      .join();
  final boundaryStringWithoutDotsAndNumbers =
      boundaryString.replaceAllMapped(RegExp(r'\.|\d{1}'), (match) => '');
  return boundaryStringWithoutDotsAndNumbers.isNotEmpty;
}

List<Point> getLocationsToCheckForSymbols(
    Part part, int schematicWidth, int schematicHeight) {
  final locs = <Point>[];
  final left = part.loc.x != 0;
  final right = (part.loc.x + part.length) != schematicWidth;
  final top = part.loc.y != 0;
  final bottom = (part.loc.y + 1) != schematicWidth;
  if (left && top) locs.add(Point(part.loc.x - 1, part.loc.y - 1));
  if (top) {
    for (var i = 0; i < part.length; i++) {
      locs.add(Point(part.loc.x + i, part.loc.y - 1));
    }
  }
  if (right && top) locs.add(Point(part.loc.x + part.length, part.loc.y - 1));
  if (left) locs.add(Point(part.loc.x - 1, part.loc.y));
  if (right) locs.add(Point(part.loc.x + part.length, part.loc.y));
  if (left && bottom) locs.add(Point(part.loc.x - 1, part.loc.y + 1));
  if (bottom) {
    for (var i = 0; i < part.length; i++) {
      locs.add(Point(part.loc.x + i, part.loc.y + 1));
    }
  }
  if (right && bottom) {
    locs.add(Point(part.loc.x + part.length, part.loc.y + 1));
  }
  return locs;
}

Map<Point, List<Part>> doGearStuff(List<String> schematic, List<Part> parts) {
  final gearInfo = <Point, List<Part>>{};
  for (var part in parts) {
    final locsToCheck = getLocationsToCheckForSymbols(
        part, schematic[0].length, schematic.length);
    final locsValue = <Point, String>{};
    for (var e in locsToCheck) {
      final value =
          schematic[e.y as int].substring(e.x as int, (e.x as int) + 1);
      if (value == '*') {
        final point = Point(e.x, e.y);
        if (gearInfo.containsKey(point) == false) gearInfo[point] = <Part>[];
        gearInfo[point]!.add(part);
      }
    }
  }
  return gearInfo;
}
