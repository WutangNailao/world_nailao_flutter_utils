import 'package:dio/dio.dart';

import '../config/network_config.dart';

class TimeInterceptor extends Interceptor {
  @override
  void onRequest(RequestOptions options, RequestInterceptorHandler handler) {
    Map<String, dynamic> extra = options.extra;
    bool connect = extra.containsKey(NetWorkConfig.connectTimeout);
    bool receive = extra.containsKey(NetWorkConfig.receiveTimeOut);
    if (connect || receive) {
      if (connect) {
        int connectTimeout = options.extra[NetWorkConfig.connectTimeout];
        options.connectTimeout = Duration(seconds: connectTimeout);
      }
      if (receive) {
        int receiveTimeOut = options.extra[NetWorkConfig.receiveTimeOut];
        options.receiveTimeout = Duration(seconds: receiveTimeOut);
      }
    }
    super.onRequest(options, handler);
  }
}
