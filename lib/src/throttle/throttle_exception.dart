class ThrottleException implements Exception {
  final String msg;

  ThrottleException(this.msg);

  @override
  String toString() {
    // TODO: implement toString
    return "ThrottleException:$msg";
  }
}
