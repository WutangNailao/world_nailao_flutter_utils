abstract class DioErrorCode {
  factory DioErrorCode() => _DioErrorCodeImpl();
  Map<String, int> errorCodeMap = {};

  int getCodeByMsg(String msg);

  String getMsg(int code);
}



class _DioErrorCodeImpl implements DioErrorCode {
  @override
  Map<String, int> errorCodeMap = {};

  @override
  int getCodeByMsg(String msg) {
    if (!errorCodeMap.keys.contains(msg)) {
      return -1;
    }
    return errorCodeMap[msg]!;
  }

  @override
  String getMsg(int code) {
    for (var entry in errorCodeMap.entries) {
      if (entry.value == code) {
        return entry.key;
      }
    }
    return "unknown error";
  }
}
