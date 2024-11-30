import 'package:flutter/material.dart';
import '../../../../../utils/elements.dart';
import '../../widgets/top_location_bar.dart';
import 'info_stats_page.dart';

class StatisticsPage extends StatelessWidget {
  const StatisticsPage({super.key});

  String capitalizeFirstLetter(String input) {
    if (input.isEmpty) return input;
    return input[0].toUpperCase() + input.substring(1);
  }

  @override
  Widget build(BuildContext context) {
    return MaterialApp(
      debugShowCheckedModeBanner: false,
      home: Scaffold(
        appBar: AppBar(
          title: ValueListenableBuilder<String>(
            valueListenable: Elements.filterByCity,
            builder: (context, city, _) {
              return Text("How does ${capitalizeFirstLetter(city)} feel today");
            },
          ),
        ),
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
