import 'package:flutter/cupertino.dart';
import 'package:flutter/material.dart';
import 'package:ai_assisted_reader/utils/platform_utils.dart';

TextSelectionControls selectionControls() {
  switch (AarPlatform.type) {
    case AarPlatformEnum.ios:
    case AarPlatformEnum.macos:
      return CupertinoTextSelectionControls();
    case AarPlatformEnum.android:
    case AarPlatformEnum.ohos:
    case AarPlatformEnum.windows:
      return MaterialTextSelectionControls();
  }
}
