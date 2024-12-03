import 'package:flutter/material.dart';

class NoInternetPage extends StatelessWidget {
  const NoInternetPage({super.key});

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(
        title: const Text('No Internet Connection'),
      ),
      body: Center(
        child: Column(
          mainAxisAlignment: MainAxisAlignment.center,
          children: [
            Icon(
              Icons.wifi_off,
              size: 100.0,
              color: Colors.redAccent,
            ),
            const SizedBox(height: 20.0),
            const Text(
              'No Internet Connection',
              style: TextStyle(
                fontSize: 24.0,
                fontWeight: FontWeight.bold,
                color: Colors.black,
              ),
            ),
            const SizedBox(height: 10.0),
            const Text(
              'Please check your network settings\nand try again.',
              textAlign: TextAlign.center,
              style: TextStyle(
                fontSize: 16.0,
                color: Colors.black54,
              ),
            ),
            const SizedBox(height: 30.0),
            // ElevatedButton(
            //   onPressed: () {
            //     // Add logic to retry checking the connection
            //     // Example: Refresh the page or check connectivity
            //   },
            //   style: ElevatedButton.styleFrom(
            //     padding: const EdgeInsets.symmetric(horizontal: 32.0, vertical: 12.0),
            //   ),
            //   child: const Text(
            //     'Retry',
            //     style: TextStyle(fontSize: 16.0),
            //   ),
            // ),
          ],
        ),
      ),
    );
  }
}
