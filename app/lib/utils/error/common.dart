import 'dart:ui';

import 'package:ai_assisted_reader/utils/log/common.dart';
import 'package:flutter/material.dart';

class AarError {
  static Future<void> init() async {
    AarLog.info('AarError init');
    FlutterError.onError = (details) {
      FlutterError.presentError(details);
      AarLog.severe(details.exceptionAsString(), details.stack);
    };
    PlatformDispatcher.instance.onError = (error, stack) {
      AarLog.severe(error.toString(), stack);
      return false;
    };
  }
}
