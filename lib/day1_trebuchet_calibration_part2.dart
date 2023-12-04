import 'dart:async';
import 'dart:io';

void day1_trebuchet_calibration_part2() async {
  // https://adventofcode.com/2023/day/1/input
  var input = await File('assets/input.txt')
      .readAsString()
      .then((value) => value.split('\n'));
  //print(input);
//   input.map((e) => e.replaceAll('
// ', ''));
  var sum = 0;
  for (var i = 0; i < input.length; i++) {
    final element = input[i];

    RegExp exp =
        RegExp(r"\d|one|two|three|four|five|six|seven|eight|nine|zero");
    final matches = exp.allMatches(element).toList();

    // Sort matches by start pos
    matches.sort((a, b) => a.start.compareTo(b.start));

    final first = NumberWordToDigit(FoundValue(matches.first));
    final last = NumberWordToDigit(FoundValue(matches.last));

    final calibCode = int.parse('$first$last');
    sum += calibCode;
    print('${i + 1})$element,$calibCode,$sum');
  }
  print(
      "\n${''.padLeft(21, '-')}\nThe answer is '$sum'\n${''.padLeft(21, '-')}");
}

String NumberWordToDigit(String numberWord) {
  return numberWord
      .replaceAll('one', '1')
      .replaceAll('two', '2')
      .replaceAll('three', '3')
      .replaceAll('four', '4')
      .replaceAll('five', '5')
      .replaceAll('six', '6')
      .replaceAll('seven', '7')
      .replaceAll('eight', '8')
      .replaceAll('nine', '9')
      .replaceAll('zero', '0');
}

String FoundValue(RegExpMatch rem) {
  return rem.input.substring(rem.start, rem.end);
}
