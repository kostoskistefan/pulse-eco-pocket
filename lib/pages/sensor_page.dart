import 'package:flutter/material.dart';
import 'package:provider/provider.dart';
import 'package:flutter/foundation.dart';
import 'package:pulse_eco_pocket/drivers/hardware_sensor_driver.dart';
import 'package:pulse_eco_pocket/pages/sensor/sensor_found_page.dart';
import 'package:pulse_eco_pocket/pages/sensor/sensor_not_found_page.dart';

class SensorPage extends StatelessWidget {
  const SensorPage({super.key});

  @override
  Widget build(BuildContext context) {
    return Consumer<HardwareSensorDriver>(
      builder: (context, hardwareSensorDriver, child) {
        bool sensorConnected = (hardwareSensorDriver.sensor != null);

        return Container(
          padding: const EdgeInsets.all(10),
          alignment: Alignment.center,
          decoration: BoxDecoration(
            color: Theme.of(context).cardColor,
            borderRadius: BorderRadius.circular(16)
          ),
          child: sensorConnected ? SensorFoundPage() : SensorNotFoundPage(),
        );
      },
    );
  }
}
