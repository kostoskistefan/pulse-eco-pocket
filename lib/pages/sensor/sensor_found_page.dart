import 'package:flutter/material.dart';
import 'package:provider/provider.dart';
import 'package:pulse_eco_pocket/drivers/ai_interpreter.dart';
import 'package:pulse_eco_pocket/widgets/sensor_container.dart';
import 'package:pulse_eco_pocket/drivers/hardware_sensor_driver.dart';
import 'package:pulse_eco_pocket/utilities/network_connection_listener.dart';

class SensorFoundPage extends StatefulWidget {
  const SensorFoundPage({Key? key}) : super(key: key);

  @override
  State<SensorFoundPage> createState() => _SensorFoundPageState();
}

class _SensorFoundPageState extends State<SensorFoundPage> {
  bool _readToggled = HardwareSensorDriver().state == HardwareSensorDriverState.READING_DATA;
  bool _uploadToggled = true;

  void _interpretDataWithAI(BuildContext context) async {
    showDialog(
      context: context,
      barrierDismissible: false,
      builder: (BuildContext context) {
        return StatefulBuilder(
          builder: (context, setState) {
            return AlertDialog(
              content: Row(
                children: const [
                  CircularProgressIndicator(),
                  SizedBox(width: 20),
                  Text("Analyzing data..."),
                ],
              ),
            );
          },
        );
      },
    );

    String aiResponse = await AIInterpreter.interpret();

    setState(() {
      Navigator.of(context).pop();

      showDialog(
        context: context,
        barrierDismissible: true,
        builder: (BuildContext context) {
          return AlertDialog(
            title: Text("AI Interpretation"),
            content: SingleChildScrollView(
              child: Text(aiResponse),
            ),
          );
        },
      );
    });
  }

  @override
  Widget build(BuildContext context) {
    return Column(
      children: [
        Expanded(
          child: Center(
            child: Consumer<HardwareSensorDriver>(
              builder: (context, hardwareSensorDriver, child) {
                final sensor = hardwareSensorDriver.sensor;

                if (sensor == null || sensor.data.isEmpty) {
                  return Center(
                    child: Column(
                      mainAxisAlignment: MainAxisAlignment.center,
                      children: const [
                        CircularProgressIndicator(),
                        SizedBox(height: 20),
                        Text('Initializing Sensor')
                      ],
                    ),
                  );
                }

                final data = sensor.data;

                return GridView.builder(
                  shrinkWrap: true,
                  gridDelegate: const SliverGridDelegateWithFixedCrossAxisCount(
                    crossAxisCount: 2,
                    crossAxisSpacing: 10,
                    mainAxisSpacing: 10,
                  ),
                  itemCount: data.length,
                  itemBuilder: (BuildContext context, int index) {
                    final sensorData = data[index];
                    return SensorContainer(
                      label: sensorData.name,
                      value: sensorData.value,
                      unit: sensorData.unit,
                    );
                  },
                );
              },
            ),
          ),
        ),
        Divider(height: 20),
        Row(
          mainAxisAlignment: MainAxisAlignment.spaceEvenly,
          children: [
            Expanded(
              flex: 1,
              child: Column(
                children: [
                  Switch(
                    value: _uploadToggled,
                    onChanged: (value) {
                      setState(() {
                        _uploadToggled = value;
                      });
                    },
                  ),
                  Text("Upload data", style: Theme.of(context).textTheme.titleMedium),
                ],
              ),
            ),
            Expanded(
              flex: 1,
              child: Column(
                children: [
                  Switch(
                    value: _readToggled,
                    onChanged: _toggleReadMode,
                  ),
                  Text("Read sensor", style: Theme.of(context).textTheme.titleMedium),
                ],
              ),
            ),
          ]
        ),
        ValueListenableBuilder<bool>(
          valueListenable: NetworkConnectionListener.isConnectedNotifier,
          builder: (context, isConnected, child) {
            return isConnected
              ? Padding(
                  padding: const EdgeInsets.only(top: 8),
                  child: TextButton.icon(
                    icon: const Icon(Icons.visibility),
                    label: const Text('Interpret data with AI'),
                    onPressed: () {
                      _interpretDataWithAI(context);
                    },
                  ),
                )
              : SizedBox.shrink();
          },
        ),
      ],
    );
  }

  void _toggleReadMode(bool value) {
    if (value == true) {
      HardwareSensorDriver().startReading();
    }

    else {
      HardwareSensorDriver().stopReading();
    }

    setState(() {
      _readToggled = value;
    });
  }
}
