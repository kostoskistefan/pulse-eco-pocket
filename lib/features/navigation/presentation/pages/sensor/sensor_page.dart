import 'package:flutter/material.dart';
import 'package:proba/features/navigation/presentation/pages/sensor/sensor_found_page.dart';
import 'package:proba/features/navigation/presentation/pages/sensor/sensor_not_found_page.dart';

import '../../../../../utils/elements.dart';

class SensorPage extends StatefulWidget {
  const SensorPage({super.key});

  @override
  _SensorPageState createState() => _SensorPageState();
}

class _SensorPageState extends State<SensorPage> {

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      body: Column(
        mainAxisAlignment: MainAxisAlignment.center,
        children: [
          Expanded(
            child: ValueListenableBuilder<bool>(
              valueListenable: Elements.hasUsb,
              builder: (context, usbAttached, child) {
                if (usbAttached) {
                  return const SensorFoundPage();
                } else {
                  return const SensorNotFoundPage();
                }
              },
            ),
          ),
        ],
      ),
    );
  }
}
