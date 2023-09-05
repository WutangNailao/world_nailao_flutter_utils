import 'package:flutter/widgets.dart';
import 'package:world_nailao_flutter_utils/src/throttle/throttle_extension.dart';

void main() async {
  for (var i = 0; i < 10; i++) {
    increase.call();
    await Future.delayed(Duration(milliseconds: 500));
  }

  // () async {
  //   await increase();
  // }.throttleWithTimeout(duration: const Duration(seconds: 2));
}

VoidCallback increase = () async {
  print(1);
  await Future.delayed(const Duration(seconds: 1));
}.throttleWithTimeout(duration: const Duration(seconds: 2));
