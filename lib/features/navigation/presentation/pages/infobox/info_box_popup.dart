import 'package:flutter/material.dart';

class PopupButton extends StatelessWidget {
  const PopupButton({Key? key}) : super(key: key);

  @override
  Widget build(BuildContext context) {
    return ElevatedButton(
      onPressed: () {
        _showInfoPopup(context);
      },
      style: ElevatedButton.styleFrom(
        shape: RoundedRectangleBorder(
          borderRadius: BorderRadius.circular(20),
        ),
        padding: const EdgeInsets.symmetric(horizontal: 40, vertical: 12),
      ),
      child: const Text('Info'),
    );
  }

  // Function to show the popup dialog
  void _showInfoPopup(BuildContext context) {
    showDialog(
      context: context,
      builder: (BuildContext context) {
        return AlertDialog(
          shape: RoundedRectangleBorder(
            borderRadius: BorderRadius.circular(12),
          ),
          title: const Text('Pulse Eco Pocket'),
          content: const Text(
            'Discover and contribute to real-time environmental monitoring with the Pulse Eco App.\nThis app connects with the Pulse Eco platform, providing vital information about various urban sensors.\n\n' +
                'Also you can connect external sensors directly to your phone to collect the data and view it and seamlessly upload it to the Pulse Eco database in real-time.',
            style: TextStyle(fontSize: 16),
          ),
          actions: [
            TextButton(
              onPressed: () {
                Navigator.of(context).pop(); // Close the dialog
              },
              child: const Text('Close'),
            ),
          ],
        );
      },
    );
  }
}
