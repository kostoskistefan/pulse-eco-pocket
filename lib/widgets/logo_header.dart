import 'package:flutter/material.dart';

class LogoHeaderWidget extends StatelessWidget {
  final String logoPath = 'lib/images/logo.png';

  const LogoHeaderWidget({Key? key}) : super(key: key);

  @override
  Widget build(BuildContext context) {
    return Container(
      width: double.infinity,
      padding: const EdgeInsets.symmetric(vertical: 16.0),
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
