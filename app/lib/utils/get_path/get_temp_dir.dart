import 'dart:io';
import 'package:ai_assisted_reader/utils/platform_utils.dart';

import 'package:path_provider/path_provider.dart';

Future<Directory> getAnxTempDir() async {
  switch (AarPlatform.type) {
    case AarPlatformEnum.android:
    case AarPlatformEnum.ohos:
    case AarPlatformEnum.windows:
    case AarPlatformEnum.macos:
    case AarPlatformEnum.ios:
      return await getTemporaryDirectory();
  }
}
