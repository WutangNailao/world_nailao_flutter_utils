import 'package:world_nailao_flutter_utils/world_nailao_flutter_utils.dart';



void main() async {
  DioClient.init();
  // Map res = (await DioClient.request(
  //             "https://api.campus.zhiwya.com/school/getSchoolPageInfo")
  //         .add("univUID", "mZ4NhGB2yLOHJjlA7DUb9g==")
  //         .postForm())
  //     .parse()
  //     .getData<Map<String, dynamic>>();
  // print(res);
  String res = (await DioClient.request("https://www.baidu.com")
          // .add("univUID", "mZ4NhGB2yLOHJjlA7DUb9g==")
          .get())
      .asString();
  print(res);
}
