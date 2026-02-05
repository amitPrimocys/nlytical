// ignore_for_file: prefer_conditional_assignment
import 'package:nlytical/utils/global.dart';
import 'package:get/get.dart';
import 'package:nlytical/models/vendor_models/insights_model.dart';
import 'package:nlytical/utils/api_helper.dart';
import 'package:nlytical/utils/common_widgets.dart';
import 'package:syncfusion_flutter_charts/charts.dart';

class InsightsController extends GetxController {
  ApiHelper apiHelper = ApiHelper();
  RxBool isLoading = false.obs;
  Rx<InsightsModel> model = InsightsModel().obs;
  RxList<Graphdata> graphdataList = <Graphdata>[].obs;
  RxList<List<Graphdata>> weeksData = <List<Graphdata>>[].obs;
  RxInt currentWeekIndex = 0.obs;
  RxList<Graphdata> currentWeekData = <Graphdata>[].obs;

  void groupDataIntoWeeks(String selectedMonth) {
    List<Graphdata> monthData = graphdataList
        .where((data) => data.date!.contains(selectedMonth))
        .toList();

    monthData.sort((a, b) => parseDate(a.date!).compareTo(parseDate(b.date!)));

    weeksData.clear();
    List<Graphdata> currentWeek = [];

    DateTime? weekStartDate;
    for (var data in monthData) {
      DateTime currentDate = parseDate(data.date!);

      // Set the start date for the week if it's not set
      if (weekStartDate == null) {
        weekStartDate = currentDate;
      }

      // If the current date exceeds a 7-day range, start a new week
      if (currentDate.difference(weekStartDate).inDays >= 7) {
        if (currentWeek.isNotEmpty) {
          weeksData.add(List.from(currentWeek));
        }
        currentWeek.clear();
        weekStartDate = currentDate;
      }

      currentWeek.add(data);
    }

    // Add the last remaining week
    if (currentWeek.isNotEmpty) {
      weeksData.add(List.from(currentWeek));
    }

    // Assign current week data
    currentWeekIndex.value = 0; // Reset to the first week
    currentWeekData.assignAll(weeksData[currentWeekIndex.value]);
  }

  void loadNextWeek() {
    if (currentWeekIndex.value < weeksData.length - 1) {
      currentWeekIndex.value++;
      currentWeekData.value = weeksData[currentWeekIndex.value];
      refresh();
      update();
    }
  }

  void loadPreviousWeek() {
    if (currentWeekIndex.value > 0) {
      currentWeekIndex.value--;
      currentWeekData.value = weeksData[currentWeekIndex.value];
      refresh();
      update();
    }
  }

  // Custom method to parse date in the format "1 March"
  DateTime parseDate(String dateStr) {
    List<String> parts = dateStr.split(" ");
    int day = int.parse(parts[0]);
    String monthName = parts[1];
    int year = DateTime.now().year;

    int month = _monthNameToNumber(monthName);
    return DateTime(year, month, day);
  }

  // Helper method to map month name to month number
  int _monthNameToNumber(String monthName) {
    const months = {
      "January": 1,
      "February": 2,
      "March": 3,
      "April": 4,
      "May": 5,
      "June": 6,
      "July": 7,
      "August": 8,
      "September": 9,
      "October": 10,
      "November": 11,
      "December": 12,
    };

    return months[monthName] ??
        1; // Default to January if month name is invalid
  }

  Future<void> graphApi({required String monthName}) async {
    try {
      isLoading(true);

      final response = await apiHelper.multipartPostMethod(
        url: apiHelper.serviceinsights,
        headers: {},
        formData: {"service_id": userStoreID, "monthname": monthName},
        files: [],
      );

      model.value = InsightsModel.fromJson(response);
      graphdataList.clear();
      if (model.value.status == true) {
        graphdataList.addAll(model.value.graphdata!);
        groupDataIntoWeeks(monthName);
        isLoading(false);
      } else {
        isLoading(false);
        snackBar(model.value.message!);
      }
    } catch (e) {
      graphdataList.clear();
      isLoading(false);
      snackBar("Something went wrong, try again");
    }
  }

  final RxList<String> monthList = <String>[
    "Jan",
    "Feb",
    "Mar",
    "Apr",
    "May",
    "Jun",
    "Jul",
    "Aug",
    "Sep",
    "Oct",
    "Nov",
    "Dec",
  ].obs;

  final RxList<String> fullMonthList = <String>[
    "January",
    "February",
    "March",
    "April",
    "May",
    "June",
    "July",
    "August",
    "September",
    "October",
    "November",
    "December",
  ].obs;
  RxnString selectedMonthValue = RxnString();

  RxBool isLoad = false.obs;

  double axisVisibleMin = 1, axisVisibleMax = 1000;
  late SelectionBehavior selectionBehavior;
  // create instance for axis controller
  NumericAxisController? axisController;

  void performSwipe(ChartSwipeDirection direction) {
    if (axisController == null) return; // Prevent crashes if not initialized

    if (direction == ChartSwipeDirection.end &&
        (axisVisibleMax + 5) < graphdataList.length) {
      isLoad(true);
      axisVisibleMin += 5;
      axisVisibleMax += 5;
      axisController!.visibleMinimum = axisVisibleMin;
      axisController!.visibleMaximum = axisVisibleMax;

      Future.delayed(const Duration(milliseconds: 300), () {
        selectionBehavior.selectDataPoints(axisVisibleMin.toInt() + 2);
      });
    } else if (direction == ChartSwipeDirection.start &&
        (axisVisibleMin - 5) >= 0) {
      axisVisibleMin -= 5;
      axisVisibleMax -= 5;
      axisController!.visibleMinimum = axisVisibleMin;
      axisController!.visibleMaximum = axisVisibleMax;

      Future.delayed(const Duration(milliseconds: 300), () {
        selectionBehavior.selectDataPoints(axisVisibleMin.toInt() + 2);
      });
    }
  }
}
