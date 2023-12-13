import 'dart:io';
import 'dart:math';
import 'dart:collection';

class SpringLineDamgeReport {
  String report;
  List<int> damageGrouping;
  SpringLineDamgeReport({
    required this.report,
    required this.damageGrouping,
  });

  @override
  String toString() => 'SpringLineDamgeReport(report: $report, damageGrouping: $damageGrouping)';
}

Future<void> Day12DamagedSprings() async {
  var input = (await File('assets/day12_input_damaged_springs.txt').readAsLines());
  final damageReports = <SpringLineDamgeReport>[];
  for (var line in input) {
    final split = line.split(' ');
    damageReports.add(
        SpringLineDamgeReport(report: split[0], damageGrouping: split[1].split(',').map((e) => int.parse(e)).toList()));
  }
  print(damageReports.join('\n'));
  final maxQM = damageReports.map((e) => e.report.split('').where((element) => element == '?').length).reduce(max);
  print('$maxQM -> ${pow(2, maxQM)}');
  final x = damageReports
      .map((e) => e.report.split('').where((element) => element == '?').length)
      .toList()
      .fold(<int, int>{}, (previousValue, element) {
    previousValue.update(element, (value) => value + 1, ifAbsent: () => 1);
    return previousValue;
  });

  //Can we brute force...think so with approx 7m strings to regex
  var y = x.entries.toList();
  y.sort((a, b) => a.key.compareTo(b.key));
  print(y.map((e) => '${e.key} --> ${e.value} --> ${pow(2, e.key)} --> ${pow(2, e.key) * e.value}').join('\n'));

  var totalMatches = 0;
  for (var v = 0; v < damageReports.length; v++) {
    final dr = damageReports[v];
    final qmCount = countQuestionMarks(dr.report);
    var combos = getQmCombos(qmCount);
    // print(dr.report);
    // print('\n\nCombos');
    // print(combos.join('\n'));

    // print('start');
    // combos = <String>[];
    // await Future.delayed(Duration.zero);
    // for (var i = 0; i < 19; i++) {
    //   print(i);
    //   combos = addCombos(combos, ['.', '?']);
    // }
    // print(combos.length);
    // print(combos.first);
    // print(combos.last);
    // print('finished');

    List<String> merged = mergeStuff(combos, dr);
    //print("\n\nMerged\n${merged.join('\n')}");

    final regexpString = getRegExp(dr.damageGrouping);
    var re = RegExp(regexpString, multiLine: true);
    var mergedListString = merged.join('\n');
    var matches = re.allMatches(mergedListString).toList();
    await Future.delayed(Duration.zero);
    print('\n\n ($v) Matches (${dr.report}, ${dr.damageGrouping} --> ${re.pattern})');
    for (var i = 0; i < matches.length; i++) {
      print('${i + 1}: ${matches[i][0]}');
    }
    totalMatches += matches.length;
  }
  print('Total matches: $totalMatches');
}

List<String> mergeStuff(List<String> combos, SpringLineDamgeReport dr) {
  var merged = <String>[];
  for (var combo in combos) {
    merged.add(merge(dr.report, combo));
  }
  return merged;
}

List<String> getQmCombos(int qmCount) {
  var combos = <String>[];
  for (var i = 0; i < qmCount; i++) {
    combos = addCombos(combos, ['#', '.']);
  }
  return combos;
}

String getRegExp(List<int> damageGrouping) {
  var tmp = damageGrouping.map((e) => '#{n}'.replaceFirst('n', e.toString()));
  return r'^\.*' + tmp.join(r'\.+') + r"\.*$";
}

int countQuestionMarks(String string) {
  return string.split('').where((element) => element == '?').length;
}

List<String> addCombos(List<String> existing, List<String> combos) {
  if (existing.isEmpty) return combos;
  final tmp = <String>[];
  for (var e in existing) {
    for (var c in combos) {
      tmp.add('$e$c');
    }
  }
  return tmp;
}

String merge(String a, String b) {
  final bChars = b.split('');
  for (var i = 0; i < bChars.length; i++) {
    final index = a.indexOf('?');
    a = a.replaceRange(index, index + 1, bChars[i]);
  }
  return a;
}
