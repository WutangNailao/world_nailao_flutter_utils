import 'package:cookie_jar/cookie_jar.dart';
import 'package:dio/dio.dart';
import 'package:dio_cookie_manager/dio_cookie_manager.dart';
import 'package:flutter_ulog/flutter_ulog.dart';

import 'dio_utils.dart';
import 'interceptor/check_http_state_interceptor.dart';
import 'ulog_console_adaptar.dart';

class DioClient {
  static bool? enableLog;
  static final List<Interceptor> _interceptors = [
    CookieManager(CookieJar()),
    CheckHttpStateInterceptor(),
    // CheckResponseStateInterceptor()
  ];

  static DioUtils request(String url) {
    return DioUtils.builder(url);
  }

  static init({bool? enableLog, List<Interceptor>? interceptors}) {
    ULog.addLogAdapter(UlogConsoleAdapter());

    if (interceptors != null) {
      _interceptors.addAll(interceptors);
    }
  }

  static List<Interceptor> getInterceptors() => _interceptors;

  static void clear() {
    DioUtils.clear();
  }
}
