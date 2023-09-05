import 'time_interval.dart';

class TimeUtils {
  //计算传入时间与当前时间的时间差
  static TimeInterval timeHandler(milliSecond) {
    if (milliSecond.runtimeType == String) {
      milliSecond == int.tryParse(milliSecond);
    }
    DateTime t = DateTime.now();
    // print(t); //当前时间戳
    DateTime s = DateTime.fromMillisecondsSinceEpoch(milliSecond);
    // print(s); //时间戳转时间 2021-05-29 11:48:06.181

    Duration timeLag = t.difference(s); //时间戳进行比较
    // print("时间差：${timeLag}");
    // print("时间差 天：${timeLag.inDays}");
    // print("时间差 时：${timeLag.inHours}");
    // print("时间差 分：${timeLag.inMinutes}");
    // print('相差时间：${timeLag.inSeconds}');

    int dayLag = timeLag.inDays;
    int hourLag = timeLag.inHours;
    int minLag = timeLag.inMinutes;
    int secLag = timeLag.inSeconds;

    return TimeInterval(dayLag, hourLag, minLag, secLag);
  }
}
