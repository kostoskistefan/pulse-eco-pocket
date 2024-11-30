import '../../../../utils/arduino_controller.dart';
import '../../../../utils/elements.dart';
import 'enumartions/sensor_type.dart';
import 'package:http/http.dart' as http;
import 'dart:convert';
import 'dart:io';

class SensorData {
  final SensorType type;
  late int data;
  final DateTime dateTime;
  final String location;

  SensorData(this.type, String value, this.dateTime, this.location) {
    data = int.parse(value);
  }

  Future<void> getDataValue() async {
    String url = 'https://skopje.pulse.eco/rest/overall';
    String val = 'pm25';
    var response = await http.get(Uri.parse(url));
    if (response.statusCode == 200) {
      var jsonce = json.decode(response.body);

      this.data = int.parse(jsonce['values'][val]);
      print(data);

    } else {
      print('Request failed with status: ${response.statusCode}');
    }
  }

  Map<String, String> toMap() {
    String title = getTitle();
    String particles = getParticles();
    String desc = getDescription();
    String comparisonText = getComparisonText();
    String yesterdayComparison = getYesterdayComparison();
    String weekComparison = getWeekComparison();

    return {
      'title': title,
      'particles': particles,
      'description': desc,
      'comparisonText': '',
      'yesterdayComparison': '',
      'weekComparison': '',
    };
  }

  String getTitle() {
    String result = type.toString();

    switch (type) {
      case SensorType.PM10:
        result = 'Air quality (PM10)';
        break;

      case SensorType.PM25:
        result = 'Air quality (PM2.5)';
        break;

      case SensorType.PM1:
        result = 'Air quality (PM1)';
        break;

      case SensorType.Noise:
        result = 'Noise';
        break;

      case SensorType.Temperature:
        result = 'Temperature';
        break;

      case SensorType.Humidity:
        result = 'Humidity';
        break;

      case SensorType.Pressure:
        result = 'Pressure';
        break;

      case SensorType.NO2:
        result = 'Air quality (NO2)';
        break;

      case SensorType.O3:
        result = 'Air quality (O3)';
        break;

      case SensorType.CO:
        result = 'Air quality (CO)';
        break;
    }

    return result;
  }

  String getParticles() {
    String result = '$data';

    switch (type) {
      case SensorType.PM10:
        result = '$data µg/m3';
        break;

      case SensorType.PM25:
        result = '$data µg/m3';
        break;

      case SensorType.PM1:
        result = '$data µg/m3';
        break;

      case SensorType.Noise:
        result = '$data dBA';
        break;

      case SensorType.Temperature:
        result = '$data °C';
        break;

      case SensorType.Humidity:
        result = '$data %';
        break;

      case SensorType.Pressure:
        result = '$data hPa';
        break;

      case SensorType.NO2:
        result = '$data µg/m3';
        break;

      case SensorType.O3:
        result = '$data µg/m3';
        break;

      case SensorType.CO:
        result = '$data mg/m3';
        break;
    }

    return result;
  }

  String getDescription() {
    String result = 'Current situation:\n';

    // TODO CHANGE TEXT
    switch (type) {
      case SensorType.PM10:
        result += (data <= 50)
            ? 'Air quality is good.'
            : (data <= 150)
            ? 'Air quality is moderate.'
            : 'Air quality is poor.';
        break;

      case SensorType.PM25:
        result += (data <= 35)
            ? 'Air quality is good.'
            : (data <= 150)
            ? 'Air quality is moderate.'
            : 'Air quality is poor.';
        break;

      case SensorType.PM1:
        result += (data <= 25)
            ? 'Air quality is good.'
            : 'Air quality is concerning.';
        break;

      case SensorType.Noise:
        result += (data <= 60)
            ? 'It\'s quiet.'
            : (data <= 85)
            ? 'It\'s moderately loud.'
            : 'It\'s very loud.';
        break;

      case SensorType.Temperature:
        result += (data < 0)
            ? 'It\'s freezing!'
            : (data < 20)
            ? 'It\'s cool.'
            : (data < 30)
            ? 'It\'s warm.'
            : 'It\'s hot.';
        break;

      case SensorType.Humidity:
        result += (data < 30)
            ? 'The air is dry.'
            : (data <= 60)
            ? 'The air is comfortable.'
            : 'The air is humid.';
        break;

      case SensorType.Pressure:
        result += (data < 1013)
            ? 'It might be rainy or stormy.'
            : 'It\'s likely clear weather.';
        break;

      case SensorType.NO2:
        result += (data <= 40)
            ? 'Air quality is good.'
            : 'Air quality is poor.';
        break;

      case SensorType.O3:
        result += (data <= 100)
            ? 'Air quality is good.'
            : (data <= 180)
            ? 'Air quality is moderate.'
            : 'Air quality is poor.';
        break;

      case SensorType.CO:
        result += (data <= 9)
            ? 'CO levels are safe.'
            : 'CO levels are hazardous!';
        break;
    }

    return result;
  }

  String getComparisonText() {
    String result = 'No comparison sorry...';

    // TODO CHANGE COMPARISON TEXT


    return result;
  }

