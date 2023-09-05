import 'package:dio/dio.dart';

import 'dio_client.dart';

/// Created by nailao on 2021/3/8
///

class APIException extends DioException {
  final int? code;

  APIException({
    this.code,
    super.message,
    required super.requestOptions,
    super.response,
    super.type = DioExceptionType.unknown,
    super.error,
    super.stackTrace,
  });

  APIException.code(
    int this.code, {
    required super.requestOptions,
    super.response,
    super.type = DioExceptionType.unknown,
    super.error,
    super.stackTrace,
    String? message,
  }) : super(
          message: message = message ?? DioClient.errorCode.getMsg(code),
        );

  APIException.msg(String message,
      {int? code,
      required super.requestOptions,
      super.response,
      super.type = DioExceptionType.unknown,
      super.error,
      super.stackTrace})
      : code = code ?? DioClient.errorCode.getCodeByMsg(message),
        super(message: message);

  @override
  DioException copyWith({
    RequestOptions? requestOptions,
    Response? response,
    DioExceptionType? type,
    Object? error,
    StackTrace? stackTrace,
    String? message,
  }) {
    return DioException(
      requestOptions: requestOptions ?? this.requestOptions,
      response: response ?? this.response,
      type: type ?? this.type,
      error: error ?? this.error,
      stackTrace: stackTrace ?? this.stackTrace,
      message: message ?? this.message,
    );
  }

  @override
  String toString() {
    return "ApiException: ErrorCode:$code, msg:$message";
  }
}
