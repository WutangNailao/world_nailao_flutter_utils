import 'dart:convert';

import 'package:dio/dio.dart';
import 'package:world_nailao_flutter_utils/src/dio_utils/exception/json_format_exception.dart';
import 'package:world_nailao_flutter_utils/src/dio_utils/exception/parse_exception.dart';

class ApiResponse {
  late final Response _rawResponse;

  Map<String, dynamic>? responseData;
  int? _code;
  String? _msg;
  dynamic _data;

  ApiResponse(this._rawResponse);

  ApiResponse parse({List<String> jsonFormat = const ["code", "data", "msg"]}) {
    late final Map<String, dynamic> jsonDate;
    try {
      jsonDate = jsonDecode(_rawResponse.data);
      responseData = jsonDate;
    } catch (e) {
      throw ParseException(
          "the response type is ${_rawResponse.data.runtimeType}, not is json, so it can not be parsed");
    }
    for (String e in jsonFormat) {
      if (!jsonDate.containsKey(e)) {
        throw JsonFormatException(
            "json format may be not as expected, response json format is ${jsonDate.keys}, but your input format is ${jsonFormat.join(',')}");
      }
    }

    _code = jsonDate[jsonFormat[0]];

    _msg = jsonDate[jsonFormat[2]];

    /// 对于较大的数据返回量，使用compute来解析json

    //如果data是字符串就返回" ",
    //如果data是数组 则返回 [];
    //如果data是map 则返回 {};
    _data = jsonDate[jsonFormat[1]];

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

  T getData<T>() {
    if (_data == null) {
      throw "you need call parse function before get response data";
    }
    if(_data.runtimeType.toString().replaceAll("_", "") != T.toString()){
      throw "the data type is ${_data.runtimeType}, but you think this is ${T.toString()}";
    }
    return _data!;
  }
}
