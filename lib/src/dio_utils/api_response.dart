import 'dart:convert';

import 'package:dio/dio.dart';
import 'package:flutter/foundation.dart';
import 'package:world_nailao_flutter_utils/src/is_empty/is_empty.dart';

class ApiResponse {
  late final Response _rawResponse;
  late final int _code;
  late final String _msg;
  late final Map<String, dynamic> _data;

  ApiResponse(Response rawResponse) {
    _rawResponse = rawResponse;
    // print(rawResponse.data.toString());
    try {
      Map<String, dynamic> jsonDate = jsonDecode(rawResponse.data);
      if (jsonDate['code'] != null) {
        // print(jsonDate['data']);

        /// 对于较大的数据返回量，使用compute来解析json

        _code = jsonDate['code'];
        _msg = jsonDate['msg'];
        //如果data是字符串就返回{"data":" "},
        //否则直接返回
        var data = jsonDate['data'];
        // if (kDebugMode) {
        //   print(Utils.isEmpty(data));
        //   print(data.runtimeType);
        //   print(data is Map);
        //   print(data);
        // }
        if (isEmpty(data)) {
          _data = <String, dynamic>{};
        } else if (data is Map<String, dynamic>) {
          _data = data;
        } else {
          _data = <String, dynamic>{"data": data};
        }
      }
      // print(jsonDate);
    } catch (parseError) {
      if (kDebugMode) {
        print("parseError: $parseError");
      }
      // throw ParseException("ParseError", code);
    }
  }

  // ApiResponse.fromJson(Map<String, dynamic> json) {
  //
  //   print(1);
  //   print(json['data']=='');
  //   print(2);
  //   _code = json['code'];
  //   _msg = json['msg'];
  //   _data = json['data'] == ''|| json['data'].isNull ? <String, dynamic>{} : json['data'];
  // }

  // Future<Map<String, dynamic>> _parseJson(String text) {
  //   return compute(_parseAndDecode, text);
  // }
  //
  // Map<String, dynamic> _parseAndDecode(String response) {
  //   return jsonDecode(response) as Map<String, dynamic>;
  // }

  @override
  String toString() {
    return "{'code'：$_code,'msg': $_msg,'data': $_data,}";
  }

  String asString() {
    //未过apiResponse处理的toString
    return _rawResponse.data.toString();
  }

  Map<String, dynamic> toMap() {
    // print(_data);
    return _data;
  }

  // assertSuccess() {
  //   if (_code != 0) {
  //     throw Exception('code: $_code, msg: $_msg');
  //   }
  // }

  Response get rawResponse => _rawResponse;

  int get code => _code;

  String get msg => _msg;

  Map<String, dynamic> get data => _data;
}
