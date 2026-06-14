import 'dart:io';

import 'package:flutter/foundation.dart';

enum AarPlatformEnum { android, ios, macos, windows, ohos }

class AarPlatform {
  static AarPlatformEnum get type {
    if (Platform.isAndroid && !kIsWeb) {
      return AarPlatformEnum.android;
    }
    if (Platform.isIOS && !kIsWeb) {
      return AarPlatformEnum.ios;
    }
    if (Platform.isMacOS && !kIsWeb) {
      return AarPlatformEnum.macos;
    }
    if (Platform.isWindows && !kIsWeb) {
      return AarPlatformEnum.windows;
    }
    try {
      if (Platform.operatingSystem == 'ohos') {
        return AarPlatformEnum.ohos;
      }
    } catch (_) {
      // Platform.operatingSystem might throw if not available in some environments
    }
    throw UnsupportedError('Unsupported platform');
  }

  static bool get isAndroid => type == AarPlatformEnum.android;
  static bool get isIOS => type == AarPlatformEnum.ios;
  static bool get isMacOS => type == AarPlatformEnum.macos;
  static bool get isWindows => type == AarPlatformEnum.windows;
  static bool get isOhos => type == AarPlatformEnum.ohos;

  static bool get isMobile => isAndroid || isIOS || isOhos;

  static bool get isDesktop => isWindows || isMacOS;
}
