import 'dart:convert';
import 'package:http/http.dart' as http;
import 'package:pulse_eco_pocket/utils/elements.dart';

// not in use FOR NOW
Future<void> sendGetRequestForYesterdayComparison(String URLce) async {
  var url = Uri.parse(URLce);

  var response = await http.get(url);

  if (response.statusCode == 200) {
    var data = json.decode(response.body);
    data = data[0];



  } else {
    print('Request failed with status: ${response.statusCode}');
  }
}

Future<void> getTodayData() async {
  String apiUrl = 'https://${Elements.filterByCity.value}.pulse.eco/rest/overall';

  try {
    final response = await http.get(Uri.parse(apiUrl));

    if (response.statusCode == 200) {
      final Map<String, dynamic> jsonResponse = json.decode(response.body);

      final values = jsonResponse['values'] as Map<String, dynamic>;

      Elements.todaySensorValues.value = values.map(
            (key, value) => MapEntry(key, value.toString()),
      );
      Elements.hasInternet = true;

    } else {
      throw Exception('Failed to load data. Status code: ${response.statusCode}');
    }
  } catch (error) {
    print('Error fetching data: $error');
  }
}

