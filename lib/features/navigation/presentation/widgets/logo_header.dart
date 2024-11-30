import 'package:flutter/material.dart';

class LogoHeaderWidget extends StatelessWidget {
  final String logoPath;

  const LogoHeaderWidget({required this.logoPath, Key? key}) : super(key: key);

  @override
  Widget build(BuildContext context) {
    return Container(
      width: double.infinity,
      padding: const EdgeInsets.symmetric(vertical: 16.0), // Spacing around the logo
      child: const Column(
        children: [
          Text(
            "Pulse Eco Pocket",
            style: TextStyle(
              fontWeight: FontWeight.bold,
              fontSize: 32,
              color: Colors.black
            ),
          )
        ],
      ),
    );
  }
}
