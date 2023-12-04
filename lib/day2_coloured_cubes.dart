import 'dart:async';
import 'dart:io';
import "dart:math";

class Grab {
  int red;
  int blue;
  int green;
  Grab({
    required this.red,
    required this.blue,
    required this.green,
  });

  @override
  String toString() => 'Grab(r: $red, b: $blue, g: $green)';
}

class Game {
  int id;
  List<Grab> grabs;
  Game({
    required this.id,
    required this.grabs,
  });

  Grab get minimumGrab {
    return Grab(
        red: grabs.map((e) => e.red).reduce(max),
        blue: grabs.map((e) => e.blue).reduce(max),
        green: grabs.map((e) => e.green).reduce(max));
  }

  int get cubePower {
    final g = minimumGrab;
    return g.red * g.blue * g.green;
  }

  @override
  String toString() => 'Game(id: $id, grabs: $grabs)';
}

Future<void> Day2ColouredCubes() async {
  var input = await File('assets/day2_input.txt').readAsLines();
  final games = <Game>[];
  for (var line in input) {
    //ProcessInputLine(line);
    games.add(ProcessInputLine(line));
  }
  // for (var element in games) {
  //   print(element);
  // }
  final validGamesIdSum = games
      .where((game) => isGameValid(game) == true)
      .fold(0, (value, element) {
    return value + element.id;
  });
  print('Valid games count: $validGamesIdSum');

  //Part 2
  final sumOfPower = games
      .map((e) => e.cubePower)
      .fold(0, (previousValue, element) => previousValue + element);
  print('sumOfPower: $sumOfPower');
}

Game ProcessInputLine(String line) {
  //Game 1: 9 red, 5 blue, 6 green; 6 red, 13 blue; 2 blue, 7 green, 5 red
  final tokens = line.split(':');
  final gameId = int.parse(tokens[0].replaceAll("Game ", ""));
  final grabs = <Grab>[];
  final grabTokens = tokens[1].split(';');
  //9 red, 5 blue, 6 green
  for (var grabToken in grabTokens) {
    var grab = Grab(red: 0, blue: 0, green: 0);
    final cubeTokens = grabToken.split(',');
    for (var cubeToken in cubeTokens) {
      cubeToken = cubeToken.trim();
      final x = cubeToken.split(' ');
      final count = int.parse(x[0]);
      final colour = x[1];
      switch (colour) {
        case 'red':
          grab.red = count;
          break;
        case 'blue':
          grab.blue = count;
          break;
        case 'green':
          grab.green = count;
          break;
        default:
          throw Exception('Unexpected colour.');
      }
      //print(cubeToken);
    }
    grabs.add(grab);
  }
  return Game(id: gameId, grabs: grabs);
}

bool isGameValid(Game game) {
  for (var grab in game.grabs) {
    if (isGrabValid(grab) == false) {
      print('Invalid game: $game');
      return false;
    }
  }
  print('Valid game: $game');
  return true;
}

bool isGrabValid(Grab grab) {
  if (grab.red <= 12 && grab.green <= 13 && grab.blue <= 14) {
    return true;
  } else {
    return false;
  }
}
