
import 'package:world_nailao_flutter_utils/world_nailao_flutter_utils.dart';

import 'error_code_impl.dart';

void main() async {
  DioClient.init(newErrorCode: DioErrorCodeImpl());
  String res = (await DioClient.request(
              "http://localhost:3001/phoneVCode/getPhoneVCode.do")
          .post())
      .asString();
  print(res);
}
