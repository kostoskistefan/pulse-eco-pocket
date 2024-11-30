import 'package:flutter/cupertino.dart';
import 'package:intl/intl.dart';
import 'package:proba/features/navigation/presentation/model/Requests.dart';
import 'package:proba/utils/arduino_controller.dart';
import '../features/navigation/presentation/model/Sensor_Data.dart';
import '../features/navigation/presentation/model/enumartions/sensor_type.dart';

class Elements {
  static ArduinoController? arduinoController;
  static ValueNotifier<bool> hasUsb = ValueNotifier<bool>(false);
  static bool hasInternet = false;
  static ValueNotifier<Map<String, String>> mapOfSensors = ValueNotifier<Map<String, String>>({
    "tmp": '...',
    "tmp1": '...',
    "tmp2": '...',
    "tmp3": '...',
  });
  static Map<String, String> mapOfSensorsUnits = {};
  static Map<String, List<String>> dataOfSensors = {};

  static List<String> availableDates = [
    DateFormat('EEEE\nMMMM d, yyyy').format(DateTime.now()),
    DateFormat('EEEE\nMMMM d, yyyy').format(DateTime.now().subtract(const Duration(days: 1))),
    DateFormat('EEEE\nMMMM d, yyyy').format(DateTime.now().subtract(const Duration(days: 2))),
  ];
  static List<String> availableCities = ["skopje",
                                        "tirana",
                                        "sofia",
                                        "yambol",
                                        "zagreb",
                                        "nicosia",
                                        "copenhagen",
                                        "berlin",
                                        "magdeburg",
                                        "syros",
                                        "thessaloniki",
                                        "cork",
                                        "novo selo",
                                        "struga",
                                        "bitola",
                                        "stardojran",
                                        "shtip",
                                        "tetovo",
                                        "gostivar",
                                        "ohrid",
                                        "resen",
                                        "kumanovo",
                                        "strumica",
                                        "bogdanci",
                                        "kichevo",
                                        "chisinau",
                                        "delft",
                                        "amsterdam",
                                        "bucharest",
                                        "targu mures",
                                        "sacele",
                                        "codlea",
                                        "roman",
                                        "cluj-napoca",
                                        "oradea",
                                        "iasi",
                                        "brasov",
                                        "nis",
                                        "lausanne",
                                        "zuchwil",
                                        "bern",
                                        "luzern",
                                        "grenchen",
                                        "zurich",
                                        "grand rapids",
                                        "portland"
                                        ];
  static ValueNotifier<Map<String, String>> todaySensorValues = ValueNotifier<Map<String, String>>({});

  static ValueNotifier<String> filterByCity = ValueNotifier<String>('skopje');
  static ValueNotifier<DateTime> filterByDate = ValueNotifier<DateTime>(DateTime.now());
  static ValueNotifier<List<Map<String, String>>> globalSensors = ValueNotifier<List<Map<String, String>>>([]);

  static void initializeListeners() {
    filterByCity.addListener(_updatetodaySensorValues);
    filterByDate.addListener(_updateSensorItems);
    todaySensorValues.addListener(_updateSensorItems);
  }

  static void _updateSensorItems() {
    List<Map<String, String>> res = [];
    todaySensorValues.value.forEach((k, v) {
      switch (k) {
        case 'pm10':
          if (v == 'N/A') break;
          res.add(SensorData(SensorType.PM10, todaySensorValues.value['pm10']!, filterByDate.value, filterByCity.value).toMap());
          break;

        case 'pm25':
          if (v == 'N/A') break;
          res.add(SensorData(SensorType.PM25, todaySensorValues.value['pm25']!, filterByDate.value, filterByCity.value).toMap());
          break;

        case 'pm1':
          if (v == 'N/A') break;
          res.add(SensorData(SensorType.PM1, todaySensorValues.value['pm1']!, filterByDate.value, filterByCity.value).toMap());
          break;

        case 'noise_dba':
          if (v == 'N/A') break;
          res.add(SensorData(SensorType.Noise, todaySensorValues.value['noise_dba']!, filterByDate.value, filterByCity.value).toMap());
          break;

        case 'temperature':
          if (v == 'N/A') break;
          res.add(SensorData(SensorType.Temperature, todaySensorValues.value['temperature']!, filterByDate.value, filterByCity.value).toMap());
          break;

        case 'humidity':
          if (v == 'N/A') break;
          res.add(SensorData(SensorType.Humidity, todaySensorValues.value['humidity']!, filterByDate.value, filterByCity.value).toMap());
          break;

        case 'pressure':
          if (v == 'N/A') break;
          res.add(SensorData(SensorType.Pressure, todaySensorValues.value['pressure']!, filterByDate.value, filterByCity.value).toMap());
          break;

        case 'no2':
          if (v == 'N/A') break;
          res.add(SensorData(SensorType.NO2, todaySensorValues.value['no2']!, filterByDate.value, filterByCity.value).toMap());
          break;

        case 'o3':
          if (v == 'N/A') break;
          res.add(SensorData(SensorType.O3, todaySensorValues.value['o3']!, filterByDate.value, filterByCity.value).toMap());
          break;

        case 'co':
          if (v == 'N/A') break;
          res.add(SensorData(SensorType.CO, todaySensorValues.value['co']!, filterByDate.value, filterByCity.value).toMap());
          break;
      }
    });
    globalSensors.value = res;
  }

  static void _updatetodaySensorValues() {
    getTodayData();
  }
}