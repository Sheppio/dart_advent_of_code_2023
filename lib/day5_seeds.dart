import "dart:math";
import 'dart:async';
import 'dart:io';

class RangeEntry {
  int sourceStart;
  int destStart;
  int length;
  RangeEntry({
    required this.sourceStart,
    required this.destStart,
    required this.length,
  });

  int get sourceLast {
    return sourceStart + length - 1;
  }

  @override
  String toString() => 'RangeEntry(sourceStart: $sourceStart, destStart: $destStart, length: $length)';
}

class RangeController {
  List<RangeEntry> rangeEntries;
  RangeController({
    required this.rangeEntries,
  });

  int mapToDest(int source) {
    for (var re in rangeEntries) {
      if (source >= re.sourceStart && source <= re.sourceLast) {
        final diff = source - re.sourceStart;
        return re.destStart + diff;
      }
    }
    return source;
  }
}

Future<void> Day5Seeds() async {
  var seeds = await getSeedList('assets/day5_seeds_seeds.txt');

  var seedToSoil = await createRangeController('assets/day5_seeds_seed_to_soil.txt');
  var soilToFertilizer = await createRangeController('assets/day5_seeds_soil_to_fertilizer.txt');
  var fertilizerToWater = await createRangeController('assets/day5_seeds_fertilizer_to_water.txt');
  var waterToLight = await createRangeController('assets/day5_seeds_water_to_light.txt');
  var lightToTemperature = await createRangeController('assets/day5_seeds_light_to_temperature.txt');
  var temperatureToHumidity = await createRangeController('assets/day5_seeds_temperature_to_humidity.txt');
  var humidityToLocation = await createRangeController('assets/day5_seeds_humidity_to_location.txt');

  final locs = seeds.map((seed) {
    return getLocationForSeed(seed, seedToSoil, soilToFertilizer, fertilizerToWater, waterToLight, lightToTemperature,
        temperatureToHumidity, humidityToLocation);
  }).toList();

  var minLoc = locs.reduce(min);

  print('minLoc: $minLoc');

  //Part 2
  final seedRanges = await getSeedRanges('assets/day5_seeds_seeds.txt');
  final toCheckCount = seedRanges.values.reduce((value, element) => value + element);
  print(toCheckCount);
  minLoc = int.parse('999999999999');
  var checkCount = 0;

  // final timer = Timer.periodic(Duration(milliseconds: 1000), (timer) {
  //   print('$checkCount/$toCheckCount: minLoc --> $minLoc');
  // });

  for (var r in seedRanges.entries) {
    print('Checking ${r.key}-${r.key + r.value - 1} (${r.value})');
    printStatusOfPart2(checkCount, toCheckCount, minLoc, r.key);
    for (var i = 0; i < r.value; i++) {
      checkCount++;
      final seedValue = r.key + i;
      final loc = getLocationForSeed(seedValue, seedToSoil, soilToFertilizer, fertilizerToWater, waterToLight,
          lightToTemperature, temperatureToHumidity, humidityToLocation);
      if (loc < minLoc) minLoc = loc;
      if (checkCount % 10000000 == 0) printStatusOfPart2(checkCount, toCheckCount, minLoc, seedValue);
    }
    printStatusOfPart2(checkCount, toCheckCount, minLoc, r.key + r.value - 1);
  }

  //timer.cancel;

  print('minLoc: $minLoc');
}

void printStatusOfPart2(int checkCount, int toCheckCount, int minLoc, int seedValue) => print(
    '$checkCount/$toCheckCount (${((checkCount / toCheckCount) * 100).toStringAsPrecision(3)}%): minLoc --> $minLoc   Seed:$seedValue ');

int getLocationForSeed(
    int seed,
    RangeController seedToSoil,
    RangeController soilToFertilizer,
    RangeController fertilizerToWater,
    RangeController waterToLight,
    RangeController lightToTemperature,
    RangeController temperatureToHumidity,
    RangeController humidityToLocation) {
  final soil = seedToSoil.mapToDest(seed);
  final fertilizer = soilToFertilizer.mapToDest(soil);
  final water = fertilizerToWater.mapToDest(fertilizer);
  final light = waterToLight.mapToDest(water);
  final temp = lightToTemperature.mapToDest(light);
  final humidity = temperatureToHumidity.mapToDest(temp);
  final loc = humidityToLocation.mapToDest(humidity);
  return loc;
}

Future<List<int>> getSeedList(String path) async {
  final line = (await File(path).readAsLines())[0];
  final tokens = line.split(' ');
  return tokens.map((e) => int.parse(e)).toList();
}

Future<Map<int, int>> getSeedRanges(String path) async {
  final line = (await File(path).readAsLines())[0];
  final tokens = line.split(' ');
  final ranges = <int, int>{};
  for (var i = 0; i < tokens.length; i += 2) {
    final start = int.parse(tokens[i]);
    final count = int.parse(tokens[i + 1]);
    ranges[start] = count;
  }
  return ranges;
}

Future<RangeController> createRangeController(String path) async {
  final rc = RangeController(
      rangeEntries: (await File(path).readAsLines()).map((line) {
    final tokens = line.split(' ');
    return RangeEntry(sourceStart: int.parse(tokens[1]), destStart: int.parse(tokens[0]), length: int.parse(tokens[2]));
  }).toList());
  rc.rangeEntries.sort((a, b) => a.sourceStart.compareTo(b.sourceStart));
  return rc;
}
