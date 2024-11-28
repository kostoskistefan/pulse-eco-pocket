import 'package:flutter/material.dart';
import 'package:proba/features/navigation/presentation/model/enumartions/sensor_type.dart';
import 'package:proba/features/navigation/presentation/pages/statistics/statistics_page.dart';
import '../../../../utils/elements.dart';
import '../model/Sensor_Data.dart';
import '../pages/statistics/info_stats_page.dart';

class StatisticsPage extends StatelessWidget {
  const StatisticsPage({super.key});

  @override
  Widget build(BuildContext context) {
    return MaterialApp(
      home: Scaffold(
        appBar: AppBar(title: const Text("How does Skopje feel today")), //TODO: Da se napraj spored lokacija
        body: Column(
          children: [
            const HeaderStatisticsWidget(),
            Expanded(
              child: ValueListenableBuilder<List<Map<String, String>>>(
                valueListenable: Elements.globalSensors,
                builder: (context, sensorItems, _) {
                  return ListView.builder(
                    scrollDirection: Axis.horizontal,
                    itemCount: sensorItems.length,
                    itemBuilder: (context, index) {
                      final item = sensorItems[index];
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
