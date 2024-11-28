import 'package:flutter/material.dart';
import 'package:intl/intl.dart';

import '../../../../../utils/elements.dart';

class HeaderStatisticsWidget extends StatelessWidget {
  const HeaderStatisticsWidget({super.key});

  String capitalizeFirstLetter(String input) {
    if (input.isEmpty) return input; // Handle empty strings
    return input[0].toUpperCase() + input.substring(1);
  }

  @override
  Widget build(BuildContext context) {
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
          ValueListenableBuilder(
            valueListenable: Elements.filterByDate,
            builder: (context, selectedDate, _) {
              // Elements.changeSensorItems();
              return DropdownButton<String>(
                value: DateFormat('EEEE\nMMMM d, yyyy').format(selectedDate),
                items: Elements.availableDates.map((date) {
                  return DropdownMenuItem<String>(
                    value: date,
                    child: Text(
                      date,
                      style: const TextStyle(fontSize: 16.0, fontWeight: FontWeight.w500),
                    ),
                  );
                }).toList(),
                onChanged: (newDate) {
                  if (newDate != null) {
                    var firstWhere = Elements.availableDates.firstWhere((date) => date == newDate, orElse: () => DateFormat('EEEE\nMMMM d, yyyy').format(DateTime.now()));
                    firstWhere = firstWhere.split('\n')[1];
                    DateFormat inputFormat = DateFormat('MMMM d, yyyy');
                    Elements.filterByDate.value = inputFormat.parse(firstWhere);
                  }
                },
              );
            },
          ),

          // TODO REMOVE THIS
          // IconButton(
          //   onPressed: () {
          //     print(Elements.filterByDate);
          //     print(Elements.filterByCity);
          //   },
          //   icon: const Icon(
          //       Icons.add,
          //       size: 30,
          //       color: Colors.grey
          //   ),
          // ),

          ValueListenableBuilder(
            valueListenable: Elements.filterByCity,
            builder: (context, selectedCity, _) {
              return DropdownButton<String>(
                value: selectedCity,
                items: Elements.availableCities.map((city) {
                  // Elements.changeSensorItems();
                  return DropdownMenuItem<String>(
                    value: city,
                    child: Text(
                      capitalizeFirstLetter(city),
                      style: const TextStyle(fontSize: 16.0, fontWeight: FontWeight.w500),
                    ),
                  );
                }).toList(),
                onChanged: (newCity) {
                  if (newCity != null) {
                    Elements.filterByCity.value = newCity;
                  }
                },
              );
            },
          ),
        ],
      ),
    );
  }
}
