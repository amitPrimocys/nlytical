// ignore_for_file: unused_local_variable

import 'dart:math';
import 'package:get/get.dart';
import 'package:nlytical/Vendor/screens/new_tabber.dart/line_chat/my_weight.dart';

class LineChartController extends GetxController {
  RxList<MyWeight> myWeightProgressGenerated = <MyWeight>[].obs;
  double maxWeight = -double.maxFinite;
  double minWeight = double.maxFinite;

  // Generate weight data based on the selected month (week-wise)
  void generateDataForMonth(DateTime startDate, DateTime endDate) {
    final progress = <MyWeight>[];
    final random = Random();

    // Clear any existing data
    myWeightProgressGenerated.clear();

    DateTime currentStartDate = startDate;
    int weekCounter = 0;

    // Loop to generate data for each week
    while (currentStartDate.isBefore(endDate)) {
      // Calculate the end of the current week (7 days from the start date or the last day of the month)
      DateTime currentEndDate = currentStartDate.add(const Duration(days: 6));

      // If the current week's end date is after the end of the month, adjust it
      if (currentEndDate.isAfter(endDate)) {
        currentEndDate = endDate;
      }

      // Generate data for the week (for each day within the week)
      for (
        int i = 0;
        i <= currentEndDate.difference(currentStartDate).inDays;
        i++
      ) {
        DateTime date = currentStartDate.add(Duration(days: i));
        final randomWeight =
            (random.nextInt(10) + 40) +
            double.parse(random.nextDouble().toStringAsFixed(1));

        final myWeight = MyWeight(dateTime: date, weight: randomWeight);
        progress.add(myWeight);
      }

      // Update the start date for the next week
      currentStartDate = currentEndDate.add(const Duration(days: 1));
      weekCounter++;
    }

    // Update the list of generated weights
    myWeightProgressGenerated.addAll(progress);
  }

  // Group the weight data by week
  List<List<MyWeight>> getGroupedDataByWeek() {
    List<List<MyWeight>> weekGroups = [];
    DateTime currentStartDate = myWeightProgressGenerated.isNotEmpty
        ? myWeightProgressGenerated.first.dateTime
        : DateTime.now();
    DateTime currentEndDate = currentStartDate.add(const Duration(days: 6));

    List<MyWeight> currentWeek = [];

    for (var i = 0; i < myWeightProgressGenerated.length; i++) {
      final myWeight = myWeightProgressGenerated[i];

      if (myWeight.dateTime.isAfter(currentEndDate)) {
        // Add the current week data to the group
        if (currentWeek.isNotEmpty) {
          weekGroups.add(currentWeek);
        }

        // Start a new week
        currentStartDate = currentEndDate.add(const Duration(days: 1));
        currentEndDate = currentStartDate.add(const Duration(days: 6));
        currentWeek = [myWeight];
      } else {
        // Add weight to the current week
        currentWeek.add(myWeight);
      }
    }

    // Add the remaining week
    if (currentWeek.isNotEmpty) {
      weekGroups.add(currentWeek);
    }

    return weekGroups;
  }
}
