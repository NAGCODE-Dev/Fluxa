extension DateExtension on DateTime {
  String toShortPtBr() {
    final day = this.day.toString().padLeft(2, '0');
    final month = this.month.toString().padLeft(2, '0');
    return '$day/$month';
  }
}
