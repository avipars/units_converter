import 'package:units_converter/UtilsConversion.dart';

//Available TIME units
enum TIME {
  seconds,
  deciseconds,
  centiseconds,
  milliseconds,
  microseconds,
  nanoseconds,
  minutes,
  hours,
  days,
  weeks,
  years_365,
  lustra,
  decades,
  centuries,
  millennia,
}

class Time {
  //Map between units and its symbol
  final Map<TIME, String> mapSymbols = {
    TIME.seconds: 'm²',
    TIME.deciseconds: 'cm²',
    TIME.centiseconds: 'in²',
    TIME.milliseconds: 'ft²',
    TIME.microseconds: 'mi²',
    TIME.nanoseconds: 'yd²',
    TIME.minutes: 'mm²',
    TIME.hours: 'km²',
    TIME.days: 'he',
    TIME.weeks: 'ac',
    TIME.years_365: 'a',
    TIME.lustra: 'km²',
    TIME.decades: 'he',
    TIME.centuries: 'ac',
    TIME.millennia: 'a',
  };

  int significantFigures;
  bool removeTrailingZeros;
  List<Unit> areaUnitList = [];
  Node _time_conversion;

  ///Class for time conversions, e.g. if you want to convert 1 hour in seconds:
  ///```dart
  ///var time = Time(removeTrailingZeros: false);
  ///time.Convert(Unit(TIME.hours, value: 1));
  ///print(TIME.seconds);
  /// ```
  Time({int significantFigures = 10, bool removeTrailingZeros = true}) {
    this.significantFigures = significantFigures;
    this.removeTrailingZeros = removeTrailingZeros;
    TIME.values.forEach((element) => areaUnitList.add(Unit(element, symbol: mapSymbols[element])));
    _time_conversion = Node(name:  TIME.seconds,
        leafNodes: [
          Node(coefficientProduct: 1e-1, name: TIME.deciseconds,),
          Node(coefficientProduct: 1e-2, name: TIME.centiseconds,),
          Node(coefficientProduct: 1e-3, name: TIME.milliseconds,),
          Node(coefficientProduct: 1e-6, name: TIME.microseconds,),
          Node(coefficientProduct: 1e-9, name: TIME.nanoseconds,),
          Node(coefficientProduct: 60.0, name: TIME.minutes,leafNodes: [
            Node(coefficientProduct: 60.0, name: TIME.hours,leafNodes: [
              Node(coefficientProduct: 24.0, name: TIME.days,leafNodes: [
                Node(coefficientProduct: 7.0, name: TIME.weeks,),
                Node(coefficientProduct: 365.0, name: TIME.years_365,leafNodes: [
                  Node(coefficientProduct: 5.0, name: TIME.lustra,),
                  Node(coefficientProduct: 10.0, name: TIME.decades,),
                  Node(coefficientProduct: 100.0, name: TIME.centuries,),
                  Node(coefficientProduct: 1000.0, name: TIME.millennia,),
                ]),
              ]),
            ]),
          ]),
        ]);
  }

  ///Converts a Unit (with a specific value and name) to all other units
  void Convert(Unit unit) {
    assert(unit.value != null);
    assert(TIME.values.contains(unit.name));
    _time_conversion.clearAllValues();
    _time_conversion.clearSelectedNode();
    var currentUnit = _time_conversion.getByName(unit.name);
    currentUnit.value = unit.value;
    currentUnit.selectedNode = true;
    currentUnit.convertedNode = true;
    _time_conversion.convert();
    for (var i = 0; i < TIME.values.length; i++) {
      areaUnitList[i].value = _time_conversion.getByName(TIME.values.elementAt(i)).value;
      areaUnitList[i].stringValue = mantissaCorrection(areaUnitList[i].value, significantFigures, removeTrailingZeros);
    }
  }

  Unit get seconds => _getUnit(TIME.seconds);
  Unit get deciseconds => _getUnit(TIME.deciseconds);
  Unit get centiseconds => _getUnit(TIME.centiseconds);
  Unit get milliseconds => _getUnit(TIME.milliseconds);
  Unit get microseconds => _getUnit(TIME.microseconds);
  Unit get nanoseconds => _getUnit(TIME.nanoseconds);
  Unit get minutes => _getUnit(TIME.minutes);
  Unit get hours => _getUnit(TIME.hours);
  Unit get days => _getUnit(TIME.days);
  Unit get weeks => _getUnit(TIME.weeks);
  Unit get years_365 => _getUnit(TIME.years_365);
  Unit get lustra => _getUnit(TIME.lustra);
  Unit get decades => _getUnit(TIME.decades);
  Unit get centuries => _getUnit(TIME.centuries);
  Unit get millennia => _getUnit(TIME.millennia);

  ///Returns all the time units converted with prefixes
  List<Unit> getAll() {
    return areaUnitList;
  }

  ///Returns the Unit with the corresponding name
  Unit _getUnit(var name) {
    return areaUnitList.where((element) => element.name == name).first;
  }
}
