import 'package:flutter/material.dart';
import '../../../../../utils/arduino_controller.dart';
import '../../../../../utils/elements.dart';
import '../../widgets/logo_header.dart';

class SensorFoundPage extends StatefulWidget {
  const SensorFoundPage({super.key});

  @override
  _SensorFoundPageState createState() => _SensorFoundPageState();
}

class _SensorFoundPageState extends State<SensorFoundPage> {
  bool readDataIsToggled = false;
  bool uploadDataIsToggled = true;

  List<Widget> createSensorButtons() {
    List<Widget> res = [];

    for (var value in Elements.listOfSensorTypes) {
      res.add(_buildSensorButton('...', value));
    }

    return res;
  }

  @override
  Widget build(BuildContext context) {
    print('TOP');
    return Scaffold(
      body: Column(
        mainAxisAlignment: MainAxisAlignment.spaceBetween,
        children: [
          Column(
            children: [
              const LogoHeaderWidget(logoPath: 'lib/features/navigation/presentation/images/logo.png'),

              const SizedBox(height: 32),
              const Text(
                'Read data',
                style: TextStyle(
                  fontSize: 24,
                  fontWeight: FontWeight.bold,
                  color: Colors.black,
                ),
              ),

              // const SizedBox(height: 8),
              IconButton(
                onPressed: () {
                  setState(() {
                    readDataIsToggled = !readDataIsToggled;
                  });
                },
                icon: Icon(
                  readDataIsToggled ? Icons.toggle_on : Icons.toggle_off,
                  size: 80,
                  color: readDataIsToggled ? Colors.blue : Colors.grey
                ),
              ),

              const SizedBox(height: 18),
              GridView.count(
                shrinkWrap: true,
                crossAxisCount: 3,
                mainAxisSpacing: 16,
                crossAxisSpacing: 16,
                padding: const EdgeInsets.symmetric(horizontal: 16),
                children: createSensorButtons(),
              ),

              const SizedBox(height: 24),
              const Text(
                'Vizualize this data',
                style: TextStyle(
                    fontSize: 20,
                    fontWeight: FontWeight.w500,
                    color: Colors.blue,
                    decoration: TextDecoration.underline
                ),
              ),
            ],
          ),

          Padding(
            padding: const EdgeInsets.only(bottom: 6.0),
            child: Row(
              mainAxisAlignment: MainAxisAlignment.center,
              children: [
                // IconButton(
                //   onPressed: () {
                //     setState(() {
                //       uploadDataIsToggled = !uploadDataIsToggled; // Toggle the state
                //     });
                //   },
                //   icon: Icon(
                //     uploadDataIsToggled ? Icons.toggle_on : Icons.toggle_off,
                //     size: 70,
                //     color: uploadDataIsToggled ? Colors.blue : Colors.grey
                //   ),
                // ),
                // const Text(
                //   'Upload to database?',
                //   style: TextStyle(
                //     fontSize: 16,
                //     fontWeight: FontWeight.w400,
                //   ),
                // ),

                IconButton(
                  onPressed: () {
                    Elements.arduinoController!.sendCommand(82); // R
                  },
                  icon: const Icon(
                      Icons.call,
                      size: 30,
                      color: Colors.red
                  ),
                ),
                IconButton(
                  onPressed: () {
                    Elements.arduinoController!.sendCommand(83); // S
                  },
                  icon: const Icon(
                      Icons.input,
                      size: 30,
                      color: Colors.red
                  ),
                ),
                IconButton(
                  onPressed: () {
                    Elements.arduinoController!.sendCommand(69); // E
                  },
                  icon: const Icon(
                      Icons.call_end,
                      size: 30,
                      color: Colors.red
                  ),
                ),
                IconButton(
                  onPressed: () {
                    Elements.arduinoController!.disconnect();
                  },
                  icon: const Icon(
                      Icons.alarm,
                      size: 30,
                      color: Colors.red
                  ),
                ),
              ],
            ),
          ),
        ],
      ),
    );
  }

  Widget _buildSensorButton(String value, String label) {
    return Container(
      decoration: BoxDecoration(
        color: Colors.blue[50],
        borderRadius: BorderRadius.circular(10),
        border: Border.all(color: Colors.blue, width: 2),
      ),
      padding: const EdgeInsets.all(8.0),
      child: Column(
        mainAxisAlignment: MainAxisAlignment.center,
        children: [
          Text(
            value,
            style: const TextStyle(
              fontSize: 16,
              fontWeight: FontWeight.bold,
            ),
          ),

          const Divider(
            color: Colors.blue,
            thickness: 2.0,
            indent: 12.0,
            endIndent: 12.0,
          ),

          // const SizedBox(height: 8),
          Text(
            label,
            textAlign: TextAlign.center,
            style: const TextStyle(
              fontSize: 12,
              color: Colors.black87,
            ),
          ),
        ],
      ),
    );
  }
}

