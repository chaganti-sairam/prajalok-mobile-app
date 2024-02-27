class DateUtilssll {
  static String getTimeAgo(DateTime createdAt) {
    DateTime currentDate = DateTime.now();
    Duration difference = currentDate.difference(createdAt);

    int days = difference.inDays;
    int months = currentDate.month - createdAt.month + 12 * (currentDate.year - createdAt.year);
    int years = currentDate.year - createdAt.year;

    if (days == 30 || days == 31 || days == 28) {
      return '$months month ago';
    } else if (months == 12) {
      return '$years years ago';
    } else {
      return '$days days ago';
    }
  }
}
