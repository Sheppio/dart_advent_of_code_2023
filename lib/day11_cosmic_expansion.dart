import 'dart:io';
import 'dart:math';

class Galaxy {
  int id;
  Point<int> loc;
  Galaxy({
    required this.id,
    required this.loc,
  });

  @override
  String toString() => 'Galaxy(id: $id, loc: $loc)';
}

class GalaxyPair {
  Galaxy galaxyA;
  Galaxy galaxyB;
  GalaxyPair({
    required this.galaxyA,
    required this.galaxyB,
  });

  int get distanceBetween {
    int x = (galaxyA.loc.x - galaxyB.loc.x).abs();
    int y = (galaxyA.loc.y - galaxyB.loc.y).abs();
    return x + y;
  }

  @override
  String toString() => 'GalaxyPair(galaxyA: $galaxyA, galaxyB: $galaxyB, dist: $distanceBetween)';
}

Future<void> Day11CosmicExpansion() async {
  final input = (await File('assets/day11_input_cosmic_expansion.txt').readAsLines());
  var cosmos = expandCosmosVertically(input);
  //var cosmos = input;

  print(cosmos.join('\n'));

  cosmos = transpose(cosmos);
  cosmos = expandCosmosVertically(cosmos);
  cosmos = transpose(cosmos);

  print('\n' * 2);
  print(cosmos.join('\n'));

  final galaxies = <Galaxy>[];
  int galaxyCount = 0;
  for (var y = 0; y < cosmos.length; y++) {
    for (var x = 0; x < cosmos[0].length; x++) {
      if (cosmos[y].substring(x, x + 1) == '#') {
        galaxyCount++;
        galaxies.add(Galaxy(id: galaxyCount, loc: Point<int>(x, y)));
      }
    }
  }
  print(galaxies.join('\n'));

  var galaxyPairs = <GalaxyPair>[];
  for (var i = 0; i < galaxies.length; i++) {
    var tmp = List<Galaxy>.from(galaxies);
    tmp.removeRange(0, i);
    galaxyPairs.addAll(pairGalaxiesWithFirst(tmp));
  }
  print('\n\n');
  print(galaxyPairs.join('\n'));

  var sum = galaxyPairs.map((e) => e.distanceBetween).reduce((value, element) => value + element);
  print('Day 11 pt1: Distances summed --> $sum');
}

List<GalaxyPair> pairGalaxiesWithFirst(List<Galaxy> galaxies) {
  var gps = <GalaxyPair>[];
  for (var i = 1; i < galaxies.length; i++) {
    gps.add(GalaxyPair(galaxyA: galaxies[0], galaxyB: galaxies[i]));
  }
  return gps;
}

List<String> expandCosmosVertically(List<String> cosmos) {
  final ret = <String>[];
  var emptySpace = '.' * cosmos[0].length;
  for (var i = 0; i < cosmos.length; i++) {
    final line = cosmos[i];
    if (line == emptySpace) {
      ret.addAll([line, line]);
    } else {
      ret.add(line);
    }
  }
  return ret;
}

List<String> transpose(List<String> input) {
  final output = <String>[];
  for (var i = 0; i < input[0].length; i++) {
    output.add(List.generate(input.length, (index) => input[index].substring(i, i + 1)).join());
  }
  return output;
}
