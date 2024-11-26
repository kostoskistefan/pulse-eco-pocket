import 'package:flutter/material.dart';
import '../../widgets/logo_header.dart';
import '../infobox/info_box_popup.dart';

class SensorNotFoundPage extends StatelessWidget {
  const SensorNotFoundPage({super.key});

  @override
  Widget build(BuildContext context) {
    return MaterialApp(
      home: Scaffold(
        body: Column(
          children: [
            const LogoHeaderWidget(logoPath: 'lib/features/navigation/presentation/images/logo.png'),

            Expanded(
              child: Center(
                child: Column(
                  mainAxisSize: MainAxisSize.min,
                  children: [
                    const Text(
                      'Sensor not found...',
                      style: TextStyle(
                        fontSize: 34,
                        fontWeight: FontWeight.bold,
                      ),
                    ),
                    const SizedBox(height: 8.0),
                    Text(
                      'add sensor device or\nexplore other features',
                      style: TextStyle(
                        fontSize: 20,
                        color: Colors.grey[700],
                      ),
                    ),
                  ],
                ),
              ),
            ),

            const PopupButton()
          ],
        ),
      ),
    );
  }
}
