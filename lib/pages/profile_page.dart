import 'package:flutter/material.dart';
import 'package:pulse_eco_pocket/models/user.dart';
import 'package:pulse_eco_pocket/pages/profile/profile_view_page.dart';
import 'package:pulse_eco_pocket/pages/profile/profile_settings_page.dart';

class ProfilePage extends StatefulWidget {
  const ProfilePage({super.key});

  @override
  State<ProfilePage> createState() => _ProfilePageState();
}

class _ProfilePageState extends State<ProfilePage> {
  bool settingsPageActive = false;

  User user = User(
    number_of_scans: 11,
    number_of_uploads: 7,
    number_of_connected_sensors: 3
  );

  void setSettingsPageActive(bool value) {
    setState(() {
      settingsPageActive = value;
    });
  }

  @override
  Widget build(BuildContext context) {
    return settingsPageActive 
    ? ProfileSettingsPage(setSettingsPageActive: setSettingsPageActive, user: user)
    : ProfileViewPage(setSettingsPageActive: setSettingsPageActive, user: user);
  }
}
