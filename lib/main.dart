import 'package:flutter/material.dart';
import 'package:proba/utils/elements.dart';
import 'package:usb_serial/usb_serial.dart';
import 'features/navigation/presentation/pages/home_page.dart';
import 'utils/arduino_controller.dart';

void main() {
  runApp(MyApp());
  UsbSerial.usbEventStream?.listen((msg) {
    if (msg.event == UsbEvent.ACTION_USB_ATTACHED) {
      Elements.hasUsb = true;
      Elements.arduinoController = new ArduinoController();
      Elements.arduinoController!.connectToArduino();
    }
    else if (msg.event == UsbEvent.ACTION_USB_DETACHED) {
      Elements.hasUsb = false;
      Elements.arduinoController!.disconnect();
    }
  });
}



class MyApp extends StatelessWidget {
  const MyApp({super.key});

  @override
  Widget build(BuildContext context) {
    return MaterialApp(
      title: 'CodeFu Architecture',
      theme: ThemeData(
        primarySwatch: Colors.blue,
      ),
      home: const HomePage(),
    );
  }
}
