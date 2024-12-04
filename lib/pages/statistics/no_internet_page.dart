import 'package:flutter/material.dart';
import 'package:pulse_eco_pocket/models/user.dart';
import 'package:pulse_eco_pocket/pages/profile/profile_view_page.dart';
import 'package:pulse_eco_pocket/pages/profile/profile_settings_page.dart';

class NoInternetPage extends StatelessWidget {
  @override
  Widget build(BuildContext context) {
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
          Icon(
            Icons.wifi_off,
            size: 80,
            color: Colors.grey,
          ),
          SizedBox(height: 20),
          Text(
            "No internet connection",
            style: TextStyle(
              fontSize: 18,
              color: Colors.grey,
            ),
          ),
        ],
      ),
    );
  }
}
