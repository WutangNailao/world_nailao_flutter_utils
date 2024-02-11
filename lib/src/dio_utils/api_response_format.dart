class ApiResponseFormat {
  final String code;
  final String? data;
  final String msg;

  const ApiResponseFormat({required this.code, this.data, required this.msg});

  String getMsg()=> msg;

  String getCode() => code;

  String? getData() => data;

  @override
  String toString() {
    return  'ApiResponseFormat{ $code, $data, $msg }';
  }
}
