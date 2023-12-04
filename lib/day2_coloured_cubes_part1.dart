import 'dart:async';
import 'dart:io';

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
  String toString() => 'Grab(red: $red, blue: $blue, green: $green)';
}

class Game {
  int id;
  List<Grab> grabs;
  Game({
    required this.id,
    required this.grabs,
  });

  @override
  String toString() => 'Game(id: $id, grabs: $grabs)';
}

void Day2ColouredCubesPart1() async {
  var input = await File('assets/day2_input.txt').readAsLines();
  final games = <Game>[];
  for (var line in input) {
    //ProcessInputLine(line);
    games.add(ProcessInputLine(line));
  }
  // for (var element in games) {
  //   print(element);
  // }
  final invalidGamesCount = games.where((game) => isGameValid(game) == false);
  print('Invalid games count: $invalidGamesCount');
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
  return true;
}

bool isGrabValid(Grab grab) {
  if (grab.red > 12 || grab.green > 13 || grab.blue > 14) {
    return false;
  } else {
    return true;
  }
}
