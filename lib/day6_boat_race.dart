import "dart:math";
import 'dart:async';
import 'dart:convert';
import 'dart:io';

class Race {
  int duration;
  int distRecord;
  Race({
    required this.duration,
    required this.distRecord,
  });

  int distanceTravelled(int buttonHeldTime) {
    // dist = duration*b-b_squared
    return (duration - buttonHeldTime) * buttonHeldTime;
  }

  List<RaceResult> getPossibleRaceResults() {
    return List.generate(duration + 1, (i) {
      final dist = distanceTravelled(i);
      return RaceResult(buttonHeldTime: i, dist: dist, isRecord: dist > distRecord);
    });
  }

  @override
  String toString() => 'Race(duration: $duration, distRecord: $distRecord)';
}

class RaceResult {
  int buttonHeldTime;
  int dist;
  bool isRecord;
  RaceResult({
    required this.buttonHeldTime,
    required this.dist,
    required this.isRecord,
  });
}

Future<void> Day6BoatRace() async {
  final input = await File('assets/day6_boat_race.txt').readAsLines();
  final re = RegExp(r'(\d+)');
  final times = re.allMatches(input[0]).map((e) => int.parse(e[0]!)).toList();
  final dists = re.allMatches(input[1]).map((e) => int.parse(e[0]!)).toList();
  final races = List.generate(times.length, (index) => Race(duration: times[index], distRecord: dists[index]));
  for (var race in races) {
    print('\n*****Race******');
    for (var i = 0; i <= race.duration; i++) {
      final dist = race.distanceTravelled(i);
      final recordBeaten = dist > race.distRecord;
      print('$i --> $dist (${recordBeaten ? 'Record' : ''})');
    }
  }

  final recordsBrokenMultiplied = races
      .map((e) => e.getPossibleRaceResults().where((rr) => rr.isRecord).length)
      .toList()
      .reduce((value, element) => value * element);

  print('recordsBrokenMultiplied: $recordsBrokenMultiplied');

  //Part 2

  //example
  //final dur = 71530;
  //final dist = 940200;
  //part2 data
  final dur = int.parse(times.map((e) => e.toString()).join());
  final dist = int.parse(dists.map((e) => e.toString()).join());
  var startTS = DateTime.now();
  final answers = quadraticSolver(1, -dur, dist);
  final lower = answers.i.ceil();
  final upper = answers.j.floor();
  final betweenInclusive = (upper - lower) + 1;
  var endTS = DateTime.now();
  print('Part 2: $betweenInclusive (in ${endTS.difference(startTS).inMicroseconds}μs)');

  startTS = DateTime.now();
  final bruteForce =
      Race(duration: 41968894, distRecord: 214178911271055).getPossibleRaceResults().where((rr) => rr.isRecord).length;
  endTS = DateTime.now();

  print('Part 2 (brute force): $bruteForce (in ${endTS.difference(startTS).inMicroseconds}μs)');
}

({num i, num j}) quadraticSolver(num a, num b, num c) {
  final negHalfB = -b / (2 * a);
  final other = (sqrt(pow(b, 2) - (4 * a * c))) / (2 * a);
  return (i: negHalfB - other, j: negHalfB + other);
}
