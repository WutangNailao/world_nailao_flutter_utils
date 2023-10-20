import 'dart:io';

import 'package:dio/dio.dart';

class CheckHttpStateInterceptor extends Interceptor {
  @override
  void onResponse(Response response, ResponseInterceptorHandler handler) {
    List<int> errStatusCodes = [
      400,
      401,
      402,
      403,
      404,
      405,
      406,
      407,
      408,
      409,
      410,
      411,
      412,
      413,
      414,
      415,
      416,
      417,
      500,
      501,
      502,
      503,
      504,
      505
    ];
    for (int errCode in errStatusCodes) {
      if (response.statusCode == errCode) {
        throw HttpException("HttpError,Http Error code: ${response.statusCode}",
            uri: response.realUri);
      }
    }
    super.onResponse(response, handler);
  }
}
