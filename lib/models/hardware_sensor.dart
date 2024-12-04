import 'package:flutter/foundation.dart';

class HardwareSensorData {
  String name;
  String unit;
  String value;

  HardwareSensorData({
    required this.name,
    required this.unit,
    required this.value,
  });
}

class HardwareSensor {
  List<HardwareSensorData> data = [];

  void updateLabelsAndUnits(String response) {
    List<String> sensorData = response.split(';');
    sensorData = sensorData.sublist(0, sensorData.length - 1);

    data.clear(); 

    for (int i = 0; i < sensorData.length; i++) {
      final List<String> labelsAndUnits = sensorData[i].split(',');

      data.add(
        HardwareSensorData(
          name: labelsAndUnits[0],
          unit: labelsAndUnits[1],
          value: '',
        )
      );
    }
  }

  void updateValues(String response) {
    List<String> values = response.split(';');
    values = values.sublist(0, values.length - 1);

    for (int i = 0; i < values.length; i++) {
      data[i].value = values[i];
    }
  }

  void reset() {
    data.clear();
  }
}
