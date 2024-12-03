import 'package:flutter/material.dart';
import 'package:pulse_eco_pocket/utils/elements.dart';
import 'package:pulse_eco_pocket/widgets/logo_header.dart';
import 'package:pulse_eco_pocket/pages/sensor/sensor_found_page.dart';
import 'package:pulse_eco_pocket/pages/sensor/sensor_not_found_page.dart';

class SensorPage extends StatefulWidget {
  const SensorPage({super.key});

  @override
  _SensorPageState createState() => _SensorPageState();
}

class _SensorPageState extends State<SensorPage> {

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      body: SafeArea(
        child: Column(
          mainAxisAlignment: MainAxisAlignment.center,
          children: [
            const LogoHeaderWidget(),
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
      ),
    );
  }
}
