import 'package:flutter/material.dart';
import 'package:nlytical/utils/colors.dart';

class DateScrollView extends StatelessWidget {
  final List<DateTime> weekStartDates;

  const DateScrollView({super.key, required this.weekStartDates});

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(title: const Text('Scroll Week Dates')),
      body: Center(
        child: SizedBox(
          height: 100, // Adjust height to your needs
          child: ListView.builder(
            scrollDirection: Axis.horizontal, // Make the ListView horizontal
            itemCount: weekStartDates
                .length, // Set item count to the length of your list
            itemBuilder: (context, index) {
              DateTime weekStartDate = weekStartDates[index];

              // Format the date (e.g., using DateFormat or toString())
              String formattedDate =
                  '${weekStartDate.month}/${weekStartDate.day}';

              return Padding(
                padding: const EdgeInsets.symmetric(horizontal: 10),
                child: Container(
                  width: 80, // Set the width for each date
                  alignment: Alignment.center,
                  color: Appcolors
                      .appPriSecColor
                      .appPrimblue, // Customize the color of the box
                  child: Text(
                    formattedDate, // Display the formatted date
                    style: TextStyle(color: Appcolors.white),
                  ),
                ),
              );
            },
          ),
        ),
      ),
    );
  }
}
