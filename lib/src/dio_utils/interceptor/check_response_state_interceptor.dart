import 'dart:convert';

import 'package:dio/dio.dart';
import 'package:world_nailao_flutter_utils/src/dio_utils/exception/api_exception.dart';

class CheckResponseStateInterceptor extends Interceptor {
  final List<String> jsonFormat;

  CheckResponseStateInterceptor(
      {this.jsonFormat = const ["code", "data", "msg"]});

  @override
  void onResponse(Response response, ResponseInterceptorHandler handler) {

    if (response.data.runtimeType is! Map<String, dynamic>) {
      super.onResponse(response, handler);
      return ;
    }
    Map resMap = jsonDecode(response.data.toString());

    if (resMap[jsonFormat[0]] != 0 && resMap[jsonFormat[0]] != "0") {
      throw ApiException(resMap[jsonFormat[0]], resMap[jsonFormat[2]]);
    }
    super.onResponse(response, handler);
  }
}
