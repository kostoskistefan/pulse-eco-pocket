import 'package:flutter/material.dart';
import 'package:provider/provider.dart';
import 'package:flutter/foundation.dart';
import 'package:pulse_eco_pocket/pages/home_page.dart';
import 'package:pulse_eco_pocket/drivers/ai_interpreter.dart';
import 'package:pulse_eco_pocket/drivers/hardware_sensor_driver.dart';
import 'package:pulse_eco_pocket/utilities/network_connection_listener.dart';

void main() async {
  WidgetsFlutterBinding.ensureInitialized();
  
  await AIInterpreter.loadUrl();

  runApp(
    ChangeNotifierProvider(
      create: (_) => HardwareSensorDriver(),
      child: MyApp(),
    ),
  );
}

class MyApp extends StatefulWidget {
  const MyApp({super.key});

  @override
  State<MyApp> createState() => _MyAppState();
}

class _MyAppState extends State<MyApp> {
  @override
  initState() {
    super.initState();
    NetworkConnectionListener.initialize();
  }

  @override
  dispose() {
    super.dispose();
    NetworkConnectionListener.dispose();
  }

  @override
  Widget build(BuildContext context) {
    return MaterialApp(
      title: 'Pulse-Eco Pocket',
      debugShowCheckedModeBanner: false,
      theme: ThemeData(
        useMaterial3: true,
        colorScheme: ColorScheme.fromSeed(seedColor: Colors.lightBlue),
        cardColor: Color(0xffe9edf8),          
      ),
      home: const HomePage(),
    );
  }
}

