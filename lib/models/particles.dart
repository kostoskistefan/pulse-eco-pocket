import 'dart:math';
import 'package:flutter/widgets.dart';
import 'package:flutter/material.dart';
import 'package:flutter/rendering.dart';
import 'package:pulse_eco_pocket/pages/camera_page.dart';
import 'package:pulse_eco_pocket/models/hardware_sensor.dart';
import 'package:pulse_eco_pocket/drivers/hardware_sensor_driver.dart';

enum ParticleType {
  PM10,
  PM25,
  Humidity,
  Temperature
}

class Particle {
  ParticleType type;
  Offset position;
  Offset velocity;
  Particle({required this.type, required this.position, required this.velocity});
}

class ParticlePainter extends CustomPainter {
  List<Particle> _particles = [];
  final random = Random();

  @override
  void paint(Canvas canvas, Size size) {
    double cameraWidth = (CameraPage.cameraKey.currentContext?.findRenderObject() as RenderBox?)!.size.width;
    double cameraHeight = (CameraPage.cameraKey.currentContext?.findRenderObject() as RenderBox?)!.size.height;

    initilalizeParticles(cameraWidth, cameraHeight);

    final paint = Paint();

    for (var particle in _particles) {
      switch(particle.type) {
        case ParticleType.PM10:
          paint.color = Colors.black26;
          canvas.drawCircle(particle.position, 11, paint);
          break;
        case ParticleType.PM25:
          paint.color = Colors.black54;
          canvas.drawCircle(particle.position, 4, paint);
          break;
        case ParticleType.Humidity:
          paint.color = Colors.lightBlueAccent.withOpacity(0.5);
          canvas.drawCircle(particle.position, 5, paint);
          break;
        case ParticleType.Temperature:
          paint.color = Colors.deepOrangeAccent.withOpacity(0.6);
          canvas.drawCircle(particle.position, 7.5, paint);
          break;
      }
    }
  }

  void initilalizeParticles(double maxWidth, double maxHeight) {
    _particles.clear();

    if (HardwareSensorDriver().sensor == null || HardwareSensorDriver().sensor!.data.isEmpty) {
      return;
    }

    for (var data in HardwareSensorDriver().sensor!.data) {
      double numOfParticles = double.parse(data.value);
      switch(data.name) {
        case 'PM10':
          Offset velocity = Offset(random.nextDouble() - 0.5, random.nextDouble() - 0.5);
          for (int i = 0; i < (numOfParticles/10.0).ceil(); i++) {
            Offset position = Offset(random.nextDouble() * maxWidth, random.nextDouble() * maxHeight);
            _particles.add(Particle(type: ParticleType.PM10, position: position, velocity: velocity));
          }
          break;
        case 'PM2.5':
          Offset velocity = Offset((random.nextDouble() * 2) - 1, (random.nextDouble() * 2) - 1);
          for (int i = 0; i < (numOfParticles/10.0).ceil(); i++) {
            Offset position = Offset(random.nextDouble() * maxWidth, random.nextDouble() * maxHeight);
            _particles.add(Particle(type: ParticleType.PM25, position: position, velocity: velocity));
          }
          break;
        case 'Humidity':
          Offset velocity = Offset(0, random.nextDouble() - 1);
          for (int i = 0; i < (numOfParticles).floor(); i++) {
            Offset position = Offset(random.nextDouble() * maxWidth, random.nextDouble() * maxHeight);
            _particles.add(Particle(type: ParticleType.Humidity, position: position, velocity: velocity));
          }
          break;
        case 'Temperature':
          Offset velocity = Offset(0, random.nextDouble() - 1);
          for (int i = 0; i < (numOfParticles).ceil() + 1; i++) {
            Offset position = Offset(random.nextDouble() * maxWidth, random.nextDouble() * maxHeight);
            _particles.add(Particle(type: ParticleType.Temperature, position: position, velocity: velocity));
          }
          break;
      }
    }
  }

  @override
  bool shouldRepaint(covariant CustomPainter oldDelegate) => true;
}
