import 'dart:async';
import 'dart:typed_data';
import 'package:pulse_eco_pocket/model/Sensor_Data.dart';
import 'package:usb_serial/usb_serial.dart';
import 'elements.dart';

enum ArduinoControllerState {
  IDLE,
  WAITING_FOR_READY_SIGNAL,
  READING_LABELS,
  READING_UNITS,
  READING_DATA,
}

enum ArduinoControllerCommand {
  REQUEST_LABELS     (76), // 'L' has Unicode value 76
  REQUEST_UNITS      (85), // 'U' has Unicode value 85
  REQUEST_DATA_START (83), // 'S' has Unicode value 83
  REQUEST_DATA_END   (69); // 'E' has Unicode value 69

  const ArduinoControllerCommand(this.value);
  final int value;
}

class ArduinoController {
  UsbPort? port;
  StreamSubscription<Uint8List>? listen;

  ArduinoControllerState state = ArduinoControllerState.WAITING_FOR_READY_SIGNAL;

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

    port!.setPortParameters(9600, 8, 1, UsbPort.PARITY_NONE);

    listen = port!.inputStream?.listen((data) {
      String string = String.fromCharCodes(data);
      print('Received: ${string}');
      readResponse(string);
    }, cancelOnError: true);
  }

  bool isSensorReady(String response) {
    return response == '1';
  }

  void readResponse(String response) {
    switch (state) {
      case ArduinoControllerState.WAITING_FOR_READY_SIGNAL:
        if (isSensorReady(response)) {
          Elements.hasUsb.value = true;
          sendCommand(ArduinoControllerCommand.REQUEST_LABELS.value);
          state = ArduinoControllerState.READING_LABELS;
        }
        break;

      case ArduinoControllerState.READING_LABELS:
        SensorData.makeMapOfSensors(response);
        sendCommand(ArduinoControllerCommand.REQUEST_UNITS.value);
        state = ArduinoControllerState.READING_UNITS;
        break;

      case ArduinoControllerState.READING_UNITS:
        SensorData.addUnitsForSensors(response);
        state = ArduinoControllerState.READING_DATA;
        break;

      case ArduinoControllerState.READING_DATA:
        SensorData.updateMapOfSensors(response);
        break;

      case ArduinoControllerState.IDLE:
        break;
    }
  }

  Future<void> sendCommand(int command) async {
    if (port == null) {
      print('Port not initialized. Connect first!');
      return;
    }

    await port!.write(Uint8List.fromList([command]));
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
