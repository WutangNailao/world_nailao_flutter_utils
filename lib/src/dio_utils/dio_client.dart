import 'package:flutter_ulog/flutter_ulog.dart';

import 'abstract/dio_error_code.dart';
import 'dio_utils.dart';
import 'ulog_console_adaptar.dart';

class DioClient {
  static DioErrorCode errorCode = DioErrorCode();

  static DioUtils request(String url) {
    return DioUtils.builder(url);
  }

  static init({DioErrorCode? newErrorCode}) {
    ULog.addLogAdapter(UlogConsoleAdapter());
    if (newErrorCode != null) {
      errorCode = newErrorCode;
    }
  }

  static void clear() {
    DioUtils.clear();
  }
}
