import 'dart:convert';
import 'package:flutter/material.dart';
import 'package:pulse_eco_pocket/models/achievement.dart';

class User {
  String name;
  String description;
  int number_of_scans;
  int number_of_uploads;
  int number_of_connected_sensors;
  List<Achievement> achievements;

  User({
    this.name = 'Name Surname',
    this.description = 'Description',
    this.number_of_scans = 0,
    this.number_of_uploads = 0,
    this.number_of_connected_sensors = 0,
  }) : achievements = [
          Achievement('First Scan', Icons.sensors, number_of_scans >= 1),
          Achievement('First Upload', Icons.cloud_upload, number_of_uploads >= 1),
          Achievement('10 Scans', Icons.sensors, number_of_scans >= 10),
          Achievement('10 Uploads', Icons.cloud_upload, number_of_uploads >= 10),
          Achievement('100 Scans', Icons.sensors, number_of_scans >= 100),
          Achievement('100 Uploads', Icons.cloud_upload, number_of_uploads >= 100),
          Achievement('500 Scans', Icons.sensors, number_of_scans >= 500),
          Achievement('500 Uploads', Icons.cloud_upload, number_of_uploads >= 500),
          Achievement('1000 Scans', Icons.sensors, number_of_scans >= 1000),
          Achievement('1000 Uploads', Icons.cloud_upload, number_of_uploads >= 1000),
        ];

  Map<String, dynamic> toMap() {
    return {
      'name': name,
      'description': description,
      'number_of_scans': number_of_scans,
      'number_of_uploads': number_of_uploads,
      'number_of_connected_sensors': number_of_connected_sensors,
    };
  }

  String toJson() {
    return json.encode(toMap());
  }

  static User fromMap(Map<String, dynamic> map) {
    return User(
      name: map['name'],
      description: map['description'],
      number_of_scans: map['number_of_scans'],
      number_of_uploads: map['number_of_uploads'],
      number_of_connected_sensors: map['number_of_connected_sensors'],
    );
  }

  static User fromJson(String jsonString) {
    return fromMap(json.decode(jsonString));
  }
}
