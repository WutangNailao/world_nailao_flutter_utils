
import 'package:world_nailao_flutter_utils/src/dio_utils/abstract/dio_error_code.dart';

class DioErrorCodeImpl implements DioErrorCode {
  static const int success = 201;
  static const int success_not_content = 204;
  static const int bad_request = 400;
  static const int unauthorized = 401;
  static const int forbidden = 403;
  static const int not_found = 404;
  static const int request_timeout = 408;
  static const int internal_server_error = 500;
  static const int service_unavailable = 503;
  static const int gateway_timeout = 504;
  static const int unknown_error = -1;

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
    return "Unknown Error";
  }

  @override
  Map<String, int> errorCodeMap = {"网络错误": 1};
}
