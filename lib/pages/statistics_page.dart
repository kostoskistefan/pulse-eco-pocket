import 'package:flutter/material.dart';
import 'package:pulse_eco_pocket/pages/statistics/no_internet_page.dart';
import 'package:pulse_eco_pocket/pages/statistics/statistics_view_page.dart';
import 'package:pulse_eco_pocket/utilities/network_connection_listener.dart';

class StatisticsPage extends StatelessWidget {
  const StatisticsPage({super.key});

  @override
  Widget build(BuildContext context) {
    return ValueListenableBuilder<bool>(
      valueListenable: NetworkConnectionListener.isConnectedNotifier,
      builder: (context, isConnected, child) {
        return Container(
          padding: const EdgeInsets.all(10),
          alignment: Alignment.center,
          decoration: BoxDecoration(
            color: Theme.of(context).cardColor,
            borderRadius: BorderRadius.circular(16),
          ),
          child: isConnected ? StatisticsViewPage() : NoInternetPage(),
        );
      },
    );
  }
}
