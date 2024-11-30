import 'dart:io';

import 'package:flutter/material.dart';
import 'package:camera/camera.dart';
// import 'package:shared_preferences/shared_preferences.dart';

import '../../../../../main.dart';
import '../../../../../utils/elements.dart';
import '../../model/Particles.dart';

class CameraPage extends StatefulWidget {
  static final GlobalKey cameraKey = GlobalKey();

  @override
  _CameraPageState createState() => _CameraPageState();
}

class _CameraPageState extends State<CameraPage> {
  CameraController? _cameraController;
  bool _isCameraInitialized = false;

  @override
  void initState() {
    super.initState();
    initializeCamera();
  }

  Future<void> initializeCamera() async {
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
    return Scaffold(
      appBar: AppBar(title: Text("Camera View")),
      body: Stack(
        children: [
          _isCameraInitialized
          ? Stack(
              children: [
                CameraPreview(_cameraController!, key: CameraPage.cameraKey),
                ValueListenableBuilder<bool>(
                  valueListenable: Elements.hasUsb,
                  builder: (context, sensors, child) {
                    return CustomPaint(
                      painter: ParticlePainter(),
                      child: Container(),
                    );
                  }
                ),
              ],
            )
          : Center(child: CircularProgressIndicator()),
          Container(color: Colors.white, child: FittedBox()) //TODO Da se dodaj legenda
        ]
      )
    );
  }
}