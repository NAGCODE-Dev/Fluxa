extension StringExtension on String {
  String orFallback(String fallback) {
    return trim().isEmpty ? fallback : this;
  }
}
