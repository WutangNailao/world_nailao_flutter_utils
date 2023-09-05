import 'package:flutter/animation.dart';

import 'throttle.dart';

extension ThrottleExtension on Function {
  VoidCallback throttleWithTimeout({Duration? duration}) {

      return Throttle(this, duration: duration).withTimeout;

  }
}
