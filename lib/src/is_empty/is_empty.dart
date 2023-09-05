bool isEmpty(dynamic data) {
  if (data.runtimeType == String) {
    String data0 = data;
    if (data0.trim() == "" || data0.trim() == '') {
      return true;
    }
    return false;
  }

  if (data.runtimeType == Map) {
    Map data1 = data;
    if (data1 == {}) {
      return true;
    }
  }

  if (data.runtimeType == List) {
    List data2 = data;
    return data2.isEmpty;
  }

  if (data.runtimeType == Null) {
    return true;
  }
  return false;
}
