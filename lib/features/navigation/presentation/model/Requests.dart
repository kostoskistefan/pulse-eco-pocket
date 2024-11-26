import 'package:http/http.dart' as http;
import 'dart:convert';

Future<void> sendGetRequest(String urlce) async {
  var url = Uri.parse('https://skopje.pulse.eco/rest/overall?type=pm10');

  // Send GET request
  var response = await http.get(url);

  // Check the status code and handle the response
  if (response.statusCode == 200) {
    var data = json.decode(response.body);

    print('Received Data:');
    print(data);


  } else {
    // If the server did not return a 200 OK response
    print('Request failed with status: ${response.statusCode}');
  }
}

// Function to send a POST request
Future<void> sendPostRequest() async {
  var url = Uri.parse('https://jsonplaceholder.typicode.com/posts');

  // Define the data you want to send in the request body
  var data = {
    'title': 'foo',
    'body': 'bar',
    'userId': 1,
  };

  // Send POST request with body data
  var response = await http.post(
    url,
    headers: {'Content-Type': 'application/json'},
    body: json.encode(data), // Convert the map to JSON
  );

  if (response.statusCode == 201) {
    // If the server returns a 201 Created response
    print('Response body: ${response.body}');
  } else {
    // If the server did not return a 201 Created response
    print('Request failed with status: ${response.statusCode}');
  }
}
