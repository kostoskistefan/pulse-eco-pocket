import 'package:flutter/material.dart';
import 'package:intl/intl.dart';

class HeaderStatisticsWidget extends StatelessWidget {
  final String location;

  HeaderStatisticsWidget({required this.location});

  @override
  Widget build(BuildContext context) {
    final String todayDate = DateFormat('EEEE\nMMMM d, yyyy').format(DateTime.now());

    return Container(
      padding: const EdgeInsets.symmetric(horizontal: 16.0, vertical: 8.0),
      decoration: const BoxDecoration(
        border: Border(
          bottom: BorderSide(color: Colors.grey, width: 1.0),
        ),
      ),
      child: Row(
        mainAxisAlignment: MainAxisAlignment.spaceBetween,
        children: [
          Text(
            todayDate,
            style: const TextStyle(fontSize: 16.0, fontWeight: FontWeight.w500),
          ),
          Text(
            location,
            style: const TextStyle(fontSize: 16.0, fontWeight: FontWeight.w500),
          ),
        ],
      ),
    );
  }
}
