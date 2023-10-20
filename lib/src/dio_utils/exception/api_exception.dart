class ApiException implements Exception {
  final int code;
  final String msg;

  ApiException(this.code, this.msg);

  @override
  String toString() {
    return "ApiException, code:$code, msg:$msg";
  }
}
