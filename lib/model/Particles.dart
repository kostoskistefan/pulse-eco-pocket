import 'dart:math';
import 'package:flutter/widgets.dart';
import 'package:flutter/material.dart';
import 'package:flutter/rendering.dart';
import 'package:pulse_eco_pocket/utils/elements.dart';
import 'package:pulse_eco_pocket/pages/camera/camera_page.dart';
import 'enumerations/particle_type.dart';

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
    var data = Elements.mapOfSensors.value;
    for (var dataType in data.keys) {
      Offset position = Offset(random.nextDouble() * maxWidth, random.nextDouble() * maxHeight);
      double numOfParticles = double.parse(data[dataType]!.split('\n')[0]);
      switch(dataType) {
        case 'PM10':
          Offset velocity = Offset(random.nextDouble() - 0.5, random.nextDouble() - 0.5);
          for (int i = 0; i < (numOfParticles/10.0).ceil(); i++) {
            _particles.add(Particle(type: ParticleType.PM10, position: position, velocity: velocity));
          }
          break;
        case 'PM2.5':
          Offset velocity = Offset((random.nextDouble() * 2) - 1, (random.nextDouble() * 2) - 1);
          for (int i = 0; i < (numOfParticles/10.0).ceil(); i++) {
            _particles.add(Particle(type: ParticleType.PM25, position: position, velocity: velocity));
          }
          break;
        case 'Humidity':
          Offset velocity = Offset(0, random.nextDouble() - 1);
          for (int i = 0; i < (numOfParticles).floor(); i++) {
            _particles.add(Particle(type: ParticleType.Humidity, position: position, velocity: velocity));
          }
          break;
        case 'Temperature':
          Offset velocity = Offset(0, random.nextDouble() - 1);
          for (int i = 0; i < (numOfParticles).ceil() + 1; i++) {
            _particles.add(Particle(type: ParticleType.Temperature, position: position, velocity: velocity));
          }
          break;
      }
    }
  }

  void updateParticles(double maxWidth, double maxHeight) {
    for (var particle in _particles) {
      particle.position += particle.velocity;
      if (particle.position.dy > maxHeight - 10 || particle.position.dx > maxWidth - 10 || particle.position.dx < 0 || particle.position.dy < 0) {
        resetParticle(particle, maxWidth, maxHeight);
      }
    }
  }

  void resetParticle(Particle particle, maxWidth, maxHeight) {
    if (particle.type == ParticleType.Humidity || particle.type == ParticleType.Temperature) {
      double randXpos = random.nextDouble() * maxWidth;
      Offset velocity = Offset(0, random.nextDouble() - 1);
      particle.position = Offset(randXpos, maxHeight + 10);
      particle.velocity = velocity;
    }
    else {
      particle.position = Offset(random.nextDouble() * maxWidth, random.nextDouble() * maxHeight);
      if(particle.type == ParticleType.PM10)
        particle.velocity = Offset(random.nextDouble() - 0.5, random.nextDouble() - 0.5);
      else
        particle.velocity = Offset((random.nextDouble() * 2) - 1, (random.nextDouble() * 2) - 1);
    }
  }

  @override
  bool shouldRepaint(covariant CustomPainter oldDelegate) => true;
}
