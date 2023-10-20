import 'dart:io';

import 'package:connectivity/connectivity.dart';
import 'package:dio/dio.dart';
import 'package:dio/io.dart';
import 'package:flutter/foundation.dart';
import 'package:world_nailao_flutter_utils/src/dio_utils/dio_client.dart';

import 'api_response.dart';
import 'global_http_overrides.dart';

enum NetWorkState {
  mobile,
  wifi,
  none,
}

class DioUtils {
  static Dio? _dio;
  late String _url;
  Map<String, String>? _headerMap;
  Map<String, String>? _paramMap;
  List<dynamic>? _files;
  CancelToken? _cancelToken;
  ResponseType? _responseType;

  // request
  DioUtils._(String url) {
    _url = url;
    _dio ??= dioInit();
  }

  Dio dioInit() {
    HttpOverrides.global = GlobalHttpOverrides();
    BaseOptions options = BaseOptions(
      connectTimeout: const Duration(seconds: 10),
      receiveTimeout: const Duration(seconds: 10),
      sendTimeout: const Duration(seconds: 10),
      followRedirects: true,
    );
    final dio = Dio(options);
    dio.httpClientAdapter = _ioHttpClientAdapter;
    dio.interceptors.addAll(DioClient.getInterceptors());
    return dio;
  }

  static DioUtils builder(String url) {
    return DioUtils._(url);
  }

  ///跳过https证书验证
  static final IOHttpClientAdapter _ioHttpClientAdapter = IOHttpClientAdapter(
    createHttpClient: () {
      HttpClient httpClient = HttpClient();
      httpClient.badCertificateCallback =
          (X509Certificate cert, String host, int port) => true;
      return httpClient;
    },
    validateCertificate: (cert, host, port) {
      return true;
    },
  );

  DioUtils add(String key, String value) {
    _paramMap ??= <String, String>{};
    _paramMap!.putIfAbsent(key, () => value);
    return this;
  }

  DioUtils addCancelToken(CancelToken cancelToken) {
    _cancelToken = cancelToken;
    return this;
  }

  DioUtils header(String key, String value) {
    _headerMap ??= <String, String>{};
    _headerMap!.putIfAbsent(key, () => value);
    return this;
  }

  DioUtils headers(Map<String, String> headers) {
    _headerMap ??= <String, String>{};
    _headerMap!.addAll(headers);
    return this;
  }

  DioUtils resType(ResponseType type) {
    _responseType = type;
    return this;
  }

  DioUtils addInterceptor(Interceptor interceptor) {
    _dio!.interceptors.add(interceptor);
    return this;
  }

  DioUtils removeInterceptor(Interceptor interceptor) {
    _dio!.interceptors.remove(interceptor);
    return this;
  }

  // DioUtils removeApiStateInterceptor() {
  //   _dio!.interceptors
  //       .removeWhere((element) => element is CheckResponseStateInterceptor);
  //   return this;
  // }

  Future<ApiResponse> get() async {
    Response response = await _dio!.request(_url,
        cancelToken: _cancelToken,
        options: Options(
            method: 'GET',
            headers: _headerMap,
            responseType: _responseType ?? ResponseType.plain,
            followRedirects: true));
    clearParams();
    return ApiResponse(response);
  }

  Future<ApiResponse> post() async {
    final Response response = await _dio!.request(_url,
        data: _paramMap,
        cancelToken: _cancelToken,
        options: Options(
            method: 'POST',
            headers: _headerMap,
            responseType: _responseType ?? ResponseType.plain,
            followRedirects: true));
    clearParams();
    return ApiResponse(response);
  }

  Future<ApiResponse> postForm() async {
    Object? data;
    if (_paramMap != null && _paramMap!.isNotEmpty) {
      data = FormData.fromMap(_paramMap!);
    }
    final Response response = await _dio!.request(_url,
        data: data,
        cancelToken: _cancelToken,
        options: Options(
            method: 'POST',
            headers: _headerMap,
            responseType: _responseType ?? ResponseType.plain,
            contentType: "application/x-www-form-urlencoded",
            followRedirects: true));
    clearParams();
    return ApiResponse(response);
  }

  Future<ApiResponse> postJson() async {
    final Response response = await _dio!.request(_url,
        data: _paramMap,
        cancelToken: _cancelToken,
        options: Options(
            method: 'POST',
            headers: _headerMap,
            responseType: _responseType ?? ResponseType.plain,
            contentType: "application/json",
            followRedirects: true));
    clearParams();
    return ApiResponse(response);
  }

  Future<ApiResponse> uploadFile() async {
    if (_files == null || _files!.isEmpty) {
      throw Exception("files is null or empty");
    }
    if (_paramMap == null || _paramMap!.isEmpty) {
      throw Exception("_paramMap is null or empty");
    }
    var multipartFiles = _files!.map((file) {
      return MapEntry(
        "files",
        MultipartFile.fromFileSync(file.path),
      );
    }).toList();

    FormData voiceData = FormData.fromMap(_paramMap!);

    voiceData.files.addAll(multipartFiles);

    final Response response = await _dio!.request(_url,
        data: voiceData,
        cancelToken: _cancelToken, onSendProgress: (int sent, int total) {
      // print("$sent $total");
    },
        options: Options(
            method: 'POST',
            headers: _headerMap,
            responseType: _responseType ?? ResponseType.plain,
            contentType: "multipart/form-data",
            followRedirects: true));
    clearParams();
    return ApiResponse(response);
  }

  Future<ApiResponse> uploadMD5File() async {
    if (_files == null || _files!.isEmpty) {
      throw Exception("files is null or empty");
    }
    if (_paramMap == null || _paramMap!.isEmpty) {
      throw Exception(
          "_paramMap is null or empty,此请求需要issueId,filesMd5,userName");
    }
    var multipartFiles = _files!.map((file) {
      return MapEntry(
        "files",
        MultipartFile.fromFileSync(file.path),
      );
    }).toList();
    List list = [];
    list.add("${_paramMap!["md5"]}");
    FormData data = FormData.fromMap(_paramMap!);
    data.files.addAll(multipartFiles);
    final Response response = await _dio!.request(_url,
        data: data,
        cancelToken: _cancelToken, onSendProgress: (int sent, int total) {
      if (kDebugMode) {
        print("$sent $total");
      }
    },
        options: Options(
            method: 'POST',
            headers: _headerMap,
            responseType: _responseType ?? ResponseType.plain,
            contentType: "multipart/form-data",
            followRedirects: true));
    clearParams();
    return ApiResponse(response);
  }

  static Future<NetWorkState> isNetWorkAvailable() async {
    ConnectivityResult connectivityResult =
        await (Connectivity().checkConnectivity());

    if (connectivityResult == ConnectivityResult.mobile) {
      return NetWorkState.mobile;
    } else if (connectivityResult == ConnectivityResult.wifi) {
      return NetWorkState.wifi;
    } else if (connectivityResult == ConnectivityResult.none) {
      return NetWorkState.none;
    }
    return NetWorkState.none;
  }

  void clearParams() {
    _headerMap = null;
    _paramMap = null;
    _files = null;
    _cancelToken = null;
    _responseType = null;
  }

  static void clear() {
    _dio = null;
  }
}
