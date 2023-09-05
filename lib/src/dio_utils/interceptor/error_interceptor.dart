//
// import 'dart:io';
//
// import 'package:connectivity_plus/connectivity_plus.dart';
// import 'package:dio/dio.dart';
// import 'package:flutter_ulog/flutter_ulog.dart';
//
// import '../../sysconfig.dart';
//
// /// 错误处理拦截器
// class ErrorInterceptor extends Interceptor {
// // 是否有网
//   Future<bool> isConnected() async {
//     var connectivityResult = await (Connectivity().checkConnectivity());
//     return connectivityResult != ConnectivityResult.none;
//   }
//   @override
//   Future<void> onError(DioException err, ErrorInterceptorHandler handler) async {
//     if (err.type == DioExceptionType.unknown) {
//       bool isConnectNetWork = await isConnected();
//       if(!isConnectNetWork){
//         throw const HttpException("网络连接失败，请检查网络设置");
//       }
//       // if (!isConnectNetWork && err.error is SocketException) {
//       //   err.error = SocketException(LibLocalizations.getLibString().libNetWorkNoConnect!);
//       // }else if (err.error is SocketException){
//       //   err.error = SocketException(LibLocalizations.getLibString().libNetWorkError!);
//       // }
//     }
//     // err.error = LibNetWorkException.create(err);
//     ULog.d('DioError : ${err.error.toString()}',tag: "${SysConfig.libNetTag}Interceptor");
//     super.onError(err, handler);
//   }
//
// }