  String getYesterdayComparison() {
    // TODO MAKE THIS PROPER
    String url = 'https://$location.pulse.eco/rest/avgData/day?sensorId=-1&';

    String typece = '';
    typece = getSensorType(typece);

    String from = parseDateTimeToString(dateTime.subtract(const Duration(days: 2)));
    String to = parseDateTimeToString(dateTime.subtract(const Duration(days: 1)));

    url += 'type=$typece&from=$from&to=$to';

    // sendGetRequestForYesterdayComparison(url);
    // sendGetRequest(url);

    String res = '1';
    return res;
  }

  String getWeekComparison() {
    // TODO MAKE THIS PROPER
    // https://skopje.pulse.eco/rest/avgData/day?sensorId=-1&type=pm10&from=2024-11-24T02:00:00%2b01:00&to=2024-11-25T12:00:00%2b01:00
    String url = 'https://$location.pulse.eco/rest/dataRaw?';

    String typece = '';
    typece = getSensorType(typece);

    String from = parseDateTimeToString(startOfWeek(dateTime));
    String to = parseDateTimeToString(dateTime);

    url += 'type=$typece&from=$from&to=$to';

    String res = '2';
    return res;
  }

  String getSensorType(String typece) {
    if (type == SensorType.PM10) typece = 'pm10';
    else if (type == SensorType.PM25) typece = 'pm25';
    else if (type == SensorType.PM1) typece = 'pm1';
    else if (type == SensorType.Temperature) typece = 'temperature';
    else if (type == SensorType.Humidity) typece = 'humidity';
    else if (type == SensorType.Noise) typece = 'noise';
    else if (type == SensorType.Pressure) typece = 'pressure';
    return typece;
  }

  String parseDateTimeToString(DateTime date) {
    // https://skopje.pulse.eco/rest/dataRaw?type=pm10&from=2017-03-15T02:00:00%2b01:00&to=2017-03-19T12:00:00%2b01:00
    // 2017-03-15T02:00:00%2b01:00
    // 2017-03-15 T 02:00:00 %2b01:00
    String res = '${date.toString().replaceAll(' ', 'T').split('.')[0]}%2b01:00';
    return res;
  }

  DateTime startOfWeek(DateTime date) {
    return date.subtract(Duration(days: date.weekday - 1));
  }

  static void makeMapOfSensors(String sensors) {
    // Humidity;Temperature;Noise Level;
    var split = sensors.split(';');
    List<String> list = split.sublist(0, split.length - 1);

    Map<String, String> res = {};
    for (var sensor in list) {
      res.putIfAbsent(sensor, () {
        return "...";
      });
      Elements.dataOfSensors.putIfAbsent(sensor, () {
        return [];
      });
    }
    Elements.mapOfSensors.value = res;
  }

  // TODO DO WE DISPLAY AVG OR THE DATA WE GOT
  static void updateMapOfSensors(String data) {
    var split = data.split(';');
    List<String> list = split.sublist(0, split.length - 1);

    Map<String, String> res = {};
    int i = 0;
    for (var key in Elements.mapOfSensors.value.keys) {
      res.putIfAbsent(key, () {
        return '${list[i]}\n${Elements.mapOfSensorsUnits[key]}';
      });
      Elements.dataOfSensors[key]!.add(list[i]);
      i++;
    }
    Elements.mapOfSensors.value = res;

    Elements.mapOfSensors.value.forEach((k, v) {
      Map<String, String> updateJson = {
        "sensorId": 'Given by Pulse Eco',
        "position": "42.006168835581406 21.410470615339875",
        "stamp": DateTime.now().toString(),
        "year": DateTime.now().year.toString(),
        "type": k,
        "value": v
      };
      updateDataCollectedJson(updateJson);
    });
  }

  static void updateDataCollectedJson(Map<String, String> updateJson) async {
    final filePath = './json/data_collected.json';
    final file = File(filePath);

    try {
      if (await file.exists()) {
        final fileContents = await file.readAsString();
        final Map<String, String> existingData = Map<String, String>.from(jsonDecode(fileContents));

        existingData.addAll(updateJson);

        await file.writeAsString(jsonEncode(existingData), mode: FileMode.write);
      } else {
        await file.create(recursive: true);
        await file.writeAsString(jsonEncode(updateJson), mode: FileMode.write);
      }

      print('File updated successfully!');
    } catch (e) {
      print('An error occurred while updating the file: $e');
    }
  }

  static void readDataButton(bool readDataIsToggled) {
    if (readDataIsToggled) {
      Elements.arduinoController!.state = ArduinoControllerState.READING_DATA;
      Elements.arduinoController!.sendCommand(ArduinoControllerCommand.REQUEST_DATA_START.value);
    } else {
      Elements.arduinoController!.state = ArduinoControllerState.IDLE;
      Elements.arduinoController!.sendCommand(ArduinoControllerCommand.REQUEST_DATA_END.value);
    }
  }

  static void addUnitsForSensors(String response) {
    var split = response.split(';');
    List<String> list = split.sublist(0, split.length - 1);

    int i = 0;
    Map<String, String> res = {};
    Elements.mapOfSensors.value.forEach((k, v) {
      res.putIfAbsent(k, () {
        return list[i].replaceAll('Î¼', 'µ');
      });
      i++;
    });

    Elements.mapOfSensorsUnits = res;
  }

  @override
  String toString() {
    return 'SensorData(type: $type, data: $data)';
  }
}
