import 'dart:async';
import 'dart:typed_data';
import 'package:proba/features/navigation/presentation/model/Sensor_Data.dart';
import 'package:usb_serial/usb_serial.dart';
import 'package:flutter/material.dart';

import '../features/navigation/presentation/model/Notifier.dart';
import '../features/navigation/presentation/pages/sensor/sensor_found_page.dart';
import 'elements.dart';

class ArduinoController {

  // static ArduinoController? arduinoController;

  UsbPort? port;
  StreamSubscription<Uint8List>? listen;
  Notifier<bool> readyNotifier = new Notifier<bool>();


  Future<void> connectToArduino() async {
    List<UsbDevice> devices = await UsbSerial.listDevices();
    if (devices.isEmpty) {
      print('No USB devices found');
      Elements.arduinoController = null;
      return;
    }

    port = await devices[0].create();
    bool openResult = false;
    try {
      openResult = await port!.open();
    } catch (e) {
      print('Wait for permission!');
    }

    if (!openResult) {
      print('Failed to open USB port');
      return;
    }

    port!.setDTR(true); // Reset Arduino
    port!.setRTS(false); // Our Arduino doesn't use RS 232

    // podeseni stvari
    // TODO THIS IS DINAMICAL
    port!.setPortParameters(9600, 8, 1, UsbPort.PARITY_NONE);

    listen = port!.inputStream?.listen((data) {
      String string = String.fromCharCodes(data);
      print('Received: ${string}');
      handleArduinoInput(string);
    }, cancelOnError: true);
  }

  void handleArduinoInput(String string) {
    if (string == '1') {
      sendCommand(82);
      Elements.hasUsb.value = true;
    }
    else if (string == '') {
      print('What?'); // TODO CHECK THIS
    }
    else if (hasNumbers(string)) { // RECIEVED NUMBERS (S)
      SensorData.updateMapOfSensors(string);
    }
    else { // RECIEVED SENSOR TYPES
      SensorData.makeMapOfSensors(string);
    }
  }

  Future<void> sendCommand(int command) async {
    if (port == null) {
      print('Port not initialized. Connect first!');
      return;
    }

    Uint8List commandBytes = Uint8List.fromList([command]);
    await port!.write(commandBytes);
    print('Sent: $command');
  }

  // TODO CHECK HOW TO DISCONNECT PROPERLY
  Future<void> disconnect() async {
    await listen?.cancel();
    listen = null;
    await port?.close();
    port = null;
    print('Disconnected from Arduino');
  }

  bool hasNumbers(String input) {
    return RegExp(r'[0-9]').hasMatch(input);
  }
}