class ParseException implements Exception {
  final String message;
  final int code;

  ParseException(this.message, this.code);

  @override
  String toString() {
    return 'ParseException{message: $message, code: $code}';
  }
}
