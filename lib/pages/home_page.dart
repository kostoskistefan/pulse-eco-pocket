import 'package:flutter/material.dart';
import 'package:pulse_eco_pocket/pages/sensor_page.dart';
import 'package:pulse_eco_pocket/pages/camera_page.dart';
import 'package:pulse_eco_pocket/pages/profile_page.dart';
import 'package:pulse_eco_pocket/pages/statistics_page.dart';
import 'package:pulse_eco_pocket/drivers/hardware_sensor_driver.dart';

class HomePage extends StatefulWidget {
  const HomePage({super.key});

  @override
  State<HomePage> createState() => _HomePageState();
}

class _HomePageState extends State<HomePage> {
  int _currentPageIndex = 0;

  @override
  void initState() {
    super.initState();
    HardwareSensorDriver().connect();
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(
        backgroundColor: Theme.of(context).cardColor,
        title: Text("Pulse-Eco Pocket", style: const TextStyle(fontWeight: FontWeight.bold)),
        centerTitle: true,
      ),
      bottomNavigationBar: NavigationBar(
        backgroundColor: Theme.of(context).cardColor,
        onDestinationSelected: (int index) {
          setState(() {
            _currentPageIndex = index;
          });
        },
        selectedIndex: _currentPageIndex,
        destinations: const <Widget>[
          NavigationDestination(
            icon: Icon(Icons.sensors),
            label: 'Sensor',
          ),
          NavigationDestination(
            icon: Icon(Icons.stacked_line_chart),
            label: 'Statistics',
          ),
          NavigationDestination(
            icon: Icon(Icons.camera),
            label: 'Camera',
          ),
          NavigationDestination(
            icon: Icon(Icons.person),
            label: 'Profile',
          ),
        ],
      ),
      body: Container(
        padding: EdgeInsets.all(16),
        child: <Widget>[
          SensorPage(),
          StatisticsPage(),
          CameraPage(),
          ProfilePage(),
        ][_currentPageIndex],
      )
    );
  }
}
