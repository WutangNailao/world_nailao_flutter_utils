import 'package:dio/dio.dart';
import 'package:world_nailao_flutter_utils/src/dio_utils/dio_client.dart';

CancelToken? cancelToken;

void main() async {
  // await DioClient.request("https://github.com")
  //     .removeApiStateInterceptor()
  //     .get()
  //     .then((value) => print(value));
  // Future.delayed(Duration(seconds: 1), () {
  //   cancelToken.cancel();
  // });
  // Dio().get("https://github.com", cancelToken: cancelToken);
  // Future.delayed(Duration(seconds: 1), () {
  //   cancelToken.cancel();
  // });
  get();
  get();
  get();
  get();
  get();
  get();
  get();
  await get();

  // await Future.delayed(const Duration(seconds: 1));
  // await get();
  // await Future.delayed(const Duration(seconds: 1));
  //
  // await get();
  // await Future.delayed(const Duration(seconds: 1));
  //
  // await get();
  // await Future.delayed(const Duration(seconds: 1));
  //
  // await get();
  // await Future.delayed(const Duration(seconds: 1));
  //
  // await get();
  // await Future.delayed(const Duration(seconds: 1));
}

get() async {
  if (cancelToken != null) {
    cancelToken!.cancel();
  }
  cancelToken = CancelToken();
  (await DioClient.request("https://github.com")
          .addCancelToken(cancelToken!)
          // .removeApiStateInterceptor()
          .get())
      .asString();
}
