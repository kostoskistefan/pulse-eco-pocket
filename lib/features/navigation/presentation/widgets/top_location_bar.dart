import 'package:flutter/material.dart';
import 'package:proba/features/navigation/presentation/model/enumartions/sensor_type.dart';
import 'package:proba/features/navigation/presentation/pages/statistics/statistics_page.dart';
import '../model/Sensor_Data.dart';
import '../pages/statistics/info_stats_page.dart';

class StatisticsPage extends StatelessWidget {

  final List<Map<String, String>> items = [
    SensorData(SensorType.PM10, 10, DateTime.now(), 'skopje').toMap(),
    SensorData(SensorType.Temperature, 30, DateTime(2024, 11, 23), 'skopje').toMap(),
    SensorData(SensorType.Humidity, 2, DateTime.now(), 'skopje').toMap(),
    // SensorData(SensorType.PM10, 10, DateTime.now(), 'skopje').toMap(),
  ];

  @override
  Widget build(BuildContext context) {
    return MaterialApp(
      home: Scaffold(
        appBar: AppBar(title: const Text("How does Skopje feel today")),
        body: Column(
          children: [
            HeaderStatisticsWidget(location: "Skopje"),
            Expanded(
              child: ListView.builder(
                scrollDirection: Axis.horizontal,
                itemCount: items.length,
                itemBuilder: (context, index) {
                  final item = items[index];
                  return SizedBox(
                    width: MediaQuery.of(context).size.width * 0.9,
                    child: InfoStatsPage(
                      title: item["title"]!,
                      particles: item["particles"]!,
                      description: item["description"]!,
                      comparisonText: item["comparisonText"]!,
                      yesterdayComparison: item["yesterdayComparison"]!,
                      weekComparison: item["weekComparison"]!,
                    ),
                  );
                },
              ),
            ),
          ],
        ),
      ),
    );
  }
}
