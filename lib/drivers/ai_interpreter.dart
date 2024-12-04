import 'package:ollama/ollama.dart';
import 'package:shared_preferences/shared_preferences.dart';
import 'package:pulse_eco_pocket/drivers/hardware_sensor_driver.dart';

class AIInterpreter {
  static String URL = 'http://localhost:11431';

  static Future<void> loadUrl() async {
    final SharedPreferences sharedPreferences = await SharedPreferences.getInstance();
    URL = sharedPreferences.getString('ai_url') ?? URL;
  }

  static Future<void> setUrl(String url) async {
    final SharedPreferences sharedPreferences = await SharedPreferences.getInstance();
    await sharedPreferences.setString('ai_url', url);
    URL = url;
  }

  static Future<String> interpret() async {
    if (HardwareSensorDriver().sensor == null) {
      return '';
    }

    String prompt = 'Summarize the following environmental data using very common everyday situations/activities in a very short sentence so that even the dumbest person can understand what those values mean: ';

    for (final sensor in HardwareSensorDriver().sensor!.data) {
      prompt += '${sensor.name}: ${sensor.value}${sensor.unit}, ';
    }

    print(prompt);

    final ollama = Ollama(baseUrl: Uri.parse(URL));
    final stream = ollama.chat([ChatMessage(role: 'user', content: prompt)], model: 'mistral');

    String response = '';

    await for (final chunk in stream) {
      response += chunk.message?.content ?? '';
    }

    return response;
  }
}
