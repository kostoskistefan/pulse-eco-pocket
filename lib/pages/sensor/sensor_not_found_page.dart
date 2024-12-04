import 'package:flutter/material.dart';

class SensorNotFoundPage extends StatefulWidget {
  const SensorNotFoundPage({super.key});

  @override
  State<SensorNotFoundPage> createState() => _SensorNotFoundPageState();
}

class _SensorNotFoundPageState extends State<SensorNotFoundPage> {

  @override
  Widget build(BuildContext context) {
    return Column(
      mainAxisAlignment: MainAxisAlignment.center,
      crossAxisAlignment: CrossAxisAlignment.center,
      children: [
        const Text(
          'Sensor not found',
          style: TextStyle(fontSize: 34, fontWeight: FontWeight.bold)
        ),
        const SizedBox(height: 10),
        const Text(
          'Connect a sensor or explore other features',
          style: TextStyle(fontSize: 18, color: Colors.grey),
          textAlign: TextAlign.center
        ),
      ],
    );
  }
}
