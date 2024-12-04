import 'package:flutter/material.dart';
import 'package:pulse_eco_pocket/widgets/sensor_container.dart';
import 'package:pulse_eco_pocket/models/overall_sensor_data.dart';
import 'package:pulse_eco_pocket/utilities/sensor_name_to_unit_converter.dart';

const List<String> availableCities = [
  'Skopje',
  'Tirana',
  'Sofia',
  'Yambol',
  'Zagreb',
  'Nicosia',
  'Copenhagen',
  'Berlin',
  'Magdeburg',
  'Syros',
  'Thessaloniki',
  'Cork',
  'Novo Selo',
  'Struga',
  'Bitola',
  'Stardojran',
  'Shtip',
  'Tetovo',
  'Gostivar',
  'Ohrid',
  'Resen',
  'Kumanovo',
  'Strumica',
  'Bogdanci',
  'Kichevo',
  'Chisinau',
  'Delft',
  'Amsterdam',
  'Bucharest',
  'Targu Mures',
  'Sacele',
  'Codlea',
  'Roman',
  'Cluj-Napoca',
  'Oradea',
  'Iasi',
  'Brasov',
  'Nis',
  'Lausanne',
  'Zuchwil',
  'Bern',
  'Luzern',
  'Grenchen',
  'Zurich',
  'Grand Rapids',
  'Portland'
];

class StatisticsViewPage extends StatefulWidget {
  const StatisticsViewPage({super.key});

  @override
  State<StatisticsViewPage> createState() => _StatisticsViewPageState();
}

class _StatisticsViewPageState extends State<StatisticsViewPage> {
  OverallSensorData _overallSensorData = OverallSensorData();
  bool _isLoading = true;

  @override
  void initState() {
    super.initState();
    _loadCityOverallSensorData(availableCities.first);
  }

  void _loadCityOverallSensorData(String city) async {
    setState(() {
      _isLoading = true;
    });
    
    await _overallSensorData.fetch(city);

    setState(() {
      _isLoading = false;
    });
  }

  @override
  Widget build(BuildContext context) {
    return Column(
      children: [
        Expanded(
          child: Center(
            child: _isLoading
                ? Column(
                    mainAxisAlignment: MainAxisAlignment.center,
                    crossAxisAlignment: CrossAxisAlignment.center,
                    children: [
                      CircularProgressIndicator(),
                      SizedBox(height: 20),
                      Text(
                        "Loading data",
                        style: TextStyle(
                          fontSize: 18,
                          color: Colors.grey,
                        ),
                      ),
                    ],
                  )
                : _overallSensorData.values.isEmpty
                    ? Column(
                        mainAxisAlignment: MainAxisAlignment.center,
                        crossAxisAlignment: CrossAxisAlignment.center,
                        children: [
                          Icon(
                            Icons.info_outline,
                            size: 80,
                            color: Colors.grey,
                          ),
                          SizedBox(height: 20),
                          Text(
                            "No data available",
                            style: TextStyle(
                              fontSize: 18,
                              color: Colors.grey,
                            ),
                          ),
                        ],
                      )
                    : GridView.builder(
                        shrinkWrap: true,
                        gridDelegate: const SliverGridDelegateWithFixedCrossAxisCount(
                          crossAxisCount: 2,
                          crossAxisSpacing: 10,
                          mainAxisSpacing: 10,
                        ),
                        itemCount: _overallSensorData.values.length,
                        itemBuilder: (BuildContext context, int index) {
                          final List<String> labels = _overallSensorData.values.keys.toList();
                          final List<String> values = _overallSensorData.values.values.toList();

                          return SensorContainer(label: labels[index], value: values[index]);
                        },
                      ),
          ),
        ),
        Divider(height: 20),
        DropdownMenu<String>(
          width: double.infinity,
          menuHeight: 300,
          initialSelection: availableCities.first,
          leadingIcon: const Icon(Icons.search),
          inputDecorationTheme: const InputDecorationTheme(
            filled: true,
            fillColor: Colors.white,
          ),
          onSelected: (String? value) { _loadCityOverallSensorData(value!); },
          dropdownMenuEntries: availableCities.map<DropdownMenuEntry<String>>((String value) {
            return DropdownMenuEntry<String>(value: value, label: value);
          }).toList(),
        ),
      ],
    );
  }
}
