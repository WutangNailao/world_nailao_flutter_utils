import 'dart:convert';

import 'package:dio/dio.dart';

import '../api_exception.dart';

class CheckResponseStateInterceptor extends Interceptor {
  @override
  void onResponse(Response response, ResponseInterceptorHandler handler) {
    Map resMap = jsonDecode(response.data.toString());
    if (resMap["code"] != 0 && resMap["code"] != "0") {
      throw APIException(
          code: resMap['code'],
          error: APIException,
          message: resMap['msg'],
          requestOptions: response.requestOptions,
          response: response);
    }
    super.onResponse(response, handler);
  }
}
