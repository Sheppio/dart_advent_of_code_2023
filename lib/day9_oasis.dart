import 'dart:async';
import 'dart:io';

import 'helpers_and_constants.dart';

class Sensor {
  List<int> readings;
  Sensor({
    required this.readings,
  });

  int get prediction {
    final pred = readings.last + getDiffToAdd(readings);
    print('${readings.join(' ')} ${ConsoleColors.yellow}$pred${ConsoleColors.reset}');
    return pred;
  }

  int get backPrediction {
    final pred = readings.first + getDiffToAdd(readings.reversed.toList());
    print('${ConsoleColors.yellow}$pred${ConsoleColors.reset} ${readings.join(' ')}');
    return pred;
  }

  int getDiffToAdd(List<int> readings) {
    final diffs = getDifferences(readings);
    final allZeros = diffs.where((element) => element == 0).length == diffs.length;
    //final sumOfDiffs = diffs.reduce((value, element) => value + element);
    print('readings:$readings, diffs: $diffs, allZeros: $allZeros');
    if (!allZeros) {
      final x = getDiffToAdd(diffs);
      final ret = diffs.last + x;
      print('${diffs.join(' ')} ${ConsoleColors.yellow}$ret${ConsoleColors.reset}');
      return ret;
    } else {
      final ret = 0;
      print('${diffs.join(' ')} ${ConsoleColors.yellow}$ret${ConsoleColors.reset}');
      return ret;
    }
  }
}

Future<void> Day9Oasis() async {
  final input = await File('assets/day9_input_oasis.txt').readAsLines();
  final sensors = <Sensor>[];
  for (var line in input) {
    final readings = line.split(' ').map((e) => int.parse(e)).toList();
    final s = Sensor(readings: readings);
    sensors.add(s);
  }
  var sum = 0;
  for (var i = 0; i < sensors.length; i++) {
    final sensor = sensors[i];
    final pred = sensor.prediction;
    sum += pred;
    print('${i + 1}) Adding prediction ($pred) to sum ($sum)');
  }
  //print('Day 9 pt1, prediction sum: ${sensors.map((e) => e.prediction).reduce((value, element) => value + element)}');
  print('Day 9 pt1, prediction sum: $sum');

  sum = 0;
  for (var i = 0; i < sensors.length; i++) {
    final sensor = sensors[i];
    final pred = sensor.backPrediction;
    sum += pred;
    print('${i + 1}) Adding backPrediction ($pred) to sum ($sum)');
  }
  print('Day 9 pt2, backPrediction sum: $sum');

  print('Done');
}

List<int> getDifferences(List<int> readings) {
  if (readings.length < 2) throw Exception('getDifferences(): Too few readings');
  final diffs = <int>[];
  for (var i = 0; i < readings.length - 1; i++) {
    diffs.add(readings[i + 1] - readings[i]);
  }
  return diffs;
}
