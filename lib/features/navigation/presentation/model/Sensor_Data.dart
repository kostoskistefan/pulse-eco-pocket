import '../../../../utils/elements.dart';
import 'Requests.dart';
import 'enumartions/sensor_type.dart';

class SensorData {
  final SensorType type;
  final int data;
  final DateTime dateTime;
  final String location;

  SensorData(this.type, this.data, this.dateTime, this.location);

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
      'comparisonText': comparisonText,
      'yesterdayComparison': yesterdayComparison,
      'weekComparison': weekComparison,
    };
  }

  String getTitle() {
    String result = type.toString();

    // if (type.toString().contains('PM') || type.toString().contains('O')) {
    //   result = 'Air quality ($type)';
    // }

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
        result = '$data dBA';;
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
    String url = 'https://$location.pulse.eco/rest/data24h?';

    String typece = '';
    if (type == SensorType.PM10) typece = 'pm10';
    else if (type == SensorType.PM10) typece = 'pm25';
    else if (type == SensorType.PM10) typece = 'temperature';
    else if (type == SensorType.PM10) typece = 'humidity';
    else if (type == SensorType.PM10) typece = 'noise';

    url += 'type=$typece';
    // https://skopje.pulse.eco/rest/data24h?type=humidity

    // avg e ova
    sendGetRequest(url);

    String res = '1';
    return res;
  }

  String getWeekComparison() {
    // TODO MAKE THIS PROPER
    // https://skopje.pulse.eco/rest/avgData/day?sensorId=-1&type=pm10&from=2024-11-24T02:00:00%2b01:00&to=2024-11-25T12:00:00%2b01:00
    String url = 'https://$location.pulse.eco/rest/dataRaw?';

    String typece = '';
    if (type == SensorType.PM10) typece = 'pm10';
    else if (type == SensorType.PM25) typece = 'pm25';
    else if (type == SensorType.PM1) typece = 'pm1';
    else if (type == SensorType.Temperature) typece = 'temperature';
    else if (type == SensorType.Humidity) typece = 'humidity';
    else if (type == SensorType.Noise) typece = 'noise';

    String from = parseDateTimeToString(startOfWeek(dateTime));
    String to = parseDateTimeToString(dateTime);

    url += 'type=$typece&from=$from&to=$to';

    String res = '2';
    return res;
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

  static void makeListOfSensorTypes(String sensors) {
    // Humidity;Temperature;Noise Level;
    List<String> list = sensors.split(';');
    for (var sensor in list) {
      Elements.listOfSensorTypes.add(sensor);
    }
  }

  @override
  String toString() {
    return 'SensorData(type: $type, data: $data)';
  }
}