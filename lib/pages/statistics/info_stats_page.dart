import 'package:flutter/material.dart';

class InfoStatsPage extends StatelessWidget {
  final String title;
  final String particles;
  final String description;
  final String comparisonText;
  final String yesterdayComparison;
  final String weekComparison;

  const InfoStatsPage({
    required this.title,
    required this.particles,
    required this.description,
    required this.comparisonText,
    required this.yesterdayComparison,
    required this.weekComparison,
  });

  @override
  Widget build(BuildContext context) {
    return Container(
      margin: const EdgeInsets.symmetric(horizontal: 16.0, vertical: 8.0),
      padding: const EdgeInsets.all(16.0),
      decoration: BoxDecoration(
        color: Colors.lightGreen[50],
        border: Border.all(color: Colors.green, width: 1.0),
        borderRadius: BorderRadius.circular(16.0),
      ),
      child: Column(
        crossAxisAlignment: CrossAxisAlignment.start,
        children: [
          Center(
            child: Text(
              title,
              style: const TextStyle(
                fontSize: 22.0,
                fontWeight: FontWeight.bold,
                color: Colors.green,
              ),
            ),
          ),
          const SizedBox(height: 8.0),
          Center(
            child: Text(
              particles,
              style: const TextStyle(
                fontSize: 20.0,
                fontWeight: FontWeight.w600,
                // TODO Color base on the result if number is lower or higher than usual
              ),
            ),
          ),
          const SizedBox(height: 20.0),
          Text(
            description,
            style: const TextStyle(
              fontSize: 16.0,
              fontWeight: FontWeight.normal,
            ),
          ),
          const SizedBox(height: 16.0),
          Text(
            comparisonText,
            style: const TextStyle(
              fontSize: 20.0,
              fontStyle: FontStyle.italic,
              color: Colors.green, // TODO SAME COLOR AS PARTICLES
            ),
          ),
          const SizedBox(height: 16.0),
          Column(
            crossAxisAlignment: CrossAxisAlignment.start,
            children: [
              Text(
                "$yesterdayComparison",
                style: const TextStyle(
                  fontSize: 18.0,
                ),
              ),
              Text(
                "$weekComparison",
                style: const TextStyle(
                  fontSize: 18.0,
                ),
              ),
            ],
          ),
        ],
      ),
    );
  }
}
