class JsonFormatException implements Exception {
  final String msg;

  JsonFormatException(this.msg);

  @override
  String toString() {
    return msg;
  }
}
