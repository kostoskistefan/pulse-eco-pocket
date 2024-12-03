import 'package:flutter/material.dart';
import 'package:ollama/ollama.dart';
import 'package:pulse_eco_pocket/utils/elements.dart';
import 'package:pulse_eco_pocket/model/Sensor_Data.dart';

class SensorFoundPage extends StatefulWidget {
  const SensorFoundPage({super.key});

  @override
  _SensorFoundPageState createState() => _SensorFoundPageState();
}

class _SensorFoundPageState extends State<SensorFoundPage> {
  bool readDataIsToggled = false;
  bool uploadDataIsToggled = true;
  bool isLoading = false;
  String aiResponse = '';

  @override
  void initState() {
    super.initState();
    setState(() {
      aiResponse = '';
      isLoading = false;
    });
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      body: SingleChildScrollView(
        child: Column(
          mainAxisAlignment: MainAxisAlignment.spaceBetween,
          children: [
            Column(
              children: [
                const SizedBox(height: 32),
                const Text(
                  'Read data',
                  style: TextStyle(
                    fontSize: 24,
                    fontWeight: FontWeight.bold,
                    color: Colors.black,
                  ),
                ),
                IconButton(
                  onPressed: () {
                    if (Elements.mapOfSensors.value.isNotEmpty) {
                      setState(() {
                        readDataIsToggled = !readDataIsToggled;
                        SensorData.readDataButton(readDataIsToggled);
                      });
                    }
                  },
                  icon: Icon(
                    readDataIsToggled ? Icons.toggle_on : Icons.toggle_off,
                    size: 80,
                    color: readDataIsToggled ? Colors.blue : Colors.grey),
                ),
                const SizedBox(height: 18),
                ValueListenableBuilder<Map<String, String>>(
                  valueListenable: Elements.mapOfSensors,
                  builder: (context, sensors, child) {
                    return GridView.builder(
                      shrinkWrap: true,
                      physics: const NeverScrollableScrollPhysics(),
                      padding: const EdgeInsets.symmetric(horizontal: 16),
                      gridDelegate: const SliverGridDelegateWithFixedCrossAxisCount(
                        crossAxisCount: 3,
                        mainAxisSpacing: 16,
                        crossAxisSpacing: 16,
                      ),
                      itemCount: sensors.length,
                      itemBuilder: (context, index) {
                        final key = sensors.keys.elementAt(index);
                        final value = sensors[key]!;
                        return _buildSensorButton(value, key);
                      },
                    );
                  },
                ),
                const SizedBox(height: 24),
                Padding(
                  padding: const EdgeInsets.symmetric(horizontal: 16),
                  child: Text(
                    aiResponse,
                    style: TextStyle(
                      color: Colors.grey[700],
                      fontSize: 16
                    )
                  )
                ),
                isLoading 
                  ? const CircularProgressIndicator() 
                  : TextButton.icon(
                      icon: const Icon(Icons.visibility),
                      label: const Text('Interpret data'),
                      onPressed: _interpretData,
                    ),
              ],
            ),
            Padding(
              padding: const EdgeInsets.only(bottom: 6.0),
              child: Row(
                mainAxisAlignment: MainAxisAlignment.center,
                children: [
                  IconButton(
                    onPressed: () {
                      setState(() {
                        uploadDataIsToggled = !uploadDataIsToggled;
                      });
                    },
                    icon: Icon(
                      uploadDataIsToggled ? Icons.toggle_on : Icons.toggle_off,
                      size: 70,
                      color: uploadDataIsToggled ? Colors.blue : Colors.grey),
                  ),
                  const Text(
                    'Upload to database?',
                    style: TextStyle(
                      fontSize: 16,
                      fontWeight: FontWeight.w400,
                    ),
                  ),
                ],
              ),
            ),
          ],
        ),
      ),
    );
  }

  Future<void> _interpretData() async {
    setState(() {
      aiResponse = '';
      isLoading = true;
    });

    if (Elements.mapOfSensors.value.isEmpty) {
      setState(() {
        isLoading = false;
      });
      return;
    }

    String prompt = 'Summarize the following environmental data using very common everyday situations/activities in a very short sentence so that even the dumbest person can understand what those values mean: ';

    for (final sensor in Elements.mapOfSensors.value.entries) {
      prompt += '${sensor.key}: ${sensor.value}, '.replaceAll('\n', '');
    }

    final ollama = Ollama(baseUrl: Uri.parse('http://192.168.113.150:11434'));
    final stream = ollama.chat([ChatMessage(role: 'user', content: prompt)], model: 'mistral');

    String response = '';

    await for (final chunk in stream) {
      response += chunk.message?.content ?? '';
    }

    setState(() {
      aiResponse = response;
      isLoading = false;
    });
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
          Text(
            label,
            textAlign: TextAlign.center,
            style: const TextStyle(
              fontSize: 12,
              color: Colors.black87,
              fontWeight: FontWeight.bold
            ),
          ),
        ],
      ),
    );
  }
}
