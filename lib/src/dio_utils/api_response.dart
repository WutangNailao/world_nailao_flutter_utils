import 'dart:convert';

import 'package:dio/dio.dart';
import 'package:world_nailao_flutter_utils/src/dio_utils/api_response_format.dart';
import 'package:world_nailao_flutter_utils/src/dio_utils/exception/json_format_exception.dart';
import 'package:world_nailao_flutter_utils/src/dio_utils/exception/parse_exception.dart';

class ApiResponse {
  late final Response _rawResponse;

  Map<String, dynamic>? responseData;
  int? _code;
  String? _msg;
  dynamic _data;

  ApiResponse(this._rawResponse);

  ApiResponse parse(
      {ApiResponseFormat jsonFormat =
          const ApiResponseFormat(code: "code", msg: "msg", data: "data")}) {
    late final Map<String, dynamic> jsonData;
    try {
      jsonData = jsonDecode(_rawResponse.data);
      responseData = jsonData;
    } catch (e) {
      throw ParseException(
          "the response type is ${_rawResponse.data.runtimeType}, not is json, so it can not be parsed");
    }

    if (!jsonData.containsKey(jsonFormat.getCode())) {
      throw JsonFormatException(
          "json format may be not as expected, response json format is ${jsonData.keys}, but your input format is ${jsonFormat.toString()}");
    }
    if (!jsonData.containsKey(jsonFormat.getMsg())) {
      throw JsonFormatException(
          "json format may be not as expected, response json format is ${jsonData.keys}, but your input format is ${jsonFormat.toString()}");
    }

    _code = jsonData[jsonFormat.getCode()];

    _msg = jsonData[jsonFormat.getMsg()];

    /// 对于较大的数据返回量，使用compute来解析json

    //如果data是字符串就返回" ",
    //如果data是数组 则返回 [];
    //如果data是map 则返回 {};
    if (jsonData.containsKey(jsonFormat.getData())) {
      _data = jsonData[jsonFormat.getData()];
    }

    return this;
  }

  String asString() {
    //未过apiResponse处理的toString
    return _rawResponse.data.toString();
  }

  // assertSuccess() {
  //   if (_code != 0) {
  //     throw Exception('code: $_code, msg: $_msg');
  //   }
  // }

  Response get rawResponse => _rawResponse;

  int getCode() {
    if (_code == null) {
      throw "you need call parse function before get response code";
    }
    return _code!;
  }

  String getMsg() {
    if (_msg == null) {
      throw "you need call parse function before get response msg";
    }
    return _msg!;
  }

  T? getData<T>() {
    // if (_data == null) {
    //   throw "Maybe this response json don't contains data, or You need call parse function before get response data";
    // }
    // if(_data.runtimeType.toString().replaceAll("_", "") == "Null"){
    //   return null;
    // }
    //
    // if (_data.runtimeType.toString().replaceAll("_", "") != T.toString()) {
    //   throw "the data type is ${_data.runtimeType}, but you think this is ${T.toString()}";
    // }

    // if(_data.runtimeType==T.toString())

    return _data;
  }
}
