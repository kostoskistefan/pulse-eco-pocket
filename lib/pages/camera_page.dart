import 'dart:io';
import 'package:camera/camera.dart';
import 'package:flutter/material.dart';
import 'package:provider/provider.dart';
import 'package:pulse_eco_pocket/main.dart';
import 'package:pulse_eco_pocket/models/particles.dart';
import 'package:pulse_eco_pocket/drivers/hardware_sensor_driver.dart';

class CameraPage extends StatefulWidget {
  static final GlobalKey cameraKey = GlobalKey();

  @override
  _CameraPageState createState() => _CameraPageState();
}

class _CameraPageState extends State<CameraPage> {
  bool _isCameraInitialized = false;
  CameraController? _cameraController;
  List<CameraDescription> cameras = [];

  Future<void> initializeCamera() async {
    if (cameras.isEmpty) {
      cameras = await availableCameras();
    }

    _cameraController = CameraController(
      cameras[0],
      ResolutionPreset.max,
    );

    try {
      await _cameraController?.initialize();
      setState(() {
        _isCameraInitialized = true;
      });
    } catch (e) {
      print("Error initializing camera: $e");
    }
  }

  @override
  void dispose() {
    _cameraController?.dispose();
    super.dispose();
  }

  @override
  Widget build(BuildContext context) {
    return ClipRRect(
      borderRadius: BorderRadius.circular(16),
      child: Consumer<HardwareSensorDriver>(
        builder: (context, hardwareSensorDriver, child) {
          if (hardwareSensorDriver.sensor == null) {
            if (_isCameraInitialized) {
              _cameraController?.dispose();
              setState(() {
                _isCameraInitialized = false;
              });
            }

            return Container(
              padding: const EdgeInsets.all(10),
              alignment: Alignment.center,
              decoration: BoxDecoration(
                color: Theme.of(context).cardColor,
                borderRadius: BorderRadius.circular(16)
              ),
              child: Column(
                mainAxisAlignment: MainAxisAlignment.center,
                crossAxisAlignment: CrossAxisAlignment.center,
                children: [
                  const Text(
                    'Sensor not found',
                    style: TextStyle(fontSize: 34, fontWeight: FontWeight.bold)
                  ),
                  const SizedBox(height: 10),
                  const Text(
                    'Connect a sensor to use the camera feature',
                    style: TextStyle(fontSize: 18, color: Colors.grey),
                    textAlign: TextAlign.center
                  ),
                ],
              ),
            );
          }

          else
          {
            if (!_isCameraInitialized) {
              initializeCamera();
            }

            return Stack(
              children: [
                _isCameraInitialized
                ? Stack(
                    children: [
                      ClipRRect(
                        borderRadius: BorderRadius.circular(16),
                        child: CameraPreview(_cameraController!, key: CameraPage.cameraKey),
                      ),
                      RepaintBoundary(child: CustomPaint(
                          painter: ParticlePainter(),
                          child: Container(),
                        ),
                      )
                    ],
                  )
                : Center(child: CircularProgressIndicator()),
                Container(color: Colors.white, child: FittedBox()) // TODO: Add legend
              ]
            );
          }
        },
      )
    );
  }
}
