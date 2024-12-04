import 'package:flutter/material.dart';

class Achievement {
  String name;
  IconData icon;
  bool isUnlocked = false;

  Achievement(this.name, this.icon, this.isUnlocked);
}
