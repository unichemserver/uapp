import 'package:intl/intl.dart';

class DateUtils {
  static String formatDateString(String dateString) {
    DateTime dateTime = DateTime.parse(dateString);

    String day = DateFormat('dd').format(dateTime);
    String monthYear = DateFormat(
      'MMMM, yyyy',
      'id_ID',
    ).format(dateTime);
    String time = DateFormat('HH:mm:ss').format(dateTime);

    return '$day\n$monthYear\n$time'; // 01\nJanuary, 2022\n12:00:00
  }

  static formatDate(String date) {
    return DateFormat('dd MMMM yyyy', 'id_ID').format(DateTime.parse(date));
  }

  static formatTime(String date) {
    return DateFormat('HH:mm:ss').format(DateTime.parse(date));
  }

  static bool isDateAfter(String dateString, String compareTo) {
    DateTime date = DateTime.parse(dateString);
    DateTime compareDate = DateTime.parse(compareTo);

    return date.isAfter(compareDate);
  }

  static String getFormattedDateFromYMD(String date) {
    return DateFormat('dd-MM-yyyy').format(DateTime.parse(date));
  }

  static String getCurrentDate() {
    return DateFormat('yyyy-MM-dd').format(DateTime.now());
  }

  static String getYMDFormat(DateTime date) {
    return DateFormat('yyyy-MM-dd').format(date);
  }

  // function to return date in format dd/MM/yyyy HH:mm:ss
  static String getCurrentDateTime() {
    return DateFormat('dd/MM/yyyy HH:mm:ss').format(DateTime.now());
  }

  static String getFormattedDateOnly(DateTime date) {
    return DateFormat('dd/MM/yyyy').format(date);
  }

  static String getFormattedDate(DateTime date) {
    return DateFormat('dd MMMM yyyy', 'id_ID').format(date);
  }

  static String getDayDate(DateTime date) {
    return DateFormat('EEEE, dd MMMM yyyy', 'id_ID').format(date);
  }

  // create function to get format date like yyMMdd
  static String getFormatDate() {
    return DateFormat('yyMMdd').format(DateTime.now());
  }
  static String getDay() {
    return DateFormat('dd').format(DateTime.now());
  }

  static int getDayOfWeek(String date) {
    return DateFormat('yyyy-MM-dd').parse(date).weekday;
  }

  static int getDayOfMonth(String date) {
    return DateFormat('yyyy-MM-dd').parse(date).day;
  }

  static int getFirstDayOfMonth(String date) {
    DateTime firstDay =
        DateTime(DateTime.parse(date).year, DateTime.parse(date).month, 1);
    return firstDay.weekday;
  }

  static int getDaysInMonth(String date) {
    DateTime dateTime = DateTime.parse(date);
    DateTime firstDayOfNextMonth =
        DateTime(dateTime.year, dateTime.month + 1, 1);
    DateTime lastDayOfCurrentMonth =
        firstDayOfNextMonth.subtract(const Duration(days: 1));
    return lastDayOfCurrentMonth.day;
  }

  static int getWeekOfMonth(String date) {
    int dayOfMonth = getDayOfMonth(date);
    int firstDayOfMonth = getFirstDayOfMonth(date);
    int daysInMonth = getDaysInMonth(date);

    // Determine the first day of the first week of the next month
    DateTime firstDayOfNextMonth =
        DateTime(DateTime.parse(date).year, DateTime.parse(date).month + 1, 1);
    int firstDayOfNextMonthWeekday = firstDayOfNextMonth.weekday;

    // Check if the given date is in the last week of the month that extends to the next month
    if (dayOfMonth > daysInMonth - firstDayOfNextMonthWeekday + 1) {
      return 1;
    }

    if (dayOfMonth <= (7 - firstDayOfMonth + 1)) {
      return 1;
    } else {
      return ((dayOfMonth - (7 - firstDayOfMonth + 1)) / 7).ceil() + 1;
    }
  }
}
