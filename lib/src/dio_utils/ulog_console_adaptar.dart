import 'package:flutter_ulog/flutter_ulog.dart';

import 'config/log_config.dart';

class UlogConsoleAdapter extends ULogConsoleAdapter {
  @override
  bool isLoggable(ULogType type, String? tag) {
    return LogConfig.Ulog_showLog;
  }
}
