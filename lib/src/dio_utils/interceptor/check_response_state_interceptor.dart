import 'dart:convert';

import 'package:dio/dio.dart';
import 'package:world_nailao_flutter_utils/src/dio_utils/api_response_format.dart';
import 'package:world_nailao_flutter_utils/src/dio_utils/exception/api_exception.dart';

class CheckResponseStateInterceptor extends Interceptor {
  final ApiResponseFormat jsonFormat;

  CheckResponseStateInterceptor(
      {this.jsonFormat =
          const ApiResponseFormat(code: "code", msg: "msg", data: "data")});

  @override
  void onResponse(Response response, ResponseInterceptorHandler handler) {
    try {
      Map resMap = jsonDecode(response.data.toString());

      if (resMap[jsonFormat.getCode()] != 0 &&
          resMap[jsonFormat.getCode()] != "0") {
        throw ApiException(
            resMap[jsonFormat.getCode()], resMap[jsonFormat.getMsg()]);
      }
    } on ApiException catch (e) {
      rethrow;
    } catch (e) {
      super.onResponse(response, handler);
    }
  }
}
