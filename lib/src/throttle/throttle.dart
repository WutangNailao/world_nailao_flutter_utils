import 'dart:async';

import 'package:flutter/foundation.dart';
import 'package:fluttertoast/fluttertoast.dart';

class Throttle {
  static final Map<String, bool> _funcThrottle = {};

  final Function _target;

  final Duration? _duration;

  late String key;

  Throttle(Function target, {Duration? duration})
      : _target = target,
        _duration = duration ?? const Duration(seconds: 5) {
    key = hashCode.toString();
  }

  withTimeout() async {
    // print(key);
    // print(_target);
    bool enable = _funcThrottle[key] ?? true;
    if (enable) {
      _funcThrottle[key] = false;
      Timer(_duration!, () {
        _funcThrottle.remove(key);
      });
      await _target.call();
    } else {
      // throw ThrottleException("请勿频繁调用此函数: $_target");
      Fluttertoast.showToast(msg: "请勿频繁调用此函数: $_target");
      if (kDebugMode) {
        print("请勿频繁调用此函数: $_target");
      }
    }
  }
}
