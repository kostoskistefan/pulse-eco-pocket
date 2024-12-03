import 'package:flutter/material.dart';
import 'package:pulse_eco_pocket/widgets/logo_header.dart';
import 'package:pulse_eco_pocket/pages/infobox/info_box_popup.dart';

class SensorNotFoundPage extends StatelessWidget {
  const SensorNotFoundPage({super.key});

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      body: Column(
        children: [
          Expanded(
            child: Container(
              width: double.infinity,
              child: Column(
                mainAxisAlignment: MainAxisAlignment.center,
                crossAxisAlignment: CrossAxisAlignment.center,
                children: [
                  const Text(
                    'Sensor not found...',
                    style: TextStyle(
                      fontSize: 34,
                      fontWeight: FontWeight.bold,
                    ),
                  ),
                  const SizedBox(height: 8),
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

          const PopupButton(),
          const SizedBox(height: 16),
        ],
      ),
    );
  }
}
