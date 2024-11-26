import 'package:flutter/material.dart';

class LogoHeaderWidget extends StatelessWidget {
  final String logoPath;

  const LogoHeaderWidget({required this.logoPath, Key? key}) : super(key: key);

  @override
  Widget build(BuildContext context) {
    return Container(
      width: double.infinity,
      padding: const EdgeInsets.symmetric(vertical: 16.0), // Spacing around the logo
      child: Column(
        children: [
          // Logo in the center of the top of the screen
          Image.asset(
            logoPath,
            width: 100.0, // Adjust size as needed
            height: 100.0,
            fit: BoxFit.contain,
          ),
        ],
      ),
    );
  }
}
