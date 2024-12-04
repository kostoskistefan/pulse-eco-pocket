import 'dart:async';
import 'dart:typed_data';
import 'package:flutter/foundation.dart';
import 'package:usb_serial/usb_serial.dart';
import 'package:pulse_eco_pocket/models/hardware_sensor.dart';

enum HardwareSensorDriverCommand {
  REQUEST_LABELS_AND_UNITS (76), // 'L' has ASCII value 76
  REQUEST_DATA_START       (83), // 'S' has ASCII value 83
  REQUEST_DATA_END         (69); // 'E' has ASCII value 69

  const HardwareSensorDriverCommand(this.value);
  final int value;
}

enum HardwareSensorDriverState {
  IDLE,
  WAITING_FOR_READY_SIGNAL,
  READING_LABELS_AND_UNITS,
  READING_DATA,
}

class HardwareSensorDriver extends ChangeNotifier {
  UsbPort? port;
  HardwareSensor? sensor;
  StreamSubscription<Uint8List>? listen;

  HardwareSensorDriverState state = HardwareSensorDriverState.WAITING_FOR_READY_SIGNAL;

  static final HardwareSensorDriver _instance = HardwareSensorDriver._internal();

  factory HardwareSensorDriver() {
    return _instance;
  }

  HardwareSensorDriver._internal() {
    UsbSerial.usbEventStream?.listen((msg) {
      if (msg.event == UsbEvent.ACTION_USB_ATTACHED) {
        connect();
      }
      else if (msg.event == UsbEvent.ACTION_USB_DETACHED) {
        disconnect();
      }

      notifyListeners();
    });
  }

  Future<void> connect() async {
    List<UsbDevice> devices = await UsbSerial.listDevices();

    if (devices.isEmpty) {
      print('No USB devices found');
      return;
    }

    if (sensor == null) {
      sensor = HardwareSensor();
      notifyListeners();
    }

    port = await devices[0].create();

    bool openResult = false;

    try {
      openResult = await port!.open();
    }
    catch (e) {
      print('Wait for permission!');
    }

    if (!openResult) {
      print('Failed to open USB port');
      if (sensor != null) {
        sensor!.reset();
        sensor = null;
      }
      return;
    }

    port!.setDTR(true);
    port!.setRTS(false);
    port!.setPortParameters(9600, 8, 1, UsbPort.PARITY_NONE);

    state = HardwareSensorDriverState.WAITING_FOR_READY_SIGNAL;

    listen = port!.inputStream?.listen((data) {
      String string = String.fromCharCodes(data);
      print('Received: ${string}');
      readResponse(string);
    }, cancelOnError: true);
  }

  void startReading() {
    state = HardwareSensorDriverState.READING_DATA;
    sendCommand(HardwareSensorDriverCommand.REQUEST_DATA_START.value);
  }

  void stopReading() {
    state = HardwareSensorDriverState.IDLE;
    sendCommand(HardwareSensorDriverCommand.REQUEST_DATA_END.value);
  }

  void readResponse(String response) {
    switch (state) {
      case HardwareSensorDriverState.WAITING_FOR_READY_SIGNAL:
        if (response == '1') {
          sendCommand(HardwareSensorDriverCommand.REQUEST_LABELS_AND_UNITS.value);
          state = HardwareSensorDriverState.READING_LABELS_AND_UNITS;
        }
        break;

      case HardwareSensorDriverState.READING_LABELS_AND_UNITS:
        if (sensor != null)
        {
          sensor!.updateLabelsAndUnits(response);
          notifyListeners();
          state = HardwareSensorDriverState.READING_DATA;
        }
        break;

      case HardwareSensorDriverState.READING_DATA:
        if (sensor != null)
        {
          sensor!.updateValues(response);
          notifyListeners();
        }
        break;

      case HardwareSensorDriverState.IDLE:
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

  Future<void> disconnect() async {
    await listen?.cancel();
    await port?.close();
    sensor?.reset();
    listen = null;
    port = null;
    sensor = null;
    state = HardwareSensorDriverState.WAITING_FOR_READY_SIGNAL;
    notifyListeners();
  }
}
