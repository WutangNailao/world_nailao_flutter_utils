class ParseException implements Exception {
  final String reason;

  ParseException(this.reason);

  @override
  String toString() {
    return reason;
  }
}
