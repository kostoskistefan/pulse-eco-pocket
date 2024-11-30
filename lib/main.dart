import 'package:flutter/material.dart';
import 'package:proba/utils/elements.dart';
import 'package:usb_serial/usb_serial.dart';
import 'features/navigation/presentation/pages/home_page.dart';
import 'utils/arduino_controller.dart';
import 'features/navigation/presentation/model/Requests.dart';

Future<void> main() async {
  await loadAllNecessaryStuff();

  runApp(MyApp());

  usbEventListeners();
}

void usbEventListeners() {
  UsbSerial.usbEventStream?.listen((msg) {
    if (msg.event == UsbEvent.ACTION_USB_ATTACHED) {
      Elements.arduinoController = new ArduinoController();
      Elements.arduinoController!.connectToArduino();
      Elements.hasUsb.value = true;
    }
    else if (msg.event == UsbEvent.ACTION_USB_DETACHED) {
      Elements.hasUsb.value = false;
      Elements.arduinoController!.disconnect();
      Elements.mapOfSensors.value = {};
    }
  });
}

Future<void> loadAllNecessaryStuff() async {
  Elements.initializeListeners();
  try {
    await getTodayData();
  } catch (e) {
    print(e);
  }
}

class MyApp extends StatelessWidget {
  const MyApp({super.key});

  void checkUsbAttached() {
    Elements.arduinoController = new ArduinoController();
    Elements.arduinoController!.connectToArduino();
  }

  @override
  Widget build(BuildContext context) {
    checkUsbAttached(); // CHECK IF HAS SENSOR CONNECTED
    return MaterialApp(
      title: 'CodeFu Architecture',
      debugShowCheckedModeBanner: false,
      theme: ThemeData(
        primarySwatch: Colors.blue,
      ),
      home: const HomePage(),
    );
  }
}
