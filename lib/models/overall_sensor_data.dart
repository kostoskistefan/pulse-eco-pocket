import 'dart:convert';
import 'package:http/http.dart' as http;
 
class OverallSensorData {
  Map<String, String> values = {};

  Future<void> fetch(String city) async {
    final String cityLowercase = city.toLowerCase().replaceAll(' ', '');
    final response = await http.get(Uri.parse('https://$cityLowercase.pulse.eco/rest/overall'));

    values?.clear();

    if (response.statusCode != 200) {
      return;
    }

    json.decode(response.body)['values'].forEach(
      (key, value) {
        String adjustedKey = key.replaceAll('_', ' ');

        if (key.contains('_dba')) {
          adjustedKey = adjustedKey.substring(0, adjustedKey.length - 4);
        }

        if (RegExp(r'.*\d.*').hasMatch(adjustedKey)) {
          adjustedKey = adjustedKey.toUpperCase();
        }
        else {
          adjustedKey = adjustedKey[0].toUpperCase() + adjustedKey.substring(1);
        }

        values![adjustedKey] = value;
      }
    );
  }
}
