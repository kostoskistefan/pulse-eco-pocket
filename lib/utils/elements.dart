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
  static ValueNotifier<Map<String, String>> mapOfSensors = ValueNotifier<Map<String, String>>({});
  static Map<String, List<String>> dataOfSensors = {};

  static List<String> availableDates = [
    DateFormat('EEEE\nMMMM d, yyyy').format(DateTime.now()),
    DateFormat('EEEE\nMMMM d, yyyy').format(DateTime.now().subtract(const Duration(days: 1))),
    DateFormat('EEEE\nMMMM d, yyyy').format(DateTime.now().subtract(const Duration(days: 2))),
  ];
  static List<String> availableCities = ['skopje', 'bitola', 'paris', 'New York'];
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
    List<Map<String, String>> res = [
      SensorData(SensorType.PM10, todaySensorValues.value['pm10']!, filterByDate.value, filterByCity.value).toMap(),
      SensorData(SensorType.PM25, todaySensorValues.value['pm25']!, filterByDate.value, filterByCity.value).toMap(),
      // SensorData(SensorType.PM1, todaySensorValues.value['pm10']!, filterByDate.value, filterByCity.value).toMap(),
      SensorData(SensorType.Temperature, todaySensorValues.value['temperature']!, filterByDate.value, filterByCity.value).toMap(),
      SensorData(SensorType.Humidity, todaySensorValues.value['humidity']!, filterByDate.value, filterByCity.value).toMap(),
      SensorData(SensorType.Noise, todaySensorValues.value['noise_dba']!, filterByDate.value, filterByCity.value).toMap(),
      SensorData(SensorType.Pressure, todaySensorValues.value['pressure']!, filterByDate.value, filterByCity.value).toMap(),
    ];
    globalSensors.value = res;
  }

  static void _updatetodaySensorValues() {
    getTodayData();
  }
}