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
    final soil = seedToSoil.mapToDest(seed);
    final fertilizer = soilToFertilizer.mapToDest(soil);
    final water = fertilizerToWater.mapToDest(fertilizer);
    final light = waterToLight.mapToDest(water);
    final temp = lightToTemperature.mapToDest(light);
    final humidity = temperatureToHumidity.mapToDest(temp);
    final loc = humidityToLocation.mapToDest(humidity);
    return loc;
  }).toList();

  final minLoc = locs.reduce(min);

  print('minLoc: $minLoc');

  print(seedToSoil);
}

Future<List<int>> getSeedList(String path) async {
  final line = (await File('assets/day5_seeds_seeds.txt').readAsLines())[0];
  final tokens = line.split(' ');
  return tokens.map((e) => int.parse(e)).toList();
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
