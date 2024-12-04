import 'package:flutter/material.dart';
import 'package:pulse_eco_pocket/utilities/sensor_name_to_unit_converter.dart';

class SensorContainer extends StatefulWidget {
  final String label;
  final String value;
  final String? unit;

  SensorContainer({
    Key? key,
    required this.label,
    required this.value,
    String? unit,
  }) : unit = unit ?? sensorNameToUnit(label), super(key: key);

  @override
  State<SensorContainer> createState() => _SensorContainerState();
}

class _SensorContainerState extends State<SensorContainer> {
  @override
  Widget build(BuildContext context) {
    return Container(
      padding: const EdgeInsets.all(16),
      decoration: BoxDecoration(
        color: Colors.blue[100],
        borderRadius: BorderRadius.circular(12),
      ),
      child: Column(
        mainAxisAlignment: MainAxisAlignment.center,
        children: [
          widget.value.isEmpty
              ? Text(
                  'N/A',
                  style: Theme.of(context).textTheme.headlineLarge,
                  textAlign: TextAlign.center,
                )
              : Row(
                  mainAxisAlignment: MainAxisAlignment.center,
                  crossAxisAlignment: CrossAxisAlignment.start,
                  children: [
                    Text(
                      '${widget.value} ',
                      style: Theme.of(context).textTheme.headlineLarge,
                      textAlign: TextAlign.center,
                    ),
                    Text(
                      '${widget.unit}',
                      style: Theme.of(context).textTheme.titleLarge,
                      textAlign: TextAlign.center,
                    ),
                  ],
                ),
          const Divider(
            color: Colors.blue,
            thickness: 2,
            indent: 12,
            endIndent: 12,
          ),
          Text(
            '${widget.label}',
            style: Theme.of(context).textTheme.titleMedium,
            textAlign: TextAlign.center,
          ),
        ],
      ),
    );
  }
}
